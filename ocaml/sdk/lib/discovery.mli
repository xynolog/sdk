(** Whole-document launcher discovery. An empty managed document is distinct
    from an absent, invalid or unsupported one. *)

type discovery_state =
  | Absent of Enums.Discovery_absent_reason.t
  | Managed of Records.Discovered_kb.t list

type discovery_read = Read of discovery_state | Unchanged
type discovery_transport = unit -> discovery_read

type discovery_diff = {
  state : discovery_state;
  added : Records.Discovered_kb.t list;
  updated : Records.Discovered_kb.t list;
  removed : Records.Discovered_kb.t list;
  duplicated : (string * int) list;
}

val discovery_interval : int
val parse_discovery_document : string -> discovery_state
val text_discovery : (unit -> string option) -> discovery_transport
val file_discovery : state_directory:string -> discovery_transport

val http_discovery :
  (etag:string option -> int * string option * string) -> discovery_transport

val discovery_diff :
  discovery_state option -> discovery_state -> discovery_diff option

val subscribe_discovery :
  sw:Eio.Switch.t ->
  clock:Clock.t ->
  ?interval_ms:int ->
  discovery_transport ->
  on_change:(discovery_diff -> unit) ->
  unit ->
  unit
