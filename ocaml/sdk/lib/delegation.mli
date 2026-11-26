(** Follow delegated jobs over an existing bus subscription. *)

type t
type release = unit -> unit
type report_kind = Created | Progress | Complete | Retrying | Refused

(** What a delegated job failed with: the job's own code, or the code of a
    request made to follow it. *)
type failure_code =
  | Job of Error_codes.Job.t
  | Request of Http_wire.request_code

val failure_code : failure_code -> string
(** The code, as protocol/specs/src/errors/codes.json states it. *)

type failure = {
  code : failure_code;
  message : string option;
  failure_class : Enums.Failure_class.t option;
}

val make :
  ?silence_ms:int ->
  ?poll_ms:int ->
  sw:Eio.Switch.t ->
  clock:Clock.t ->
  subscription:Subscription.t ->
  http:Http_wire.t ->
  client_id:string ->
  correlation_id:(unit -> string) ->
  unit ->
  t

val on_frame : t -> (Wire_stream.frame, Wire_stream.refusal) result -> unit
(** Forward the subscription's event callback here. *)

val start :
  t ->
  verb:Enums.Job_type.t ->
  ?resource:string ->
  ?stall_ms:int ->
  params:Yojson.Safe.t ->
  on_report:(report_kind -> Yojson.Safe.t -> unit) ->
  on_failure:(failure -> unit) ->
  on_close:(unit -> unit) ->
  unit ->
  unit ->
  unit
(** Start following a job. The returned function releases the observer. *)

val close : t -> unit
(** Releases all followers and prevents new delegations. *)
