open Xynolog_codegen

let case name test = Alcotest.test_case name `Quick test
let file = "errors/codes.json"

(* Two docs of words that wrap where Go's width of 78 and Python's of 96
   break a line, and where a column more or less would not. *)
let go_wrapped =
  "transport the peer reply peer reply an refused reply a reply answered reply \
   refused peer an closed code transport a closed transport status status \
   reply an peer."

let python_wrapped =
  "an answered peer request gateway the request gateway an request the peer \
   transport status peer status request status peer a status transport failure \
   closed reply peer peer a refused answered answered."

(* A code of a vocabulary, as codes.json states it. *)
let entry ?wire ?status ?status_from ?(docs = "Docs.") code =
  String.concat ","
    (List.concat
       [
         [ "\"code\":" ^ Text.quoted code; "\"docs\":" ^ Text.quoted docs ];
         Option.to_list (Option.map (fun w -> "\"wire\":" ^ Text.quoted w) wire);
         Option.to_list
           (Option.map (fun s -> "\"status\":" ^ string_of_int s) status);
         Option.to_list
           (Option.map
              (fun s -> "\"statusFrom\":" ^ string_of_int s)
              status_from);
       ])
  |> Printf.sprintf "{%s}"

let codes entries = "[" ^ String.concat "," entries ^ "]"

let plain docs entries =
  Printf.sprintf {|{"docs":%s,"codes":%s}|} (Text.quoted docs) (codes entries)

let bus_codes =
  [
    entry ~docs:"No reply came." "bus.timeout";
    entry ~docs:"The peer refused." "bus.rejected";
    entry ~docs:"Not there." ~wire:"not-found" "bus.not-found";
    entry ~docs:"No peer." ~wire:"peer-unavailable" "bus.peer-unavailable";
    entry ~docs:"Not allowed." ~wire:"unauthorized" "bus.unauthorized";
    entry ~docs:"Nothing waits." ~wire:"none-pending" "bus.none-pending";
  ]

let transport_codes =
  [
    entry ~docs:"Who?" ~status:401 "unauthorized";
    entry ~docs:"Missing, */ even." ~status:404 "not-found";
    entry ~docs:"Down." ~status_from:500 "unavailable";
    entry ~docs:"Else." "error";
  ]

let session_codes = [ entry ~docs:"No auth." "session.auth-failed" ]

let table ?(bus = bus_codes) ?(unrecognized = "bus.rejected")
    ?(transport = transport_codes) ?(unclassified = "error")
    ?(session = session_codes)
    ?(control =
      {|{"code":"control.failed","docs":"Failed.","rpc":-32603,"retryable":false}|})
    () =
  Printf.sprintf
    {|{"$comment":"c",
      "busRequest":{"docs":"Why a bus request failed.","unrecognizedFailure":%s,"codes":%s},
      "transport":{"docs":%s,"unclassified":%s,"codes":%s},
      "job":%s,"session":%s,"signIn":%s,"kbIdentity":%s,"spanRefusal":%s,"control":%s}|}
    (Text.quoted unrecognized) (codes bus) (Text.quoted go_wrapped)
    (Text.quoted unclassified) (codes transport)
    (plain python_wrapped [ entry ~docs:"It failed." "job.failed" ])
    (plain "Why a session broke." session)
    (plain "Why a sign-in failed." [ entry ~docs:"No issuer." "no-issuer" ])
    (plain "Why an identity is unverified."
       [ entry ~docs:"Unreachable." "unreachable" ])
    (plain "Why a span was refused."
       [ entry ~docs:"Out of range." "span-out-of-range" ])
    (plain "Control." [ control ])

let decode text =
  Decode.run ~file (Yojson.Safe.from_string text) Tables.Errors_codes.decode

let model text =
  match decode text with
  | Ok (t, _) -> t
  | Error error -> Alcotest.fail (Decode.error_to_string error)

(* The JSON-RPC codes the control codes are answered under, as
   control/rpc-codes.json states them. *)
let rpc_codes =
  match
    Decode.run ~file:"control/rpc-codes.json"
      (Yojson.Safe.from_string
         {|{"$comment":"c","codes":[{"number":-32603,"name":"internal-error","docs":"Broke."},{"number":-32000,"name":"operation-failed","docs":"Failed."}]}|})
      Tables.Control_rpc_codes.decode
  with
  | Ok (t, _) -> t
  | Error error -> Alcotest.fail (Decode.error_to_string error)

let derive text = Error_codes.Table.derive ~rpc_codes (model text)

let derived text =
  match derive text with
  | Ok t -> t
  | Error errors ->
      Alcotest.fail
        (String.concat "\n" (List.map Decode.error_to_string errors))

let refuses text expected () =
  match derive text with
  | Ok _ ->
      Alcotest.failf "expected the refusals\n  %s\nand none came"
        (String.concat "\n  " expected)
  | Error errors ->
      Alcotest.(check (list string))
        "refusals"
        (List.map (fun e -> file ^ ": " ^ e) expected)
        (List.map Decode.error_to_string errors)

let code = Alcotest.(pair string string)

let rules =
  [
    case "the vocabularies, the wire's codes and the statuses" (fun () ->
        let t = derived (table ()) in
        Alcotest.(check (list (pair string string)))
          "wire"
          [
            ("not-found", "bus.not-found");
            ("peer-unavailable", "bus.peer-unavailable");
            ("unauthorized", "bus.unauthorized");
            ("none-pending", "bus.none-pending");
          ]
          (List.map
             (fun (wire, (c : Error_codes.Table.code)) -> (wire, c.code))
             t.wire);
        Alcotest.(check string)
          "unrecognized" "bus.rejected" t.unrecognized.code;
        Alcotest.(check (list (pair int string)))
          "exact"
          [ (401, "unauthorized"); (404, "not-found") ]
          (List.map
             (fun (status, (c : Error_codes.Table.code)) -> (status, c.code))
             t.exact);
        Alcotest.(check (option (pair int string)))
          "from"
          (Some (500, "unavailable"))
          (Option.map
             (fun (status, (c : Error_codes.Table.code)) -> (status, c.code))
             t.from);
        Alcotest.(check string) "unclassified" "error" t.unclassified.code;
        Alcotest.(check (list code))
          "names"
          [
            ("BusRequestErrorCode", "BusRequestErrorCode");
            ("TransportErrorCode", "TransportErrorCode");
            ("JobErrorCode", "JobErrorCode");
            ("XynologSessionErrorCode", "SessionErrorCode");
            ("SignInErrorCode", "SignInErrorCode");
            ("IdentityUnverifiableReason", "IdentityUnverifiableReason");
            ("SpanRefusal", "SpanRefusal");
          ]
          (List.map
             (fun (v : Error_codes.Table.vocabulary) -> (v.name, v.go_name))
             (t.bus :: t.transport :: t.others));
        Alcotest.(check (list string))
          "Go constants"
          [
            "BusRequestErrorCodeTimeout";
            "BusRequestErrorCodeRejected";
            "BusRequestErrorCodeNotFound";
            "BusRequestErrorCodePeerUnavailable";
            "BusRequestErrorCodeUnauthorized";
            "BusRequestErrorCodeNonePending";
          ]
          (List.map (fun (c : Error_codes.Table.code) -> c.go) t.bus.codes));
    case "a code's Go constant, from its part after its last dot" (fun () ->
        let t =
          derived (table ~session:[ entry "session.store.keep-failed" ] ())
        in
        Alcotest.(check (list string))
          "Go constants"
          [ "SessionErrorCodeKeepFailed" ]
          (List.map
             (fun (c : Error_codes.Table.code) -> c.go)
             (List.nth t.others 1).codes));
    case "no range and no exact status" (fun () ->
        let t = derived (table ~transport:[ entry "error" ] ()) in
        Alcotest.(check int) "exact" 0 (List.length t.exact);
        Alcotest.(check bool) "from" true (t.from = None));
    case "a wire code no bus code restates is refused"
      (refuses
         (table
            ~bus:
              (List.filter
                 (fun e ->
                   e
                   <> entry ~docs:"Not there." ~wire:"not-found" "bus.not-found")
                 bus_codes)
            ())
         [
           "/busRequest/codes: restates no code as CommandError.code's \
            not-found";
         ]);
    case "each control code's JSON-RPC code, and whether it is retryable"
      (fun () ->
        let t = derived (table ()) in
        Alcotest.(check (list (triple string string bool)))
          "answered"
          [ ("control.failed", "internal-error", false) ]
          (List.map
             (fun (a : Error_codes.Table.answered) ->
               (a.control_code.code, a.rpc.name, a.retryable))
             t.answered));
    case "a control code answered under no JSON-RPC code is refused"
      (refuses
         (table
            ~control:
              {|{"code":"control.failed","docs":"Failed.","rpc":-1,"retryable":true}|}
            ())
         [
           "/control/codes/0/rpc: is -1, which is none of \
            control/rpc-codes.json's numbers";
         ]);
    case "a wire code restated twice is refused"
      (refuses
         (table ~bus:(bus_codes @ [ entry ~wire:"not-found" "bus.closed" ]) ())
         [
           "/busRequest/codes/6/wire: is not-found, which bus.not-found \
            restates already";
         ]);
    case "a code stated twice is refused"
      (refuses
         (table ~session:(session_codes @ [ entry "session.auth-failed" ]) ())
         [
           "/session/codes/1/code: is session.auth-failed, which \
            /session/codes/0 states already";
         ]);
    case "two codes that are one Go constant are refused"
      (refuses
         (table ~session:(session_codes @ [ entry "other.auth-failed" ]) ())
         [
           "/session/codes/1/code: is SessionErrorCodeAuthFailed in Go, which \
            /session/codes/0 is already";
         ]);
    case "a code whose last part names no Go constant is refused"
      (refuses
         (table
            ~session:[ entry "session.Auth_failed"; entry "session.a--b" ]
            ())
         [
           "/session/codes/0/code: is session.Auth_failed, whose last part \
            names no Go constant: it is lower-case words of letters and digits \
            joined by hyphens";
           "/session/codes/1/code: is session.a--b, whose last part names no \
            Go constant: it is lower-case words of letters and digits joined \
            by hyphens";
         ]);
    case "an unrecognized failure that restates a wire code is refused"
      (refuses
         (table ~unrecognized:"bus.not-found" ())
         [
           "/busRequest/unrecognizedFailure: is bus.not-found, which restates \
            the wire's not-found: an unrecognized failure is no recognized one";
         ]);
    case "an unrecognized failure that is none of the codes is refused"
      (refuses
         (table ~unrecognized:"bus.gone" ())
         [
           "/busRequest/unrecognizedFailure: is bus.gone, which is none of its \
            codes";
         ]);
    case "a status two codes are read from is refused"
      (refuses
         (table
            ~transport:(transport_codes @ [ entry ~status:404 "conflict" ])
            ())
         [
           "/transport/codes/4/status: is 404, which not-found is read from \
            already";
         ]);
    case "a status in the range is refused"
      (refuses
         (table
            ~transport:(transport_codes @ [ entry ~status:503 "conflict" ])
            ())
         [
           "/transport/codes/4/status: is 503, which is in unavailable's \
            statuses, from 500";
         ]);
    case "a status at the range's start is refused"
      (refuses
         (table
            ~transport:(transport_codes @ [ entry ~status:500 "conflict" ])
            ())
         [
           "/transport/codes/4/status: is 500, which is in unavailable's \
            statuses, from 500";
         ]);
    case "a second range is refused"
      (refuses
         (table
            ~transport:(transport_codes @ [ entry ~status_from:600 "worse" ])
            ())
         [
           "/transport/codes/4/statusFrom: is a second range of statuses: a \
            status falls in one";
         ]);
    case "a transport code nothing produces is refused"
      (refuses
         (table ~transport:(transport_codes @ [ entry "gone" ]) ())
         [
           "/transport/codes/4: is gone, which no status is read as, and which \
            is not the unclassified code";
         ]);
    case "an unclassified code a status is read as is refused"
      (refuses
         (table ~unclassified:"not-found" ())
         [
           "/transport/codes/1: is not-found, the unclassified code, which a \
            status is read as already";
           "/transport/codes/3: is error, which no status is read as, and \
            which is not the unclassified code";
         ]);
    case "an unclassified code that is none of the codes is refused"
      (refuses
         (table ~unclassified:"lost" ())
         [
           "/transport/unclassified: is lost, which is none of its codes";
           "/transport/codes/3: is error, which no status is read as, and \
            which is not the unclassified code";
         ]);
  ]

(* A tab, in the expected texts below, is written as a tilde. *)
let tabs = Text.replace_all ~sub:"~" ~by:"\t"

let go =
  {|// Code generated from protocol/specs/src/errors/codes.json; DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/error_codes/go.ml)
// The TypeScript, Python and Rust vocabularies are generated from the same
// table.

package api

// Why a bus request failed.
type BusRequestErrorCode string

const (
~// No reply came.
~BusRequestErrorCodeTimeout BusRequestErrorCode = "bus.timeout"
~// The peer refused.
~BusRequestErrorCodeRejected BusRequestErrorCode = "bus.rejected"
~// Not there.
~BusRequestErrorCodeNotFound BusRequestErrorCode = "bus.not-found"
~// No peer.
~BusRequestErrorCodePeerUnavailable BusRequestErrorCode = "bus.peer-unavailable"
~// Not allowed.
~BusRequestErrorCodeUnauthorized BusRequestErrorCode = "bus.unauthorized"
~// Nothing waits.
~BusRequestErrorCodeNonePending BusRequestErrorCode = "bus.none-pending"
)

// BusRequestErrorCodeOfWire is the code a failure's own code
// (CommandError.code) becomes, a case for each of CommandErrorCode's codes. A
// failure that states none is BusRequestErrorCodeRejected. A reader leaves a
// code the required table does not recognize out of the failure before it
// decodes it, so a code CommandErrorCode does not name is none a failure is
// read with: given one, it panics.
func BusRequestErrorCodeOfWire(code *CommandErrorCode) BusRequestErrorCode {
~if code == nil {
~~return BusRequestErrorCodeRejected
~}
~switch *code {
~case CommandErrorCodeNotFound:
~~return BusRequestErrorCodeNotFound
~case CommandErrorCodePeerUnavailable:
~~return BusRequestErrorCodePeerUnavailable
~case CommandErrorCodeUnauthorized:
~~return BusRequestErrorCodeUnauthorized
~case CommandErrorCodeNonePending:
~~return BusRequestErrorCodeNonePending
~default:
~~panic("a failure's code \"" + string(*code) + "\" is none of CommandErrorCode's: the required table recognizes a code CommandError does not list")
~}
}

// Wire is the wire code a peer stated, when this code restates one: what a
// service answers its own caller with. A failure only this side knows states
// none, and ok is false.
func (c BusRequestErrorCode) Wire() (code CommandErrorCode, ok bool) {
~switch c {
~case BusRequestErrorCodeNotFound:
~~return CommandErrorCodeNotFound, true
~case BusRequestErrorCodePeerUnavailable:
~~return CommandErrorCodePeerUnavailable, true
~case BusRequestErrorCodeUnauthorized:
~~return CommandErrorCodeUnauthorized, true
~case BusRequestErrorCodeNonePending:
~~return CommandErrorCodeNonePending, true
~default:
~~return "", false
~}
}

// transport the peer reply peer reply an refused reply a reply answered reply
// refused peer an closed code transport a closed transport status status
// reply an peer.
type TransportErrorCode string

const (
~// Who?
~TransportErrorCodeUnauthorized TransportErrorCode = "unauthorized"
~// Missing, */ even.
~TransportErrorCodeNotFound TransportErrorCode = "not-found"
~// Down.
~TransportErrorCodeUnavailable TransportErrorCode = "unavailable"
~// Else.
~TransportErrorCodeError TransportErrorCode = "error"
)

// TransportErrorCodeOfStatus is the code an HTTP status becomes.
func TransportErrorCodeOfStatus(status int) TransportErrorCode {
~switch {
~case status == 401:
~~return TransportErrorCodeUnauthorized
~case status == 404:
~~return TransportErrorCodeNotFound
~case status >= 500:
~~return TransportErrorCodeUnavailable
~default:
~~return TransportErrorCodeError
~}
}

// LimitRefusalTransportCode is a gateway refusal of a limit that is a
// transport code too: its status, its LimitRefusal code, and the transport
// code it is.
type LimitRefusalTransportCode struct {
~Status    int
~Code      string
~Transport TransportErrorCode
}

// LimitRefusalTransportCodes is each gateway refusal of a limit that is a
// transport code too.
var LimitRefusalTransportCodes = []LimitRefusalTransportCode{

}

// an answered peer request gateway the request gateway an request the peer
// transport status peer status request status peer a status transport failure
// closed reply peer peer a refused answered answered.
type JobErrorCode string

const (
~// It failed.
~JobErrorCodeFailed JobErrorCode = "job.failed"
)

// Why a session broke.
type SessionErrorCode string

const (
~// No auth.
~SessionErrorCodeAuthFailed SessionErrorCode = "session.auth-failed"
)

// Why a sign-in failed.
type SignInErrorCode string

const (
~// No issuer.
~SignInErrorCodeNoIssuer SignInErrorCode = "no-issuer"
)

// Why an identity is unverified.
type IdentityUnverifiableReason string

const (
~// Unreachable.
~IdentityUnverifiableReasonUnreachable IdentityUnverifiableReason = "unreachable"
)

// Why a span was refused.
type SpanRefusal string

const (
~// Out of range.
~SpanRefusalSpanOutOfRange SpanRefusal = "span-out-of-range"
)

// Control.
type ControlErrorCode string

const (
~// Failed.
~ControlErrorCodeFailed ControlErrorCode = "control.failed"
)

// ControlRpcCode is a JSON-RPC error code the launcher's control API answers
// with (control/rpc-codes.json).
type ControlRpcCode int

const (
~// Broke.
~ControlRpcCodeInternalError ControlRpcCode = -32603
~// Failed.
~ControlRpcCodeOperationFailed ControlRpcCode = -32000
)

// Rpc is the JSON-RPC code an answer carries the code under.
func (c ControlErrorCode) Rpc() ControlRpcCode {
~switch c {
~case ControlErrorCodeFailed:
~~return ControlRpcCodeInternalError
~default:
~~panic("a control code \"" + string(c) + "\" is none of ControlErrorCode's")
~}
}

// Retryable is whether the same request can succeed sent again unchanged,
// once something outside it changes: what ErrorData's retryable says of the
// code.
func (c ControlErrorCode) Retryable() bool {
~switch c {
~case ControlErrorCodeFailed:
~~return false
~default:
~~panic("a control code \"" + string(c) + "\" is none of ControlErrorCode's")
~}
}
|}

let python =
  {|# Generated from protocol/specs/src/errors/codes.json; do not edit.
# Regenerate: make generate (codegen/lib/error_codes/python.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""The codes a Xynolog client reports a failure under.

Each vocabulary is a closed set: a `Literal` union, so a `match` over one that
ends in `assert_never` is checked to name every code, and a tuple of the same
codes to iterate.
"""

from typing import Final, Literal, assert_never

__all__ = [
    "BUS_REQUEST_ERROR_CODES",
    "BusRequestErrorCode",
    "CONTROL_ERROR_CODES",
    "CONTROL_RPC_INTERNAL_ERROR",
    "CONTROL_RPC_OPERATION_FAILED",
    "ControlErrorCode",
    "IDENTITY_UNVERIFIABLE_REASONS",
    "IdentityUnverifiableReason",
    "JOB_ERROR_CODES",
    "JobErrorCode",
    "LIMIT_REFUSAL_TRANSPORT_CODES",
    "SIGN_IN_ERROR_CODES",
    "SPAN_REFUSALS",
    "SignInErrorCode",
    "SpanRefusal",
    "TRANSPORT_ERROR_CODES",
    "TransportErrorCode",
    "XYNOLOG_SESSION_ERROR_CODES",
    "XynologSessionErrorCode",
    "bus_request_code_for_wire_code",
    "control_code_retryable",
    "control_rpc_code",
    "transport_error_code_for_status",
]

# Why a bus request failed.
type BusRequestErrorCode = Literal[
    # No reply came.
    "bus.timeout",
    # The peer refused.
    "bus.rejected",
    # Not there.
    "bus.not-found",
    # No peer.
    "bus.peer-unavailable",
    # Not allowed.
    "bus.unauthorized",
    # Nothing waits.
    "bus.none-pending",
]

BUS_REQUEST_ERROR_CODES: Final[tuple[BusRequestErrorCode, ...]] = (
    "bus.timeout",
    "bus.rejected",
    "bus.not-found",
    "bus.peer-unavailable",
    "bus.unauthorized",
    "bus.none-pending",
)


def bus_request_code_for_wire_code(
    code: Literal["not-found", "peer-unavailable", "unauthorized", "none-pending"] | None,
) -> BusRequestErrorCode:
    """The bus code a failure's own code (`CommandError.code`) becomes.

    A failure that states none is the unrecognized failure, and so is one
    whose code the wire does not list, which is read as stating none.
    """
    match code:
        case "not-found":
            return "bus.not-found"
        case "peer-unavailable":
            return "bus.peer-unavailable"
        case "unauthorized":
            return "bus.unauthorized"
        case "none-pending":
            return "bus.none-pending"
        case None:
            return "bus.rejected"
        case _:
            assert_never(code)


# transport the peer reply peer reply an refused reply a reply answered reply refused peer an
# closed code transport a closed transport status status reply an peer.
type TransportErrorCode = Literal[
    # Who?
    "unauthorized",
    # Missing, */ even.
    "not-found",
    # Down.
    "unavailable",
    # Else.
    "error",
]

TRANSPORT_ERROR_CODES: Final[tuple[TransportErrorCode, ...]] = (
    "unauthorized",
    "not-found",
    "unavailable",
    "error",
)


def transport_error_code_for_status(status: int) -> TransportErrorCode:
    """The transport code an HTTP status becomes."""
    match status:
        case 401:
            return "unauthorized"
        case 404:
            return "not-found"
        case _:
            pass
    if status >= 500:
        return "unavailable"
    return "error"


LIMIT_REFUSAL_TRANSPORT_CODES: Final[tuple[tuple[int, str, TransportErrorCode], ...]] = ()
"""Each gateway refusal of a limit that is a transport code too: its status, its `LimitRefusal` code, and the transport code it is."""

# an answered peer request gateway the request gateway an request the peer transport status peer
# status request status peer a status transport failure closed reply peer peer a refused
# answered answered.
type JobErrorCode = Literal[
    # It failed.
    "job.failed",
]

JOB_ERROR_CODES: Final[tuple[JobErrorCode, ...]] = ("job.failed",)

# Why a session broke.
type XynologSessionErrorCode = Literal[
    # No auth.
    "session.auth-failed",
]

XYNOLOG_SESSION_ERROR_CODES: Final[tuple[XynologSessionErrorCode, ...]] = ("session.auth-failed",)

# Why a sign-in failed.
type SignInErrorCode = Literal[
    # No issuer.
    "no-issuer",
]

SIGN_IN_ERROR_CODES: Final[tuple[SignInErrorCode, ...]] = ("no-issuer",)

# Why an identity is unverified.
type IdentityUnverifiableReason = Literal[
    # Unreachable.
    "unreachable",
]

IDENTITY_UNVERIFIABLE_REASONS: Final[tuple[IdentityUnverifiableReason, ...]] = ("unreachable",)

# Why a span was refused.
type SpanRefusal = Literal[
    # Out of range.
    "span-out-of-range",
]

SPAN_REFUSALS: Final[tuple[SpanRefusal, ...]] = ("span-out-of-range",)

# Control.
type ControlErrorCode = Literal[
    # Failed.
    "control.failed",
]

CONTROL_ERROR_CODES: Final[tuple[ControlErrorCode, ...]] = ("control.failed",)

CONTROL_RPC_INTERNAL_ERROR: Final = -32603
"""Broke."""

CONTROL_RPC_OPERATION_FAILED: Final = -32000
"""Failed."""


def control_rpc_code(code: ControlErrorCode) -> int:
    """The JSON-RPC code of control/rpc-codes.json an answer carries a control code under."""
    match code:
        case "control.failed":
            return CONTROL_RPC_INTERNAL_ERROR
        case _:
            assert_never(code)


def control_code_retryable(code: ControlErrorCode) -> bool:
    """Whether the same request can succeed sent again unchanged, once something outside it changes: what `ErrorData.retryable` says of the code."""
    match code:
        case "control.failed":
            return False
        case _:
            assert_never(code)
|}

let typescript =
  {|// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/errors/codes.json
// Regenerate:  make generate  (codegen/lib/error_codes/typescript.ml)

/** Why a bus request failed. */
export type BusRequestErrorCode =
  /** No reply came. */
  | 'bus.timeout'
  /** The peer refused. */
  | 'bus.rejected'
  /** Not there. */
  | 'bus.not-found'
  /** No peer. */
  | 'bus.peer-unavailable'
  /** Not allowed. */
  | 'bus.unauthorized'
  /** Nothing waits. */
  | 'bus.none-pending';

/** The bus code a failure's own wire code (`CommandError.code`) becomes. */
export const busRequestCodeByWireCode = {
  'not-found': 'bus.not-found',
  'peer-unavailable': 'bus.peer-unavailable',
  'unauthorized': 'bus.unauthorized',
  'none-pending': 'bus.none-pending',
} as const;

/** What a failure becomes when it states no code, or one CommandError does not list, which is read as none. */
export const unrecognizedFailureCode = 'bus.rejected' as const;

/** transport the peer reply peer reply an refused reply a reply answered reply refused peer an closed code transport a closed transport status status reply an peer. */
export type TransportErrorCode =
  /** Who? */
  | 'unauthorized'
  /** Missing, *\/ even. */
  | 'not-found'
  /** Down. */
  | 'unavailable'
  /** Else. */
  | 'error';

/** The transport code an HTTP status becomes. */
export function transportErrorCodeForStatus(status: number): TransportErrorCode {
  switch (status) {
    case 401: return 'unauthorized';
    case 404: return 'not-found';
  }
  if (status >= 500) return 'unavailable';
  return 'error';
}

/** Each gateway refusal of a limit that is a transport code too: its status, its `LimitRefusal` code, and the transport code it is. */
export const limitRefusalTransportCodes = [] as const;

/** an answered peer request gateway the request gateway an request the peer transport status peer status request status peer a status transport failure closed reply peer peer a refused answered answered. */
export type JobErrorCode =
  /** It failed. */
  | 'job.failed';

/** Why a session broke. */
export type XynologSessionErrorCode =
  /** No auth. */
  | 'session.auth-failed';

/** Why a sign-in failed. */
export type SignInErrorCode =
  /** No issuer. */
  | 'no-issuer';

/** Why an identity is unverified. */
export type IdentityUnverifiableReason =
  /** Unreachable. */
  | 'unreachable';

/** Why a span was refused. */
export type SpanRefusal =
  /** Out of range. */
  | 'span-out-of-range';

/** Control. */
export type ControlErrorCode =
  /** Failed. */
  | 'control.failed';

/** Each JSON-RPC error code the launcher's control API answers with (control/rpc-codes.json), by its name. */
export const controlRpcCodes = {
  /** Broke. */
  internalError: -32603,
  /** Failed. */
  operationFailed: -32000,
} as const;

/** A JSON-RPC error code the launcher's control API answers with. */
export type ControlRpcCode = (typeof controlRpcCodes)[keyof typeof controlRpcCodes];

/** Each control code's JSON-RPC code, the one an answer carries it under, and whether it is retryable: whether the same request can succeed sent again unchanged, once something outside it changes. */
export const controlErrorCodeAnswers = {
  'control.failed': { rpc: controlRpcCodes.internalError, retryable: false },
} as const satisfies { readonly [code in ControlErrorCode]: { readonly rpc: ControlRpcCode; readonly retryable: boolean } };
|}

let writers =
  [
    case "Go's vocabularies" (fun () ->
        Alcotest.(check string)
          "text" (tabs go)
          (Error_codes.Go.text (derived (table ()))));
    case "Python's vocabularies" (fun () ->
        Alcotest.(check string)
          "text" python
          (Error_codes.Python.text (derived (table ()))));
    case "TypeScript's vocabularies" (fun () ->
        Alcotest.(check string)
          "text" typescript
          (Error_codes.Typescript.text (derived (table ()))));
    case "with no range, no line for one" (fun () ->
        let t = derived (table ~transport:[ entry "error" ] ()) in
        let lines text =
          List.filter
            (fun line -> String.trim line <> "")
            (String.split_on_char '\n' text)
        in
        let around text first =
          let rec from = function
            | [] -> []
            | line :: rest when line = first -> line :: rest
            | _ :: rest -> from rest
          in
          List.filteri (fun i _ -> i < 5) (from (lines text))
        in
        Alcotest.(check (list string))
          "Go"
          [
            "func TransportErrorCodeOfStatus(status int) TransportErrorCode {";
            "\tswitch {";
            "\tdefault:";
            "\t\treturn TransportErrorCodeError";
            "\t}";
          ]
          (around (Error_codes.Go.text t)
             "func TransportErrorCodeOfStatus(status int) TransportErrorCode {");
        Alcotest.(check (list string))
          "Python"
          [
            "def transport_error_code_for_status(status: int) -> \
             TransportErrorCode:";
            "    \"\"\"The transport code an HTTP status becomes.\"\"\"";
            "    match status:";
            "        case _:";
            "            pass";
          ]
          (around
             (Error_codes.Python.text t)
             "def transport_error_code_for_status(status: int) -> \
              TransportErrorCode:");
        Alcotest.(check (list string))
          "TypeScript"
          [
            "export function transportErrorCodeForStatus(status: number): \
             TransportErrorCode {";
            "  switch (status) {";
            "  }";
            "  return 'error';";
            "}";
          ]
          (around
             (Error_codes.Typescript.text t)
             "export function transportErrorCodeForStatus(status: number): \
              TransportErrorCode {"));
  ]

let () =
  Alcotest.run "error-codes" [ ("the rules", rules); ("the writers", writers) ]
