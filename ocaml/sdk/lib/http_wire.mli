type t

type timing = {
  emit_attempts : int;
  emit_initial_delay_ms : int;
  emit_max_delay_ms : int;
  emit_timeout_ms : int;
  request_timeout_ms : int;
}

type failure = {
  code : Error_codes.Transport.t;
  status : int option;
  message : string;
}
(** A failure of the transport: its code, the status it was answered with, and
    what went wrong, in the gateway's own words when its answer states them. *)

(** What a request over the bus fails with: the bus request's code, or the
    transport's when the request never reached the bus. *)
type request_code =
  | Bus of Error_codes.Bus_request.t
  | Transport of Error_codes.Transport.t

val request_code : request_code -> string
(** The code, as protocol/specs/src/errors/codes.json states it. *)

exception Failed of failure

val default_timing : timing

val make :
  ?timing:timing ->
  ?telemetry:Telemetry.t ->
  clock:Clock.t ->
  session:Session.t ->
  key:(unit -> string) ->
  on_error:(failure -> unit) ->
  call:
    (sw:Eio.Switch.t ->
    meth:string ->
    path:string ->
    headers:(string * string) list ->
    body:string ->
    progress:(int -> unit) option ->
    int * (string * string) list * Eio.Flow.source_ty Eio.Resource.t) ->
  unit ->
  t

val subscribe :
  t ->
  sw:Eio.Switch.t ->
  Subscription.snapshot ->
  bearer:string ->
  (Eio.Buf_read.t, Subscription.credential_error) result

val emit :
  t ->
  client_id:string ->
  ?scope:Identifiers.Resource_id.t ->
  ?correlation_id:string ->
  ?trace:Wire_stream.trace ->
  'a Bus_registry.channel ->
  string ->
  string

val bus_failure : 'a Bus_registry.decoded -> Error_codes.Bus_request.t
val health : t -> string
val status : t -> string
val current_user : t -> string
val protected_resource_metadata : t -> string
val media_token : t -> Identifiers.Resource_id.t -> string
val graph : t -> Identifiers.Resource_id.t -> string
val annotations : t -> Identifiers.Resource_id.t -> string
val anchored_text : t -> Identifiers.Resource_id.t -> string

val with_content :
  t ->
  ?streaming:bool ->
  Identifiers.Resource_id.t ->
  (content_type:string -> Eio.Flow.source_ty Eio.Resource.t -> 'a) ->
  'a

val put :
  t ->
  fields:(string * string) list ->
  bytes:string ->
  on_progress:(Records.Upload_progress.t -> unit) ->
  string

val check_user : t -> string -> (string, failure) result
(** Who the gateway names [token] by: one [GET /api/users/me], bounded by the
    request timeout, neither made again nor sent with a renewed token. *)
