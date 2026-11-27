# Changelog

The changes to the Xynolog SDK for Swift, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

- A type for ten of Protocol's tables that no service keeps, each typed by
  the table's own schema: `ClientDiscoveryAbsent`, `ClientRefresh`,
  `ClientTesting`, `ControlCli`, `ErrorsCodes`, `IdentifiersKinds`,
  `MediaTypesRegistry`, `SdkTelemetryTelemetry`, `SessionOauth` and
  `SignInStoreOwnerOnly`.
- `ServiceEnvironmentVariable`: every environment variable a Xynolog service
  reads, beside its configuration document, by its name
  (`ServiceEnvironmentVariable.xynologBusLog`). The bus log reads its variable
  by it.
- A type for every schema Protocol states, not only the gateway's components:
  the Control API's methods, notifications and errors (`AboutParams`,
  `ErrorData`, `RequestId`, …), the stack's kinds (`Inference`, `Issuer`,
  `KnowledgeIndex`, `Runner`, …), `ProjectConfig`, `FollowerFollowing`, the
  conformance documents, and the rest.
- The Control API's table, `Control`: each method as a `ControlMethod` typed by
  its params and result, with whether it is exclusive and the notifications
  it sends, and each notification as a `ControlNotification` typed by its
  params, with the `ControlParty` that sends it.
- Protocol's tables are public: an `Operation`'s `request`, `result`,
  `failure` and `replyNames`; a channel's `stamps`; `Timings` and
  `RetryBudget`; `resourceScopedChannels`; `telemetrySpans`,
  `telemetryMetrics` and the telemetry attribute keys; `oauthClients`,
  `signInScope`, `ownerOnlyDirectory`, `ownerOnlyFile` and `signInLockName`;
  `mediaTypes`, `extensionAliases` and `encodings`; `locales`, the languages
  Xynolog supports; `cacheQueries`;
  `credentialNames`; `traceField` and `userField`; and the gateway's
  `GatewayRoute`, `GatewayMedia`, `GatewayHeader`, `UploadField` and
  `clientSecretForm`.
- The tables the services keep to, each as its schema's model: the
  environment they read and why they refuse to start (`serviceEnvironmentVariables`,
  `serviceEnvironmentBootRefusals`), what they tell OpenTelemetry and log
  (`serviceTelemetryTelemetry`, `serviceTelemetryLogLines`), each service's
  messages, the jobs' budgets and storage, the worker's answer formats, the
  gateway's media token and response headers, the archivist's layout and
  default entity types, the embedding requests and the bounds of the bus's
  replies, and all of them by file as `serviceTables`.
- `ArchivistRoute`: each of the archivist's operations, its method and path.
- `retryRules`, `retry/rules.json` as its schema's model, and `RetryContext`,
  which says by those rules whether a failure in a boot, a transport, a
  refresh or a job is worth another try.
- `faultOf(_:_:)` and `Fault`: the first fault a value has as a schema Protocol
  states, named by its member and its reason, and what every SDK says of it.
- `Claims.health(of:)`: what an engine claiming with these claims says of
  itself to a worker's health endpoint, as `WorkerEngineHealth`.
- What a value is held to before it is read takes in more of its schema: a
  pattern's groups and alternatives (`^(GET|POST) /`), a set of members an
  object may not carry together, the fewest members it carries, and what its
  members' names must be.

### Changed

- What a worker says of itself and of its claims is the generated client
  types: `ClaimRefusal` (its text is `message`, where it was `detail`),
  `WorkerVitals` with its `WorkerActiveJob`, and `HeldJobStall` (its
  `silentForMs` and `thresholdMs`), where `Claims` declared its own. A vitals
  stamp is the RFC 3339 string the wire carries, to the millisecond.
- A held job keeps the `HeldJobRecord` its claim handed it, as `record`, and
  its `jobId`, `jobType`, `resourceId`, `params`, `completedUnits`,
  `unitCursors`, `retryCount` and `maxRetries` are the record's members, read
  through it.
- A held job's `trace`, and a received frame's, is the generated
  `TraceCarrier`, where it was a `[String: String]` of its members.
- A relayed frame's trace is held to the table before it is read as a
  `TraceCarrier`, and a carrier the table refuses is ignored whole: one with
  an empty `tracestate`, for one, no longer continues its `traceparent`.
