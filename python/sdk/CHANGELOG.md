# Changelog

The changes to the Xynolog SDK for Python, release by release. A release's
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

- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
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
