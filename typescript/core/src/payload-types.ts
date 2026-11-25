/**
 * Payload Type Aliases
 *
 * Convenience aliases for OpenAPI-generated schema types that are
 * referenced across the codebase. Shorter than
 * `components['schemas']['<Name>']` and carry intent.
 *
 * These aliases are not about the bus. They live here so that
 * bus-protocol.ts can focus on channel-protocol concerns (EventMap,
 * CHANNEL_SCHEMAS, scope classification).
 */

import type { components, records } from './types';

export type Selector = components['schemas']['Selector'];

/** Where a clicked annotation's element is on the viewer's screen. */
export type AnchorRect = components['schemas']['AnchorRect'];

/** One of an annotation's bodies, and one change to its list of bodies. */
export type AnnotationBody = components['schemas']['AnnotationBody'];
export type BodyOperation = components['schemas']['BodyOperation'];

export type GatheredContext = components['schemas']['GatheredContext'];

// What a job is asked with and what it reports, under the spec's own names —
// the wire owns these shapes, and a differently-named local alias is a rename
// layer, not a derivation.
export type MarkJobParams = components['schemas']['MarkJobParams'];
export type JobFilter = components['schemas']['JobFilter'];
export type JobResult = components['schemas']['JobResult'];
export type MarkJobDone = components['schemas']['MarkJobDone'];
export type YieldJobDone = components['schemas']['YieldJobDone'];
/** What a `mark` job reports: its counts, or a decline. */
export type MarkJobResult = components['schemas']['MarkJobResult'];
/** What a `yield` job reports: the resource it made, or a decline. */
export type YieldJobResult = components['schemas']['YieldJobResult'];

/**
 * The furthest one unit of a job got, and what it had counted there: where a
 * resume takes an unfinished unit up, and where a finished unit ended.
 * Spec-owned: it crosses the wire on three job commands and is read back off
 * the claimed record's metadata, so the queue, the worker and the Go client
 * all have to mean the same `{ next, size }`.
 */
export type UnitCursor = components['schemas']['UnitCursor'];
/**
 * A `yield` job's parameters, as the spec states them: what the SDK's
 * `yield.delegate` writes and what a worker is handed with the job.
 */
export type GenerationJobParams = components['schemas']['GenerationJobParams'];
export type JobType = components['schemas']['JobType'];

/**
 * One of the knowledge base's engines (`browse:engines-result`): a provider and
 * a model its Inference document names, and the jobs the document has it used
 * for, each named as a claim names it. An engine only Librarian actors ask
 * omits `jobs`. An engine is not a principal: it carries no identity of its own.
 */
export type EngineEntry = components['schemas']['EngineEntry'];

/**
 * An engine with the inference limits its key holder reported, as the SDK
 * joins them: the knowledge base names its engines, and the services holding
 * the inference credentials report the limits (`LIMITS_OPERATIONS`). Absent
 * `limits` means no key holder reported that engine.
 */
export type EngineWithLimits = EngineEntry & {
  limits?: components['schemas']['InferenceLimits'];
};

/**
 * What a knowledge base says of itself (`browse:kb-result`): its committed
 * name and domain, and the working tree's branch. The Archivist answers it;
 * it is the only source clients use for a KB's name and domain.
 */
export type KbDescription = components['schemas']['KbDescription'];

/**
 * The launcher's published KB-discovery view: the document at
 * `DISCOVERY_URL_PATH` and its entries. Endpoints and identity only — never
 * credentials.
 */
export type DiscoveryDocument = components['schemas']['DiscoveryDocument'];
export type DiscoveredKB = components['schemas']['DiscoveredKB'];

/**
 * A knowledge base as a client names it, kept locally and never sent: where to
 * connect (`KbTarget`, reached by its `KbEndpoint`), what registering one
 * takes (`NewKnowledgeBase`), and a registered one, which has said what it is
 * (`KnowledgeBase`, with its `KbRead`).
 */
export type KbTarget = components['schemas']['KbTarget'];
export type KnowledgeBase = components['schemas']['KnowledgeBase'];
export type NewKnowledgeBase = components['schemas']['NewKnowledgeBase'];
export type KbRead = components['schemas']['KbRead'];
export type KbEndpoint = components['schemas']['KbEndpoint'];
export type HttpEndpoint = components['schemas']['HttpEndpoint'];
export type LocalEndpoint = components['schemas']['LocalEndpoint'];

/** A resource open in a knowledge base (session/OpenResource.json): a registry keeps a list of them per knowledge base. */
export type OpenResource = components['schemas']['OpenResource'];

/**
 * What a registry of knowledge bases hands its caller, and what the state
 * units' signals say: records Protocol states in its tables
 * (protocol/specs/src/client/registry.json, client/state-units.json), with why
 * a session ended (session/cases.json's `told`) and what is kept of a sign-in
 * (session/stored.json).
 */
export type ConnectionIdentity = records['ConnectionIdentity'];
export type Expected = records['Expected'];
export type SignInOutcome = records['SignInOutcome'];
export type KbReadVerdict = records['KbReadVerdict'];
export type TabCheck = records['TabCheck'];
export type KbSessionStatus = records['KbSessionStatus'];
export type SessionEnded = records['SessionEnded'];
export type PermissionDenied = records['PermissionDenied'];
export type KbIdentityConflict = records['KbIdentityConflict'];
export type SessionEndReason = records['SessionEndReason'];
export type StoredSession = records['StoredSession'];
export type PendingAuthorization = records['PendingAuthorization'];
export type LastEventIds = records['LastEventIds'];

/**
 * The client types (protocol/specs/src/client/types) a client holds beside the
 * wire's, the options its methods take, and why discovery found no launcher
 * (client/discovery-absent.json).
 */
export type AnchorMethod = records['AnchorMethod'];
export type MatchQuality = records['MatchQuality'];
export type FrameRefusalReason = records['FrameRefusalReason'];
export type DiscoveryAbsentReason = records['DiscoveryAbsentReason'];
export type BeginAuthorizationOptions = records['BeginAuthorizationOptions'];
export type DeviceCode = records['DeviceCode'];
export type IssuedTokens = records['IssuedTokens'];
export type PdfCoordinate = records['PdfCoordinate'];
export type PendingAnnotation = records['PendingAnnotation'];
export type QuotedText = records['QuotedText'];
export type TextSpan = records['TextSpan'];
export type ReconciledSpan = records['ReconciledSpan'];
export type UploadProgress = records['UploadProgress'];
export type ClaimOptions = records['ClaimOptions'];
export type CreateFromTokenOptions = records['CreateFromTokenOptions'];
export type GatherResourceOptions = records['GatherResourceOptions'];
export type JobPollOptions = records['JobPollOptions'];
export type MatchSearchOptions = records['MatchSearchOptions'];
export type ResourceSearchFilters = records['ResourceSearchFilters'];
export type TraceCarrier = records['TraceCarrier'];
export type ConnectionState = records['ConnectionState'];
export type WorkerVitals = records['WorkerVitals'];
export type WorkerActiveJob = records['WorkerActiveJob'];
export type HeldJobStall = records['HeldJobStall'];
export type ClaimRefusal = records['ClaimRefusal'];
export type JobCheckpoint = records['JobCheckpoint'];
export type JobFailure = records['JobFailure'];
export type JobReached = records['JobReached'];
