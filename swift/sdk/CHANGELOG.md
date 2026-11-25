# Changelog

The changes to the Xynolog SDK for Swift, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

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

### Fixed

- An annotation's `created`, a knowledge base's `KbRead.at` and the worker
  driver's vitals are RFC 3339 date-times in UTC. `created` lacked its `Z`,
  and `at` and the vitals carried a time with no date.

### Removed

- `ResourceFilters` and `WorkerTiming`: `BrowseResourcesRequest`,
  `ResourceSearchFilters` and `ClaimOptions` say what they said.
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
