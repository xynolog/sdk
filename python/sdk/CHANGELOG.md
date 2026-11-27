# Changelog

The changes to the Xynolog SDK for Python, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

- A type for ten of Protocol's tables that no service keeps, each typed by
  the table's own schema: `ClientDiscoveryAbsent`, `ClientRefresh`,
  `ClientTesting`, `ControlCli`, `ErrorsCodes`, `IdentifiersKinds`,
  `MediaTypesRegistry`, `SdkTelemetryTelemetry`, `SessionOauth` and
  `SignInStoreOwnerOnly`.
- `xynolog.service_environment`: every environment variable a Xynolog service
  reads, beside its configuration document, a constant of its name
  (`XYNOLOG_BUS_LOG`). The bus log reads its variable by it.
- A type for every schema Protocol states, not only the gateway's components:
  the Control API's methods, notifications and errors (`AboutParams`,
  `ErrorData`, `RequestId`, …), the stack's kinds (`Inference`, `Issuer`,
  `KnowledgeIndex`, `Runner`, …), `ProjectConfig`, `FollowerFollowing`, the
  conformance documents, and the rest.
- What a value is held to before it is read takes in more of its schema: a
  pattern's groups and alternatives (`^(GET|POST) /`), a set of members an
  object may not carry together, the fewest members it carries, and what its
  members' names must be.
- `xynolog.retry.JOB`, the `job` rule of the retry table: whether a job a
  worker failed with a status is tried again. `RETRY_RULES` holds it.
- A held job's `accepted` says whether its claim accepts it.
- `xynolog.http.gateway_http`, the gateway's routes as `openapi.json`
  states them (was private).
- `xynolog.error_codes.ControlErrorCode` and `CONTROL_ERROR_CODES`, why a
  request of the launcher's control API failed.
- `xynolog.white_space`: white space as the protocol's tables count it,
  `WHITE_SPACE`, `trimmed` and `collapsed`.
- `xynolog.control_methods`, generated from `control/methods.json`: the
  launcher's control API's version, each of its methods (`LAUNCHER_ABOUT`,
  `STACK_START`, …, each a `ControlMethod` with the models of its params and
  its result, whether it runs alone and the notifications it sends) and each
  of its notifications, and both by name. `xynolog.control` holds the
  classes.
- `xynolog.locales`, generated from `locales/registry.json`: `LOCALES`, each
  supported language's code, native name and English name, with
  `LOCALE_CODES` and `LocaleCode`.
- `xynolog.service_tables`: every table the services keep to (each service's
  messages, `service-environment`, `service-telemetry`, `jobs/budgets.json`
  and `storage.json`, `bus/reply-bounds.json`, `embedding/requests.json`,
  `worker/answer-formats.json`, the gateway's media token and response
  headers, the Archivist's layout and default entity types, the graph's
  schema), each read as its schema's model, which `xynolog.types` now holds.
  `SERVICE_TABLES` holds each by its file.
- `xynolog.http.archivist_http`: each of the Archivist's operations as an
  `ArchivistRoute`, its method and its path.
- `xynolog.http.oauth.stored_session_of(client_id, issuer, tokens)`: what is
  kept of a sign-in, for a caller that completes the redirect grant itself.
- `Bus.answer`, a request's answering side: it runs a handler on a request
  `frames` read, in the trace it was sent under, and sends what it answers on
  the operation's result channel, or a `CommandError` it answers or raises
  on its failure channel, under the request's correlation id. The failure
  names what its schema names beside the error as the request named it. A
  request that is not its channel's is answered as failed when it can be.

### Changed

- An upload is a `PutBinaryRequest` (`xynolog.types`), the model of
  Protocol's `client/types/PutBinaryRequest.json`, where it was the dataclass
  `xynolog.transport.PutBinaryRequest`, with the members it had. It is
  validated as it is made, and refuses a member its schema does not name.
  `entity_types` is a `list[str]` or `None`, `None` when it is left out,
  where it was a sequence that was empty when left out; `generator` is a
  `OneOrMoreAgents`, an `Agent` or a `list[Agent]`, where it was an `Agent`
  or a sequence of them. What an upload sends is as it was.
- A resource's bytes, read whole, are a `ResourceRepresentation`
  (`xynolog.types`), the type of Protocol's
  `client/types/ResourceRepresentation.json`, where they were
  `xynolog.transport.Content`, with the members it had, `data` and
  `content_type`.
