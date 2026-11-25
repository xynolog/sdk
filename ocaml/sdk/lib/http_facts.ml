(* Generated from error codes. Do not edit.
   Regenerate: make generate (codegen/lib/ocaml_sdk/http_facts.ml) *)

let status_code = function
  | 401 -> Error_codes.Transport.Unauthorized
  | 403 -> Error_codes.Transport.Forbidden
  | 404 -> Error_codes.Transport.Not_found
  | 409 -> Error_codes.Transport.Conflict
  | 400 -> Error_codes.Transport.Bad_request
  | 422 -> Error_codes.Transport.Unprocessable
  | 429 -> Error_codes.Transport.Rate_limited
  | status when status >= 500 -> Error_codes.Transport.Unavailable
  | _ -> Error_codes.Transport.Error

module Failure_code = struct
  type t = Not_found | Peer_unavailable | Unauthorized | None_pending

  let of_wire = function
    | "not-found" -> Not_found
    | "peer-unavailable" -> Peer_unavailable
    | "unauthorized" -> Unauthorized
    | "none-pending" -> None_pending
    | code ->
        invalid_arg
          ("a failure's code \"" ^ code
         ^ "\" is none of CommandError's: the reader leaves such a code out")
end

let bus_failure = function
  | None -> Error_codes.Bus_request.Rejected
  | Some Failure_code.Not_found -> Error_codes.Bus_request.Not_found
  | Some Failure_code.Peer_unavailable ->
      Error_codes.Bus_request.Peer_unavailable
  | Some Failure_code.Unauthorized -> Error_codes.Bus_request.Unauthorized
  | Some Failure_code.None_pending -> Error_codes.Bus_request.None_pending
