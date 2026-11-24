(* Generated from protocol/specs/src/errors/codes.json. Do not edit.
   Regenerate: make generate (codegen/lib/error_codes/ocaml.ml) *)

let () =
  let module Model = Xynolog.Error_codes.Bus_request in
  Alcotest.check Alcotest.string "Bus_request code" "bus.timeout"
    (Model.code Model.Timeout);
  Alcotest.check Alcotest.string "Bus_request code" "bus.rejected"
    (Model.code Model.Rejected);
  Alcotest.check Alcotest.string "Bus_request code" "bus.closed"
    (Model.code Model.Closed);
  Alcotest.check Alcotest.string "Bus_request code" "bus.not-found"
    (Model.code Model.Not_found);
  Alcotest.check Alcotest.string "Bus_request code" "bus.unsubscribed"
    (Model.code Model.Unsubscribed);
  Alcotest.check Alcotest.string "Bus_request code" "bus.peer-unavailable"
    (Model.code Model.Peer_unavailable);
  Alcotest.check Alcotest.string "Bus_request code" "bus.unauthorized"
    (Model.code Model.Unauthorized);
  Alcotest.check Alcotest.string "Bus_request code" "bus.none-pending"
    (Model.code Model.None_pending);
  let module Model = Xynolog.Error_codes.Transport in
  Alcotest.check Alcotest.string "Transport code" "unauthorized"
    (Model.code Model.Unauthorized);
  Alcotest.check Alcotest.string "Transport code" "forbidden"
    (Model.code Model.Forbidden);
  Alcotest.check Alcotest.string "Transport code" "not-found"
    (Model.code Model.Not_found);
  Alcotest.check Alcotest.string "Transport code" "conflict"
    (Model.code Model.Conflict);
  Alcotest.check Alcotest.string "Transport code" "bad-request"
    (Model.code Model.Bad_request);
  Alcotest.check Alcotest.string "Transport code" "unprocessable"
    (Model.code Model.Unprocessable);
  Alcotest.check Alcotest.string "Transport code" "rate-limited"
    (Model.code Model.Rate_limited);
  Alcotest.check Alcotest.string "Transport code" "unavailable"
    (Model.code Model.Unavailable);
  Alcotest.check Alcotest.string "Transport code" "error"
    (Model.code Model.Error);
  let module Model = Xynolog.Error_codes.Job in
  Alcotest.check Alcotest.string "Job code" "job.failed"
    (Model.code Model.Failed);
  Alcotest.check Alcotest.string "Job code" "job.cancelled"
    (Model.code Model.Cancelled);
  Alcotest.check Alcotest.string "Job code" "job.stalled"
    (Model.code Model.Stalled);
  let module Model = Xynolog.Error_codes.Session in
  Alcotest.check Alcotest.string "Session code" "session.construct-failed"
    (Model.code Model.Construct_failed);
  Alcotest.check Alcotest.string "Session code" "session.auth-failed"
    (Model.code Model.Auth_failed);
  Alcotest.check Alcotest.string "Session code" "session.refresh-exhausted"
    (Model.code Model.Refresh_exhausted);
  Alcotest.check Alcotest.string "Session code" "session.credential-refused"
    (Model.code Model.Credential_refused);
  Alcotest.check Alcotest.string "Session code" "session.keep-failed"
    (Model.code Model.Keep_failed);
  Alcotest.check Alcotest.string "Session code" "session.save-refused"
    (Model.code Model.Save_refused);
  let module Model = Xynolog.Error_codes.Sign_in in
  Alcotest.check Alcotest.string "Sign_in code" "no-issuer"
    (Model.code Model.No_issuer);
  Alcotest.check Alcotest.string "Sign_in code" "discovery"
    (Model.code Model.Discovery);
  Alcotest.check Alcotest.string "Sign_in code" "no-pending"
    (Model.code Model.No_pending);
  Alcotest.check Alcotest.string "Sign_in code" "state" (Model.code Model.State);
  Alcotest.check Alcotest.string "Sign_in code" "denied"
    (Model.code Model.Denied);
  Alcotest.check Alcotest.string "Sign_in code" "expired"
    (Model.code Model.Expired);
  Alcotest.check Alcotest.string "Sign_in code" "aborted"
    (Model.code Model.Aborted);
  Alcotest.check Alcotest.string "Sign_in code" "exchange"
    (Model.code Model.Exchange);
  let module Model = Xynolog.Error_codes.Kb_identity in
  Alcotest.check Alcotest.string "Kb_identity code" "unreachable"
    (Model.code Model.Unreachable);
  Alcotest.check Alcotest.string "Kb_identity code" "not-reported"
    (Model.code Model.Not_reported);
  let module Model = Xynolog.Error_codes.Span_refusal in
  Alcotest.check Alcotest.string "Span_refusal code" "span-out-of-range"
    (Model.code Model.Span_out_of_range);
  Alcotest.check Alcotest.string "Span_refusal code" "exact-mismatch"
    (Model.code Model.Exact_mismatch);
  Alcotest.check Alcotest.string "Span_refusal code" "prefix-mismatch"
    (Model.code Model.Prefix_mismatch);
  Alcotest.check Alcotest.string "Span_refusal code" "suffix-mismatch"
    (Model.code Model.Suffix_mismatch);
  Alcotest.check Alcotest.string "Span_refusal code" "nothing-located"
    (Model.code Model.Nothing_located);
  Alcotest.check Alcotest.string "Span_refusal code" "exact-not-covered"
    (Model.code Model.Exact_not_covered);
  Alcotest.check Alcotest.string "Span_refusal code" "item-out-of-range"
    (Model.code Model.Item_out_of_range);
  let module Model = Xynolog.Error_codes.Control in
  Alcotest.check Alcotest.string "Control code" "control.invalid-params"
    (Model.code Model.Invalid_params);
  Alcotest.check Alcotest.string "Control code"
    "control.unsupported-api-version"
    (Model.code Model.Unsupported_api_version);
  Alcotest.check Alcotest.string "Control code" "control.invalid-request"
    (Model.code Model.Invalid_request);
  Alcotest.check Alcotest.string "Control code" "control.invalid-service"
    (Model.code Model.Invalid_service);
  Alcotest.check Alcotest.string "Control code" "control.invalid-value"
    (Model.code Model.Invalid_value);
  Alcotest.check Alcotest.string "Control code" "control.unknown-setting"
    (Model.code Model.Unknown_setting);
  Alcotest.check Alcotest.string "Control code" "control.target-required"
    (Model.code Model.Target_required);
  Alcotest.check Alcotest.string "Control code" "control.target-ambiguous"
    (Model.code Model.Target_ambiguous);
  Alcotest.check Alcotest.string "Control code" "control.root-not-found"
    (Model.code Model.Root_not_found);
  Alcotest.check Alcotest.string "Control code" "control.root-not-registered"
    (Model.code Model.Root_not_registered);
  Alcotest.check Alcotest.string "Control code" "control.stack-not-running"
    (Model.code Model.Stack_not_running);
  Alcotest.check Alcotest.string "Control code" "control.stack-running"
    (Model.code Model.Stack_running);
  Alcotest.check Alcotest.string "Control code" "control.start-in-progress"
    (Model.code Model.Start_in_progress);
  Alcotest.check Alcotest.string "Control code" "control.runtime-unavailable"
    (Model.code Model.Runtime_unavailable);
  Alcotest.check Alcotest.string "Control code" "control.dependency-unavailable"
    (Model.code Model.Dependency_unavailable);
  Alcotest.check Alcotest.string "Control code" "control.unreachable"
    (Model.code Model.Unreachable);
  Alcotest.check Alcotest.string "Control code" "control.instance-in-use"
    (Model.code Model.Instance_in_use);
  Alcotest.check Alcotest.string "Control code" "control.instance-not-found"
    (Model.code Model.Instance_not_found);
  Alcotest.check Alcotest.string "Control code" "control.confirmation-required"
    (Model.code Model.Confirmation_required);
  Alcotest.check Alcotest.string "Control code" "control.unreadable-state"
    (Model.code Model.Unreadable_state);
  Alcotest.check Alcotest.string "Control code" "control.already-signed-in"
    (Model.code Model.Already_signed_in);
  Alcotest.check Alcotest.string "Control code" "control.sign-in-failed"
    (Model.code Model.Sign_in_failed);
  Alcotest.check Alcotest.string "Control code" "control.cancelled"
    (Model.code Model.Cancelled);
  Alcotest.check Alcotest.string "Control code" "control.failed"
    (Model.code Model.Failed);
  ()