- A held job's checkpoint, failure and cancellation take the types Protocol
  states for what each one says: `checkpoint(_ checkpoint: JobCheckpoint)`,
  in place of `checkpoint(completedUnits:unitCursors:)`;
  `fail(_ message: String, failure: JobFailure?)`, in place of
  `fail(_:failureClass:completedUnits:unitCursors:)`; and
  `cancel(_ reached: JobReached?)`, in place of
  `cancel(completedUnits:unitCursors:)`.
- `KbPlacement` names where a knowledge base's stack runs, in place of
  `DiscoveredKBPlacement`, `RootPlacement`, `KnowledgeBaseStatusPlacement`
  and `TargetKind`; `InferenceProvider` names an inference provider, in
  place of `EngineProvider`.
- `PutBinaryRequest` is the type of Protocol's
  `client/types/PutBinaryRequest.json`, where it was the SDK's own: `Codable`
  and `Hashable` as every generated type is, its four required members `var`s
  where they were `let`s, and its initializer names `language` before
  `entityTypes`. `entityTypes` is a `[String]?` and `generator` a
  `OneOrMoreAgents?`, absent by default, where they were a `[String]` and an
  `[Agent]` defaulting to empty. An upload sends `entityTypes` when it is
  present and not empty, as it sent it when not empty, and `generator` as the
  JSON of its value: what an `[Agent]` sent, as an array, is sent of `.list`
  of it.
- A resource's bytes, read whole, are a `ResourceRepresentation`, the type of
  Protocol's `client/types/ResourceRepresentation.json`, where they were the
  SDK's own `Content`: `browse.resourceRepresentation` and
  `ContentTransport.getBinary` answer one, made by
  `ResourceRepresentation(data:contentType:)`, and its bytes are its `data`,
  where they were `bytes`.
- `BrowseNamespace.engines()` is a `Cached<EnginesWithLimits>`, the type of
  Protocol's `client/types/EnginesWithLimits.json`, whose `EngineWithLimits`
  is `Codable` and `Hashable` as every generated type is, where the SDK's own
  was only `Encodable`.
- `Binary`, the type of Protocol's bytes held whole, is `Data`, where it was a
  `String`, and `ResourceUpload`'s `file` is one.
- `RetryBudget` is the model of Protocol's `client/RetryBudget.json`:
  `Codable` and `Hashable`, its members `var`s.
- `ResourceUpload.file` is a `Binary`, the type of Protocol's bytes held
  whole, which is a `String`.
- The keys a registry keeps what it keeps under, and the prefixes of the
  keys made per knowledge base, are generated from Protocol's
  `session/stored.json`, with the names and values they had
  (`knowledgeBasesKey`, `pendingAuthorizationKey`, …).
- A model's members are in its schema's order, as the other SDKs hold them,
  and so are its initializer's arguments and the members it writes: a call
  names them in that order (`JobProgress(percentage: 50, message: …)`),
  where it named them in the order of their names.
- The items of a union's member that is a list are the union's type and
  `Item`, as the other SDKs name them (`ResourceDescriptorContextItem`),
  where they were `ResourceDescriptorContextListItem`.
- A union's member that is an object of no named member, and holds any, is
  its `object` case, as Typing names its variant
  (`ResourceDescriptorContext.object`), where it was `empty`.
- A union is decoded as the one member that admits a value, by what each
  member's schema states, where one whose schema names no `discriminator`
  was decoded as the first member that decoded. A value that no member
  admits, but that one member names by its kind and the values it states, is
  refused for what is wrong with it as that member; one that none names is
  refused.
- A union every member of which is text is a `String`, as a bus event's
  `id` (`BusEventMessage.id`) is, where it was an enumeration of its members
  that read every value as the first.
- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- `GetAnnotationsResponse.motivation` is a `Motivation?`, where it was a
  `Stated<Motivation>`. Protocol no longer allows it to be null: a null for it
  is refused as malformed.
- The smelter's and the weaver's health name how far they have followed the
  record as `FollowerFollowing`, the type Protocol states, in place of
  `SmelterHealthFollowing`, `WeaverHealthFollowing` and their `…Sweep` types.
- `OpenResource` is the type Protocol states: its `openedAt` is an `Int`, and
  its initializer takes its members in their alphabetical order.
- `PendingAuthorization` is the type Protocol states: its members are
  variables, its `issuer` is public as `PendingAuthorizationIssuer`, and its
  initializer takes its members in their alphabetical order.
- `LastEventIds` is keyed by `ResourceId`, as Protocol keys it, in place of
  `String`. Each id (`ResourceId`, `AnnotationId`, `JobId`, `UserId`) is an
  `Identifier`, which is `CodingKeyRepresentable`: a dictionary keyed by one
  is a JSON object, and a key its kind's rule refuses is no key.
