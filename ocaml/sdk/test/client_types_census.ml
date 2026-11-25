(* SearchState and JobEvent, written by hand, held to their schemas in
   protocol/specs/src/client/types, and Claims.vitals to WorkerEngineHealth: a
   member or a branch either side gains or loses fails. A record literal names every field and a match every
   constructor, so either gaining one does not compile until it is named
   here. *)

open Xynolog
module J = Yojson.Safe.Util

let properties schema =
  List.sort compare (List.map fst (J.to_assoc (J.member "properties" schema)))

let schema = function
  | "SearchState" -> Protocol_cases.Client_types_search_state_schema.schema
  | "JobEvent" -> Protocol_cases.Client_types_job_event_schema.schema
  | name -> failwith ("no client type " ^ name ^ " is written for these tests")

let search_state () =
  let ({ results = _; is_searching = _ } : State_units.Search.search_state) =
    { results = []; is_searching = false }
  in
  Alcotest.(check (list string))
    "members"
    (properties (schema "SearchState"))
    (List.sort compare [ "results"; "isSearching" ])

(* The kind each report is the event of: an attempt that failed is one the
   queue tries again. *)
let kind : Delegation.report_kind -> string = function
  | Created -> "created"
  | Progress -> "progress"
  | Retrying -> "failed"
  | Refused -> "refused"
  | Complete -> "complete"

let job_event () =
  let branches = J.to_list (J.member "oneOf" (schema "JobEvent")) in
  List.iter
    (fun branch ->
      Alcotest.(check (list string))
        "a branch is its kind and its data" [ "data"; "kind" ]
        (properties branch))
    branches;
  Alcotest.(check (list string))
    "kinds"
    (List.sort compare
       (List.map
          (fun branch ->
            J.to_string
              (List.hd
                 (J.to_list
                    (J.member "enum"
                       (J.member "kind" (J.member "properties" branch))))))
          branches))
    (List.sort compare
       (List.map kind [ Created; Progress; Retrying; Refused; Complete ]))

(* Claims.vitals is what a worker's claims say of themselves: each member of
   WorkerEngineHealth but the engine and the jobs, which the worker states. A
   record literal of each names every field, so a member either side gains
   does not compile until it is named here. *)
let vitals () =
  let ({
         last_queued_event_at;
         last_claim_at;
         last_finished_at;
         last_activity_at;
         active_job = _;
         jobs_completed;
       }
        : Claims.vitals) =
    {
      last_queued_event_at = Some 0.;
      last_claim_at = Some 0.;
      last_finished_at = Some 0.;
      last_activity_at = Some 0.;
      active_job = None;
      jobs_completed = 0;
    }
  in
  let stamp = Option.map (fun _ -> "2026-01-01T00:00:00Z") in
  let health : Records.Worker_engine_health.t =
    {
      engine =
        Records.Engine.of_model
          (Result.get_ok
             (Models.decode Models.engine {|{"provider":"ollama","model":"m"}|}));
      jobs = [ YieldJobFilter { job_type = Yield; extra = [] } ];
      last_queued_event_at = stamp last_queued_event_at;
      last_claim_at = stamp last_claim_at;
      last_finished_at = stamp last_finished_at;
      last_activity_at = stamp last_activity_at;
      active_job = None;
      jobs_completed;
      extra = [];
    }
  in
  match Records.Worker_engine_health.to_model health with
  | Ok _ -> ()
  | Error (Models.Invalid_json message) -> Alcotest.fail message
  | Error (Invalid_payload { member; _ }) ->
      Alcotest.fail ("WorkerEngineHealth refuses the member " ^ member)

let () =
  Alcotest.run "client_types_census"
    [
      ( "census",
        [
          Alcotest.test_case "SearchState" `Quick search_state;
          Alcotest.test_case "JobEvent" `Quick job_event;
          Alcotest.test_case "WorkerEngineHealth" `Quick vitals;
        ] );
    ]
