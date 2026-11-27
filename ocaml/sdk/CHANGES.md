# Changelog

The changes to the Xynolog SDK for OCaml, release by release. A release's
version is the SDK's, the same in all nine languages. The latest section is
the coming release's, and gathers its changes as they land.

## 0.8.2

### Added

- `Client_timing.client` and `Client_timing.transport`, the records of what a
  caller may override of the timing a client and its transport keep, with the
  protocol's values of them, `client_defaults` and `transport_defaults`.
- `Records.Engine_with_limits` and `Records.Engines_with_limits`, the types of
  Protocol's `client/types/EngineWithLimits.json` and
  `client/types/EnginesWithLimits.json`.
- A record of `Records` for ten of Protocol's tables that no service keeps,
  each typed by the table's own schema: `Client_discovery_absent`,
  `Client_refresh`, `Client_testing`, `Control_cli`, `Errors_codes`,
  `Identifiers_kinds`, `Media_types_registry`, `Sdk_telemetry_telemetry`,
  `Session_oauth` and `Sign_in_store_owner_only`.
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

- `Browse.resource_representation` answers a
  `Records.Resource_representation.t`, the record of Protocol's
  `client/types/ResourceRepresentation.json`, `{ data; content_type }`, where
  it answered a pair of the media type and the bytes.
- `Yield.resource` takes a `Records.Put_binary_request.t`, the record of
  Protocol's `client/types/PutBinaryRequest.json`, whose `file` holds the
  bytes, in place of `~fields` and `~bytes`.
- `Agent.sign_in` asks the gateway to name the agent once. A gateway that
  does not answer, or answers 503 or 401, fails the sign-in at once, after
  one grant and one `GET /api/users/me`. It no longer asks again after
  `request_retry_pause_ms`, and no longer renews the token on a 401 to ask
  again. Starting the sign-in again is the service's, as in the other eight
  SDKs.
- `Http_wire.check_user` gives a refusal its status's code (`Not_found` for
  404, `Unavailable` for 5xx), as every other request does, where every
  refusal that was not of the credential was `Unavailable`.
- A frame's trace, a held job's and the one a worker's claims are made in is
  the generated `Records.Trace_carrier.t` (`traceparent`, `tracestate`),
  where `Wire_stream.trace` (`parent`, `state`) declared its own.
- `Enums.Kb_placement` names where a knowledge base's stack runs, in place of
  `Records.Discovered_kb.Placement`, `Records.Root.Placement`,
  `Records.Knowledge_base_status.Placement` and `Records.Target.Kind`;
  `Enums.Inference_provider` names an inference provider, in place of
  `Records.Engine.Provider`.
- A held job is its record, the generated `Records.Held_job_record.t`:
  `Worker.record` returns it, and `Worker.job_id`, `job_type`, `resource_id`,
  `params`, `completed_units`, `unit_cursors`, `retry_count` and
  `max_retries` each read its member, as it types it. `Worker.params` is the
  job's `[ \`JobParams ] Models.t` and `Worker.unit_cursors` a list of
  `[ \`UnitCursor ] Models.t`, in place of JSON. `Worker.view` is gone.
- `Worker.checkpoint` takes a `Records.Job_checkpoint.t`, `Worker.fail` an
  optional `~failure:Records.Job_failure.t`, and `Worker.cancel` an optional
  `~reached:Records.Job_reached.t`, in place of `~completed`, `~cursors` and
  `~failure_class`. Each command carries every member of its record.
- `Claims.vitals` is the generated `Records.Worker_vitals.t`, its times
  date-times, in place of `Claims.vitals`'s seconds since the epoch;
  `Claims.refused` says a `Records.Claim_refusal.t` (its code and message) in
  place of a code; `Claims.stalled` says a `Records.Held_job_stall.t` in place
  of the held job. `Worker.claim`'s `Refused` carries the refusal.
- Each table record of `Records` holds an id member as its
  `Identifiers` kind (`Records.Held_job_stall.job_id` is an
  `Identifiers.Job_id.t`) and a member that names a string enum Protocol
  roots as its `Enums` type (`Records.Job_failure.failure_class` is an
  `Enums.Failure_class.t`), in place of a string and a `Models.t`.
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
- `Registry` hands and takes `Records.Open_resource.t`,
  `Annotations.locate_pdf` takes `Records.Pdf_text_item.t`, and
  `Oauth.device` holds the `Records.Device_code.t` the gateway answered, in
  place of records of their own that restated those schemas.
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
- A record's member that names a union, a record stated in place, a map, a
  list of records or unions, or a schema of another file is typed as its
  schema states it, where it was its raw JSON: a union is a module of
  `Records` with a constructor per member (`Records.Kb_endpoint.t`,
  `Records.Resource_descriptor_representations.t`), and a map is an
  association list (`Records.Bus_frame.t`'s `payload`). Only a value whose
  schema constrains nothing, or an object that names no member, is still
  `Yojson.Raw.t`. `Resources.primary_representation` hands a
  `Records.Representation.t`, and `Testing.deliver`'s payload is an object,
  as a bus frame's is.
- A union is a constructor per member, named as Protocol names the member,
  and its value is the first member whose schema admits it, where a union a
  tag told apart was a constructor per value of its tag:
  `Records.Anchored_text_answer.t` is `ExtractedText | ExtractionDeclined |
  AnchoredTextAbsent`, where it was five, and `Records.Kb_endpoint.t` is
  `HttpEndpoint | LocalEndpoint`. Each union's `of_model` is the union, not
  an option. Every union Protocol roots is a module of `Records`, among them
  `Bus_stream_message` and `Conformance_driver_line`.
- A record drops the members its schema does not name, where it kept them
  in `extra` and wrote them back: only the records Protocol states hold
  other members keep `extra` (`Agent_organization`, `Agent_person`,
  `Agent_software`, `Job_params`, `Representation`, `Resource_descriptor`,
  `Resource_descriptor_identifier_object` and `Scored_resource`). A
  `Selector` branch has no `extra` either.
- A string constant is a type of its own, where a record held it as a
  `string`: a schema that is one is a module of `Enums`
  (`Enums.Api_version.t`, `Enums.Stack_api_version.t`), and one stated in
  place a module of its record's (a stack document's `kind`, as
  `Records.Inference.Kind.t`). Annotation's `@context` is
  `Records.Annotation.Field_context.t`.

