(** A caller-owned sink for the SDK's transport instrumentation. *)

type kind = Client | Producer | Consumer
type attribute = String of string | Int of int | Bool of bool

type span = {
  trace : Records.Trace_carrier.t option;
  name : string;
  kind : kind;
  attributes : (string * attribute) list;
  started : float;
  ended : float;
}

type counter = {
  name : string;
  attributes : (string * attribute) list;
  time : float;
}

type t = { span : span -> unit; increment : counter -> unit }

val around :
  ?trace:Records.Trace_carrier.t ->
  t option ->
  clock:Clock.t ->
  string * kind ->
  (string * attribute) list ->
  (unit -> 'a) ->
  'a
