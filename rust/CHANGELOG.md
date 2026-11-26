# Changelog

The changes to the Xynolog SDK for Rust, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

- `service_environment`: every environment variable a Xynolog service reads,
  beside its configuration document, a constant of its name
  (`service_environment::XYNOLOG_BUS_LOG`). The bus log reads its variable by
  it.
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
  floating-point number, and `Default` when every member is optional.
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
- `xynolog::service_tables`: each table the services keep to (the services'
  own tables, `service-environment`, `service-telemetry`, `jobs` and
  `bus/reply-bounds.json`), read as the generated type of its own schema by a
  function named as the type is (`jobs_budgets()`), and every one by its file
  (`SERVICE_TABLE_FILES`, `service_table(file)`). The types are in
  `xynolog::types` (`JobsBudgets`, `ArchivistLayout`, …).
- `xynolog::archivist_http`: each operation of the Archivist as an
  `ArchivistRoute` constant, with its `ArchivistMethod` and its path.
- `ControlErrorCode`, the control vocabulary of `errors/codes.json`. Every
  vocabulary's enum states its codes as `ALL`.
- `read_as::<T>(value)` reads a value as the schema `T` is generated from,
  refused for its first fault as `fault_said` says it. `bounds_of::<T>(member)`
  gives the sizes and bounds the schema states of a member.
- `stored_session_of(client_id, issuer, tokens)` in `xynolog-http-transport`:
  the session a completed sign-in keeps.
