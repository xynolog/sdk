# Changelog

The changes to the Xynolog SDK for C#, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

- `Xynolog.Control`: the launcher's control API. `ControlMethods` holds each
  method as a `ControlMethod<TParams, TResult>` and each notification as a
  `ControlNotification<TParams>`, typed by the models of what it carries, and
  `ControlSender` says which side sends a notification.
- `Xynolog.Services.ServiceEnvironmentVariable`: every environment variable a
  Xynolog service reads, beside its configuration document, a constant of its
  name (`XynologBusLog`). The bus log reads its variable by it.
- A type for every schema Protocol states, not only the gateway's components:
  the Control API's methods, notifications and errors (`AboutParams`,
  `ErrorData`, `RequestId`, …), the stack's kinds (`Inference`, `Issuer`,
  `KnowledgeIndex`, `Runner`, …), `ProjectConfig`, `FollowerFollowing`, the
  conformance documents, and the rest.
- What a value is held to before it is read takes in more of its schema: a
  pattern's groups and alternatives (`^(GET|POST) /`), a set of members an
  object may not carry together, the fewest members it carries, and what its
  members' names must be.
- Every error-code vocabulary Protocol states is a class of constants in
  `Xynolog.Errors`: `BusRequestErrorCode`, `TransportErrorCode`,
  `JobErrorCode`, `SessionErrorCode`, `SignInErrorCode`,
  `IdentityUnverifiableReason`, `SpanRefusal` and `ControlErrorCode`, so a
  caller compares `XynologError.Code` to `BusRequestErrorCode.NotFound` in
  place of `"bus.not-found"`.
- `Claims.Health(engine)` is the worker's `WorkerEngineHealth`, its vitals
  with the engine it runs and the jobs it accepts.
- `Xynolog.Services.ServiceTables` holds each table Protocol states for its
  services as the type its schema is: the environment a service reads and
  why it refuses to start, its telemetry and log lines, each service's
  messages, the jobs' budgets and storage, the bounds of the bus's replies,
  the embedding requests, the worker's answer formats, the gateway's media
  token and response headers, and the archivist's layout and default entity
  types. `ArchivistRoutes` names each operation of the archivist's HTTP
  surface as a `ServiceRoute`.

### Changed

- A retry budget is `Xynolog.Types.RetryBudget`, the model of Protocol's
  `client/RetryBudget.json`, where it was `Xynolog.Http.RetryPolicy`:
  `Timing.EmitRetry` is one, and `Retry.RetryWithBackoffAsync` takes one. It
  is made with an initializer
  (`new RetryBudget { Attempts = 2, InitialDelayMs = 1, MaxDelayMs = 1 }`),
  and its members are `long`.
- The HTTP transports name each span and their count by the SDK telemetry
  table, and the live queries each query by the refresh table, as generated
  constants (`TelemetrySpans`, `TelemetryMetrics`, `CacheQuery`) in place of
  names spelled at each call. What they report and keep is the same.
- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- `GetAnnotationsResponse.Motivation` is a `Motivation?`, absent or a value,
  where it was a `Stated<Motivation?>`. Protocol no longer allows it to be
  null: a null for it is refused as malformed.
- The smelter's and the weaver's health name how far they have followed the
  record as `FollowerFollowing`, the type Protocol states, in place of
  `SmelterHealthFollowing`, `WeaverHealthFollowing` and their `…Sweep` types.
- A value is validated against every keyword of its schema: `const`, `not`,
  `propertyNames` and `minProperties` among them, each keyword beside a
  `oneOf` or an `anyOf`, and those of a schema that states no `type`. A value
  is one of a `oneOf`'s variants exactly.
- `OpenResource` is `Xynolog.Types.OpenResource`, the type Protocol states, in
  place of `Xynolog.Registry.OpenResource`: it is built with an initializer,
  and its `Order` is a `long`.
- A method's options are the records Protocol states for them:
  `Browse.Resources(BrowseResourcesRequest?)`,
  `Match.Resources(search, ResourceSearchFilters?)`,
  `Match.Search(…, MatchSearchOptions?)`,
  `Gather.ResourceAsync(resourceId, GatherResourceOptions?)`,
  `Yield.CreateFromTokenAsync(CreateFromTokenOptions)`,
  `Job.Claim(ClaimOptions)` and
  `Job.PollUntilCompleteAsync(jobId, JobPollOptions?, onStatus)`, in place
  of their positional parameters. A worker's claim, stall and commit waits
  are its `ClaimOptions`, and default to the client's `Timing`.
- `WorkerVitals.ActiveJob` is `WorkerEngineHealthActiveJob`, the type
  Protocol states, in place of `ActiveJob`, and the vitals' times are
  ISO 8601 text, as a worker's health carries them.
- `Timing.HttpRequestMs` and `Timing.StreamOpenMs` are
  `HttpRequestTimeoutMs` and `StreamOpenTimeoutMs`, the names the protocol's
  timing table gives them; each of `Timing`'s defaults is that table's.
- The pending sign-in is `Xynolog.Types.PendingAuthorization`, the type
  Protocol states, in place of `Xynolog.Authorization.PendingAuthorization`,
  and its issuer is `PendingAuthorizationIssuer` in place of
  `AuthorizationIssuer`: both are built with an initializer.
- `LastEventIds.AdditionalProperties` is an
  `IReadOnlyDictionary<ResourceId, string>`, keyed as Protocol keys it, in
  place of JSON values under text. A model whose other members are of a
  schema holds each as that schema's type, and each id is a key
  System.Text.Json reads and writes.

### Removed

- `Xynolog.Types.Stated<T>` is removed. No member of Protocol is both optional
  and nullable, so a model's optional member is a nullable type, absent when
  null.

## 0.8.1

### Added

- The package targets .NET 10, the LTS release, as well as .NET 11.
- A symbols package (`.snupkg`) beside the package, with Source Link to the
  release's commit, so a debugger steps into the SDK's source.
- nuget.org shows the package's license (Apache-2.0), project and repository
  URLs and tags.
- The package ships XML documentation (`lib/<tfm>/Xynolog.xml`), so
  IntelliSense and NuGet show a summary for every hand-written public member;
  a missing or malformed doc comment fails the build.

### Changed

- The README is NuGet's page for the package: it says what the SDK is, how to
  install it with `dotnet add package` and take releases up to the next
  minor, and then shows a first program, connecting to a knowledge base and
  asking its name, before signing in and the eight verbs. How the SDK itself
  is built and verified moves to CONTRIBUTING.md, which the README's last
  line links to.
- The README links to the repository's files at the release's tag, so its
  links resolve on NuGet and show the files as of the release.
- The README's coverage badge reads the package: `make test-csharp` writes
  the suite's coverage as lcov, and CI uploads it to Codecov.

### Fixed

- A request its gateway refused is sent again with the token its renewal
  gave, or the one it was first sent with. It was sent with whatever token
  the transport held by then, which was none once the session had withdrawn
  its token in between.
- A browser closes a session only once its check of what is open in the
  knowledge base has stopped. A check still under way sent through the
  closed session, and the browser's disposal threw
  `ObjectDisposedException`.
