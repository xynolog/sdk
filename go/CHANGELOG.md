# Changelog

The changes to the Xynolog SDK for Go, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

- A type for ten of Protocol's tables that no service keeps, each typed by
  the table's own schema: `ClientDiscoveryAbsent`, `ClientRefresh`,
  `ClientTesting`, `ControlCli`, `ErrorsCodes`, `IdentifiersKinds`,
  `MediaTypesRegistry`, `SdkTelemetryTelemetry`, `SessionOauth` and
  `SignInStoreOwnerOnly`.
- A type for every schema Protocol states, not only the gateway's components:
  the Control API's methods, notifications and errors (`AboutParams`,
  `ErrorData`, `RequestId`, …), the stack's kinds (`Inference`, `Issuer`,
  `KnowledgeIndex`, `Runner`, …), `ProjectConfig`, `FollowerFollowing`, the
  conformance documents, and the rest.
- What a value is held to before it is read takes in more of its schema: a
  pattern's groups and alternatives (`^(GET|POST) /`), a set of members an
  object may not carry together, the fewest members it carries, and what its
  members' names must be.
- Package `control`, the launcher's control API: each method a
  `control.Method[P, R]` and each notification a `control.Notification[P]`,
  typed by `api`'s types of their schemas, with whether a method is exclusive,
  what it may send, and who sends a notification (`api.ControlSender`).
- `ControlErrorCode`, the control API's error codes, generated with the other
  error codes.
- `RetryRuleJob`, the rule a job's retry budget follows. Every rule's sets
  (`Statuses`, `StatusFrom`, `IdempotentMethods`, `NoResponse`) are now
  generated from `retry/rules.json`.
- The gateway's routes are exported (`GatewayRoute`, `RouteGetHealth`, …), as
  are the headers its operations name (`HeaderIdempotencyKey`, …) and the
  query parameter a media token goes in (`MediaTokenQuery`).
- `HTTPTransport.MediaURL`: where a reader that sends no bearer reads a
  resource's representation with a media token.
- `ServiceEnvironmentVariable`: every environment variable a Xynolog service
  reads, as `service-environment/variables.json` names it.
- Package `servicetables`: every table the services keep to (the archivist's
  layout, messages and default entity types, the jobs' budgets and
  storage, the bus's reply bounds, the worker's answer formats, the
  environment and telemetry tables and the rest), each a value of `api`'s
  type of its own schema, read from the table as Protocol holds it.
- `ArchivistRoute`: each operation of the Archivist's HTTP surface, its method
  and its path (`ArchivistRouteGetHealth`, `ArchivistRouteStoreResource`, …).
- `api.ControlRpcCode`, each code of `control/rpc-codes.json`
  (`api.ControlRpcCodeInternalError`, …), and `ControlErrorCode.Rpc` and
  `Retryable`: the JSON-RPC code each control error code is answered with, and
  whether a request it failed is worth sending again, generated from
  `control/rpc-codes.json` and `errors/codes.json`.
- `discovery.DiscoveryURLPath`, where a launcher's discovery document is,
  generated from `client/surface.json`.

### Changed

- A schema a `$ref` names at a place within a file is one type, named where
  that place is stated, wherever it is referred to: the Archivist layout's
  trees are all `ArchivistLayoutEventStreamTree`, every error vocabulary
  whose codes state only their docs is `ErrorsCodesJob`, the SDK's telemetry
  instruments are `ServiceTelemetryTelemetryMetricsItemInstrument`, and the
  rest. The type each reference was given of its own
  (`ArchivistLayoutViewTree`, `ErrorsCodesSession`, …) is gone.
- An upload is an `api.PutBinaryRequest`, the type of Protocol's
  `client/types/PutBinaryRequest.json`, where it was the SDK's own
  `PutBinaryRequest`: `ContentTransport.PutBinary` and
  `YieldNamespace.Resource` take one, and `xynologtest.ContentCall.Put` is
  one. Its bytes are its `File`, where they were `Bytes`; `StorageURI`,
  `SourceAnnotationID`, `SourceResourceID` and `JobID` are `StorageUri`,
  `SourceAnnotationId`, `SourceResourceId` and `JobId`. A member it may leave
  out is a pointer, nil when it is left out: `Language`, `GenerationPrompt`
  and `CloneToken` are `*string`, `EntityTypes` is `*[]string`, and the ids
  are pointers to them. `Generator` is an `*api.OneOrMoreAgents`, one agent
  or several, where it was an `*api.Agent`. What an upload sends is as it
  was.
