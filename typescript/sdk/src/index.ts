/**
 * @xynolog/sdk
 *
 * The Xynolog SDK — `XynologClient`, the verb-oriented namespaces, the
 * per-KB session layer, the flow state machines, and the supporting
 * helpers (the `cache` primitive, KB discovery).
 *
 * Transport-agnostic: `XynologClient` consumes the `ITransport` /
 * `IContentTransport` contracts from `@xynolog/core`. The HTTP adapters
 * (`HttpTransport`, `HttpContentTransport`) are re-exported here for
 * convenience so the common case is a single import; non-HTTP transports
 * are constructed by the caller from their own package.
 *
 * `APIError`, the HTTP transport's error class, is re-exported with the
 * adapters. Catch on `XynologError` (exported below) and route on
 * `err.code`; reach for the transport-specific class only when you're
 * already in HTTP-aware code.
 *
 * ```ts
 * import { XynologClient, HttpTransport, HttpContentTransport } from '@xynolog/sdk';
 * import { BRIDGED_CHANNELS, baseUrl } from '@xynolog/core';
 *
 * const transport = new HttpTransport({ baseUrl: baseUrl('https://kb.example/'), channels: BRIDGED_CHANNELS });
 * // HttpTransport implements both ITransport and IGatewayOperations;
 * // passing it as the third arg wires `client.auth` and `client.system`.
 * const client = new XynologClient(transport, new HttpContentTransport(transport), transport);
 * ```
 */

// XynologClient + the convenience HTTP-adapter re-exports.
export * from './client';

// The Observable subclasses namespace methods return. The stream and the
// upload are thenable, so scripts `await` them without `lastValueFrom`;
// the cache one is not, and its one-shot read is `.fresh()`.
export {
  StreamObservable,
  CacheObservable,
  DelegationObservable,
  UploadObservable,
  type JobCompletion,
  type JobEvent,
  type MarkJobCompletion,
  type YieldJobCompletion,
} from './awaitable';

// A worker's side of the job queue: what `job.claim` returns, the jobs it
// hands out, and what a transport made for a worker names.
export {
  ClaimsObservable,
  willRetryAfter,
  type HeldJob,
  type HeldMarkJob,
  type HeldYieldJob,
} from './claims';
export type {
  ClaimRefusal,
  HeldJobRecord,
  HeldJobStall,
  JobCheckpoint,
  JobFailure,
  JobReached,
  WorkerVitals,
} from '@xynolog/core';
export { JOB_CLAIM_CHANNELS, JOB_COMMIT_CHANNELS } from './worker-channels';

// The SWR cache primitive behind every `browse.*` live query. Exported so
// consumers of its observables (react-ui's `trackList`) can be tested against
// the REAL B14/B15 semantics instead of mock subjects — mock-only coverage is
// how a two-state consumer of a three-outcome cache shipped twice.
export {
  createCache,
  isReady,
  readyValue,
  type CacheState,
  type Cache,
} from './cache';
// Where a client keeps its persisted queries: `XynologClient`'s `cachePersistence` option.
export type { CachePersistence } from './cache-persister';

// `Bus` / `BusPrimitive` live in @xynolog/core (next to the bus protocol
// they're coupled to); a client hands its out as `client.wire`.
// `BusRequestError` (and
// its `BusRequestErrorCode`) are re-exported below for catch-convenience, so
// consumers catch every SDK error from one package.

// Verb-oriented namespace API. Frame is the schema-layer flow's surface;
// the others are content-layer flows + job/auth/system.
export { FrameNamespace } from './namespaces/frame';
export { BrowseNamespace } from './namespaces/browse';
export { MarkNamespace } from './namespaces/mark';
export { BindNamespace } from './namespaces/bind';
export { GatherNamespace } from './namespaces/gather';
export { MatchNamespace } from './namespaces/match';
export { YieldNamespace } from './namespaces/yield';
export {
  GenerationStallError,
  deriveStallDeadlineMs,
} from './namespaces/generation-stall';
export { BeckonNamespace } from './namespaces/beckon';
export { JobNamespace } from './namespaces/job';
export {
  JobCancelledError,
  JobFailedError,
} from './namespaces/job-status-poll';
export { AuthNamespace } from './namespaces/auth';
export { SystemNamespace } from './namespaces/system';
export type * from './namespaces/types';