- `Retry.retry_with_backoff` takes its `budget` as a `Records.Retry_budget.t`,
  the record of Protocol's `client/RetryBudget.json`, in place of
  `Retry.budget`; `Client_timing.emit_retry` and `Client_timing.refresh_retry`
  are one. `Client_timing`, the timing every SDK reads from Protocol, is
  public.
- `Gather_state.gather_annotation`'s `?context_window` has no default: left
  out, no `contextWindow` is sent, nor an `options` member when no option is
  given, and the Librarian's own default applies (protocol#109), where it
  sent 2000. Its type is the same.
- An error code is a constructor of its vocabulary's `t`
  (`Error_codes.Bus_request.Timeout`), never a string. Each module of
  `Error_codes` holds `t`, `code` (its text) and `of_code` (the constructor a
  text is), and no string constants. `Oauth.error`, `Http_wire.failure`,
  `Client.session_error` and `Worker.commit`'s error carry their
  vocabulary's `t`. A holder of codes of more than one vocabulary carries a
  sum: `Http_wire.request_code` (`Bus | Transport`) for a live query's and
  `Cache_state`'s loads and states, `Client.fresh`, `Client.Refused`,
  `Worker.Refused` and `Claims.refused`; `Delegation.failure_code`
  (`Job | Request`) for a delegation's failure;
  `Registry.identity_unverifiable_error` (`Kb_identity | Transport`) for
  `Registry.describe_connection` and
  `Redirect_sign_in.identity_unverifiable_error`, which was a `string`; and
  `Registry.sign_in_error` (`Sign_in | Identity | Id_conflict`) for
  `Registry.record_sign_in` and `Registry.complete_sign_in`, whose
  `describe` refuses with a `Kb_identity.t`.
- A session factory refuses with a `Client.session_error`, where it gave a
  `string`, and `Registry.Unavailable` carries it. An activation of a
  knowledge base the registry does not hold is `Registry.Unknown_kb`, and a
  sign-in whose id another knowledge base holds is `Id_conflict`, where each
  was a code Protocol does not state (`kb.not-found`, `kb.id-conflict`).
- What discovery reads is the generated records Protocol names, in place of
  `Discovery`'s own types: `Discovery.parse_discovery_document` gives a
  `Records.Discovery_state.t` (`Absent` of a `Records.Discovery_absent.t`,
  its reason and diagnostic, or `Managed` of a `Records.Discovery_managed.t`),
  a transport reads a `Records.Discovery_read.t` (either of those, or
  `Unchanged`), and `Discovery.discovery_diff` and `subscribe_discovery` give
  a `Records.Discovery_diff.t`. Its knowledge bases are
  `` [ `DiscoveredKB ] Models.t ``, where they were `Records.Discovered_kb.t`,
  and an address more than one claims is its `host:port` text, where it was
  a pair. The types `Discovery.discovery_state`, `discovery_read` and
  `discovery_diff` go.
- An upload's `Records.Upload_progress.Started` and `Progress` state
  `total_bytes` as an `int option`, as does
  `Records.Conformance_driver_line_progress_progress`: the total is stated
  when the source states its length, as every upload's does today.
- `Client.connect` takes `?client_timing`, a `Client_timing.client`, and
  `?transport_timing`, a `Client_timing.transport`, in place of `?timing`,
  `?http_timing`, `?delegation_silence_ms`, `?delegation_poll_ms` and
  `?invalidation_window_ms`.
- `Subscription.start`'s and `Http_wire.make`'s `?timing` is a
  `Client_timing.transport`. Its `emit_retry` is a `Records.Retry_budget.t`,
  in place of `emit_attempts`, `emit_initial_delay_ms` and
  `emit_max_delay_ms`, and `http_request_timeout_ms` is what
  `request_timeout_ms` was. A subscription remembers as many event ids as
  `seen_event_ids_count` states.
- `Delegation.make` takes `?timing`, a `Client_timing.client`, in place of
  `?silence_ms` and `?poll_ms`, and its requests wait its
  `bus_request_timeout_ms`.
- `Subscription.request` takes `~timeout_ms`, which it no longer defaults: a
  subscription holds no client's timing. `Client.request` still waits the
  client's `bus_request_timeout_ms` when none is stated.

### Removed

- `Subscription.timing`, `Subscription.default_timing`, `Http_wire.timing` and
  `Http_wire.default_timing`. `max_reconnect_ms`, `degraded_threshold_ms`,
  `reconnect_debounce_ms` and `emit_timeout_ms` cannot be set: each is
  `Client_timing`'s.
- `Mark_state.make`'s `?silence_ms`: a quiet job is said after
  `Client_timing.delegate_silence_ms`.

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
