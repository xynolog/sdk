(* Generated from protocol/specs/src/errors/codes.json. Do not edit.
   Regenerate: make generate (codegen/lib/error_codes/ocaml.ml) *)

module Bus_request = struct
  type t =
    | Timeout
    | Rejected
    | Closed
    | Not_found
    | Unsubscribed
    | Peer_unavailable
    | Unauthorized
    | None_pending

  let code = function
    | Timeout -> "bus.timeout"
    | Rejected -> "bus.rejected"
    | Closed -> "bus.closed"
    | Not_found -> "bus.not-found"
    | Unsubscribed -> "bus.unsubscribed"
    | Peer_unavailable -> "bus.peer-unavailable"
    | Unauthorized -> "bus.unauthorized"
    | None_pending -> "bus.none-pending"

  let of_code = function
    | "bus.timeout" -> Some Timeout
    | "bus.rejected" -> Some Rejected
    | "bus.closed" -> Some Closed
    | "bus.not-found" -> Some Not_found
    | "bus.unsubscribed" -> Some Unsubscribed
    | "bus.peer-unavailable" -> Some Peer_unavailable
    | "bus.unauthorized" -> Some Unauthorized
    | "bus.none-pending" -> Some None_pending
    | _ -> None

  let timeout = "bus.timeout"
  let rejected = "bus.rejected"
  let closed = "bus.closed"
  let not_found = "bus.not-found"
  let unsubscribed = "bus.unsubscribed"
  let peer_unavailable = "bus.peer-unavailable"
  let unauthorized = "bus.unauthorized"
  let none_pending = "bus.none-pending"
end

module Transport = struct
  type t =
    | Unauthorized
    | Forbidden
    | Not_found
    | Conflict
    | Bad_request
    | Unprocessable
    | Rate_limited
    | Unavailable
    | Error

  let code = function
    | Unauthorized -> "unauthorized"
    | Forbidden -> "forbidden"
    | Not_found -> "not-found"
    | Conflict -> "conflict"
    | Bad_request -> "bad-request"
    | Unprocessable -> "unprocessable"
    | Rate_limited -> "rate-limited"
    | Unavailable -> "unavailable"
    | Error -> "error"

  let of_code = function
    | "unauthorized" -> Some Unauthorized
    | "forbidden" -> Some Forbidden
    | "not-found" -> Some Not_found
    | "conflict" -> Some Conflict
    | "bad-request" -> Some Bad_request
    | "unprocessable" -> Some Unprocessable
    | "rate-limited" -> Some Rate_limited
    | "unavailable" -> Some Unavailable
    | "error" -> Some Error
    | _ -> None

  let unauthorized = "unauthorized"
  let forbidden = "forbidden"
  let not_found = "not-found"
  let conflict = "conflict"
  let bad_request = "bad-request"
  let unprocessable = "unprocessable"
  let rate_limited = "rate-limited"
  let unavailable = "unavailable"
  let error = "error"
end

module Job = struct
  type t = Failed | Cancelled | Stalled

  let code = function
    | Failed -> "job.failed"
    | Cancelled -> "job.cancelled"
    | Stalled -> "job.stalled"

  let of_code = function
    | "job.failed" -> Some Failed
    | "job.cancelled" -> Some Cancelled
    | "job.stalled" -> Some Stalled
    | _ -> None

  let failed = "job.failed"
  let cancelled = "job.cancelled"
  let stalled = "job.stalled"
end

module Session = struct
  type t =
    | Construct_failed
    | Auth_failed
    | Refresh_exhausted
    | Credential_refused
    | Keep_failed
    | Save_refused

  let code = function
    | Construct_failed -> "session.construct-failed"
    | Auth_failed -> "session.auth-failed"
    | Refresh_exhausted -> "session.refresh-exhausted"
    | Credential_refused -> "session.credential-refused"
    | Keep_failed -> "session.keep-failed"
    | Save_refused -> "session.save-refused"

  let of_code = function
    | "session.construct-failed" -> Some Construct_failed
    | "session.auth-failed" -> Some Auth_failed
    | "session.refresh-exhausted" -> Some Refresh_exhausted
    | "session.credential-refused" -> Some Credential_refused
    | "session.keep-failed" -> Some Keep_failed
    | "session.save-refused" -> Some Save_refused
    | _ -> None

  let construct_failed = "session.construct-failed"
  let auth_failed = "session.auth-failed"
  let refresh_exhausted = "session.refresh-exhausted"
  let credential_refused = "session.credential-refused"
  let keep_failed = "session.keep-failed"
  let save_refused = "session.save-refused"