- A resource's bytes, read whole, are an `api.ResourceRepresentation`, the
  type of Protocol's `client/types/ResourceRepresentation.json`, where they
  were the SDK's own `Content`: `BrowseNamespace.ResourceRepresentation` and
  `ContentTransport.GetBinary` answer one, and its bytes are its `Data`, where
  they were `Bytes`. `xynologtest.InMemoryContent.Seed` takes one.
- `BrowseNamespace.Engines` is a `Cached[api.EnginesWithLimits]`, the type of
  Protocol's `client/types/EnginesWithLimits.json`, where it was of the SDK's
  own `EngineWithLimits`: an engine's `Engine` and `Jobs` are its own fields,
  where they were its `Entry`'s.
- A retry budget is `api.RetryBudget`, the type of Protocol's
  `client/RetryBudget.json`, where it was `RetryPolicy`:
  `TransportTiming.EmitRetry` is one, and `RetryWithBackoff` takes one. Its
  delays are whole milliseconds, `InitialDelayMs` and `MaxDelayMs`, as
  Protocol states them, where they were `time.Duration`s, `InitialDelay` and
  `MaxDelay`.
- `ResourceUpload.File` is an `api.Binary`, the type of Protocol's bytes held
  whole, which is `[]byte`.
- The keys a registry keeps what it keeps under, and the prefixes of the
  keys made per knowledge base, are generated from Protocol's
  `session/stored.json`, with the names and values they had
  (`registry.KnowledgeBasesKey`, `PendingAuthorizationKey`, …).
- The version of a kept query's document is generated from
  `session/stored.json` too, where `storage.go` stated it.
- A struct's fields are in the order its schema states its members, as in
  every SDK, where they were in the order of their names.
- A schema of an object that names no member and says nothing of others
  (`BrowseKbRequest`, `Runner`, `ResourceUnarchivedPayload`) is an empty
  struct, as in every SDK: the members a value carries beside are read past
  and not written back, where it was an alias of `map[string]any` that kept
  them.
- Every union says which member a value is: `Member` (in place of
  `ValueByDiscriminator`, which only a union told apart by a property had)
  reads it as the one member whose schema admits it. A value that no member
  admits is refused, said of the one member that names it by its kind and
  the values it states, where one does.
- A stream's place, and each place `CoupledBookmarks` keeps, is an id
  `LastEventIds` holds in its scope, read as the generated `api.LastEventIds`,
  in place of an id held to `PersistedEventId` by that schema's name.
- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- So is one in what the SDK reads beside a request's answer: the emit reply,
  the agent's `UserResponse`, a stored event, the job anchor, stored tabs and
  last-viewed, and a 429's `LimitRefusal`. Each takes the way it already had
  for what does not read. A last-viewed map that holds a null is not read,
  where the null was read as `""`.
- `GetAnnotationsResponse`'s `Motivation` carries Protocol's description of
  it. Protocol no longer allows it to be null: a null for it is refused as
  malformed.
- The element of an answer format (`WorkerAnswerFormatsFormatsItem`'s
  `element`) carries Protocol's description of it.
- The smelter's and the weaver's health name how far they have followed the
  record as `FollowerFollowing`, the type Protocol states, in place of
  `SmelterHealthFollowing`, `WeaverHealthFollowing` and their `…Sweep` types.
- `OpenResource` is `api.OpenResource`, the type Protocol states, in place of
  `registry.OpenResource`: its `Id` and `StorageUri` are spelled as Protocol
  spells them, and a media type or storage URI it does not know is nil.
- What is kept of a sign-in is `api.StoredSession`, in place of
  `HeldSignIn`: its `ClientId` is spelled as Protocol spells it, and an issuer
  with no revocation endpoint states none (nil).
- What a sign-in by a page redirect remembers is `api.PendingAuthorization`,
  in place of `PendingAuthorization`, and its issuer is
  `api.PendingAuthorizationIssuer`, in place of `IssuerEndpoints`, the types
  Protocol states: its `RedirectUri` and `KbId` are spelled as Protocol
  spells them, and an issuer with no device or revocation endpoint states
  none (nil). `Issuer.Discover` and `SignInWithDevice` give the issuer as
  that type, and `Bookmarks.Load` gives the places as `api.LastEventIds`.
