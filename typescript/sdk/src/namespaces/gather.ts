import type {
  AnnotationId,
  CacheQuery,
  CacheValues,
  ClientTiming,
  components,
  ResourceId,
  EventBus,
  GatheredContext,
} from '@xynolog/core';
import type { GatherResourceOptions, ITransport } from '@xynolog/core';
import { CacheObservable, StreamObservable } from '../awaitable';
import { Bus, DEFAULT_CLIENT_TIMING } from '@xynolog/core';
import { createCache, type Cache } from '../cache';
import { CacheRefresher, ScopedSources } from '../cache-refresh';
import type {
  GatherNamespace as IGatherNamespace,
  GatherAnnotationComplete,
  ReferencedByEntry,
} from './types';

/**
 * The live queries of protocol/specs/src/client/refresh.json this namespace answers.
 * `client.ts` holds the namespaces to answering every one between them.
 */
export const GATHER_QUERIES = [
  'referencedBy',
] as const satisfies readonly CacheQuery[];
type GatherQuery = (typeof GATHER_QUERIES)[number];

export class GatherNamespace implements IGatherNamespace {
  /** In memory only: an answer of the graph, asked again on each session. */
  private readonly referencedByCache: Cache<
    ResourceId,
    CacheValues['referencedBy']
  >;
  private readonly scoped: ScopedSources;
  private readonly refresher: CacheRefresher<GatherQuery>;

  private readonly wire: Bus;

  constructor(
    private readonly transport: ITransport,
    private readonly bus: EventBus,
    options?: {
      /** What of the client's timing differs from `DEFAULT_CLIENT_TIMING`. */
      timing?: Partial<ClientTiming>;
    },
  ) {
    this.wire = new Bus(transport);
    const { busRequestTimeoutMs, invalidationWindowMs } = {
      ...DEFAULT_CLIENT_TIMING,
      ...options?.timing,
    };
    this.scoped = new ScopedSources(this.transport);

    this.referencedByCache = createCache<
      ResourceId,
      CacheValues['referencedBy']
    >(async (resourceId) => {
      const result = await this.wire.request(
        'gather:referenced-by-requested',
        { resourceId },
        busRequestTimeoutMs,
      );
      return result.referencedBy;
    });

    this.refresher = new CacheRefresher<GatherQuery>(
      this.transport,
      this.bus,
      {
        referencedBy: {
          refetch: (subject, reach) => {
            const resources =
              reach === 'held'
                ? this.referencedByCache.keys()
                : subject.resource
                  ? [subject.resource]
                  : [];
            for (const rId of resources) {
              this.refresher.held(
                this.referencedByCache,
                rId,
                `referenced-by/${rId}`,
                () => this.invalidateReferencedBy(rId),
              );
            }
          },
        },
      },
      invalidationWindowMs,
    );
  }

  /**
   * The annotations elsewhere that refer to a resource — a live query, kept
   * per resource. Subscribing acquires the resource's scope.
   */
  referencedBy(resourceId: ResourceId): CacheObservable<ReferencedByEntry[]> {
    return CacheObservable.from(
      this.scoped.of(resourceId, this.referencedByCache.observe(resourceId)),
      () => this.referencedByCache.fetch(resourceId),
    );
  }

  /** A direct caller says the key is out of date: asked again at once, whatever it holds (B8). */
  invalidateReferencedBy(resourceId: ResourceId): void {
    this.referencedByCache.invalidate(resourceId);
  }

  /** B16: detach from the bus and dispose the cache this namespace built. Idempotent. */
  dispose(): void {
    this.refresher.dispose();
    this.referencedByCache.dispose();
  }

  annotation(
    resourceId: ResourceId,
    annotationId: AnnotationId,
    options?: components['schemas']['GatherAnnotationOptions'],
  ): StreamObservable<GatherAnnotationComplete> {
    // Options none of which is stated are not sent: each is the gatherer's.
    const stated =
      options !== undefined &&
      Object.values(options).some((option) => option !== undefined);
    return new StreamObservable<GatherAnnotationComplete>((subscriber) => {
      const abandoned = new AbortController();
      this.wire
        .request(
          'gather:requested',
          { annotationId, resourceId, options: stated ? options : undefined },
          // The request's own deadline: the option above is the live query's.
          undefined,
          abandoned.signal,
        )
        .then(
          (response) => {
            subscriber.next({ annotationId, response });
            subscriber.complete();
          },
          (error: unknown) => {
            // Abandoned by its reader, who is gone: there is nobody to tell.
            if (subscriber.closed) return;
            subscriber.error(error);
          },
        );
      return () => abandoned.abort();
    });
  }

  /**
   * Gather whole-resource LLM context — a request/reply over
   * `gather:resource-requested` → `gather:resource-complete`/`-failed`, shaped
   * as a `Promise` rather than the `StreamObservable` `annotation()` returns. Resolves to the unified `GatheredContext` (focus.kind:
   * 'resource') the gateway assembled — the resource focus plus the shared
   * knowledge graph; rejects with a `BusRequestError` on failure. Defaults mirror
   * the CLI `gather` command (depth 2, maxResources 10, content in, summary out).
   */
  resource(
    resourceId: ResourceId,
    options?: GatherResourceOptions,
  ): Promise<GatheredContext> {
    return this.wire.request('gather:resource-requested', {
      resourceId,
      options: {
        depth: options?.depth ?? 2,
        maxResources: options?.maxResources ?? 10,
        includeContent: options?.includeContent ?? true,
        includeSummary: options?.includeSummary ?? false,
        ...(options?.excludeEntityTypes?.length
          ? { excludeEntityTypes: options.excludeEntityTypes }
          : {}),
      },
    });
  }
}