// Re-exports from @xynolog/core for one-import convenience. The principled
// boundary still holds — sdk depends on core, never the reverse — but most
// consumers don't care about the layering and importing branded IDs from
// the same package as `XynologClient` is the ergonomic default.
export type {
  Logger,
  // Branded ID + URL + token types
  AccessToken,
  AnnotationId,
  BaseUrl,
  JobId,
  ResourceId,
  UserId,
  // Verb / shape types
  Annotation,
  AnnotationBody,
  BodyOperation,
  EntityType,
  EventMap,
  GatheredContext,
  Motivation,
  ResourceDescriptor,
  TagCategory,
  TagSchema,
  // The options the client's methods take
  ClaimOptions,
  CreateFromTokenOptions,
  ResourceSearchFilters,
  // Transport contracts
  ConnectionState,
  IContentTransport,
  ITransport,
  // The state-unit contract — the pattern every layer's factories implement
  // (https://github.com/xynolog/docs/blob/main/builder/STATE-UNITS.md); it lives in core so layers below the sdk share it.
  // A unit's state is a `Watched`.
  StateUnit,
  Watched,
  // Transport-neutral error-code vocabulary (route on `error.code`).
  TransportErrorCode,
  BusRequestErrorCode,
  XynologSessionErrorCode,
} from '@xynolog/core';
export {
  // The kinds of id are made by their constructors, which hold text to the
  // kind's rule; the others are casts.
  accessToken,
  annotationId,
  baseUrl,
  entityType,
  jobId,
  resourceId,
  userId,
  // Unified error base — every Xynolog-thrown error extends this.
  XynologError,
  // Bus-mediated command error — re-exported for catch-convenience (defined in
  // @xynolog/core next to `Bus`).
  BusRequestError,
  // What a read of a channel gives in place of a frame whose payload is not
  // the channel's (defined in @xynolog/core next to `Bus`): a reader of
  // `client.bus` tells one apart with `instanceof`.
  FrameRefusal,
  // The read-only view a state unit hands out of a state it holds.
  watched,
} from '@xynolog/core';

// The annotation readers. An annotation's target is an id or an object, its
// selector one or a list, its body absent, one item or a list: these read
// each without a script narrowing by hand. Every SDK has them, and
// protocol/specs/src/annotations/reader-cases.json holds them to one answer.
export {
  getAnnotationExactText,
  getBodySource,
  getCommentText,
  getEntityTypes,
  getExactText,
  getTagCategory,
  getTagSchemaId,
  getTargetSelector,
  getTargetSource,
  getTextQuoteSelector,
  isAssessment,
  isBodyResolved,
  isComment,
  isHighlight,
  isReference,
  isResolvedReference,
  isStubReference,
  isTag,
} from '@xynolog/core';

// The annotation builders. A worker finds the words its model quoted in a
// text (`reconcile`), builds the annotation of the span (`annotationOfSpan`),
// or of a resource as a whole (`annotationOfResource`), and commits it
// (`job.commit`). A span that is not the text's is refused with a
// `SpanRefusedError`. Every SDK has the three, and
// protocol/specs/src/annotations/builder-cases.json holds them to one answer.
export {
  annotationOfResource,
  annotationOfSpan,
  reconcile,
  SpanRefusedError,
} from '@xynolog/core';
export type {
  AnchorMethod,
  MatchQuality,
  QuotedText,
  ReconciledSpan,
  SpanRefusal,
  TextSpan,
} from '@xynolog/core';

