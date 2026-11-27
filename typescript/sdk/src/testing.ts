/**
 * `@xynolog/sdk/testing` — the SDK's contract double, exported where
 * consumers already look.
 *
 * One scriptable, REAL-pathway test client: `createTestClient` wires a real
 * `XynologClient` — real `createCache`, real `Bus.request`, real namespaces —
 * over a `FaultyTransport` (re-exported below; its home stays
 * `@xynolog/core/testing`). Script the transport, observe through the
 * client. `createTestSession` wraps the same stack in a real
 * `XynologSession` for state-unit factories, which take a session.
 *
 * Why this exists: a hand-rolled mock encodes its author's model of the
 * contract instead of the contract, so a wrong belief about the SDK passes
 * inside green tests — a fixture whose `state$` satisfies the TYPE but not
 * the contract, for one.
 * Tests whose subject is consumer behavior should start here; bespoke
 * fixtures are for testing the transport contract itself.
 */

import { BehaviorSubject } from 'rxjs';
import type {
  AccessToken,
  AnchoredTextAnswer,
  ClientTiming,
  IGatewayOperations,
  IContentTransport,
  PutBinaryOptions,
  PutBinaryRequest,
  ResourceId,
  components,
} from '@xynolog/core';
import type { CachePersistence } from './cache-persister';
import { BRIDGED_CHANNELS, resourceId as makeResourceId } from '@xynolog/core';
import {
  FaultyTransport,
  type FaultyTransportConfig,
} from '@xynolog/core/testing';
import { XynologClient } from './client';
import { XynologSession } from './session/xynolog-session';
import type {
  KbTarget,
  ResourceRepresentation,
  ResourceRepresentationStream,
} from '@xynolog/core';
import { httpKb } from './session/knowledge-base';
import { keptIn } from './session/storage';
import { InMemorySessionStorage } from './session/session-storage';

type GetResourceResponse = components['schemas']['GetResourceResponse'];
type GetAnnotationsResponse = components['schemas']['GetAnnotationsResponse'];

// The transport double's scripting surface, so a consumer test imports ONE
// module. `FaultyTransport`'s home remains `@xynolog/core/testing` — this is
// the consumer-facing barrel, not a second home.
export {
  FaultyTransport,
  refuseUnscriptedOperation,
  retryKeyOf,
  type FaultAction,
  type FaultyTransportConfig,
  type RequestLogEntry,
} from '@xynolog/core/testing';

/**
 * Minimal in-memory `IContentTransport`. Stores what `putBinary` receives;
 * `getBinary` throws on unknown ids the way a real transport 404s, so a
 * test that forgets to seed content fails loudly instead of returning
 * fabricated bytes. `getAnchoredText` and `getAnnotations` throw for every
 * id: nothing here derives text or records annotations, and an answer is a
 * test's to give. A test that needs one passes its own `content`.
 */
export function inMemoryContent(): IContentTransport {
  const store = new Map<string, ResourceRepresentation>();
  let seq = 0;

  return {
    async putBinary(
      request: PutBinaryRequest,
      _options?: PutBinaryOptions,
    ): Promise<{ resourceId: ResourceId }> {
      const rId = makeResourceId(`test-content-${++seq}`);
      store.set(rId as string, {
        data: request.file,
        contentType: String(request.format),
      });
      return { resourceId: rId };
    },
    async getBinary(rId: ResourceId): Promise<ResourceRepresentation> {
      const hit = store.get(rId as string);
      if (!hit)
        throw new Error(
          `inMemoryContent: no content stored for ${String(rId)}`,
        );
      return hit;
    },
    async getBinaryStream(
      rId: ResourceId,
    ): Promise<ResourceRepresentationStream> {
      const { data, contentType } = await this.getBinary(rId);
      const bytes = new Uint8Array(await data.arrayBuffer());
      return {
        stream: new ReadableStream<Uint8Array>({
          start(controller) {
            controller.enqueue(bytes);
            controller.close();
          },
        }),
        contentType,
      };
    },
    async getResourceGraph(rId: ResourceId): Promise<GetResourceResponse> {
      return {
        resource: {
          '@context': 'https://xynolog.dev/context/v1',
          '@id': rId,
          name: String(rId),
          representations: [],
        },
        annotations: [],
      };
    },
    async getAnnotations(rId: ResourceId): Promise<GetAnnotationsResponse> {
      throw new Error(`inMemoryContent: no annotations for ${String(rId)}`);
    },
    async getAnchoredText(rId: ResourceId): Promise<AnchoredTextAnswer> {
      throw new Error(`inMemoryContent: no anchored text for ${String(rId)}`);
    },
    dispose(): void {
      store.clear();
    },
  };
}

