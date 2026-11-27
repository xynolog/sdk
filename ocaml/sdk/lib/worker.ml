module B = Bus_registry
module J = Yojson.Safe.Util

type phase = Claimed | Started | Settled

type held = {
  http : Http_wire.t;
  client_id : string;
  trace : Records.Trace_carrier.t option;
  record : Records.Held_job_record.t;
  lock : Eio.Mutex.t;
  on_activity : unit -> unit;
  on_settled : bool -> unit;
  settled : unit Eio.Promise.t * unit Eio.Promise.u;
  mutable phase : phase;
  cancellation : bool State_value.t * bool State_value.writer;
  mutable durability : (int * Enums.Durability_evidence.t) option;
}

type claim = Held of held | Empty | Refused of Records.Claim_refusal.t

include Held_job_members.Held_job_record.Make (struct
  type t = held

  let record job = job.record
end)

let text value = `String value
let trace job = job.trace
let id job = Identifiers.Job_id.to_string (job_id job)
let attempt job = retry_count job + 1

let accepts ~filters ~announcement =
  let verb = J.member "jobType" announcement in
  let job_type =
    match verb with
    | `String value -> Enums.Job_type.of_string value
    | _ -> None
  in
  let motivation value =
    match J.member "params" value with
    | `Assoc _ as params -> J.member "motivation" params
    | _ -> `Null
  in
  J.to_list filters
  |> List.exists (fun filter ->
      J.member "jobType" filter = verb
      &&
      match job_type with
      | Some Enums.Job_type.Yield -> true
      | Some Enums.Job_type.Mark ->
          let wanted = motivation filter in
          wanted <> `Null && wanted = motivation announcement
      | None -> false)

let claim subscription http ~client_id ~correlation_id ?trace
    ?(on_activity = ignore) ?(on_settled = ignore)
    ?(timeout_ms = Client_timing.job_claim_timeout_ms) ~accepts () =
  let operation = B.Operations.job_claim in
  let send () =
    ignore
      (Http_wire.emit http ~client_id ~correlation_id ?trace
         (B.request operation)
         (Yojson.Safe.to_string (`Assoc [ ("accepts", accepts) ])))
  in
  match
    Subscription.request subscription ~timeout_ms ~correlation_id operation
      ~send
  with
  | Error Subscription.Timeout ->
      Refused
        {
          code = Some Error_codes.Bus_request.Timeout;
          message = "The claim had no answer within its timeout.";
        }
  | Error _ ->
      Refused { code = None; message = "The claim ended with no answer." }
  | Ok (Subscription.Failure payload) -> (
      match
        ( Http_wire.bus_failure payload,
          Models.decode Models.command_error (B.encode payload) )
      with
      | Error_codes.Bus_request.None_pending, _ -> Empty
      | code, Ok failure ->
          Refused
            {
              code = Some code;
              message = (Records.Command_error.of_model failure).message;
            }
      | _, Error _ ->
          Refused
            {
              code = None;
              message = "The claim's refusal is not a CommandError.";
            })
  | Ok (Subscription.Result payload) -> (
      let refused () =
        Refused
          { code = None; message = "The claim's answer is not a held job." }
      in
      match
        J.member "response" (Yojson.Safe.from_string (B.encode payload))
      with
      | exception J.Type_error _ -> refused ()
      | response -> (
          let metadata = J.member "metadata" response in
          let params = J.member "params" response in
          (* Both appear on the metadata once an attempt has checkpointed.
             Absent, each is none. *)
          let stated name none =
            match J.member name metadata with `Null -> none | value -> value
          in
          match
            Records.Held_job_record.of_json
              (`Assoc
                 [
                   ("jobId", J.member "id" metadata);
                   ("jobType", J.member "type" metadata);
                   ("resourceId", J.member "resourceId" params);
                   ("params", params);
                   ("completedUnits", stated "completedUnits" (`List []));
                   ("unitCursors", stated "unitCursors" (`Assoc []));
                   ("retryCount", J.member "retryCount" metadata);
                   ("maxRetries", J.member "maxRetries" metadata);
                 ])
          with
          | exception J.Type_error _ -> refused ()
          | Error _ -> refused ()
          | Ok record ->
              Held
                {
                  http;
                  client_id;
                  trace;
                  record;
                  lock = Eio.Mutex.create ();
                  on_activity;
                  on_settled;
                  settled = Eio.Promise.create ();
                  phase = Claimed;
                  cancellation = State_value.make false;
                  durability = None;
                }))

let identity job =
  [
    ("resourceId", text (Identifiers.Resource_id.to_string (resource_id job)));
    ("jobId", text (id job));
    ("jobType", text (Enums.Job_type.to_string (job_type job)));
  ]

(* The members [to_json] writes of a record, which is an object. *)
let members = function
  | `Assoc members -> members
  | _ -> invalid_arg "a record is written as an object"

let send job channel fields =
  ignore
    (Http_wire.emit job.http ~client_id:job.client_id ?trace:job.trace channel
       (Yojson.Safe.to_string (`Assoc fields)));
  job.on_activity ()

