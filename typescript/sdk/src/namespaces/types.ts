/**
 * Verb Namespace Interfaces
 *
 * These interfaces define the public API of `@xynolog/sdk`, organized by
 * the eight flows (Browse, Mark, Bind, Gather, Match, Yield, Beckon, Frame)
 * plus the `job`, `auth` and `system` namespaces.
 *
 * Each flow has one namespace. The frontend calls
 * `client.mark.annotation()` and the client handles HTTP, auth, SSE, and
 * caching internally.
 *
 * Return type conventions:
 * - Browse live queries → `CacheObservable<T>` (bus-driven, cached;
 *   subscribe yields `CacheState<T>`, `.fresh()` is the one-shot read)
 * - Browse one-shot reads → `Promise<T>` (fetch once, no cache)
 * - Commands (mark, bind, frame) and gather.resource → `Promise<T>`
 *   (resolve on the reply, reject on failure)
 * - Upload (yield.resource) → `UploadObservable` (the upload's phases;
 *   await yields `{ resourceId }`)
 * - Long-running ops (gather.annotation, match.search) →
 *   `StreamObservable<T>` (subscribe yields every emit, await yields the
 *   last one)
 * - Delegated jobs (mark.delegate, yield.delegate) → `DelegationObservable`
 *   (subscribe yields the job's events; await yields its completion)
 * - Ephemeral signals, local (beckon.hover/sparkle, browse.click, …) → `void`
 * - Wire drives at other participants (beckon.attention/click/openResource/
 *   sparkleAll) → `Promise<number | undefined>`: the /bus/emit subscriber
 *   count, absent when the gateway cannot count — information, not an ack
 *   (X5's third shape)
 *
 * `StreamObservable`, `DelegationObservable` and `UploadObservable` are
 * `Observable` subclasses that also implement `PromiseLike` — `await
 * client.X.Y(...)` works directly without a `lastValueFrom` wrapper.
 * `CacheObservable` is deliberately not thenable.
 * `.pipe(...)` returns a plain `Observable<T>` (the thenable subclass
 * does not propagate through pipe — by design).
 */

import type { Observable } from 'rxjs';
import type {
  StreamObservable,
  CacheObservable,
  DelegationObservable,
  MarkJobCompletion,
  UploadObservable,
  YieldJobCompletion,
} from '../awaitable';
import type {
  ClaimOptions,
  components,
  CreateFromTokenOptions,
  GatherResourceOptions,
  JobPollOptions,
  ResourceRepresentation,
  ResourceRepresentationStream,
  MatchSearchOptions,
  PutBinaryRequest,
  EventMap,
  FrameRefusal,
  HealthCheckResponse,
  ResourceSearchFilters,
  StatusResponse,
} from '@xynolog/core';
import type { ClaimsObservable } from '../claims';
import type {
  ResourceId,
  AnnotationId,
  AttributedEvent,
  BodyOperation,
  GenerationJobParams,
  JobId,
  MarkJobParams,
  Motivation,
  AnchorRect,
  GatheredContext,
  TagSchema,
  EnginesWithLimits,
  KbDescription,
} from '@xynolog/core';

// ── OpenAPI schema type aliases ─────────────────────────────────────────────

import type { Annotation } from '@xynolog/core';
import type { AnchoredTextAnswer } from '@xynolog/core';
import type { ResourceDescriptor } from '@xynolog/core';
type GetResourceResponse = components['schemas']['GetResourceResponse'];
type MatchSearchResult = components['schemas']['MatchSearchResult'];
type ListResourcesResponse = components['schemas']['ListResourcesResponse'];
type BrowseResourcesRequest = components['schemas']['BrowseResourcesRequest'];
type MatchResourcesResponse = components['schemas']['MatchResourcesResponse'];
type CreateAnnotationRequest = components['schemas']['CreateAnnotationRequest'];
type MarkCreateOkResponse = components['schemas']['MarkCreateOkResponse'];
export type GatherAnnotationComplete =
  components['schemas']['GatherAnnotationComplete'];