- `Browse.Resources` takes `api.BrowseResourcesRequest` and `Match.Resources`
  takes `api.ResourceSearchFilters`, the types Protocol states, in place of
  `ResourceFilters`, which is gone. A limit stated as zero is now sent as
  zero.
- A union's member interface is exported (`api.MarkJobParamsMember`,
  `api.ConformanceDriverLineMember`, …), so a function can take any member
  of a union. Its marker method is still unexported: no other type joins it.
- `Job.PollUntilComplete` takes `api.JobPollOptions` in place of its `every`
  and `within` durations; a wait left out (nil) is the client's timing.
- `Job.Claim` takes `api.ClaimOptions`: the filters it accepts, and any of its
  four waits in place of the client's timing.
- A worker's claims give the types Protocol states, in place of the
  package's own: `api.ClaimRefusal` (in place of `ClaimRefusal`; a
  `*api.ClaimRefusal` is the error the claims give), `api.WorkerVitals` and
  `api.WorkerActiveJob` (in place of `WorkerVitals` and `ActiveJob`),
  `api.HeldJobStall` (in place of `HeldJobStall`) and `api.JobFailure` (in
  place of `JobFailure`), which `HeldJob.Fail` takes. A stamp is the RFC 3339
  text the wire carries, in UTC to the millisecond, where it was a
  `time.Time`; a vitals stamp that has not happened is nil, where it was the
  zero time. A stall's silence and threshold are `SilentForMs` and
  `ThresholdMs`, whole milliseconds, in place of `SilentFor` and `Threshold`.
  A failure's `CompletedUnits` and `UnitCursors` are pointers, nil when it
  states none, as `api.JobFailCommand`'s are.
- A trace is `*api.TraceCarrier`, the type Protocol states, in place of
  `TraceContext`, which is gone: `Frame.Trace`, `Delivered.Trace` and
  `HeldJob.Trace` are nil for none, where they were the zero `TraceContext`,
  and `Continuing` takes one. A trace with no tracestate has a nil
  `Tracestate`, where it was "".
- A held job's members as its claim handed it (`JobId`, `JobType`,
  `ResourceId`, `Params`, `CompletedUnits`, `UnitCursors`, `RetryCount` and
  `MaxRetries`) are `HeldJobRecordMembers`, generated from
  `api.HeldJobRecord`, which `HeldJob` embeds. `HeldJob.Record` is the whole
  record.
- `api.KbPlacement` replaces `api.DiscoveredKBPlacement`, `api.RootPlacement`,
  `api.KnowledgeBaseStatusPlacement` and `api.TargetKind`, and
  `api.InferenceProvider` replaces `api.EngineProvider`: Protocol states each
  once.
- A resource's representation is held to the whole of its schema when it is
  read, not to its media type alone.
- `HeldJob.Checkpoint` takes `api.JobCheckpoint`, the type Protocol states,
  in place of its units and cursors: `Checkpoint(ctx, checkpoint
  api.JobCheckpoint)` where it was `Checkpoint(ctx, completedUnits []string,
  unitCursors map[string]api.UnitCursor)`. `HeldJob.Cancel` takes
  `api.JobReached` likewise: `Cancel(ctx, reached api.JobReached)` where it
  was `Cancel(ctx, completedUnits []string, unitCursors
  map[string]api.UnitCursor)`; `api.JobReached{}` states nothing reached.
- A frame's trace is read as `api.TraceCarrier` by the required table: one
  the table refuses, such as one whose tracestate is empty, is no trace, and
  is still taken off the payload.
- A default the service owns is no longer sent when the caller leaves it
  out, and the service's own applies (protocol#109): `Browse.Resources` and
  `Match.Resources` no longer send `limit` 100 and `offset` 0,
  `Gather.Annotation` no longer sends `contextWindow` 2000 (nor `options`
  when every option is nil), and `Match.Search` no longer sends
  `useSemanticScoring` true. A stated value is sent as stated, and a list or
  a search stating a limit of 100 is no longer the one stating none.
- `StateDir` takes Protocol's `api.System` (`api.SystemMacos`,
  `api.SystemWindows`, `api.SystemOther`), where the package declared its own
  `System`.