end

module Sign_in = struct
  type t =
    | No_issuer
    | Discovery
    | No_pending
    | State
    | Denied
    | Expired
    | Aborted
    | Exchange

  let code = function
    | No_issuer -> "no-issuer"
    | Discovery -> "discovery"
    | No_pending -> "no-pending"
    | State -> "state"
    | Denied -> "denied"
    | Expired -> "expired"
    | Aborted -> "aborted"
    | Exchange -> "exchange"

  let of_code = function
    | "no-issuer" -> Some No_issuer
    | "discovery" -> Some Discovery
    | "no-pending" -> Some No_pending
    | "state" -> Some State
    | "denied" -> Some Denied
    | "expired" -> Some Expired
    | "aborted" -> Some Aborted
    | "exchange" -> Some Exchange
    | _ -> None

  let no_issuer = "no-issuer"
  let discovery = "discovery"
  let no_pending = "no-pending"
  let state = "state"
  let denied = "denied"
  let expired = "expired"
  let aborted = "aborted"
  let exchange = "exchange"
end

module Kb_identity = struct
  type t = Unreachable | Not_reported

  let code = function
    | Unreachable -> "unreachable"
    | Not_reported -> "not-reported"

  let of_code = function
    | "unreachable" -> Some Unreachable
    | "not-reported" -> Some Not_reported
    | _ -> None

  let unreachable = "unreachable"
  let not_reported = "not-reported"
end

module Span_refusal = struct
  type t =
    | Span_out_of_range
    | Exact_mismatch
    | Prefix_mismatch
    | Suffix_mismatch
    | Nothing_located
    | Exact_not_covered
    | Item_out_of_range

  let code = function
    | Span_out_of_range -> "span-out-of-range"
    | Exact_mismatch -> "exact-mismatch"
    | Prefix_mismatch -> "prefix-mismatch"
    | Suffix_mismatch -> "suffix-mismatch"
    | Nothing_located -> "nothing-located"
    | Exact_not_covered -> "exact-not-covered"
    | Item_out_of_range -> "item-out-of-range"

  let of_code = function
    | "span-out-of-range" -> Some Span_out_of_range
    | "exact-mismatch" -> Some Exact_mismatch
    | "prefix-mismatch" -> Some Prefix_mismatch
    | "suffix-mismatch" -> Some Suffix_mismatch
    | "nothing-located" -> Some Nothing_located
    | "exact-not-covered" -> Some Exact_not_covered
    | "item-out-of-range" -> Some Item_out_of_range
    | _ -> None

  let span_out_of_range = "span-out-of-range"
  let exact_mismatch = "exact-mismatch"
  let prefix_mismatch = "prefix-mismatch"
  let suffix_mismatch = "suffix-mismatch"
  let nothing_located = "nothing-located"
  let exact_not_covered = "exact-not-covered"
  let item_out_of_range = "item-out-of-range"
end