type JobStatusResponse = components['schemas']['JobStatusResponse'];
type CloneResourceWithTokenResponse =
  components['schemas']['CloneResourceWithTokenResponse'];
type ProtectedResourceMetadata =
  components['schemas']['ProtectedResourceMetadata'];

// ── Domain-specific input types ─────────────────────────────────────────────

/** Referenced-by entry from gather.referencedBy() */
export type ReferencedByEntry =
  components['schemas']['GetReferencedByResponse']['referencedBy'][number];

/** Annotation history from browse.annotationHistory() */
export type AnnotationHistoryResponse =
  components['schemas']['GetAnnotationHistoryResponse'];

/** The signed-in user, as `GET /api/users/me` returns it. */
export type User = components['schemas']['UserResponse'];

// ── Namespace interfaces ────────────────────────────────────────────────────

/**
 * Browse — reads from materialized views
 *
 * Live queries return Observables that emit initial state and re-emit
 * on bus gateway updates. One-shot reads return Promises.
 *
 * Gateway actor: Browser (context classes)
 * Event prefix: browse:*
 */
export interface BrowseNamespace {
  // Live queries (Observable — refreshed by bus events, cached in BehaviorSubject;
  // `annotations` reads over HTTP, the rest ask the bus)
  resource(resourceId: ResourceId): CacheObservable<ResourceDescriptor>;
  resources(
    filters?: BrowseResourcesRequest,
  ): CacheObservable<ListResourcesResponse>;
  annotations(resourceId: ResourceId): CacheObservable<Annotation[]>;
  annotation(
    resourceId: ResourceId,
    annotationId: AnnotationId,
  ): CacheObservable<Annotation>;
  entityTypes(): CacheObservable<string[]>;
  tagSchemas(): CacheObservable<TagSchema[]>;
  /**
   * The KB's engines — each a provider and a model its Inference document
   * names, with the jobs the document has it used for — with each engine's
   * limits as the services holding its inference credentials report them.
   * KB-wide singleton; cached for the client lifetime, asked again when the
   * stream reopens after a drop.
   */
  engines(): CacheObservable<EnginesWithLimits>;
  events(resourceId: ResourceId): CacheObservable<AttributedEvent[]>;

  // One-shot reads (Promise — no caching, no live update)
  resourceContent(resourceId: ResourceId): Promise<string>;
  resourceGraph(resourceId: ResourceId): Promise<GetResourceResponse>;
  /** The resource's coordinate map, read through the content transport.
   *  Never null — absence is named, so a caller can tell "not yet" from
   *  "never". */
  resourceAnchoredText(resourceId: ResourceId): Promise<AnchoredTextAnswer>;
  resourceRepresentation(
    resourceId: ResourceId,
  ): Promise<ResourceRepresentation>;
  resourceRepresentationStream(
    resourceId: ResourceId,
  ): Promise<ResourceRepresentationStream>;
  resourceEvents(resourceId: ResourceId): Promise<AttributedEvent[]>;
  annotationHistory(
    resourceId: ResourceId,
    annotationId: AnnotationId,
  ): Promise<AnnotationHistoryResponse>;
  files(
    dirPath?: string,
    sort?: components['schemas']['BrowseDirectoryRequest']['sort'],
  ): Promise<components['schemas']['BrowseFilesResponse']>;
  /**
   * What the KB says of itself — its committed name and domain, and the
   * working tree's branch — asked on every call. Never cached: a branch
   * changes with no event that could invalidate a kept answer.
   */
  kb(): Promise<KbDescription>;

  // UI signals — THIS viewer's own local fan-out, never the wire. The
  // cross-namespace pair is the rule: `browse.X()` does it for me,
  // `beckon.X()` does it for everyone else. (`resourceViewed` is the one
  // exception and goes to the wire — it is a REPORT, not a drive.)
  click(annotationId: AnnotationId, anchorRect?: AnchorRect): void;
  openResource(resourceId: ResourceId): void;
  resourceViewed(resourceId: ResourceId): void;
}

