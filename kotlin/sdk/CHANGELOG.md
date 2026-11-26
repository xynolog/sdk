# Changelog

The changes to the Xynolog SDK for Kotlin, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

- `xynolog.services.ServiceEnvironmentVariable`: every environment variable a
  Xynolog service reads, beside its configuration document, a constant of its
  name (`XYNOLOG_BUS_LOG`). The bus log reads its variable by it.
- A type for every schema Protocol states, not only the gateway's components:
  the Control API's methods, notifications and errors (`AboutParams`,
  `ErrorData`, `RequestId`, …), the stack's kinds (`Inference`, `Issuer`,
  `KnowledgeIndex`, `Runner`, …), `ProjectConfig`, `FollowerFollowing`, the
  conformance documents, and the rest.
- What a value is held to before it is read takes in more of its schema: a
  pattern's groups and alternatives (`^(GET|POST) /`), a set of members an
  object may not carry together, the fewest members it carries, and what its
  members' names must be.
- `xynolog.services.ServiceTables`: every table the services keep to, each
  read as its schema's type (`GatewayMessages`, `ServiceEnvironmentVariable`,
  `ArchivistLayout`, …, now in `xynolog.types`): the variables a service
  reads and its boot refusals, its telemetry and log lines, its messages,
  the jobs' budgets and storage, the bounds of the bus's replies, the
  embedding requests, the worker's answer formats, the gateway's media token
  and response headers, the Archivist's layout and default entity types, and
  the rest; `SERVICE_TABLES` holds each by its file. And `ArchivistRoute`,
  each of the Archivist's HTTP operations.
- `xynolog.control`: the launcher's control API, `ControlMethods`, each of
  its methods and notifications with the serializers of what each carries,
  whether it runs alone and what it sends, and the
  `xynolog.types.ControlSender` that sends a notification.
- `xynolog.errors.ControlErrorCode`, the control API's codes.
- `CONTROL_RPC_*`, each code of `control/rpc-codes.json`, and
  `controlRpcCodeOf(code)` and `controlCodeRetryable(code)`: the JSON-RPC code
  each control error code is answered with, and whether a request it failed is
  worth sending again, generated from `control/rpc-codes.json` and
  `errors/codes.json`.
- `xynolog.discovery.DISCOVERY_URL_PATH`, where a launcher's discovery
  document is, generated from `client/surface.json`.

### Changed

- A retry budget is `xynolog.types.RetryBudget`, the type of Protocol's
  `client/RetryBudget.json`, where it was `xynolog.retry.RetryPolicy`:
  `Timing.emitRetry` is one, and `retryWithBackoff` and
  `retryWithBackoffFuture` take one. Its `attempts` is a `Long`.
- `ResourceUpload.file` is a `Binary`, the type of Protocol's bytes held
  whole, which is a `String`.
- The keys a registry keeps what it keeps under (`KNOWLEDGE_BASES_KEY`,
  `ACTIVE_KEY`, `OPEN_RESOURCES_BY_KB_KEY`, `LAST_VIEWED_RESOURCE_BY_KB_KEY`,
  `PENDING_AUTHORIZATION_KEY`) are generated from Protocol's
  `session/stored.json`, and Java reads them from `StoredKeysKt`, where it
  read them from `StoredKt`.
- The version of a kept query's document is generated from
  `session/stored.json` too, where `Stored.kt` stated it.
- A member of one integer or boolean is a type of its own, as a member of
  one string already was: an object, read and written as that value, and
  the member's default (`ConformanceDriverLineReady.ready` is
  `ConformanceDriverLineReadyReady`). It was a `Long` or `Boolean` a caller
  passed, and a builder took.
- A union is decoded as the one member that admits a value, by what each
  member's schema states, where one whose members do not each state one
  value of a property was decoded as the first member, of those read from
  the value's kind of JSON, that fit. A value that no member admits, but
  that one member names by its kind and the values it states, is refused for
  what is wrong with it as that member; one that none names is refused.
- A stream's place, and each place the bookmarks keep, is an id
  `LastEventIds` holds in its scope, in place of an id held to
  `PersistedEventId` by that schema's name.
- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- `GetAnnotationsResponse.motivation` is a `Motivation?`, absent when null,
  where it was a `Stated<Motivation>`, and carries Protocol's description of
  it; its builder's `motivation(null)` leaves it absent. Protocol no longer
  allows it to be null: a null for it is refused as malformed.
- The element of an answer format (`WorkerAnswerFormatsFormatsItem`'s
  `element`) carries Protocol's description of it.
- The smelter's and the weaver's health name how far they have followed the
  record as `FollowerFollowing`, the type Protocol states, in place of
  `SmelterHealthFollowing`, `WeaverHealthFollowing` and their `…Sweep` types.
- A schema of one integer, number or boolean is an alias of that type
  (`HttpStatus`), and a union reads a member that is a number or a boolean.
- `OpenResource` is `xynolog.types.OpenResource`, the type Protocol states, in
  place of `xynolog.registry.OpenResource`: its `order` is a `Long`, and Java
  makes one with its `builder`.
- What is kept of a sign-in is `xynolog.types.StoredSession`, in place of
  `xynolog.signin.HeldSignIn`.
