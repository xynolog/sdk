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
  `Timing.emit_retry` take one. Its members are as they were.
- `ResourceUpload.file` is a `Binary`, the type of Protocol's bytes held
  whole, which is `bytes`.
- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- So is one in what the SDK reads beside a request's answer: the discovery
  document, a stored event's payload, the job anchor, the stored session,
  knowledge bases and tabs, the pending sign-in, a 429's body, the emit reply
  and an error's words. Each takes the way it already had for what does not
  read: no count, no entry, or the bare status.
- `Empty` and `Response` are `xynolog.model`'s, where they were
  `xynolog.channel`'s.
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
- `claims.vitals()` is a `WorkerVitals` model named and written as
  `WorkerEngineHealth`'s members are: its times are the protocol's text, and
  the job it holds is a `WorkerEngineHealthActiveJob`. `ActiveJob` is gone. A
  host's health is `WorkerEngineHealth(engine=…, jobs=…, **dict(vitals))`.
- A list of resources, and a search for them, are cached by the request each
  sends, `BrowseResourcesRequest` and `MatchResourcesRequest`, in place of
  `xynolog.namespaces.live.ResourceFilters` and `ResourceSearch`.

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