export interface TestClientOptions {
  /**
   * FaultyTransport scripting: fault schedule and `makeResponse`. Its
   * channels are a full client's, `BRIDGED_CHANNELS`: a test of a client that
   * hears other channels builds its own `FaultyTransport`.
   */
  transport?: Omit<FaultyTransportConfig, 'channels'>;
  /**
   * Gateway operations for the `auth`/`system` namespaces. Omitted = both are
   * `undefined` (a transport-only client). Pass `stubGateway()` when a unit
   * under test touches
   * `client.auth` and the test scripts it via `AuthNamespace.prototype`
   * spies (the AuthShell precedent).
   */
  gateway?: IGatewayOperations;
  /**
   * The client's `timing`. A test that drives B14/B15 through timeouts states
   * a small `busRequestTimeoutMs` (e.g. 40); `reject-emit` faults need none.
   */
  timing?: Partial<ClientTiming>;
  /** Replace the in-memory content transport (e.g. to pre-seed bytes). */
  content?: IContentTransport;
  /** B17 persistence, for rehydration tests. Omitted = in-memory caches. */
  cachePersistence?: CachePersistence;
}

/**
 * A COMPLETE `IGatewayOperations` whose every method rejects loudly with its
 * own name — so a unit that touches an op the test didn't script fails with
 * "not scripted: <op>" instead of a fabricated success. Script behavior via
 * `AuthNamespace.prototype` / `SystemNamespace.prototype` spies, or spread
 * overrides over this stub. tsc enforces completeness: a new gateway op is a
 * compile error HERE, not a silent gap.
 */
export function stubGateway(): IGatewayOperations {
  const notScripted = (name: string) => () =>
    Promise.reject(new Error(`stubGateway: not scripted: ${name}`));
  return {
    getCurrentUser: notScripted('getCurrentUser'),
    getMediaToken: notScripted('getMediaToken'),
    getProtectedResourceMetadata: notScripted('getProtectedResourceMetadata'),
    healthCheck: notScripted('healthCheck'),
    getStatus: notScripted('getStatus'),
  };
}

/**
 * A real `XynologClient` over a scriptable `FaultyTransport`.
 *
 * The returned `transport` IS the `FaultyTransport` instance, given a full
 * client's channels (`BRIDGED_CHANNELS`) — script faults via its config,
 * drive connection state via `transport.state$.next(...)`, and account
 * requests via `transport.requestLog`.
 */
export function createTestClient(options: TestClientOptions = {}): {
  client: XynologClient;
  transport: FaultyTransport;
} {
  const transport = new FaultyTransport({
    ...options.transport,
    channels: BRIDGED_CHANNELS,
  });
  const client = new XynologClient(
    transport,
    options.content ?? inMemoryContent(),
    options.gateway,
    {
      ...(options.timing ? { timing: options.timing } : {}),
      ...(options.cachePersistence
        ? { cachePersistence: options.cachePersistence }
        : {}),
    },
  );
  return { client, transport };
}

export interface TestSessionOptions extends TestClientOptions {
  /** Override the default test KB target (id 'test-kb'). */
  kb?: KbTarget;
}

/**
 * A real `XynologSession` over the same scriptable stack — for testing
 * state-unit factories, which take a session. Its sign-in is kept in
 * `storage`, as a registry's session's is (`keptIn`).
 * No token is seeded and no
 * `validate`/`refresh` callbacks are wired, so `session.ready` settles
 * immediately; tests that need an authenticated shape push into `token$`.
 * The caller ends the client and then the session: the session only uses it.
 */
export function createTestSession(options: TestSessionOptions = {}): {
  session: XynologSession;
  client: XynologClient;
  transport: FaultyTransport;
  storage: InMemorySessionStorage;
  token$: BehaviorSubject<AccessToken | null>;
} {
  const { client, transport } = createTestClient(options);
  const storage = new InMemorySessionStorage();
  const token$ = new BehaviorSubject<AccessToken | null>(null);
  const kb =
    options.kb ??
    httpKb({
      id: 'test-kb',
      label: 'Test KB',
      host: 'localhost',
      port: 4000,
      protocol: 'http',
    });
  const session = new XynologSession({
    kb,
    kept: keptIn(storage, kb.id),
    client,
    token$,
  });
  return { session, client, transport, storage, token$ };
}