- `browse.engines()` is a `Cached[EnginesWithLimits]` of
  `xynolog.types.EngineWithLimits`, the types of Protocol's
  `client/types/EnginesWithLimits.json`, where it was of
  `xynolog.namespaces.browse.EngineWithLimits`: an engine's `engine` and
  `jobs` are its own, where they were its `entry`'s.
- A retry budget is `xynolog.types.RetryBudget`, the model of Protocol's
  `client/RetryBudget.json`, where it was `xynolog.retry.RetryPolicy`:
  `EMIT_RETRY` and `REFRESH_RETRY` are one, and `retry_with_backoff` and
  `TransportTiming.emit_retry` take one. Its members are as they were.
- `ResourceUpload.file` is a `Binary`, the type of Protocol's bytes held
  whole, which is `bytes`.
- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- `GetAnnotationsResponse`'s `motivation` is absent or a `Motivation`.
  Protocol no longer allows it to be null: a null for it is refused as
  malformed.
- The element of an answer format (`WorkerAnswerFormatsFormatsItem`'s
  `element`) carries Protocol's description of it.
- The smelter's and the weaver's health name how far they have followed the
  record as `FollowerFollowing`, the type Protocol states, in place of
  `SmelterHealthFollowing`, `WeaverHealthFollowing` and their `…Sweep` types.
- `OpenResource` is `xynolog.types.OpenResource`, in place of
  `xynolog.stored.OpenResource`. Its bounds are held by the required table as
  the registry reads what it stored.
- What is kept of a sign-in is `xynolog.types.StoredSession`, in place of
  `xynolog.session.HeldSignIn`; a changed one is made with `model_copy`.
- A sign-in pending its redirect is `xynolog.types.PendingAuthorization`, and
  its issuer `xynolog.types.PendingAuthorizationIssuer`, in place of
  `xynolog.http.oauth.PendingAuthorization` and `IssuerEndpoints`.
  `discover_issuer` and `sign_in_with_device_grant` give the issuer as one,
  and `stored_session_of` takes one.
- Where each stream was is `xynolog.types.LastEventIds`, in place of
  `xynolog.stored.LastEventIds`.
- `xynolog.resume.is_place(scope, event_id)`, whether `LastEventIds` holds
  the id as the place reached in the scope, in place of
  `is_recorded_event_id(event_id)`. The stream and the places kept both ask
  it.
- `claims.vitals()` is a `xynolog.types.WorkerVitals`, the type Protocol
  states, in place of `xynolog.claims.WorkerVitals`: its times are the
  protocol's text, and the job it holds is a `xynolog.types.WorkerActiveJob`,
  in place of `WorkerEngineHealthActiveJob`. `ActiveJob` is gone. A host's
  health is `WorkerEngineHealth(engine=…, jobs=…, **dict(vitals))`.
- A list of resources, and a search for them, are cached by the request each
  sends, `BrowseResourcesRequest` and `MatchResourcesRequest`, in place of
  `xynolog.namespaces.live.ResourceFilters` and `ResourceSearch`.
- A claim refused is a `xynolog.types.ClaimRefusal`, in place of
  `xynolog.claims.ClaimRefusal`. It is a model, made by keyword:
  `ClaimRefusal(code=…, message=…)`.
- A stall is a `xynolog.types.HeldJobStall`, in place of
  `xynolog.claims.HeldJobStall`: its `held_since` and `last_activity_at` are
  the protocol's text, to the millisecond, where they were `datetime`s.
- A trace as the wire carries it is `xynolog.types.TraceCarrier`, in place of
  `xynolog.transport.TraceContext`: a frame's `trace`, a delivered payload's,
  a held job's, and what `xynolog.telemetry` reads and continues.
- A held job holds `record`, the `xynolog.types.HeldJobRecord` its claim
  handed it. Its `job_id`, `job_type`, `resource_id`, `params`,
  `completed_units`, `unit_cursors`, `retry_count` and `max_retries` are
  read-only properties of that record, generated from it:
  `completed_units` is the record's list, where it was a tuple, and
  `HeldMarkJob.job_type` and `HeldYieldJob.job_type` are properties, where
  they were class attributes.
- `KbPlacement` is where a knowledge base's stack runs, in place of
  `DiscoveredKBPlacement`, `RootPlacement`, `KnowledgeBaseStatusPlacement`
  and `TargetKind`, and `InferenceProvider` who serves a model, in
  place of `EngineProvider`, as Protocol names them.
