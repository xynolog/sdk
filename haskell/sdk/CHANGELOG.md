# Changelog

The changes to the Xynolog SDK for Haskell, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

- A type for ten of Protocol's tables that no service keeps, each typed by
  the table's own schema: `ClientDiscoveryAbsent`, `ClientRefresh`,
  `ClientTesting`, `ControlCli`, `ErrorsCodes`, `IdentifiersKinds`,
  `MediaTypesRegistry`, `SdkTelemetryTelemetry`, `SessionOauth` and
  `SignInStoreOwnerOnly`.
- `Xynolog.Control`: the launcher's control API, a value per method (a
  `ControlMethod params result`) and per notification (a
  `ControlNotification params`), typed by the types of `Xynolog.Types` it
  carries, and `ControlSender`, which side sends a notification.
- `Xynolog.ServiceEnvironment`: every environment variable a Xynolog service
  reads, beside its configuration document, a value of its name
  (`xynologBusLog`). The bus log reads its variable by it.
- A type for every schema Protocol states, not only the gateway's components:
  the Control API's methods, notifications and errors (`AboutParams`,
  `ErrorData`, `RequestId`, …), the stack's kinds (`Inference`, `Issuer`,
  `KnowledgeIndex`, `Runner`, …), `ProjectConfig`, `FollowerFollowing`, the
  conformance documents, and the rest.
- What a value is held to before it is read takes in more of its schema: a
  pattern's groups and alternatives (`^(GET|POST) /`), a set of members an
  object may not carry together, the fewest members it carries, and what its
  members' names must be.
- An enumeration of words has a function that gives each its word
  (`httpEndpointProtocolText`, `jobTypeText`, …).
- `Xynolog.ServiceTables`: every table the services read, each a value of
  the type its own schema states (`jobsBudgets :: JobsBudgets`,
  `serviceEnvironmentVariables`, `gatewayMediaToken`, `archivistLayout`,
  each service's messages, …): every table of a service's area and of
  `service-environment/`, `service-telemetry/` and `jobs/` but the case
  tables, and `bus/reply-bounds.json`.
- `Xynolog.Tables`: the clients' tables no other module carries, each a value
  of the type its own schema states: `localesRegistry` and `retryRules`.
- `Xynolog.Archivist.Routes`: the Archivist's HTTP operations as
  `ArchivistRoute`, typed by what each is asked and answers, with its method,
  path, status, media types and required headers, as `Xynolog.Http.Routes`
  states the gateway's.

### Changed

- A retry budget is `Xynolog.Types.RetryBudget`, the model of Protocol's
  `client/RetryBudget.json`, where `Xynolog.Timing` declared one of its own:
  its fields are `retryBudgetAttempts`, `retryBudgetInitialDelayMs` and
  `retryBudgetMaxDelayMs`, where they were `retryAttempts`,
  `retryInitialDelayMs` and `retryMaxDelayMs`. One read from JSON is held to
  its schema, so each member is at least 1.
- `ResourceUpload`'s `resourceUploadFile` is a `Binary`, the type of
  Protocol's bytes held whole.
- The HTTP transport names each span and its count by the SDK telemetry
  table, as generated values (`spanContentGet`, `metricXynologBusSent`, …)
  in place of names spelled at each call. What it reports is the same.
- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- `getAnnotationsResponseMotivation` is a `Maybe Motivation`, where it was a
  `Presence Motivation`. Protocol no longer allows it to be null: a null for
  it is refused as malformed.
- The smelter's and the weaver's health name how far they have followed the
  record as `FollowerFollowing`, the type Protocol states, in place of
  `SmelterHealthFollowing`, `WeaverHealthFollowing` and their `…Sweep` types.
- A service health's `kb` is a `KbDid`, the type Protocol states, in place of
  `Text`.
- A value is validated against its schema as Protocol states it: `const`,
  `not`, `propertyNames` and `minProperties` among its keywords, and those of
  a schema that states no `type`.
- A pattern may use the class escapes Protocol's patterns use (`\s`, `\d`,
  `\w`, and outside a class `\S`, `\D`, `\W`), and `\/` and `\:`.
- A union's members are named by what each is, in place of their place in
  the union: the type a member names (`KbEndpointLocalEndpoint`), the value
  its discriminant states, or its title (`ConformanceDriverLineReady`), in
  place of `KbEndpointBranch1` and the like.
- A pending sign-in's issuer is `PendingAuthorizationIssuer`, the type
  Protocol states, in place of `IssuerEndpoints`; `discoverIssuer` and
  `signInWithDeviceGrant` give one. Where each stream was is `LastEventIds`.
- A frame's refusal reason is `FrameRefusalReason`, the type Protocol states,
  in place of `FaultReason` (`FrameRefusalReasonLacks`,
  `FrameRefusalReasonMalformed`).
- `Job.claim` and `Worker.newClaims` take `ClaimOptions`, the type Protocol
  states, in place of `WorkerOptions`; the claims' clock and timing are the
  client's. A filter list that is empty, a stall check that is not positive,
  or a claim, stall or commit timeout that is negative, is
  `InvalidClaimOptions`, in place of `InvalidWorkerTiming`.
