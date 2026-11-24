# Changelog

The changes to the Xynolog SDK for Kotlin, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

- `xynolog.services.ServiceEnvironmentVariables`: every environment variable a
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
  read as its schema's type (`GatewayMessages`, `ServiceEnvironmentVariables`,
  `ArchivistLayout`, …, now in `xynolog.types`): the variables a service
  reads and its boot refusals, its telemetry and log lines, its messages,
  the jobs' budgets and storage, the bounds of the bus's replies, the
  embedding requests, the worker's answer formats, the gateway's media token
  and response headers, the Archivist's layout and default entity types, and
  the rest; `SERVICE_TABLES` holds each by its file. And `ArchivistRoute`,
  each of the Archivist's HTTP operations.
- `xynolog.control`: the launcher's control API, `ControlMethods`, each of
  its methods and notifications with the serializers of what each carries,
  whether it runs alone and what it sends, and `ControlSender`.
- `xynolog.errors.ControlErrorCode`, the control API's codes.

### Changed

- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
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
  `WorkerEngineHealthActiveJob`, as `WorkerEngineHealth` does, and
  `Claims.health(engine)` is that health. `xynolog.jobs.ActiveJob` is gone.
- A channel that carries nothing is typed `xynolog.types.EmptyObject`, in
  place of `xynolog.channels.Empty`.
- A discovery document is read as its schema states it: its versions are
  those `DiscoveryDocument` allows.

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
