import type {
  ResourceId,
  EventBus,
  GenerationJobParams,
  components,
} from '@xynolog/core';
import {
  cloneFormat,
  deriveStorageUri,
  getPrimaryRepresentation,
} from '@xynolog/core';

import type { ITransport, IContentTransport } from '@xynolog/core';
import { Bus, isReportedJobResult, isYieldJobResult } from '@xynolog/core';
import {
  UploadObservable,
  type DelegationObservable,
  type YieldJobCompletion,
} from '../awaitable';
import { delegated, type DelegatedVerb } from './delegation';
import { deriveStallDeadlineMs } from './generation-stall';
import type { JobFollowTiming } from './job-status-poll';
import type { YieldNamespace as IYieldNamespace } from './types';

import type {
  CreateFromTokenOptions,
  PutBinaryRequest,
  ResourceDescriptor,
} from '@xynolog/core';

type CloneResourceWithTokenResponse =
  components['schemas']['CloneResourceWithTokenResponse'];

/** A `yield` job's completion, as its follower hears or learns it. */
const YIELD: DelegatedVerb<YieldJobCompletion> = {
  jobType: 'yield',
  heard: (frame) => (frame.jobType === 'yield' ? frame : undefined),
  learned: (status, resourceId) => {
    if (status.type !== 'yield') return undefined;
    const completion = {
      jobId: status.jobId,
      jobType: status.type,
      resourceId,
    };
    // A job completed without a result is stored with an empty one; the
    // job:complete this stands for carried none.
    if (!isReportedJobResult(status.result)) return completion;
    return isYieldJobResult(status.result)
      ? { ...completion, result: status.result }
      : undefined;
  },
};

export class YieldNamespace implements IYieldNamespace {
  private readonly wire: Bus;

  constructor(
    private readonly transport: ITransport,
    private readonly bus: EventBus,
    private readonly content: IContentTransport,
    private readonly timing: JobFollowTiming = {},
  ) {
    this.wire = new Bus(transport);
  }

  resource(data: PutBinaryRequest): UploadObservable {
    const totalBytes = data.file.size;
    return new UploadObservable((subscriber) => {
      // `started` fires synchronously so subscribers can render an upload-
      // in-progress indicator before any I/O begins.
      subscriber.next({ phase: 'started', totalBytes });
      let cancelled = false;
      const abortController = new AbortController();
      this.content
        .putBinary(data, {
          // Byte-progress hook. `HttpContentTransport` calls it as the
          // bytes are sent; a transport with no wire never calls it.
          onProgress: ({ bytesUploaded, totalBytes: txTotal }) => {
            if (cancelled) return;
            // Prefer the transport's reported total; fall back to the
            // pre-flight size if the transport reports 0 (chunked encoding
            // or indeterminate length).
            const total = txTotal > 0 ? txTotal : totalBytes;
            subscriber.next({
              phase: 'progress',
              bytesUploaded,
              totalBytes: total,
            });
          },
          signal: abortController.signal,
        })
        .then((result) => {
          if (cancelled) return;
          subscriber.next({
            phase: 'finished',
            resourceId: result.resourceId,
          });
          subscriber.complete();
        })
        .catch((err) => {
          if (!cancelled) subscriber.error(err);
        });
      return () => {
        cancelled = true;
        // Cancel the upload when the subscriber unsubscribes: over HTTP its
        // connection is closed. The transport's rejection is the signal's
        // reason, which `cancelled` keeps from the subscriber.
        abortController.abort();
      };
    });
  }

  /**
   * Grounded generation, delegated as a `yield` job — translate, summarize,
   * answer, synthesize; the role is carried by `params.task`/`params.prompt`
   * (+ `language`, `outputMediaType`). The job names no resource: the focus
   * of `params.context` does, and the dispatcher derives the job's resource
   * from it (a mismatched pair is unrepresentable):
   *
   * - `resource` focus (from `gather.resource`) — the job is about
   *   `focus.resource`; on completion the worker mints a navigable
   *   source→derived reference annotation (provenance).
   * - `annotation` focus (from `gather.annotation`) — the job is about
   *   `focus.sourceResource`, and the worker binds the new resource to
   *   `focus.annotation`.
   *
   * A context without a usable focus throws synchronously — the runtime half
   * of the schema's `required: focus` for values whose type history was
   * severed (wire JSON, storage, casts). Never guesses, never defaults.
   *
   * `stallDeadlineMs` is how long the follower waits in silence before it
   * gives the job up. It is the client's own and is not sent. Unset, it
   * derives from `params.maxTokens` — see `deriveStallDeadlineMs`. On firing,
   * the job is asked to be cancelled and the stream errors with
   * `GenerationStallError`.
   *
   * ⚠️ Cold: do NOT both `.subscribe(...)` and `await` the same instance —
   * that creates the job twice. Use `.run(onNext)` for progress + completion.
   */
  delegate(
    params: GenerationJobParams,
    stallDeadlineMs?: number,
  ): DelegationObservable<YieldJobCompletion> {
    // The resource read here is for the completion the status poll stands in
    // for; the wire carries none, and the dispatcher derives its own from the
    // same focus.
    const focus = params.context?.focus;
    const resourceId =
      focus?.kind === 'resource' && typeof focus.resource?.['@id'] === 'string'
        ? focus.resource['@id']
        : focus?.kind === 'annotation' &&
            typeof focus.sourceResource?.['@id'] === 'string'
          ? focus.sourceResource['@id']
          : undefined;
    if (resourceId === undefined) {
      throw new Error(
        'yield.delegate: params.context has no usable focus — pass a GatheredContext ' +
          'produced by gather.resource(...) or gather.annotation(...).',
      );
    }
    return delegated(
      this.transport,
      this.bus,
      this.timing,
      { jobType: 'yield', params },
      YIELD,
      resourceId,
      stallDeadlineMs ?? deriveStallDeadlineMs(params.maxTokens),
    );
  }

  async cloneToken(
    resourceId: ResourceId,
  ): Promise<CloneResourceWithTokenResponse> {
    return this.wire.request('yield:clone-token-requested', { resourceId });
  }

  async fromToken(token: string): Promise<ResourceDescriptor> {
    const result = await this.wire.request('yield:clone-resource-requested', {
      token,
    });
    return result.sourceResource as ResourceDescriptor;
  }

  async createFromToken(
    options: CreateFromTokenOptions,
  ): Promise<{ resourceId: ResourceId }> {
    // The clone's bytes ride the upload path, never the bus: fetch the
    // source, apply the clone-format gate (authorable sources keep their base
    // type, everything else falls back to text/plain), and put the bytes with
    // the token — the Archivist stores them and routes creation through
    // `yield:clone-create`.
    const source = await this.fromToken(options.token);
    const format = cloneFormat(getPrimaryRepresentation(source)?.mediaType);
    return this.content.putBinary({
      name: options.name,
      file: new Blob([options.content], { type: format }),
      format,
      storageUri: deriveStorageUri(options.name, format),
      cloneToken: options.token,
      ...(options.archiveOriginal !== undefined
        ? { archiveOriginal: options.archiveOriginal }
        : {}),
    });
  }

  clone(): void {
    this.bus.emit('yield:clone', undefined);
  }
}
