(* The names each SDK gives the code vocabularies of
   protocol/specs/src/errors/codes.json, by the member a schema's
   [x-xynolog-codes] names: Python's and TypeScript's, then Go's, which Rust,
   Kotlin and Swift share. *)

let names =
  [
    ("busRequest", ("BusRequestErrorCode", "BusRequestErrorCode"));
    ("transport", ("TransportErrorCode", "TransportErrorCode"));
    ("job", ("JobErrorCode", "JobErrorCode"));
    ("session", ("XynologSessionErrorCode", "SessionErrorCode"));
    ("signIn", ("SignInErrorCode", "SignInErrorCode"));
    ("kbIdentity", ("IdentityUnverifiableReason", "IdentityUnverifiableReason"));
    ("spanRefusal", ("SpanRefusal", "SpanRefusal"));
    ("control", ("ControlErrorCode", "ControlErrorCode"));
  ]

(* The names of the vocabulary [member] names, as a schema's
   [x-xynolog-codes] names it. *)
let named member =
  match List.assoc_opt member names with
  | Some named -> named
  | None ->
      invalid_arg
        (Printf.sprintf
           "errors/codes.json names %s, which is no vocabulary of it" member)