- `Job.pollUntilComplete` takes `JobPollOptions`, the type Protocol states, in
  place of `PollOptions`, and the callback that is told each status.
- `Content.putBinary`, `Yield.resource` and `Yield.createFromToken` answer
  `CreateResourceResponse`, the type Protocol states, in place of the new
  resource's id; `Yield.createFromToken` takes `CreateFromTokenOptions`.
- A gateway's URL takes its scheme from the endpoint's `protocol`.
- What each retry rule retries is read from `retryRules`, the value of
  `retry/rules.json`, in place of the SDK's own statuses and methods.
- A type written in place is named as every SDK names it: its owner and its
  member in Pascal case (`AnnotationContext`), a list's item with `Item`
  and a map's value with `Value` after it, in place of the member's
  characters spelled by code point (`AnnotationU40_context`) and `Inline`
  or `AdditionalValue` after it (`AnnotationTargetValue`,
  `BusReplyBoundsRepliesValue`). A union's member written in place is named
  by the union and what the member is (`ConformanceDriverLineAbandoned`, in
  place of `ConformanceDriverLineAbandonedValue`), and as a record or
  newtype is constructed by `Mk` and its name
  (`MkConformanceDriverLineAbandoned`), as the union's constructor for it
  takes that name. A field is named by its record and its member in Pascal
  case (`annotationContext`, `clientSecretFormGrantType`), and an
  enumeration's constructor by its value in Pascal case
  (`AnchorMethodFuzzyMatch`, `SupportedMediaTypeTextXCPlusPlus`,
  `AnchoredTextDeclinedEntryV3`).
- A record drops the members its schema does not name, where it kept them
  in a `…AdditionalProperties` field and wrote them back: only the records
  Protocol states hold other members keep that field (`AgentOrganization`,
  `AgentPerson`, `AgentSoftware`, `JobParams`, `Representation`,
  `ResourceDescriptor`, `ResourceDescriptorIdentifierObject` and
  `ScoredResource`), beside the maps and the objects that name no member
  (`BusFramePayload`). A record built positionally takes no `mempty` for
  them, and a knowledge base is kept as it is read, with nothing to strip.
- A record's fields are in the order its schema states its members, in place
  of the order of their names: `AnchorRect`'s are `anchorRectX`,
  `anchorRectY`, `anchorRectWidth`, `anchorRectHeight`, `anchorRectTop`,
  `anchorRectRight`, `anchorRectBottom` and `anchorRectLeft`. A record built
  or matched positionally binds its arguments in that order, and where two
  fields share a type a positional use still compiles: build and match a
  record by naming its fields.
- A map or a scalar whose schema states nothing its type cannot carry is
  that type, in place of a type that wraps it. `LastEventIds` is a
  `Map ResourceId PersistedEventId`, and `ResourceId` reads and writes as a
  map's key; `ContentFormat` is `Text`. A map written in place is a
  `KM.KeyMap` of its values where it is held (`metadataLabels ::
  Maybe (KM.KeyMap Text)`, `jobMetadataUnitCursors`), in place of a record of
  one `…AdditionalProperties` field (`MetadataLabels`,
  `JobMetadataUnitCursors`). A scalar that states a pattern, a length or a
  range stays a type of its own.
- A union's value is read as the member that admits it, by what each
  member's schema states (its kind, the members an object of it requires and
  allows, the values it and its members may take, and the pattern its text
  matches), in place of trying each member until one parses. Only that
  member is read, and a value it refuses is refused as that member refuses
  it, where it was refused as the last member tried refused it.

### Removed

- `Session.signInAgent` takes no `RetryBudget`, and signs the agent in once,
  as every SDK does: a failure is thrown as it came, and starting the sign-in
  again is the service's, on its own backoff (Protocol's WORKER-SERVICE R3).
  It was `signInAgent http options budget service`; it is
  `signInAgent http options service`.
- `Xynolog.Types.Presence` is removed. No member of Protocol is both optional
  and nullable, so a model's optional field is a `Maybe`.

## 0.8.1

### Added

- Builds with GHC 9.12 as well as 9.10 (`base < 4.22`, `time < 1.15`), as
  `tested-with` states.
- Hackage shows the package's homepage, bug tracker, source repository and
  this changelog.
- The README is Hackage's page for the package: it says what the SDK is, how
  to add it to `build-depends` and take releases up to the next minor, and
  then shows a first program, which connects and reads the knowledge base's
  name, before signing in and the eight verbs. How the SDK itself is built
  and checked moves to CONTRIBUTING.md, which the README's last line links to.
- The README links to the repository's files at the release's tag, so its
  links resolve on Hackage and show the files as of the release.

### Changed

- The README's coverage badge reads the package: `make test-haskell` writes
  the suite's coverage, less Cabal's generated `Paths_xynolog`, and CI
  uploads it to Codecov.
