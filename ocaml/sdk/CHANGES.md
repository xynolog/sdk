# Changelog

The changes to the Xynolog SDK for OCaml, release by release. A release's
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
- Each record of `Records` types its members as their schema states them:
  strings, booleans, `int`, `float`, the enum a member names or states in
  place (a module of the record's own, such as
  `Records.Job_status_response.Status`), and the record it names. Each record
  is also written back (`to_json`, `to_model`).
- The records Protocol's tables state are records of `Records` too, read and
  written as their schemas say, among them the stored session and an open
  resource.
- The tables the services keep to, each a module of its own read from
  Protocol: the variables a service reads and why it refuses to start, what
  it tells OpenTelemetry and logs, its messages, the jobs' budgets, the bounds
  of the bus's replies, and the rest.
- `Service_environment`: every environment variable a Xynolog service reads,
  beside its configuration document, a value of its name
  (`Service_environment.xynolog_bus_log`). The bus log reads its variable by
  it.
- `Control`, the launcher's control API: each method a `Control.Method.t`
  typed by its params and its result descriptors, whether it runs alone and
  the notifications it sends, and each notification a
  `Control.Notification.t` typed by its params, with who sends it
  (`Client | Launcher`).
- `Error_codes` has every vocabulary of codes, the control plane's and span
  refusal's among them, each with `t`, a constructor per code, and `code`,
  the code each is.
- `Archivist_http`: every route of the archivist, a method and a path by its
  operation, where four were.
- `Service_tables`: the services' tables, reachable from `Xynolog`.
- An enum for every string enum Protocol roots (`Enums.Output_stream`,
  `Runtime`, `Run_service`, `Service_group`, `Kb_read_kind`, `Tab_verdict`),
  and each record's member of one is read as it.

### Changed

- `Annotations.span_refusal` is `Error_codes.Span_refusal.t`, the
  generated vocabulary, in place of a variant of its own.
- A member that holds null where its schema does not allow null is refused
  as malformed, where it was read as absent.
- `Records.Get_annotations_response.t`'s `motivation` is an
  `Enums.Motivation.t option`, where it was a `Types.presence`. Protocol no
  longer allows it to be null: a null for it is refused as malformed.
- `Bus.frame_refusal_reason` is `Enums.Frame_refusal_reason.t`
  (`Lacks | Malformed`), as is every fault's reason, in place of
  `` [ `Lacks | `Malformed ] ``.
- `Registry` hands and takes `Records.Open_resource.t`, `Discovery` hands
  `Records.Discovered_kb.t`, `Annotations.locate_pdf` takes
  `Records.Pdf_text_item.t`, and `Oauth.device` holds the
  `Records.Device_code.t` the gateway answered, in place of records of their
  own that restated those schemas.
- A sign-in by a page redirect that is under way is
  `Records.Pending_authorization.t`, and an issuer is
  `Records.Pending_authorization_issuer.t`, in place of
  `Redirect_sign_in.pending_authorization`, `Oauth.issuer` and
  `Oauth.redirect`, and their hand-written JSON (`Oauth.keep_redirect`,
  `Oauth.take_redirect`). `Oauth.begin_redirect` takes
  `Records.Begin_authorization_options.t`, `Oauth.url` and
  `Oauth.finish_redirect` take the pending sign-in alone, and
  `Registry.begin_sign_in`'s `~target` is an `HttpEndpoint`.
  `Oauth.issuer_url`, `Oauth.token_endpoint` and `Oauth.revocation_endpoint`
  go: the issuer's members are read directly.
- An optional member that may not be null is an `option`; `Types.presence`
  is left to a member that may be absent and may be null.

- `Retry.retry_with_backoff` takes its `budget` as a `Records.Retry_budget.t`,
  the record of Protocol's `client/RetryBudget.json`, in place of
  `Retry.budget`; `Client_timing.emit_retry` and `Client_timing.refresh_retry`
  are one. `Client_timing`, the timing every SDK reads from Protocol, is
  public.

## 0.8.1

- The package installs on OCaml 5.5 and later, not on 5.5.2 alone.
- ocamlformat is a development tool of the repository (`with-dev-setup`),
  so `opam install --with-test xynolog` no longer installs it.
- The README's coverage badge reads the package: `make test-ocaml` runs the
  tests instrumented by bisect_ppx_ng, a test dependency for that reason,
  and CI uploads their coverage to Codecov.
- The GitHub release carries the opam source archive as an asset of its
  own, for an opam-repository entry's `url` to name.
- The README is opam's page for the package: it says what the SDK is, how
  to install it and take releases up to the next minor, and then shows a
  first program, which connects with a token the reader holds and prints
  the knowledge base's description of itself, before signing in and the
  eight verbs. How the SDK itself is built and checked moves to
  CONTRIBUTING.md, which the README's last line links to.
- The README links to the repository's files at the release's tag, so its
  links resolve on opam and show the files as of the release.