- A held job's `accepted()`: whether a filter it was claimed with accepts it.
- `xynolog_telemetry::table` names each span, metric and attribute key of
  the SDK telemetry table (`SPAN_CONTENT_GET`, `METRIC_XYNOLOG_BUS_SENT`,
  `ATTR_RESOURCE_ID`, …, and `CHANNEL`, what stands for the channel in a
  span's name), and the crate's spans and count are named by them.
- `errors::CONTROL_RPC_*`, each code of `control/rpc-codes.json`, and
  `ControlErrorCode::rpc` and `retryable`: the JSON-RPC code each control
  error code is answered with, and whether a request it failed is worth
  sending again, generated from `control/rpc-codes.json` and
  `errors/codes.json`.
- `discovery::DISCOVERY_URL_PATH`, where a launcher's discovery document is,
  generated from `client/surface.json`.

### Changed

- What a worker says of itself and of its claims is the generated client
  types, in `xynolog::types` as Protocol states them: `ClaimRefusal`,
  `WorkerVitals` and its `WorkerActiveJob` (where `ActiveJob` was; its job's
  kind is `r#type`), `HeldJobStall`, `JobFailure` and `TraceCarrier`, where
  `claims` and `transport` declared their own. A vitals stamp is the RFC 3339
  `String` the wire carries, to the millisecond, where it was a `SystemTime`;
  a stall's `silent_for_ms` and `threshold_ms` are its milliseconds, where
  `silent_for` and `threshold` were `Duration`s.
- A held job keeps the `HeldJobRecord` its claim handed it, as `record()`,
  and its `job_id`, `job_type`, `resource_id`, `params`, `completed_units`,
  `unit_cursors`, `retry_count` and `max_retries` are the record's, generated
  from `client/surface.json` and typed as the record types them.
- `KbPlacement` names where a knowledge base's stack runs, in place of
  `DiscoveredKBPlacement`, `RootPlacement`, `KnowledgeBaseStatusPlacement`
  and `TargetKind`; `InferenceProvider` names an inference provider, in
  place of `EngineProvider`.
- A retry budget is `types::RetryBudget`, the type of Protocol's
  `client/RetryBudget.json`, where it was `retry::RetryPolicy`:
  `timing::EMIT_RETRY` and `timing::REFRESH_RETRY` are one, a transport's
  `Timing::emit_retry` is one, and `retry_with_backoff` takes one by
  reference. Its delays are whole milliseconds, `initial_delay_ms` and
  `max_delay_ms`, as Protocol states them, where they were `Duration`s,
  `initial_delay` and `max_delay`, and its `attempts` is a `u64`. The
  transport's `Timing` is no longer `Copy`.
- `ResourceUpload::file` is a `types::Binary`, the type of Protocol's bytes
  held whole, which is a `String`; `ResourceUpload::new` takes one.
- The keys a registry keeps what it keeps under, and the prefixes of the
  keys made per knowledge base, are generated from Protocol's
  `session/stored.json`, with the names and values they had
  (`xynolog::session::KNOWLEDGE_BASES_KEY`,
  `xynolog_http_transport::oauth::PENDING_AUTHORIZATION_KEY`, …).
- The version of a kept query's document is generated from
  `session/stored.json` too, where the cache module stated it.
- A union's variant for a schema it names is that schema's own name
  (`Job::JobPending`, `ConformanceStep::ConformanceBusFetch`,
  `Agent::AgentPerson`), as every SDK names it, where the prefix its members'
  names share was stripped (`Job::Pending`).
- A property that admits one integer or boolean is a type of that value
  alone (`DiscoveryDocumentVersion`, `JobDeclinedDeclined`), as Go declares
  it: it is written as that value, and a value stating another is refused
  where it was read. Its value is the type's `VALUE`
  (`DiscoveryDocumentVersion::VALUE`), and the struct's constructor states it
  (`ConformanceDriverLineAbandoned::new(id)`).
- A union is decoded as the one member that admits a value, by what each
  member's schema states, where one whose members do not each state one
  value of a property (`AnchoredTextAnswer`) was decoded as the first member
  that fit. A value that no member admits, but that one member names by its
  kind and the values it states, is refused for what is wrong with it as that
  member. Each union states what its members admit (`Job::MEMBERS`).
- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- `GetAnnotationsResponse::motivation` is an `Option<Motivation>`, where it
  was an `Option<Option<Motivation>>`, and carries Protocol's description of
  it. Protocol no longer allows it to be null: a null for it is refused as
  malformed.
- The smelter's and the weaver's health name how far they have followed the
  record as `FollowerFollowing`, the type Protocol states, in place of
  `SmelterHealthFollowing`, `WeaverHealthFollowing` and their `…Sweep` types.
- A schema of one integer, number or boolean is an alias of that type
  (`HttpStatus`).
- `OpenResource` is `xynolog::types::OpenResource`, the type Protocol states,
  in place of `xynolog::session::OpenResource`.
- `browse.resources` takes the generated `BrowseResourcesRequest`, and
  `match.resources` takes `ResourceSearchFilters`. `ResourceFilters` is gone.
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
- A pending sign-in is `xynolog::types::PendingAuthorization`, the type
  Protocol states, in place of `oauth::PendingAuthorization`, and its issuer is
  `PendingAuthorizationIssuer` in place of `oauth::IssuerEndpoints`, which
  `discover_issuer`, `stored_session_of` and `sign_in_with_device_grant` take
  and give. `CoupledBookmarks::load` gives the generated `LastEventIds`.
- `xynolog::resume::is_place(scope, event_id)`, whether `LastEventIds` holds
  the id as the place reached in the scope, in place of
  `is_persisted_event_id(id)`. The stream and the places kept both ask it.
- A held job's `checkpoint` takes the generated `JobCheckpoint`, in place of
  its units and cursors: `checkpoint(checkpoint: JobCheckpoint)` where it was
  `checkpoint(completed_units: Vec<String>, unit_cursors:
  Option<BTreeMap<String, UnitCursor>>)`. Its `cancel` takes the generated
  `JobReached`: `cancel(reached: Option<JobReached>)` where it was
  `cancel(completed_units: Option<Vec<String>>, unit_cursors:
  Option<BTreeMap<String, UnitCursor>>)`. Both on `Held<V>` and `HeldJob`.
- The HTTP transport reads a frame's trace as `TraceCarrier` by the required
  table (`read_as`): one the table refuses, such as one whose tracestate is
  empty, is no trace, and is still taken off the payload.
- A default the service decides is no longer sent for it (protocol#109).
  `browse.resources` and `match.resources` send no `limit` of 100 and no
  `offset` of 0, `gather.annotation` no `contextWindow` of 2000, and
  `match.search` no `useSemanticScoring` of true, when the caller leaves them
  out: the service's own default applies. Options to `gather.annotation` that
  state nothing are not sent.
- `sign_in_store::System` is Protocol's `types::System`, and
  `System::of_this_build()` is `sign_in_store::this_system()`. `System::named`
  is gone: a system is read as the type's own serde.
- `roles`' constants are generated from `principals/roles.json`.
  `SERVICE_ROLE` and `WORKER_ROLE` are `XYNOLOG_SERVICE_ROLE` and
  `XYNOLOG_WORKER_ROLE`.
- `control::ControlSender` is `types::ControlSender`, the type of its schema.

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
