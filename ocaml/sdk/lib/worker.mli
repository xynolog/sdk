(** A claimed job and its serialized lifecycle over the typed wire. *)

type held
type claim = Held of held | Empty | Refused of Records.Claim_refusal.t

include Held_job_members.Held_job_record.S with type held := held
(** A held job's record, and each of its members. *)

val accepts : filters:Yojson.Safe.t -> announcement:Yojson.Safe.t -> bool

val claim :
  Subscription.t ->
  Http_wire.t ->
  client_id:string ->
  correlation_id:string ->
  ?trace:Records.Trace_carrier.t ->
  ?on_activity:(unit -> unit) ->
  ?on_settled:(bool -> unit) ->
  ?timeout_ms:int ->
  accepts:Yojson.Safe.t ->
  unit ->
  claim

val trace : held -> Records.Trace_carrier.t option
val id : held -> string
val start : held -> unit
val progress : held -> percentage:int -> message:Yojson.Safe.t option -> unit
val checkpoint : held -> Records.Job_checkpoint.t -> unit

val commit :
  held ->
  Subscription.t ->
  correlation_id:(unit -> string) ->
  ?timeout_ms:int ->
  resource:Identifiers.Resource_id.t ->
  annotations:Yojson.Safe.t list ->
  unit ->
  (unit, Error_codes.Bus_request.t) result

val complete : held -> Yojson.Safe.t -> unit

val cancel : ?reached:Records.Job_reached.t -> held -> unit
(** Cancel the job, saying how far it got when [reached] says so. *)

val fail : ?failure:Records.Job_failure.t -> held -> error:string -> unit
(** Fail the job, saying how far it got and how it failed when [failure] says
    so. *)

val default_stall_ms : int
val default_stall_check_ms : int
val await_settled : held -> unit

val will_retry_after :
  retry_count:int -> max_retries:int -> Enums.Failure_class.t option -> bool

val is_settled : held -> bool
val attempt : held -> int
val annotation_id : held -> Identifiers.Annotation_id.t option
val cancelled : held -> bool
val notify_cancelled : held -> unit
val settled : held -> bool

module Mark : sig
  val complete : held -> [ `MarkJobResult ] Models.t -> unit
end

module Yield : sig
  val complete : held -> [ `YieldJobResult ] Models.t -> unit
end