let lifecycle job channel fields =
  send job channel ((("attempt", `Int (attempt job)) :: identity job) @ fields)

let locked job f = Eio.Mutex.use_rw ~protect:false job.lock f

let start job =
  locked job (fun () ->
      if job.phase = Claimed then (
        lifecycle job B.Channels.job_start [];
        job.phase <- Started))

let running job f = locked job (fun () -> if job.phase <> Settled then f ())

let progress job ~percentage ~message =
  running job (fun () ->
      let percentage = `Int percentage in
      let detail =
        ("percentage", percentage)
        :: Option.to_list (Option.map (fun value -> ("message", value)) message)
      in
      lifecycle job B.Channels.job_report_progress
        [ ("percentage", percentage); ("progress", `Assoc detail) ])

let checkpoint job reached =
  running job (fun () ->
      send job B.Channels.job_checkpoint
        (("jobId", text (id job))
        :: members (Records.Job_checkpoint.to_json reached)))

let commit job subscription ~correlation_id
    ?(timeout_ms = Client_timing.mark_commit_timeout_ms) ~resource ~annotations
    () =
  let request operation fields =
    let correlation_id = correlation_id () in
    let send () =
      ignore
        (Http_wire.emit job.http ~client_id:job.client_id ~correlation_id
           ?trace:job.trace (B.request operation)
           (Yojson.Safe.to_string (`Assoc fields)))
    in
    Subscription.request subscription ~timeout_ms ~correlation_id operation
      ~send
  in
  let record rank evidence =
    match job.durability with
    | Some (prior, _) when prior >= rank -> ()
    | _ -> job.durability <- Some (rank, evidence)
  in
  locked job (fun () ->
      if job.phase = Settled then Error Error_codes.Bus_request.Closed
      else
        match List.rev annotations with
        | [] -> Ok ()
        | last :: _ -> (
            let resource =
              ("resourceId", text (Identifiers.Resource_id.to_string resource))
            in
            match
              request B.Operations.mark_commit
                [
                  resource;
                  ("jobId", text (id job));
                  ("annotations", `List annotations);
                ]
            with
            | Ok (Subscription.Result _) ->
                record 0 Enums.Durability_evidence.Acknowledged;
                Ok ()
            | Ok (Subscription.Failure payload) ->
                Error (Http_wire.bus_failure payload)
            | Error Subscription.Timeout ->
                let evidence =
                  try
                    match
                      request B.Operations.browse_annotation_requested
                        [ resource; ("annotationId", J.member "id" last) ]
                    with
                    | Ok (Subscription.Result _) ->
                        (0, Enums.Durability_evidence.Probe_confirmed)
                    | Ok (Subscription.Failure _) ->
                        (1, Enums.Durability_evidence.Probe_refused)
                    | Error _ -> (2, Enums.Durability_evidence.Probe_unreachable)
                  with Http_wire.Failed _ ->
                    (2, Enums.Durability_evidence.Probe_unreachable)
                in
                let rank, label = evidence in
                record rank label;
                if rank = 0 then Ok ()
                else Error Error_codes.Bus_request.Timeout
            | Error _ -> Error Error_codes.Bus_request.Closed))

let durability job =
  Option.to_list
    (Option.map
       (fun (_, evidence) ->
         ("durability", text (Enums.Durability_evidence.to_string evidence)))
       job.durability)

let settle job ~completed send =
  locked job (fun () ->
      if job.phase <> Settled then (
        send ();
        job.phase <- Settled;
        Eio.Promise.resolve (snd job.settled) ();
        job.on_settled completed))

let complete job result =
  settle job ~completed:true (fun () ->
      lifecycle job B.Channels.job_complete
        (("result", result) :: durability job))

let cancel ?reached job =
  settle job ~completed:false (fun () ->
      send job B.Channels.job_cancel
        (identity job
        @ Option.fold ~none:[]
            ~some:(fun reached -> members (Records.Job_reached.to_json reached))
            reached))

let will_retry_after ~retry_count ~max_retries failure_class =
  retry_count < max_retries
  &&
  match failure_class with
  | Some (Enums.Failure_class.Deterministic | Enums.Failure_class.Withheld) ->
      false
  | _ -> true

let fail ?failure job ~error =
  let will_retry =
    will_retry_after ~retry_count:(retry_count job)
      ~max_retries:(max_retries job)
      (Option.bind failure (fun (failure : Records.Job_failure.t) ->
           failure.failure_class))
  in
  let fields =
    [ ("error", text error); ("willRetry", `Bool will_retry) ]
    @ Option.fold ~none:[]
        ~some:(fun failure -> members (Records.Job_failure.to_json failure))
        failure
  in
  settle job ~completed:false (fun () ->
      lifecycle job B.Channels.job_fail (fields @ durability job))

let default_stall_ms = Client_timing.held_job_stall_ms
let default_stall_check_ms = Client_timing.held_job_stall_check_ms
let await_settled job = Eio.Promise.await (fst job.settled)
let is_settled job = job.phase = Settled

let annotation_id job =
  match
    J.member "annotationId"
      (Yojson.Safe.from_string (Models.encode (params job)))
  with
  | `String value ->
      Result.to_option (Identifiers.Annotation_id.of_string value)
  | _ -> None

let cancelled job = State_value.get (fst job.cancellation)
let notify_cancelled job = State_value.set (snd job.cancellation) true
let settled = is_settled

let complete_for verb job result =
  if job_type job <> verb then invalid_arg "result belongs to another job verb";
  complete job (Yojson.Safe.from_string (Models.encode result))

module Mark = struct
  let complete job result = complete_for Enums.Job_type.Mark job result
end

module Yield = struct
  let complete job result = complete_for Enums.Job_type.Yield job result
end
