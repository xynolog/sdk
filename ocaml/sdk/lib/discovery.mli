(** Whole-document launcher discovery. An empty managed document is distinct
    from an absent, invalid or unsupported one. *)

type discovery_transport = unit -> Records.Discovery_read.t

val discovery_interval : int
val parse_discovery_document : string -> Records.Discovery_state.t
val text_discovery : (unit -> string option) -> discovery_transport
val file_discovery : state_directory:string -> discovery_transport

val http_discovery :
  (etag:string option -> int * string option * string) -> discovery_transport

val discovery_diff :
  Records.Discovery_state.t option ->
  Records.Discovery_state.t ->
  Records.Discovery_diff.t option

val subscribe_discovery :
  sw:Eio.Switch.t ->
  clock:Clock.t ->
  ?interval_ms:int ->
  discovery_transport ->
  on_change:(Records.Discovery_diff.t -> unit) ->
  unit ->
  unit