/**
 * Frame — schema-layer flow (the eighth flow).
 *
 * Frame operates on the KB's conceptual vocabulary — what *kinds* of
 * things exist (entity types) and what taxonomies are recognized (tag
 * schemas). Typed relations (predicate types) and schema import (ontology
 * I/O) are not part of it. The other seven flows (yield, mark, match,
 * bind, gather, browse, beckon) operate on content; Frame operates on the
 * schema layer that content is expressed in.
 *
 * Vocabulary writes only. Live reads of the vocabulary are on Browse
 * (`browse.entityTypes()`, `browse.tagSchemas()`). Frame owns writes;
 * Browse owns reads — the same asymmetry that holds for resources and
 * annotations.
 *
 * Gateway actor: Stower
 * Event prefix: frame:*
 */
export interface FrameNamespace {
  /** Add a single entity type to the KB's vocabulary. Idempotent — adding an existing type is a no-op. */
  addEntityType(type: string): Promise<void>;

  /** Add multiple entity types in one call. Convenience over a loop of `addEntityType`. */
  addEntityTypes(types: string[]): Promise<void>;

  /**
   * Register a tag schema with the KB's runtime registry.
   *
   * Most-recent registration of a given `schema.id` wins; identical
   * re-registrations are silent, differing content overwrites the
   * existing entry and logs a warning. KBs typically call this at
   * session/skill startup so the schema is available for `mark.delegate`
   * with motivation `tagging` and surfaces in `browse.tagSchemas()`.
   */
  addTagSchema(schema: TagSchema): Promise<void>;
}

/**
 * Mark — annotation CRUD, delegated annotation, resource lifecycle
 *
 * Commands return Promises that resolve on the confirming reply and
 * reject on failure. Results appear on browse Observables via bus gateway.
 * delegate() returns the delegated job: its events, and awaited, its completion.
 *
 * Gateway actor: Stower
 * Event prefix: mark:*
 */
export interface MarkNamespace {
  // Annotation CRUD. `input.target.source` carries the resource id; the
  // namespace derives it for the bus payload, so callers don't pass it twice.
  annotation(input: CreateAnnotationRequest): Promise<MarkCreateOkResponse>;
  delete(resourceId: ResourceId, annotationId: AnnotationId): Promise<void>;

  // Resource metadata
  archive(resourceId: ResourceId): Promise<void>;
  unarchive(resourceId: ResourceId): Promise<void>;

  /**
   * Replace a resource's own entity-type classification. A **diff/replace**
   * operation: pass the resource's current types as `current` and the desired
   * full set as `updated`. The gateway folds the difference into
   * `resource.entityTypes`, so the change surfaces in
   * `browse.resources({ entityType })` and `getResourceEntityTypes`. Awaitable +
   * rejects on failure, like `delete`/`archive`.
   */
  updateEntityTypes(
    resourceId: ResourceId,
    current: string[],
    updated: string[],
  ): Promise<void>;

  /**
   * Annotating a resource, delegated as a `mark` job. `params` state the
   * motivation and what a job of that motivation takes, and nothing else: a
   * parameter it does not take does not compile, and is refused if sent.
   *
   * ⚠️ Cold: do NOT both `.subscribe(...)` and `await` the same instance —
   * that creates the job twice. Use `.run(onNext)` for progress + completion.
   */
  delegate(
    resourceId: ResourceId,
    params: MarkJobParams,
  ): DelegationObservable<MarkJobCompletion>;

  // UI signals (fire-and-forget bus emits, local-bus fan-out)
  /** Request a new mark on `source` — the id routes the event to the state unit bound to that resource. */
  request(
    source: ResourceId,
    selector: components['schemas']['MarkRequestedEvent']['selector'],
    motivation: Motivation,
  ): void;

