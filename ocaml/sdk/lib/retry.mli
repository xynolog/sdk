type rule = Boot | Job | Transport | Refresh

val retryable :
  rule -> ?status:int -> ?meth:string -> ?keyed:bool -> unit -> bool

val retry_after_ms : string -> int option
val sleep_ms : Clock.t -> float -> unit

val retry_with_backoff :
  clock:Clock.t ->
  budget:Client_timing.retry ->
  accepts:('error -> bool) ->
  retry_after:('error -> int option) ->
  (unit -> ('value, 'error) result) ->
  ('value, 'error) result