- The discovery types are Protocol's (protocol#126), in `api`, where they
  were hand-written in `discovery`: `ParseDiscoveryDocument` gives an
  `api.DiscoveryState`, `DiscoveryTransport.Read` an `api.DiscoveryRead`, and
  `SubscribeDiscovery` each `api.DiscoveryDiff`. A state and a read are
  unions, made with `From` and read with `Member`: a state holds an
  `api.DiscoveryAbsent` or an `api.DiscoveryManaged`, and a read either or an
  `api.DiscoveryUnchanged`.
  `discovery.Absent`, `Managed`, `Unchanged`, `DiscoveryState`,
  `DiscoveryRead` and `DiscoveryDiff` are removed. An absent's `Diagnostic`
  is a `*string`, nil when there is no more to say, and a managed's entries
  are `Kbs`.
- `api.DiscoveryAbsentReason` is the generated client type
  (`client/types/DiscoveryAbsentReason.json`), with a `Valid` method; its
  values keep their names.
- `api.UploadProgressStarted`, `api.UploadProgressProgress` and
  `api.ConformanceDriverLineProgressProgress` state `TotalBytes` as an
  `*int`: a source of unstated length states none. Every upload today holds
  its bytes whole, and states its total.
- `api.StoredSession`'s `Access` is an `api.AccessToken`, which is a `string`.
- A caller sets only the timing Protocol's `client/timing.json` lets one set.
  `Timing` and `DefaultTiming()` are removed for two records of those rows:
  `ClientTiming` (`BusRequestTimeout`, `InvalidationWindow`, `JobSilence`,
  `JobStatusPoll`), whose values `DefaultClientTiming()` gives, and
  `TransportTiming` (`EmitRetry`, `HttpRequestTimeout`, `StreamOpenTimeout`,
  `Reconnect`, `Linger`, `SeenEventIdsCount`, `LazyRemove`), whose values
  `DefaultTransportTiming()` gives. Every other timing is the table's, and
  nothing sets it; a claim's and a job poll's waits are stated in
  `api.ClaimOptions` and `api.JobPollOptions`, as before.
- `ClientConfig.Timing` and `xynologtest.TestClientConfig.Timing` are a
  `ClientTiming`; `HTTPTransportConfig.Timing`, `Issuer.Timing`,
  `AgentConfig.Timing`, `SessionConfig.Timing` and `ResumeConfig.Timing` are a
  `TransportTiming`. `SessionFromKeptConfig` and `registry.HttpSessionFactory`
  take a `ClientTiming` and a `TransportTiming`, in members of those names,
  where they took `Timing`.
- `DescribeConnection` takes a `ClientTiming` and a `TransportTiming` where it
  took a `Timing`: `DescribeConnection(ctx, target, access, client,
  clientTiming, transportTiming, random)`. `registry.CompleteSignIn` takes the
  `ClientTiming` of the client it asks the knowledge base with, as a last
  argument.
- `RenewalDelay` and `RefreshDelay` take no timing: `RenewalDelay(lifetime,
  remaining)` and `RefreshDelay(token, now)`.
- `NewCache` takes no save wait: a cache saves `saveDebounceMs` after its
  values last changed.
- `NewStoragePersister` takes no size: `NewStoragePersister(storage, key)`. A
  document larger than `maxStoredBytesCount` loses the entries that have gone
  longest without a new value, until it fits.
- `state.HoverDelay` and `state.SearchDebounce` hold the table's
  `hoverDelayMs` and `searchDebounceMs`, which `DefaultTiming()` held:
  `state.NewHoverDwell` and `state.NewSearchPipeline` take the delay and the
  debounce their caller states.
- `discovery.DiscoveryInterval` is a constant, where it was a variable.

## 0.8.1

### Added

- Examples on pkg.go.dev: a client over the HTTP transport, an agent
  signed in at its issuer, and a resource's text read over `xynologtest`'s
  doubles.

### Changed

- The module requires Go 1.26, not 1.27.
- The README is pkg.go.dev's page for the module: it says what the SDK is,
  how to install it and take releases up to the next minor, and then shows a
  first program before signing in and the eight verbs. How the SDK itself is
  regenerated and checked moves to CONTRIBUTING.md, which the README's last
  line links to.
- The README links to the repository's files at the release's tag, so its
  links resolve on pkg.go.dev and show the files as of the release.