  /** Submit the pending annotation with its selector and optional body. */
  submit(input: components['schemas']['MarkSubmitEvent']): void;

  /**
   * UI signal: a delete failed at the caller that awaited it. `delete` rejects;
   * the caller knows whose command failed on which resource and reports it
   * here, and useOutcomeToasts surfaces it.
   */
  reportDeleteError(input: EventMap['mark:delete-error']): void;
}

/**
 * Bind — reference linking
 *
 * One command, `body()`, and two UI signals. The result (updated
 * annotation with resolved reference) arrives on browse.annotations() via
 * the enriched mark:body-updated event.
 *
 * Gateway actor: Stower (via mark:update-body)
 * Event prefix: mark:body-updated (shares mark event pipeline)
 */
export interface BindNamespace {
  body(
    resourceId: ResourceId,
    annotationId: AnnotationId,
    operations: BodyOperation[],
  ): Promise<void>;

  /** UI signal: a reference-binding flow is requested for an annotation. */
  initiate(input: EventMap['bind:initiate']): void;

  /** UI signal: a bind body update failed at an awaiting caller with no toast surface; useOutcomeToasts surfaces it. */
  reportBodyError(input: EventMap['bind:body-error']): void;
}

/**
 * Gather — context assembly
 *
 * Long-running (LLM calls + graph traversal). `annotation()` returns an
 * Observable that emits its result once and completes; `resource()`
 * returns a Promise of the gathered context.
 *
 * Gateway actor: Gatherer
 * Event prefix: gather:*
 */
export interface GatherNamespace {
  annotation(
    resourceId: ResourceId,
    annotationId: AnnotationId,
    options?: components['schemas']['GatherAnnotationOptions'],
  ): StreamObservable<GatherAnnotationComplete>;

  resource(
    resourceId: ResourceId,
    options?: GatherResourceOptions,
  ): Promise<GatheredContext>;

  /** Live query: the annotations elsewhere that refer to a resource. */
  referencedBy(resourceId: ResourceId): CacheObservable<ReferencedByEntry[]>;
}

/**
 * Match — search and ranking
 *
 * Long-running (semantic search, optional LLM scoring). `search()`
 * returns an Observable that emits the results once and completes.
 *
 * Gateway actor: Matcher
 * Event prefix: match:*
 */
export interface MatchNamespace {
  search(
    resourceId: ResourceId,
    referenceId: AnnotationId,
    context: GatheredContext,
    options?: MatchSearchOptions,
  ): StreamObservable<MatchSearchResult>;

  /** Fire-and-forget variant: match-state-unit orchestrates the call and its result Observable. */
  requestSearch(
    input: components['schemas']['MatchSearchRequest'],
    correlationId: string,
  ): void;

  /**
   * Live query: the resources a text search finds, lexically or, when
   * nothing matches the text, by meaning.
   */
  resources(
    search: string,
    filters?: ResourceSearchFilters,
  ): CacheObservable<MatchResourcesResponse>;
}

/**
 * Yield — resource creation
 *
 * resource() is file upload (an awaitable Observable of its phases).
 * delegate() is generation delegated as a job: its events, and awaited, its completion.
 *
 * Gateway actor: Stower + generation worker
 * Event prefix: yield:*
 */
export interface YieldNamespace {
  // File upload. Returns an `UploadObservable` — subscribers see the full
  // `UploadProgress` lifecycle (started → finished); awaiting resolves to
  // `{ resourceId }` directly.
  resource(data: PutBinaryRequest): UploadObservable;

  // Grounded generation, delegated as a `yield` job. The job names no
  // resource: the focus of `params.context` does — annotation focus binds the
  // new resource to the reference; resource focus mints a source→derived
  // provenance annotation. A context without a usable focus throws
  // synchronously. `stallDeadlineMs` is the follower's own and is not sent.
  delegate(
    params: GenerationJobParams,
    stallDeadlineMs?: number,
  ): DelegationObservable<YieldJobCompletion>;