- A method takes the options Protocol states as one value, of Protocol's
  type: `browse.resources(BrowseResourcesRequest)`,
  `match.resources(search, ResourceSearchFilters)`,
  `match.search(…, MatchSearchOptions)`, `gather.annotation(…,
  GatherAnnotationOptions)`, `gather.resource(…, GatherResourceOptions)`,
  `yield.createFromToken(CreateFromTokenOptions)`,
  `job.pollUntilComplete(jobId, JobPollOptions, onStatus)` and
  `job.claim(ClaimOptions)`, and the gather state unit's two methods. A
  member left out is what was taken before.
- A worker's vitals state its times as RFC 3339 text and its active job as
  `WorkerActiveJob`, as `WorkerEngineHealth` does, and
  `Claims.health(engine)` is that health. `xynolog.jobs.ActiveJob` is gone.
- A channel that carries nothing is typed `xynolog.types.EmptyObject`, in
  place of `xynolog.channels.Empty`.
- A discovery document is read as its schema states it: its versions are
  those `DiscoveryDocument` allows.
- A sign-in by a page redirect that is under way is
  `xynolog.types.PendingAuthorization`, the type Protocol states, in place of
  `xynolog.http.PendingAuthorization`, and its issuer is
  `xynolog.types.PendingAuthorizationIssuer`, in place of
  `xynolog.http.IssuerEndpoints`. Java makes each with its `builder`.
- What a worker's claims say is of the types Protocol states:
  `xynolog.types.ClaimRefusal`, `xynolog.types.WorkerVitals` and
  `xynolog.types.HeldJobStall`, in place of `xynolog.jobs.ClaimRefusal`,
  `xynolog.jobs.WorkerVitals` and `xynolog.jobs.HeldJobStall`. A stall's
  `heldSince` and `lastActivityAt` are RFC 3339 text, to the millisecond,
  where they were `Instant`s. Java makes each with its `builder`.
- A trace a frame was sent under is `xynolog.types.TraceCarrier`, the type
  Protocol states, in place of `xynolog.transport.TraceContext`: a `Frame`'s,
  a `Delivered`'s and a `HeldJob`'s `trace`.
- A held job's `jobId`, `jobType`, `resourceId`, `params`, `completedUnits`,
  `unitCursors`, `retryCount` and `maxRetries` are those of its `record`, the
  `xynolog.types.HeldJobRecord` its claim hands it: `HeldJob` is a
  `HeldJobRecordMembers`, generated from Protocol, and `record` is new.
- Where a knowledge base runs is `KbPlacement`, in place of
  `DiscoveredKBPlacement`, `RootPlacement`, `KnowledgeBaseStatusPlacement` and
  `TargetKind`; an engine's provider is `InferenceProvider`, in place of
  `EngineProvider`.
- A held job says what it reached as the types Protocol states:
  `checkpoint(JobCheckpoint)`, in place of `checkpoint(completedUnits,
  unitCursors = null)`; `fail(error, JobFailure? = null)`, in place of
  `fail(error, failureClass = null, completedUnits = null, unitCursors =
  null)`; and `cancel(JobReached? = null)`, in place of
  `cancel(completedUnits = null, unitCursors = null)`. Java's
  `checkpointFuture(JobCheckpoint)`, `failFuture(error, JobFailure)` and
  `cancelFuture(JobReached)` take them the same way, made with each type's
  `builder`.
- `JOB_CLAIM_CHANNELS` and `JOB_COMMIT_CHANNELS` are generated, in
  `xynolog/jobs/WorkerChannels.kt`. Java reads them from `WorkerChannelsKt`,
  in place of `ClaimsKt`: `WorkerChannelsKt.getJOB_CLAIM_CHANNELS()`.
- A default the service decides is no longer sent for it (protocol#109).
  `browse.resources` and `match.resources` send no `limit` of 100 and no
  `offset` of 0, `gather.annotation` no `contextWindow` of 2000, and
  `match.search` no `useSemanticScoring` of true, when the caller leaves them
  out: the service's own default applies. Options to `gather.annotation` that
  state nothing are not sent.
- `stateDir` takes Protocol's `xynolog.types.System`, and `thisPlatform()` is
  `thisSystem()`, where `Platform` was the SDK's own.
- `CacheState.status` is Protocol's `xynolog.types.CacheStatus`, where it was
  a `String`.

### Removed

- `xynolog.types.Stated` is removed. No member of Protocol is both optional
  and nullable, so a model's optional property is a nullable type, absent when
  null.

## 0.8.1

### Added

- The publication carries the POM Maven Central takes (name, description,
  URL, license, developer, SCM, issue tracker), a sources jar and a javadoc
  jar.

### Changed

- The README is the artifact's front page: it says what the SDK is, how to
  depend on it with Gradle or Maven and take releases up to the next minor,
  and then shows a first program, connecting to a knowledge base and saying
  its name, before connecting, signing in and the eight verbs. How the SDK
  itself is built moves to CONTRIBUTING.md, which the README's last line
  links to.

### Fixed

- kotlinx-serialization-json and kotlinx-coroutines-core are `api`
  dependencies, in the POM's compile scope: the public API takes and
  returns their types (`JsonObject`, `KSerializer`, `StateFlow`), so a
  consumer compiles against them without declaring them itself.
