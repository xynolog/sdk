/**
 * XynologClient — the verb-oriented namespace surface.
 *
 * Thin coordinator over an injected transport pair. Owns a local
 * `EventBus` (`bus`) for UI-signal channels and bridges wire events into
 * it via `transport.bridgeInto(bus)`. Namespaces receive `(transport,
 * bus)` (and `content` for binary-I/O namespaces) and choose internally
 * whether each method goes over the wire or stays local.
 *
 * No public `emit`/`on`/`stream` shortcuts: consumers call typed
 * namespace methods. A channel read by name, where no namespace names it,
 * is read from `client.bus`.
 */

import type {
  BaseUrl,
  AccessToken,
  CacheQuery,
  ClientTiming,
  TransportTiming,
} from '@xynolog/core';
import {
  BRIDGED_CHANNELS,
  Bus,
  DEFAULT_CLIENT_TIMING,
  EventBus,
  accessToken,
  baseUrl,
} from '@xynolog/core';
import { sealPlaces, type CachePersistence } from './cache-persister';
import { BehaviorSubject } from 'rxjs';
import { BrowseNamespace, type BROWSE_QUERIES } from './namespaces/browse';
import { MarkNamespace } from './namespaces/mark';
import { BindNamespace } from './namespaces/bind';
import { GatherNamespace, type GATHER_QUERIES } from './namespaces/gather';
import { MatchNamespace, type MATCH_QUERIES } from './namespaces/match';
import { YieldNamespace } from './namespaces/yield';
import { BeckonNamespace } from './namespaces/beckon';
import { FrameNamespace } from './namespaces/frame';
import { JobNamespace } from './namespaces/job';
import { AuthNamespace } from './namespaces/auth';
import { SystemNamespace } from './namespaces/system';
import type {
  IGatewayOperations,
  IContentTransport,
  ITransport,
} from '@xynolog/core';

// Local imports of the HTTP adapters from @xynolog/http-transport — needed
// here so `XynologClient.fromHttp(...)` can construct them. The same
// names are re-exported below for consumer convenience, so
// `import { XynologClient, HttpTransport } from '@xynolog/sdk'` Just Works
// without a separate http-transport import.
import { HttpTransport, HttpContentTransport } from '@xynolog/http-transport';

// Convenience re-exports of the HTTP adapters. Non-HTTP transports are
// wired directly by callers; the sdk does not pre-bundle them.
export {
  APIError,
  type TokenRefresher,
  HttpTransport,
  type HttpTransportConfig,
  HttpContentTransport,
} from '@xynolog/http-transport';

/**
 * Every live query of protocol/specs/src/client/refresh.json is answered by one of
 * the namespaces that hold them, and no query by two: each namespace's
 * refresher acts only on its own, so one left out would never refresh, and
 * silently. A query added to the table and to no namespace fails to compile
 * here, naming it.
 */
type AnsweredQuery =
  | (typeof BROWSE_QUERIES)[number]
  | (typeof GATHER_QUERIES)[number]
  | (typeof MATCH_QUERIES)[number];
type AnsweredTwice =
  | ((typeof BROWSE_QUERIES)[number] & (typeof GATHER_QUERIES)[number])
  | ((typeof BROWSE_QUERIES)[number] & (typeof MATCH_QUERIES)[number])
  | ((typeof GATHER_QUERIES)[number] & (typeof MATCH_QUERIES)[number]);
type LiveQueryCensusDrift = Exclude<CacheQuery, AnsweredQuery> | AnsweredTwice;
export const liveQueryCensus: [LiveQueryCensusDrift] extends [never]
  ? 'in-census'
  : LiveQueryCensusDrift = 'in-census';

