# Changelog

The changes to the Xynolog SDK for Rust, release by release. A release's
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
- A generated type derives `Eq` and `Hash` wherever none of its members is a
  floating-point number, and `Default` when every member is optional. A
  property that admits one integer is a constant (`DiscoveryDocument::VERSION`).
- `Claims::health(engine)` composes the generated `WorkerEngineHealth` from the
  engine, the jobs the worker claims and its vitals, with times at the
  millisecond.
- `Route::path_for(resource_id)` fills a gateway route's path for a resource.
- `bus.questions::<R>()`: the side of an operation a service answers. Each
  `Question<R>` holds the request as it was asked, and `answer` sends its
  result or failure, typed by the operation, under the asker's correlation id.
  A request that is not the operation's is refused, and its asker is told why
  on the failure channel when the request states what the failure carries.
- `xynolog::control`: the launcher's control API, from
  `control/methods.json`. Each method and notification is a marker whose
  associated types are what it carries (`LauncherAbout`, `RootsInit`,
  `NotificationsProgress`, …), and `CONTROL_METHODS`, `CONTROL_NOTIFICATIONS`
  and `control_method(name)` state the table by name.
- `ControlErrorCode`, the control vocabulary of `errors/codes.json`. Every
  vocabulary's enum states its codes as `ALL`.
- `read_as::<T>(value)` reads a value as the schema `T` is generated from,
  refused for its first fault as `fault_said` says it. `bounds_of::<T>(member)`
  gives the sizes and bounds the schema states of a member.
- `stored_session_of(client_id, issuer, tokens)` in `xynolog-http-transport`:
  the session a completed sign-in keeps.
- A held job's `accepted()`: whether a filter it was claimed with accepts it.

### Changed

- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- The smelter's and the weaver's health name how far they have followed the
  record as `FollowerFollowing`, the type Protocol states, in place of
  `SmelterHealthFollowing`, `WeaverHealthFollowing` and their `…Sweep` types.
- A schema of one integer, number or boolean is an alias of that type
  (`HttpStatus`).
- `OpenResource` is `xynolog::types::OpenResource`, the type Protocol states,
  in place of `xynolog::session::OpenResource`.
- `browse.resources` takes the generated `BrowseResourcesRequest`, and
  `match.resources` takes `ResourceSearchFilters`. `ResourceFilters` is gone.
  Both read a hundred when no limit is stated and start from the first when no
  offset is stated.
- `gather.resource` takes the generated `GatherResourceOptions`, each member of
  which a caller may leave out, in place of `GatherResourceRequestOptions`,
  which no longer has a `Default`. `match.search` takes the resource, the
  reference, its context and the generated `MatchSearchOptions`, in place of a
  whole `MatchSearchRequest`. Both follow surface.json.
- `job.poll_until_complete` takes the generated `JobPollOptions` in place of
  two durations.
- A delivered `Frame` holds the generated `BusFrame` as `bus_frame`, beside its
  `trace` and `stream_id`, in place of restating its members.
- A held yield job is anchored by its `GenerationJobParams`' focus.
- The conformance drivers write each line as a generated
  `ConformanceDriverLine` and each failure as a `ConformanceFailure`.

## 0.8.1

### Added

- The crates declare `rust-version = "1.89"`, the oldest Rust that builds
  them, which Cargo's MSRV-aware resolver reads.

### Changed

- docs.rs documents `xynolog` and `xynolog-http-transport` with every
  feature, and labels each feature-gated item with the feature it needs.
- Each crate's README reads as its crates.io page: what the crate is, how to
  install it (`cargo add`, whose requirement takes releases up to the next
  minor), and, for `xynolog`, a first program before connecting and the
  eight verbs. How the crates' own READMEs are held to their tests moved to
  the repository's CONTRIBUTING.md, which each README's last line links to.
- Each crate's README links to the repository's files at the release's tag,
  so its links resolve on crates.io and show the files as of the release.
- Each crate's coverage badge reads that crate: `make test-rust` measures
  the tests under `cargo llvm-cov`, and CI uploads the report to Codecov.
  The Rust README no longer lists the crates the Rust services share, which
  images holds.
