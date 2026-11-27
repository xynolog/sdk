open Eio.Std
module B = Bus_registry
module S = Subscription

(* When each thing the vitals say last happened, in wall seconds. *)
type activity = {
  last_queued_event_at : float option;
  last_claim_at : float option;
  last_finished_at : float option;
  last_activity_at : float option;
  active_job : (Worker.held * float) option;
  jobs_completed : int;
}

let initial_activity =
  {
    last_queued_event_at = None;
    last_claim_at = None;
    last_finished_at = None;
    last_activity_at = None;
    active_job = None;
    jobs_completed = 0;
  }

type t = {
  client : Client_core.t;
  accepts : Yojson.Safe.t;
  timeout_ms : int option;
  stall_ms : int;
  stall_check_ms : int;
  trace : unit -> Records.Trace_carrier.t option;
  mutable last_active : Mtime.t option;
  mutable did_stall : bool;
  refusals : Records.Claim_refusal.t Kept_for_first_reader.t;
  stalls : Records.Held_job_stall.t Kept_for_first_reader.t;
  mutable activity : activity;
  on_cancel : Worker.held -> unit;
  mutable held : Worker.held option;
  mutable waiting : bool;
  mutable release : Client_core.unsubscribe option;
  mutable wake : unit Promise.t * unit Promise.u;
  stopped : unit Promise.t;
  stop_now : unit Promise.u;
}

let make client ?timeout_ms ?(stall_ms = Worker.default_stall_ms)
    ?(stall_check_ms = Worker.default_stall_check_ms) ?(trace = fun () -> None)
    ?(on_cancel = ignore) filters =
  let accepts =
    `List
      (List.map
         (fun filter -> Yojson.Safe.from_string (Models.encode filter))
         filters)
  in
  let stopped, stop_now = Promise.create () in
  {
    client;
    accepts;
    timeout_ms;
    stall_ms;
    stall_check_ms;
    trace;
    last_active = None;
    did_stall = false;
    refusals = Kept_for_first_reader.make ();
    stalls = Kept_for_first_reader.make ();
    activity = initial_activity;
    on_cancel;
    held = None;
    waiting = false;
    release = None;
    wake = Promise.create ();
    stopped;
    stop_now;
  }

let refused t = Kept_for_first_reader.read t.refusals
let stalled t = Kept_for_first_reader.read t.stalls
let now t = Clock.wall_now (Client_core.clock t.client)

(* A wall time as a date-time, to the millisecond. *)
let stamp time =
  Ptime.to_rfc3339 ~frac_s:3 ~tz_offset_s:0 (Option.get (Ptime.of_float_s time))

let vitals t : Records.Worker_vitals.t =
  let a = t.activity in
  {
    last_queued_event_at = Option.map stamp a.last_queued_event_at;
    last_claim_at = Option.map stamp a.last_claim_at;
    last_finished_at = Option.map stamp a.last_finished_at;
    last_activity_at = Option.map stamp a.last_activity_at;
    active_job =
      Option.map
        (fun (job, since) ->
          match
            Records.Worker_active_job.to_model
              {
                job_id = Worker.id job;
                type_ = Worker.job_type job;
                since = stamp since;
              }
          with
          | Ok active -> active
          | Error _ -> invalid_arg "a held job is no WorkerActiveJob")
        a.active_job;
    jobs_completed = a.jobs_completed;
  }

let stopped t = Promise.is_resolved t.stopped

let wake t =
  if not (Promise.is_resolved (fst t.wake)) then Promise.resolve (snd t.wake) ()

let listen t =
  if Option.is_none t.release then (
    let queued = B.name B.Channels.job_queued in
    let cancel = B.name B.Channels.job_cancel_requested in
    let queued_seen () =
      t.activity <- { t.activity with last_queued_event_at = Some (now t) }
    in
    let receive = function
      | Ok (Wire_stream.Frame { route; payload; _ }) when route.channel = queued
        -> (
          queued_seen ();
          match payload with
          | Error _ -> wake t
          | Ok value ->
              if
                Worker.accepts ~filters:t.accepts
                  ~announcement:(Yojson.Safe.from_string (B.encode value))
              then wake t)
      | Error (Wire_stream.Invalid_frame (Some route, _))
        when route.channel = queued ->
          queued_seen ();
          wake t
      | Ok (Wire_stream.Frame { route; payload = Ok value; _ })
        when route.channel = cancel ->
          Option.iter
            (fun job ->
              let payload = Yojson.Safe.from_string (B.encode value) in
              if
                Yojson.Safe.Util.member "jobId" payload
                = `String (Worker.id job)
              then (
                Worker.notify_cancelled job;
                t.on_cancel job))
            t.held
      | _ -> ()
    in
    t.release <- Some (Client_core.on_frame t.client receive);
    let () =
      let clock = Client_core.clock t.client in
      let interval = Mtime.Span.(max 1 t.stall_check_ms * ms) in
      let threshold = Mtime.Span.(max 1 t.stall_ms * ms) in
      let bus = Client_core.subscription t.client in
      let rec check () =
        let now = Clock.monotonic_now clock in
        (match (t.held, t.last_active, t.activity) with
        | ( Some job,
            Some active,
            {
              active_job = Some (_, held_since);
              last_activity_at = Some told;
              _;
            } )
          when (not t.did_stall)
               && (not (Worker.is_settled job))
               && Mtime.Span.compare (Mtime.span now active) threshold > 0 ->
            t.did_stall <- true;
            Kept_for_first_reader.say t.stalls
              {
                job_id = Worker.job_id job;
                job_type = Worker.job_type job;
                held_since = stamp held_since;
                last_activity_at = stamp told;
                silent_for_ms =
                  Int64.to_int
                    (Int64.div
                       (Mtime.Span.to_uint64_ns (Mtime.span now active))
                       1_000_000L);
                threshold_ms = t.stall_ms;
              }
        | _ -> ());
        let next =
          Mtime.add_span now interval |> Option.value ~default:Mtime.max_stamp
        in
        Clock.sleep_until clock next;
        check ()
      in
      Fiber.fork_daemon ~sw:(Client_core.switch t.client) (fun () ->
          Fiber.first check (fun () ->
              Fiber.first
                (fun () -> Promise.await t.stopped)
                (fun () -> S.await_closed bus));
          `Stop_daemon)
    in

    let bus = Client_core.subscription t.client in
    Fiber.fork_daemon ~sw:(Client_core.switch t.client) (fun () ->
        Fiber.first
          (fun () -> Promise.await t.stopped)
          (fun () ->
            let rec watch previous seen_open =
              match S.await_state_change bus ~from:previous with
              | Enums.Connection_state.Closed -> ()
              | state ->
                  if seen_open && state = Enums.Connection_state.Open then
                    wake t;
                  watch state (seen_open || state = Enums.Connection_state.Open)
            in
            let state = S.state bus in
            watch state (state = Enums.Connection_state.Open));
        Option.iter (fun release -> release ()) t.release;
        `Stop_daemon))

