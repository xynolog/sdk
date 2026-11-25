type t
(** A single consumer of the queue. The first [next] starts claiming, and the
    next claim waits for the held job to settle. *)

val make :
  Client_core.t ->
  ?timeout_ms:int ->
  ?stall_ms:int ->
  ?stall_check_ms:int ->
  ?trace:(unit -> Records.Trace_carrier.t option) ->
  ?on_cancel:(Worker.held -> unit) ->
  [ `JobFilter ] Models.t list ->
  t

val next : t -> Worker.held option
val stop : ?settle:bool -> t -> unit
val job_claim_channels : Bus_registry.packed_channel list
val job_commit_channels : Bus_registry.packed_channel list

val will_retry_after :
  retry_count:int -> max_retries:int -> Enums.Failure_class.t option -> bool

val refused :
  t ->
  on_value:(Records.Claim_refusal.t -> unit) ->
  on_close:(unit -> unit) ->
  unit ->
  unit
(** Hear each claim refused. The first reader is first given the latest
    errorsKeptForFirstReaderCount (protocol/specs/src/client/timing.json)
    refused before it came, in order; a later reader hears what is refused from
    when it reads. [stop] ends it, and what is still kept is dropped. The
    returned function stops hearing. *)

val stalled :
  t ->
  on_value:(Records.Held_job_stall.t -> unit) ->
  on_close:(unit -> unit) ->
  unit ->
  unit
(** Hear each held job that stalls, kept for the first reader as [refused] keeps
    refusals. *)

val vitals : t -> Records.Worker_vitals.t