export class XynologClient {
  /**
   * The wire-facing transport: the bus primitives, resource scopes, and the
   * connection's state and errors. What is sent and read over it goes
   * through `wire`; ordinary consumers go through typed namespace methods.
   */
  readonly transport: ITransport;
  /** Binary I/O transport. */
  private readonly content: IContentTransport;
  /**
   * Per-client local EventBus: the client's own in-process signals, and the
   * wire's events, which the transport bridges in. Read-only public so a
   * channel of no scope can be read by name where no namespace names it;
   * everything else uses typed namespace methods.
   */
  readonly bus: EventBus;
  /**
   * The client's typed bus over its transport, as Rust's `client.wire()` and
   * Python's `client.wire` are: what it emits goes over the wire, and what it
   * reads is what the wire delivers. A channel of no scope is read with
   * `wire.frames(channel)`; a resource's channel with
   * `wire.frames(channel, resourceId)`, which holds that resource's scope
   * while it is read. The client's own in-process signals are on `bus`, not
   * here.
   */
  readonly wire: Bus;
  readonly baseUrl: BaseUrl;

  // ── Verb-oriented namespace API ──────────────────────────────────────────
  //
  // The first nine namespaces are bus-driven and always present. `frame`
  // is the schema-layer flow's surface (eighth flow); the other eight are
  // content-layer flows plus `job`. `auth` and `system` are gateway-ops
  // namespaces — they're only constructed when the caller passes an
  // `IGatewayOperations` instance to the constructor. A `XynologClient`
  // over a transport-only setup has
  // `auth === undefined` / `system === undefined`.
  public readonly frame: FrameNamespace;
  public readonly browse: BrowseNamespace;
  public readonly mark: MarkNamespace;
  public readonly bind: BindNamespace;
  public readonly gather: GatherNamespace;
  public readonly match: MatchNamespace;
  public readonly yield: YieldNamespace;
  public readonly beckon: BeckonNamespace;
  public readonly job: JobNamespace;
  public readonly auth: AuthNamespace | undefined;
  public readonly system: SystemNamespace | undefined;

  /**
   * The client *owns* its bus. The constructor creates a fresh `EventBus`
   * and hands it to the transport via `transport.bridgeInto(this.bus)`.
   * The reference flows client → transport, never the other way:
   * the transport stores the reference and publishes the events it
   * receives onto that bus. `HttpTransport` does so for every channel
   * delivered on its SSE wire; a transport with no wire adapts its
   * own source.
   *
   * Callers do not pass a bus in. If they need to interact with the bus
   * (e.g. for tests or to subscribe to arbitrary channels), they read it
   * back via `client.bus`.
   *
   * `gateway` is optional. When provided, the `auth` and `system`
   * namespaces are constructed against it; when omitted, they're
   * `undefined`. For HTTP setups this is conventionally the same
   * `HttpTransport` instance that's also passed as `transport` (HTTP
   * implements both `ITransport` and `IGatewayOperations`).
   */
  constructor(
    transport: ITransport,
    content: IContentTransport,
    gateway?: IGatewayOperations,
    options?: {
      /**
       * B17 — keep the persisted queries' values, for one knowledge base and
       * one person, from construction on. Omitted = in-memory-only caches,
       * until `browse.attachPersistence`.
       */
      cachePersistence?: CachePersistence;
      /**
       * What of the client's timing differs from `DEFAULT_CLIENT_TIMING`.
       * Its `busRequestTimeoutMs` is the deadline of `browse`'s requests and
       * of the `gather` and `match` live queries'; every other request has
       * the table's.
       */
      timing?: Partial<ClientTiming>;
    },
  ) {
    this.transport = transport;
    this.content = content;
    this.baseUrl = transport.baseUrl;

    this.bus = new EventBus();
    this.transport.bridgeInto(this.bus);
    this.wire = new Bus(this.transport);

    const timing = { ...DEFAULT_CLIENT_TIMING, ...options?.timing };

    this.frame = new FrameNamespace(this.transport);
    this.browse = new BrowseNamespace(this.transport, this.bus, this.content, {
      ...(options?.cachePersistence
        ? { cachePersistence: options.cachePersistence }
        : {}),
      timing,
    });
    this.mark = new MarkNamespace(this.transport, this.bus, timing);
    this.bind = new BindNamespace(this.transport, this.bus);
    this.gather = new GatherNamespace(this.transport, this.bus, { timing });
    this.match = new MatchNamespace(this.transport, this.bus, { timing });
    this.yield = new YieldNamespace(
      this.transport,
      this.bus,
      this.content,
      timing,
    );
    this.beckon = new BeckonNamespace(this.transport, this.bus);
    this.job = new JobNamespace(this.transport, this.bus);
    this.auth = gateway ? new AuthNamespace(gateway) : undefined;
    this.system = gateway ? new SystemNamespace(gateway) : undefined;
  }

