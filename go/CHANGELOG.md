# Changelog

The changes to the Xynolog SDK for Go, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

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
  what it may send, and who sends a notification (`control.Sender`).
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

### Changed

- A stream's place, and each place `CoupledBookmarks` keeps, is an id
  `LastEventIds` holds in its scope, read as the generated `api.LastEventIds`,
  in place of an id held to `PersistedEventId` by that schema's name.
- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- The element of an answer format (`WorkerAnswerFormatsFormatsItem`'s
  `element`) carries Protocol's description of it.
- The smelter's and the weaver's health name how far they have followed the
  record as `FollowerFollowing`, the type Protocol states, in place of
  `SmelterHealthFollowing`, `WeaverHealthFollowing` and their `…Sweep` types.
- A schema of an object that names no members is a type of its own
  (`type BrowseKbRequest map[string]any`), not an alias of `map[string]any`.
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
  `ResourceFilters`, which is gone. A limit left out (nil) is still the first
  hundred; a limit stated as zero is now sent as zero.
- A union's member interface is exported (`api.MarkJobParamsMember`,
  `api.ConformanceDriverLineMember`, …), so a function can take any member
  of a union. Its marker method is still unexported: no other type joins it.
- `Job.PollUntilComplete` takes `api.JobPollOptions` in place of its `every`
  and `within` durations; a wait left out (nil) is the client's timing.
- `Job.Claim` takes `api.ClaimOptions`: the filters it accepts, and any of its
  four waits in place of the client's timing.
- `ActiveJob.JobType` is `ActiveJob.Type`, as `WorkerEngineHealth` names it.
- A resource's representation is held to the whole of its schema when it is
  read, not to its media type alone.

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