// Session layer — per-KB sessions, app-level browser, storage adapter,
// error surface, modal signals.
export {
  XynologSession,
  type OpenedSession,
  type XynologSessionConfig,
  type UserInfo,
} from './session/xynolog-session';
// A software agent's sign-in: a worker's, or one of the knowledge base's own services'.
export {
  startAgentSession,
  type AgentSession,
  type AgentSessionOptions,
} from './session/agent-session';
export {
  privateKeyFromPem,
  ServiceToken,
  type KeyCredential,
  type SecretCredential,
  type ServiceAccountCredential,
} from '@xynolog/core';
export {
  XynologBrowser,
  type XynologBrowserConfig,
} from './session/xynolog-browser';
export { SignInError } from '@xynolog/core';
export type {
  BeginAuthorizationOptions,
  DeviceCode,
  UploadProgress,
} from '@xynolog/core';
export {
  BROWSER_CLIENT_ID,
  SCRIPT_CLIENT_ID,
  type SignInErrorCode,
  discoverIssuer,
  beginAuthorization,
  completeAuthorization,
  storedSessionOf,
  signInWithDeviceGrant,
  refreshAtIssuer,
  renewKept,
  revokeAtIssuer,
} from './session/oauth';
export {
  IdentityUnverifiableError,
  describeConnection,
} from './session/connect';
export type {
  SessionFactory,
  SessionFactoryOptions,
} from './session/session-factory';
export { createHttpSessionFactory } from './session/http-session-factory';
export {
  createSessionSignals,
  type SessionSignals,
} from './session/session-signals';
export { XynologSessionError } from './session/errors';
export { getBrowser, type GetBrowserOptions } from './session/registry';
export {
  type SessionStorage,
  InMemorySessionStorage,
} from './session/session-storage';
// A knowledge base as a client names it: the spec's shapes, from core.
export type {
  KnowledgeBase,
  NewKnowledgeBase,
  KbRead,
  KbTarget,
  KbEndpoint,
  HttpEndpoint,
  LocalEndpoint,
  OpenResource,
} from '@xynolog/core';
// What a registry hands its caller, what its signals say, and what is kept of
// a sign-in: records Protocol states in its tables, from core.
export type {
  ConnectionIdentity,
  SignInOutcome,
  KbReadVerdict,
  KbSessionStatus,
  SessionEndReason,
  SessionEnded,
  PermissionDenied,
  StoredSession,
  PendingAuthorization,
} from '@xynolog/core';
export { httpKb } from './session/knowledge-base';
export {
  defaultProtocol,
  isValidHostname,
  kbGatewayUrl,
  httpEndpointOf,
  getStoredSession,
  setStoredSession,
  clearStoredSession,
  keptIn,
  // One refresh policy for every holder of a gateway token: when a token
  // expires is the token's own claim, and how long before that to renew is
  // a single number. Sidecars outside this package schedule from both.
  parseJwtExpiry,
  refreshDelayMs,
  // The key a person's kept caches are held under: what a client built by
  // hand (the conformance driver) keeps them for.
  personKey,
} from './session/storage';
// Where a session's sign-in is kept: a registry's storage (`keptIn`), memory,
// or an entry of the sign-ins `xynolog login` keeps, over the files a caller
// gives; and a script's sign-out of one.
export { MemorySignIn, signOut, type SignInKept } from './session/sign-in-kept';
export {
  SignInStore,
  stateDir,
  type SignInFiles,
  type System,
} from './session/sign-in-store';

// State units — flow state machines and their RxJS substrate.
// None presume a UI: they're consumed by browser apps, terminals,
// daemons, and AI agents alike. See https://github.com/xynolog/docs/blob/main/builder/STATE-UNITS.md.
export * from './state';

// RxJS bridges — re-exported so consumers can unwrap our Observables to
// Promises without a separate `import { firstValueFrom } from 'rxjs'`.
// `mark.delegate`, `gather.annotation`, `match.search`, `yield.delegate`
// are awaitable as returned; the bridges are for what `.pipe(...)` gives
// back, which is a plain Observable.
export { firstValueFrom, lastValueFrom } from 'rxjs';

// Browser ↔ launcher KB discovery: the domain layer over the launcher's
// published export view — one validator, typed absent-vs-managed state, and
// the poll/diff subscription. IO-abstracted: httpDiscovery for the served
// mount, textDiscovery for any consumer-owned byte source (no fs in the sdk).
export {
  parseDiscoveryDocument,
  httpDiscovery,
  textDiscovery,
  subscribeDiscovery,
} from './discovery';
export type { DiscoveryTransport } from './discovery';
export type {
  DiscoveryAbsentReason,
  DiscoveryAbsent,
  DiscoveryManaged,
  DiscoveryUnchanged,
  DiscoveryState,
  DiscoveryRead,
  DiscoveryDiff,
} from '@xynolog/core';
