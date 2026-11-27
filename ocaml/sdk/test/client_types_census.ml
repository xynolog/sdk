(* SearchState, JobEvent and CacheState, written by hand, held to their
   schemas in protocol/specs/src/client/types: a member or a branch either
   side gains or loses fails. A record literal names every field and a match
   every constructor, so either gaining one does not compile until it is
   named here. *)

open Xynolog
module J = Yojson.Safe.Util

let properties schema =
  List.sort compare (List.map fst (J.to_assoc (J.member "properties" schema)))

let schema = function
  | "SearchState" -> Protocol_cases.Client_types_search_state_schema.schema
  | "JobEvent" -> Protocol_cases.Client_types_job_event_schema.schema
  | "CacheState" -> Protocol_cases.Client_types_cache_state_schema.schema
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

(* CacheState is a live query's state: its status, and what it holds. *)
let told : _ Live_query.cache_state -> string * string list = function
  | Pending -> ("pending", [ "status" ])
  | Ready _ -> ("ready", [ "status"; "value" ])
  | Failed _ -> ("failed", [ "error"; "status" ])

let cache_state () =
  let branches =
    List.map
      (fun branch ->
        ( J.to_string
            (List.hd
               (J.to_list
                  (J.member "enum"
                     (J.member "status" (J.member "properties" branch))))),
          properties branch ))
      (J.to_list (J.member "oneOf" (schema "CacheState")))
  in
  Alcotest.(check (list (pair string (list string))))
    "statuses, each with its members"
    (List.sort compare branches)
    (List.sort compare
       (List.map told
          [
            Pending;
            Ready ();
            Failed (Http_wire.Bus Error_codes.Bus_request.Closed);
          ]))

let () =
  Alcotest.run "client_types_census"
    [
      ( "census",
        [
          Alcotest.test_case "SearchState" `Quick search_state;
          Alcotest.test_case "JobEvent" `Quick job_event;
          Alcotest.test_case "CacheState" `Quick cache_state;
        ] );
    ]