let next t =
  if t.waiting then invalid_arg "claims already have a waiting consumer";
  if stopped t then None
  else (
    listen t;
    t.waiting <- true;
    let bus = Client_core.subscription t.client in
    let activity () =
      t.last_active <- Some (Clock.monotonic_now (Client_core.clock t.client));
      t.activity <- { t.activity with last_activity_at = Some (now t) }
    in
    let on_settled completed =
      let jobs_completed = t.activity.jobs_completed + Bool.to_int completed in
      t.activity <-
        {
          t.activity with
          active_job = None;
          last_finished_at = Some (now t);
          jobs_completed;
        }
    in
    let next () =
      Option.iter Worker.await_settled t.held;
      t.held <- None;
      let rec claim () =
        t.wake <- Promise.create ();

        let result =
          try
            Worker.claim ~on_activity:activity ~on_settled
              ?timeout_ms:t.timeout_ms ?trace:(t.trace ()) bus
              (Client_core.http t.client)
              ~client_id:(Client_core.client_id t.client)
              ~correlation_id:(Client_core.next_key t.client)
              ~accepts:t.accepts ()
          with Http_wire.Failed failure ->
            Worker.Refused { code = None; message = failure.message }
        in
        match result with
        | Worker.Held job ->
            t.held <- Some job;
            activity ();
            t.did_stall <- false;
            let claimed = now t in
            t.activity <-
              {
                t.activity with
                active_job = Some (job, claimed);
                last_claim_at = Some claimed;
              };
            Some job
        | Worker.Empty ->
            Promise.await (fst t.wake);
            claim ()
        | Worker.Refused refusal ->
            Kept_for_first_reader.say t.refusals refusal;
            Promise.await (fst t.wake);
            claim ()
      in
      claim ()
    in
    Fun.protect
      ~finally:(fun () -> t.waiting <- false)
      (fun () ->
        Fiber.first next (fun () ->
            Fiber.first
              (fun () -> Promise.await t.stopped)
              (fun () -> S.await_closed bus);
            None)))

let stop ?(settle = true) t =
  if not (stopped t) then (
    Promise.resolve t.stop_now ();
    Option.iter (fun release -> release ()) t.release;
    if settle then
      Option.iter (fun job -> Worker.fail job ~error:"worker stopped") t.held;
    t.held <- None;
    t.activity <- { t.activity with active_job = None };
    Kept_for_first_reader.close t.refusals;
    Kept_for_first_reader.close t.stalls)

include Worker_facts

let will_retry_after = Worker.will_retry_after