module Control = struct
  type t =
    | Invalid_params
    | Unsupported_api_version
    | Invalid_request
    | Invalid_service
    | Invalid_value
    | Unknown_setting
    | Target_required
    | Target_ambiguous
    | Root_not_found
    | Root_not_registered
    | Stack_not_running
    | Stack_running
    | Start_in_progress
    | Runtime_unavailable
    | Dependency_unavailable
    | Unreachable
    | Instance_in_use
    | Instance_not_found
    | Confirmation_required
    | Unreadable_state
    | Already_signed_in
    | Sign_in_failed
    | Cancelled
    | Failed

  let code = function
    | Invalid_params -> "control.invalid-params"
    | Unsupported_api_version -> "control.unsupported-api-version"
    | Invalid_request -> "control.invalid-request"
    | Invalid_service -> "control.invalid-service"
    | Invalid_value -> "control.invalid-value"
    | Unknown_setting -> "control.unknown-setting"
    | Target_required -> "control.target-required"
    | Target_ambiguous -> "control.target-ambiguous"
    | Root_not_found -> "control.root-not-found"
    | Root_not_registered -> "control.root-not-registered"
    | Stack_not_running -> "control.stack-not-running"
    | Stack_running -> "control.stack-running"
    | Start_in_progress -> "control.start-in-progress"
    | Runtime_unavailable -> "control.runtime-unavailable"
    | Dependency_unavailable -> "control.dependency-unavailable"
    | Unreachable -> "control.unreachable"
    | Instance_in_use -> "control.instance-in-use"
    | Instance_not_found -> "control.instance-not-found"
    | Confirmation_required -> "control.confirmation-required"
    | Unreadable_state -> "control.unreadable-state"
    | Already_signed_in -> "control.already-signed-in"
    | Sign_in_failed -> "control.sign-in-failed"
    | Cancelled -> "control.cancelled"
    | Failed -> "control.failed"

  let of_code = function
    | "control.invalid-params" -> Some Invalid_params
    | "control.unsupported-api-version" -> Some Unsupported_api_version
    | "control.invalid-request" -> Some Invalid_request
    | "control.invalid-service" -> Some Invalid_service
    | "control.invalid-value" -> Some Invalid_value
    | "control.unknown-setting" -> Some Unknown_setting
    | "control.target-required" -> Some Target_required
    | "control.target-ambiguous" -> Some Target_ambiguous
    | "control.root-not-found" -> Some Root_not_found
    | "control.root-not-registered" -> Some Root_not_registered
    | "control.stack-not-running" -> Some Stack_not_running
    | "control.stack-running" -> Some Stack_running
    | "control.start-in-progress" -> Some Start_in_progress
    | "control.runtime-unavailable" -> Some Runtime_unavailable
    | "control.dependency-unavailable" -> Some Dependency_unavailable
    | "control.unreachable" -> Some Unreachable
    | "control.instance-in-use" -> Some Instance_in_use
    | "control.instance-not-found" -> Some Instance_not_found
    | "control.confirmation-required" -> Some Confirmation_required
    | "control.unreadable-state" -> Some Unreadable_state
    | "control.already-signed-in" -> Some Already_signed_in
    | "control.sign-in-failed" -> Some Sign_in_failed
    | "control.cancelled" -> Some Cancelled
    | "control.failed" -> Some Failed
    | _ -> None

  let invalid_params = "control.invalid-params"
  let unsupported_api_version = "control.unsupported-api-version"
  let invalid_request = "control.invalid-request"
  let invalid_service = "control.invalid-service"
  let invalid_value = "control.invalid-value"
  let unknown_setting = "control.unknown-setting"
  let target_required = "control.target-required"
  let target_ambiguous = "control.target-ambiguous"
  let root_not_found = "control.root-not-found"
  let root_not_registered = "control.root-not-registered"
  let stack_not_running = "control.stack-not-running"
  let stack_running = "control.stack-running"
  let start_in_progress = "control.start-in-progress"
  let runtime_unavailable = "control.runtime-unavailable"
  let dependency_unavailable = "control.dependency-unavailable"
  let unreachable = "control.unreachable"
  let instance_in_use = "control.instance-in-use"
  let instance_not_found = "control.instance-not-found"
  let confirmation_required = "control.confirmation-required"
  let unreadable_state = "control.unreadable-state"
  let already_signed_in = "control.already-signed-in"
  let sign_in_failed = "control.sign-in-failed"
  let cancelled = "control.cancelled"
  let failed = "control.failed"
end

let limit_refusal_transport_codes =
  [ (429, "refusal-rate", Transport.Unauthorized) ]