- Every type Protocol states is `Hashable`, and so is `JSONValue`.
- A method's options are the types Protocol states for them:
  `job.claim(ClaimOptions)` in place of the accepts and `WorkerTiming`,
  `job.pollUntilComplete(_:options: JobPollOptions, onStatus:)` in place of
  `intervalMs` and `timeoutMs`, `match.search(…, options: MatchSearchOptions)`
  in place of `limit` and `useSemanticScoring`, and
  `yield.createFromToken(CreateFromTokenOptions)`.
- `browse.resources` takes `BrowseResourcesRequest` and `match.resources`
  takes `ResourceSearchFilters`, in place of `ResourceFilters`. Filters that
  send the same request share one live query.
- A failure a bus request is answered with is read as `CommandError`.
- What a caller leaves out of these options is not sent, and the service's
  own default applies (protocol#109): `browse.resources` and
  `match.resources` no longer send a `limit` of 100 and an `offset` of 0,
  `gather.annotation` no longer sends a `contextWindow` of 2000, nor an
  `options` member when it is given none, and `match.search` no longer sends
  `useSemanticScoring` true. Its `limit` is still 10 when none is stated.
- Discovery's types are the ones Protocol states: `parseDiscoveryDocument`
  returns `DiscoveryState`, a `DiscoveryTransport` reads a `DiscoveryRead`
  (`.discoveryAbsent`, `.discoveryManaged` or `.discoveryUnchanged`, where it
  was `.state` or `.unchanged`), and `subscribeDiscovery` yields
  `DiscoveryDiff`, which is `Codable` and `Hashable`. `Absent`, `Managed` and
  `Unchanged` are `DiscoveryAbsent`, `DiscoveryManaged` and
  `DiscoveryUnchanged`.
- `UploadProgressStarted` and `UploadProgressProgress` state `totalBytes`
  only when the upload's source states its length (protocol#121), so it is an
  `Int?`. Every upload holds its bytes whole and still reports it.
- What a caller may set of the timing is two types generated from Protocol's
  `client/timing.json`, `ClientTiming` and `TransportTiming`, each member the
  entry its name says. `XynologClient` takes `timing: ClientTiming`, in place
  of `followTiming:`, `invalidationWindowMs:` and `busRequestTimeoutMs:`, and
  `FollowTiming`'s `silenceMs` and `statusPollMs` are its `jobSilenceMs` and
  `jobStatusPollMs`. `TransportTiming`'s `httpRequestMs` and `streamOpenMs` are
  `httpRequestTimeoutMs` and `streamOpenTimeoutMs`, and its `emitAttempts`,
  `emitInitialDelayMs` and `emitMaxDelayMs` are `emitRetry`, a `RetryBudget`.
  Its initializer takes its members in the table's order, and none as `nil`.
- `XynologClient.fromHttp`, `sessionFromKept` and `HttpSessionFactory` take
  `clientTiming:` and `transportTiming:`, what the client and the transport of
  each keep.

### Fixed

- An annotation's `created`, a knowledge base's `KbRead.at` and the worker
  driver's vitals are RFC 3339 date-times in UTC. `created` lacked its `Z`,
  and `at` and the vitals carried a time with no date.

### Removed

- `ResourceFilters` and `WorkerTiming`: `BrowseResourcesRequest`,
  `ResourceSearchFilters` and `ClaimOptions` say what they said.
- `FollowTiming`: `ClientTiming` says what it said.
- `Stated` is removed. No member of Protocol is both optional and nullable, so
  a model's optional property is an optional, absent when `nil`.

## 0.8.1

### Added

- The distribution carries a `.spi.yml`, so the Swift Package Index hosts
  the DocC documentation of `Xynolog` and `XynologTesting`.
- The README reads as the package's front page: what the SDK is, how to
  install it (by `xynolog/sdk-swift`'s URL, taking releases up to the next
  minor), and a first program before connecting, signing in and the eight
  verbs. How to work on the SDK moved to the repository's CONTRIBUTING.md,
  which the README's last line links to.
- The README links to the repository's files at the release's tag, so its
  links resolve wherever the Swift Package Index shows it and show the
  files as of the release.
- The distribution's README is this README, as of the release, in place of
  a short page that pointed at it on `main`: the Swift Package Index shows
  the package's whole README.

### Changed

- The README's coverage badge reads the package: `make test-swift` exports
  the tests' coverage with `Scripts/coverage.sh`, which leaves out the build
  directory wherever its link leads, and CI uploads it to Codecov.
