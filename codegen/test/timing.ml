open Xynolog_codegen

let case name test = Alcotest.test_case name `Quick test
let file = "client/timing.json"

(* Two docs of words that wrap where Go's width of 78 (behind a field's
   "Linger is lingerMs: ") and Python's of 96 break a line, and where a column
   more or less would not. *)
let go_wrapped =
  "closed closed emit request the request a a gateway peer closed reply a a \
   request retry an gateway an closed reply peer the an an gateway emit peer \
   closed a closed closed closed the open."

let python_wrapped =
  "timer wait request a retry retry wait open an the wait gateway request \
   stream closed peer peer an timer peer reply gateway an gateway closed the \
   wait request emit emit emit an emit reply the closed."

let entry ?(docs = "Docs.") name value =
  Printf.sprintf {|{"name":%s,"value":%s,"docs":%s}|} (Text.quoted name) value
    (Text.quoted docs)

let budget attempts initial max =
  Printf.sprintf {|{"attempts":%d,"initialDelayMs":%d,"maxDelayMs":%d}|}
    attempts initial max

let entries =
  [
    entry ~docs:go_wrapped "lingerMs" "1000";
    entry ~docs:python_wrapped "emitRetry" (budget 4 1000 4000);
    entry ~docs:"Counted, */ even." "seenEventIdsCount" "512";
  ]

let table entries =
  Printf.sprintf {|{"$comment":"c","timing":[%s]}|} (String.concat "," entries)

let decode text =
  Decode.run ~file (Yojson.Safe.from_string text) Tables.Client_timing.decode

let model text =
  match decode text with
  | Ok (t, _) -> t
  | Error error -> Alcotest.fail (Decode.error_to_string error)

let derive text = Timing.Table.derive (model text)

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

let value =
  Alcotest.testable
    (fun formatter (value : Timing.Table.value) ->
      Format.pp_print_string formatter
        (match value with
        | Duration ms -> Printf.sprintf "%d ms" ms
        | Budget { attempts; initial_delay_ms; max_delay_ms } ->
            Printf.sprintf "%d attempts, %d to %d ms" attempts initial_delay_ms
              max_delay_ms
        | Count n -> Printf.sprintf "%d" n))
    ( = )

let rules =
  [
    case "each entry, by its name's kind, in the table's order" (fun () ->
        Alcotest.(check (list (pair string value)))
          "entries"
          [
            ("lingerMs", Duration 1000);
            ( "emitRetry",
              Budget
                { attempts = 4; initial_delay_ms = 1000; max_delay_ms = 4000 }
            );
            ("seenEventIdsCount", Count 512);
          ]
          (List.map
             (fun (e : Timing.Table.entry) -> (e.name, e.value))
             (derived (table entries))));
    case "a name of no kind is refused"
      (refuses
         (table
            [
              entry "linger" "1";
              entry "LingerMs" "1";
              entry "linger_Ms" "1";
              entry "Ms" "1";
              entry "lingers" "1";
            ])
         (List.map
            (fun (i, name) ->
              Printf.sprintf
                "/timing/%d/name: is %s, which says neither a duration, a \
                 budget nor a count: a name is camel case, ending in Ms, Retry \
                 or Count"
                i name)
            [
              (0, "linger");
              (1, "LingerMs");
              (2, "linger_Ms");
              (3, "Ms");
              (4, "lingers");
            ]));
    case "a name stated twice is refused"
      (refuses
         (table [ entry "lingerMs" "1"; entry "lingerMs" "2" ])
         [ "/timing/1/name: is lingerMs, which /timing/0 states already" ]);
    case "a duration not above zero is refused"
      (refuses
         (table [ entry "lingerMs" "0"; entry "emitTimeoutMs" "-5" ])
         [
           "/timing/0/value: is 0: a duration is a whole number of \
            milliseconds above zero";
           "/timing/1/value: is -5: a duration is a whole number of \
            milliseconds above zero";
         ]);
    case "a duration that is a budget is refused"
      (refuses
         (table [ entry "lingerMs" (budget 4 1 2) ])
         [
           "/timing/0/value: is an object: a duration is a whole number of \
            milliseconds above zero";
         ]);
    case "a count not above zero is refused"
      (refuses
         (table [ entry "seenEventIdsCount" "0" ])
         [ "/timing/0/value: is 0: a count is a whole number above zero" ]);
    case "a count that is a budget is refused"
      (refuses
         (table [ entry "seenEventIdsCount" (budget 4 1 2) ])
         [
           "/timing/0/value: is an object: a count is a whole number above zero";
         ]);
    case "a budget that is a number is refused"
      (refuses
         (table [ entry "emitRetry" "4" ])
         [
           "/timing/0/value: is 4: a budget is attempts, initialDelayMs and \
            maxDelayMs";
         ]);
    case "a budget that allows no attempt is refused"
      (refuses
         (table [ entry "refreshRetry" (budget 0 500 4000) ])
         [
           "/timing/0/value/attempts: is 0: a budget allows one attempt at \
            least";
         ]);
    case "a budget's delays not above zero are refused"
      (refuses
         (table [ entry "refreshRetry" (budget 1 0 0) ])
         [
           "/timing/0/value/initialDelayMs: is 0: a delay is a whole number of \
            milliseconds above zero";
           "/timing/0/value/maxDelayMs: is 0: a delay is a whole number of \
            milliseconds above zero";
         ]);
    case "a backoff that starts above its ceiling is refused"
      (refuses
         (table [ entry "refreshRetry" (budget 4 5000 4000) ])
         [
           "/timing/0/value: starts its backoff at 5000 ms, above its ceiling \
            of 4000";
         ]);
    case "a backoff that starts at its ceiling is accepted" (fun () ->
        Alcotest.(check int)
          "entries" 1
          (List.length
             (derived (table [ entry "refreshRetry" (budget 1 4000 4000) ]))));
  ]

let names =
  [
    case "a name as a constant's" (fun () ->
        Alcotest.(check (list string))
          "constants"
          [
            "EMIT_RETRY";
            "SEEN_EVENT_IDS_COUNT";
            "BUS_REQUEST_ERROR_CODE";
            "A_BC";
          ]
          (List.map Text.upper_snake
             [ "emitRetry"; "seenEventIdsCount"; "BusRequestErrorCode"; "aBC" ]));
  ]

(* A tab, in the expected text below, is written as a tilde. *)
let tabs = Text.replace_all ~sub:"~" ~by:"\t"

let go =
  {|// Code generated from protocol/specs/src/client/timing.json; DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/timing/go.ml)
// The TypeScript, Python and Rust constants are generated from the same table.

package xynolog

import (
~"time"

~"github.com/xynolog/sdk/go/api"
)

// Timing is the timing a Xynolog client keeps: its deadlines, its retry
// budgets, the cadence of its stream, and what it keeps count of, as
// protocol/specs/src/client/timing.json states them for every SDK. It holds
// one field per entry, under the entry's name. DefaultTiming is the table's
// values; a caller that wants another sets that field.
type Timing struct {
~// Linger is lingerMs: closed closed emit request the request a a gateway
~// peer closed reply a a request retry an gateway an closed reply peer the an
~// an gateway emit peer closed a closed closed closed the open.
~Linger time.Duration
~// EmitRetry is emitRetry: timer wait request a retry retry wait open an the
~// wait gateway request stream closed peer peer an timer peer reply gateway
~// an gateway closed the wait request emit emit emit an emit reply the
~// closed.
~EmitRetry api.RetryBudget
~// SeenEventIdsCount is seenEventIdsCount: Counted, */ even.
~SeenEventIdsCount int
}

// DefaultTiming is the table's values.
func DefaultTiming() Timing {
~return Timing{
~~Linger:            1000 * time.Millisecond,
~~EmitRetry:         api.RetryBudget{Attempts: 4, InitialDelayMs: 1000, MaxDelayMs: 4000},
~~SeenEventIdsCount: 512,
~}
}
|}

let python =
  {|# Generated from protocol/specs/src/client/timing.json; do not edit.
# Regenerate: make generate (codegen/lib/timing/python.ml)
# ruff: noqa: E501, I001, RUF002, RUF022, RUF100

"""The timing a Xynolog client keeps: its deadlines, its retry budgets, the
cadence of its stream, and what it keeps count of.

Each constant is an entry of the table every SDK generates from, under the
entry's own name: `emitRetry` is `EMIT_RETRY`. `TIMING_NAMES` lists the names
as the table states them, which is how a caller overrides one.
"""

from typing import Final

from xynolog.types import RetryBudget

__all__ = [
    "EMIT_RETRY",
    "LINGER_MS",
    "SEEN_EVENT_IDS_COUNT",
    "TIMING_NAMES",
]

# closed closed emit request the request a a gateway peer closed reply a a request retry an
# gateway an closed reply peer the an an gateway emit peer closed a closed closed closed the
# open.
LINGER_MS: Final = 1000

# timer wait request a retry retry wait open an the wait gateway request stream closed peer peer
# an timer peer reply gateway an gateway closed the wait request emit emit emit an emit reply
# the closed.
EMIT_RETRY: Final = RetryBudget(attempts=4, initial_delay_ms=1000, max_delay_ms=4000)

# Counted, */ even.
SEEN_EVENT_IDS_COUNT: Final = 512

# Every entry's name, as the table states it.
TIMING_NAMES: Final[tuple[str, ...]] = (
    "lingerMs",
    "emitRetry",
    "seenEventIdsCount",
)
|}

let typescript =
  Printf.sprintf
    {|// ⚠ GENERATED FILE — do not edit.
//
// Authority:   protocol/specs/src/client/timing.json
// Regenerate:  make generate  (codegen/lib/timing/typescript.ml)

import type { RetryBudget } from './retry';

/** %s */
export const LINGER_MS = 1000;

/** %s */
export const EMIT_RETRY: RetryBudget = { attempts: 4, initialDelayMs: 1000, maxDelayMs: 4000 };

/** Counted, *\/ even. */
export const SEEN_EVENT_IDS_COUNT = 512;
|}
    go_wrapped python_wrapped

let writers =
  [
    case "Go's timing" (fun () ->
        Alcotest.(check string)
          "text" (tabs go)
          (Timing.Go.text (derived (table entries))));
    case "Python's timing" (fun () ->
        Alcotest.(check string)
          "text" python
          (Timing.Python.text (derived (table entries))));
    case "TypeScript's timing" (fun () ->
        Alcotest.(check string)
          "text" typescript
          (Timing.Typescript.text (derived (table entries))));
  ]

let () =
  Alcotest.run "timing"
    [ ("the rules", rules); ("names", names); ("the writers", writers) ]