- A held job says what it reached as the types Protocol states:
  `checkpoint(JobCheckpoint(completed_units=…, unit_cursors=…))`, in place of
  `checkpoint(completed_units, unit_cursors=None)`;
  `fail(error, JobFailure(failure_class=…, completed_units=…, unit_cursors=…))`,
  in place of `fail(error, *, failure_class=None, completed_units=None,
  unit_cursors=None)`; and `cancel(JobReached(completed_units=…,
  unit_cursors=…))`, in place of `cancel(completed_units=None,
  unit_cursors=None)`. Each of `fail`'s and `cancel`'s is optional.
- A default the service owns is no longer sent when the caller leaves it
  out, and the service's own applies (protocol#109): `browse.resources` and
  `match.resources` no longer send `limit` 100 and `offset` 0,
  `gather.annotation` no longer sends `contextWindow` 2000 (nor `options`
  when none is stated), and `match.search` no longer sends
  `useSemanticScoring` true. A stated value is sent as stated, and a list or
  a search stating a limit of 100 is no longer the one stating none.
  `xynolog.namespaces.live.LIST_LIMIT` is gone.
- What discovery reads is the models Protocol names, in place of
  `xynolog.discovery`'s own: `parse_discovery_document` gives a
  `xynolog.types.DiscoveryState` (a `DiscoveryAbsent` or a
  `DiscoveryManaged`), a transport's `read` a `DiscoveryRead` (either, or a
  `DiscoveryUnchanged`), and `subscribe_discovery` a `DiscoveryDiff`, in
  place of `xynolog.discovery.Absent`, `Managed`, `Unchanged`,
  `DiscoveryState`, `DiscoveryRead` and `DiscoveryDiff`. Each is a model,
  made by keyword with its `kind` (`DiscoveryManaged(kind="managed",
  kbs=…)`), and its knowledge bases and addresses are lists, where they were
  tuples.
- An upload's `UploadProgressStarted` and `UploadProgressProgress`, and
  `ConformanceDriverLineProgressProgress`, state `total_bytes` as an
  `int | None`: the total is stated when the source states its length, as
  every upload's does today.
- The timing a caller may set is two records generated from
  `client/timing.json`, `xynolog.timing.ClientTiming` and
  `xynolog.timing.TransportTiming`, each member named as its row is.
  `xynolog.client` still exports `ClientTiming`, whose `bus_request_ms` is now
  `bus_request_timeout_ms`. `TransportTiming`, which `xynolog.http` exports,
  replaces `xynolog.http.Timing`: `http_request_ms` is now
  `http_request_timeout_ms`, and `stream_open_ms` is
  `stream_open_timeout_ms`.
- `session_from_kept` and `HttpSessionFactory` take `client_timing` and
  `transport_timing`, the timing of the client and of the transport they build.
- `Cache` no longer takes `save_debounce_ms`: it saves `SAVE_DEBOUNCE_MS`
  after its values last changed.
- `StoragePersister` no longer takes `max_bytes`: a document larger than
  `MAX_STORED_BYTES_COUNT` loses the entries received longest ago, until it
  fits.
- `subscribe_discovery` takes `interval_ms`, in milliseconds, where it took
  `interval`, in seconds, and may be left out: it is then
  `DISCOVERY_INTERVAL_MS`. `xynolog.discovery.DISCOVERY_INTERVAL_MS` replaces
  `xynolog.discovery.DISCOVERY_INTERVAL`, which was in seconds.
- `HoverDwell`'s `delay_ms` may be left out: it is then `HOVER_DELAY_MS`.

## 0.8.1

### Changed

- `cryptography` has no upper bound, so `xynolog` installs beside a project
  that takes cryptography's next major version.
- PyPI's Documentation link opens the README as of the release, and its
  Changelog link this file.
- The README is PyPI's page for the package: it says what the SDK is, how to
  install it and take releases up to the next minor, and then shows a first
  program before signing in and the eight verbs. How the SDK itself is
  checked moves to CONTRIBUTING.md, which the README's last line links to.
- The README links to the repository's files at the release's tag, so its
  links resolve on PyPI and show the files as of the release.
- The README's coverage badge reads the package: `make test-python` measures
  the tests, and CI uploads the report to Codecov.