  // Clone
  cloneToken(resourceId: ResourceId): Promise<CloneResourceWithTokenResponse>;
  fromToken(token: string): Promise<ResourceDescriptor>;
  createFromToken(
    options: CreateFromTokenOptions,
  ): Promise<{ resourceId: ResourceId }>;

  /** UI signal: user invoked the clone action from the resource-info panel. */
  clone(): void;
}

/**
 * Beckon — attention coordination
 *
 * Ephemeral signals; nothing is recorded. The gateway relays a wire drive
 * to every connected client; a local signal stays on this client's bus.
 *
 * Gateway actor: none (the gateway relays the frame)
 * Event prefix: beckon:* (and browse:click, browse:resource-open)
 */
export interface BeckonNamespace {
  // Wire drives — beckon OTHER participants (guided-tour moves). Each
  // resolves with the subscriber count, absent when there is none
  // (ITransport.emit).
  attention(
    resourceId: ResourceId,
    annotationId?: AnnotationId,
  ): Promise<number | undefined>;
  click(annotationId: AnnotationId): Promise<number | undefined>;
  openResource(resourceId: ResourceId): Promise<number | undefined>;
  sparkleAll(annotationId: AnnotationId): Promise<number | undefined>;
  // Local signals — this viewer's own fan-out; never the wire.
  hover(annotationId: AnnotationId | null): void;
  sparkle(annotationId: AnnotationId): void;
}

/**
 * Job — worker lifecycle
 */
export interface JobNamespace {
  /** Live stream of `job:queued` events from the bus. */
  readonly queued$: Observable<EventMap['job:queued'] | FrameRefusal>;
  /** Live stream of `job:report-progress` events from the bus. */
  readonly progress$: Observable<
    EventMap['job:report-progress'] | FrameRefusal
  >;
  /** Live stream of `job:complete` events from the bus. */
  readonly complete$: Observable<EventMap['job:complete'] | FrameRefusal>;
  /** Live stream of `job:fail` events from the bus. */
  readonly fail$: Observable<EventMap['job:fail'] | FrameRefusal>;

  status(jobId: JobId): Promise<JobStatusResponse>;
  /**
   * Ask for the job's status, at once and then every `options.everyMs` ms
   * (`JOB_POLL_MS` when unnamed), until it is an end, handing each answer to
   * `onStatus`. Fails `bus.timeout` at `options.withinMs` ms from the first
   * ask (`JOB_POLL_TIMEOUT_MS` when unnamed), the asks and the waits between
   * them counted.
   */
  pollUntilComplete(
    jobId: JobId,
    options?: JobPollOptions,
    onStatus?: (status: JobStatusResponse) => void,
  ): Promise<JobStatusResponse>;
  /** Cancel ONE job by id; resolves with whether the queue acted on it. */
  cancel(jobId: JobId): Promise<boolean>;

  /**
   * A worker's side: claim the jobs `options.accepts` describes, and hold one
   * at a time. Claiming begins when the claims are read, and each job they
   * hand out says its own lifecycle, commits its own annotations and settles
   * once (protocol/contract/WORKER-CONTRACT.md). The transport's stream must name
   * `JOB_CLAIM_CHANNELS`, and `JOB_COMMIT_CHANNELS` for a worker that commits.
   */
  claim(options: ClaimOptions): ClaimsObservable;
}

/**
 * Auth — authentication
 */
export interface AuthNamespace {
  me(): Promise<User>;
  mediaToken(resourceId: ResourceId): Promise<{ token: string }>;
  /** RFC 9728: which issuer the knowledge base trusts — where to send a user to sign in. */
  protectedResourceMetadata(): Promise<ProtectedResourceMetadata>;
}

/**
 * System — what the knowledge base says about itself (health, status).
 */
export interface SystemNamespace {
  healthCheck(): Promise<HealthCheckResponse>;
  status(): Promise<StatusResponse>;
}