  /** Transport-level connection state. HTTP reflects SSE health; local is `'open'` until disposed. */
  get state$() {
    return this.transport.state$;
  }

  dispose(): void {
    // B17: the places coupled to this client are sealed before anything is
    // disposed. Disposing drops a kept cache's fetch in flight and a refetch
    // the refresher owes, so either holds the places back from the saves
    // disposal makes; a save owed does not, since disposal makes it.
    sealPlaces(this, this.browse.fetchesSettled());
    // The live queries first: completing their caches stops any SWR
    // fetch/retry chain from issuing new requests into a transport that's
    // about to go away (B16 — a chain straddling teardown must die quietly,
    // not error observers or fire post-dispose traffic).
    this.browse.dispose();
    this.gather.dispose();
    this.match.dispose();
    this.transport.dispose();
    this.content.dispose();
    // Bus last (A7-owned: this client constructed it): everything upstream
    // is already quiet — the live queries detached their handlers, the transport's SSE
    // fan-in is down — so destroying it completes every remaining
    // subscriber cleanly (react-ui's event hooks, host code holding
    // client.bus). Without this, the bus outlives the client and every
    // subscriber stays attached forever, silently receiving nothing — one
    // leaked bus per session cycle under a reconnect loop. Post-dispose
    // bus access — any bus-emitting namespace method — throws
    // `destroyed bus` instead of no-op'ing into the leak: calling a
    // disposed client is a bug, and it says so.
    this.bus.destroy();
  }

  /**
   * Convenience factory for the default HTTP setup. Constructs a
   * `BehaviorSubject<AccessToken | null>` internally, plus an
   * `HttpTransport` and `HttpContentTransport`, and returns the wired
   * `XynologClient`.
   *
   * Use this for one-shot scripts, CLI commands, or any consumer that
   * doesn't need to drive the token from outside (no manual refresh).
   * For long-running scripts that need refresh, use
   * `XynologSession.fromKept(...)` over a kept sign-in (one
   * `XynologSession.signInDevice(...)` kept, or `xynolog login`'s) or
   * `XynologSession.fromHttp(...)` (with a token already on hand) instead —
   * either owns the same transport/client wiring plus the proactive
   * refresh and the kept sign-in.
   *
   * Strings are accepted for `baseUrl` and `token`; they are branded
   * via `baseUrl()` / `accessToken()` from `@xynolog/core` automatically.
   * Pass the already-branded values if you have them.
   *
   * Omit `token` for unauthenticated usage (public endpoints only). Every
   * request is sent with `fetch`, or the runtime's own. `clientTiming` is the
   * client's `timing`, and `transportTiming` the transport's.
   */
  static fromHttp(opts: {
    baseUrl: BaseUrl | string;
    token?: AccessToken | string | null;
    fetch?: typeof fetch;
    clientTiming?: Partial<ClientTiming>;
    transportTiming?: Partial<TransportTiming>;
  }): XynologClient {
    const url =
      typeof opts.baseUrl === 'string' ? baseUrl(opts.baseUrl) : opts.baseUrl;
    const tok =
      opts.token == null
        ? null
        : typeof opts.token === 'string'
          ? accessToken(opts.token)
          : opts.token;
    const token$ = new BehaviorSubject<AccessToken | null>(tok);
    const transport = new HttpTransport({
      baseUrl: url,
      token$,
      channels: BRIDGED_CHANNELS,
      ...(opts.fetch ? { fetch: opts.fetch } : {}),
      ...(opts.transportTiming ? { timing: opts.transportTiming } : {}),
    });
    const content = new HttpContentTransport(transport);
    // HttpTransport implements both ITransport and IGatewayOperations;
    // pass it twice so `client.auth` / `client.system` are wired.
    return new XynologClient(
      transport,
      content,
      transport,
      opts.clientTiming ? { timing: opts.clientTiming } : {},
    );
  }
}
