open Eio.Std
open Xynolog
module U = State_units
module V = State_value
module B = Bus_registry
module J = Yojson.Safe.Util

let field = J.member
let string key row = J.to_string (field key row)
let text value = `String value
let option read = function `Null -> None | value -> Some (read value)
let nullable write = function None -> `Null | Some value -> write value

let id value =
  Result.get_ok (Identifiers.Annotation_id.of_string (J.to_string value))

let annotation value =
  nullable (fun id -> text (Identifiers.Annotation_id.to_string id)) value

let json = Yojson.Safe.to_string
let assoc fields = `Assoc fields

let rec normalize = function
  | `Assoc fields ->
      assoc
        (List.sort compare (List.map (fun (k, v) -> (k, normalize v)) fields))
  | `List values -> `List (List.map normalize values)
  | value -> value

let check expected actual =
  Alcotest.(check string)
    "state behavior"
    (json (normalize expected))
    (json (normalize actual))

let rec matches expected actual =
  match (expected, actual) with
  | `Assoc [ ("$has", `Assoc wanted) ], `Assoc fields ->
      List.for_all
        (fun (name, value) ->
          match List.assoc_opt name fields with
          | Some actual -> matches value actual
          | None -> false)
        wanted
  | `Assoc [ ("code", code) ], `Assoc fields
    when List.mem_assoc "message" fields ->
      List.assoc_opt "code" fields = Some code
  | `List a, `List b ->
      List.length a = List.length b && List.for_all2 matches a b
  | _ -> normalize expected = normalize actual

let rec substitute fixture = function
  | `Assoc [ ("$fixture", `String name) ] ->
      substitute fixture (field name fixture)
  | `Assoc fields ->
      assoc
        (List.map (fun (key, value) -> (key, substitute fixture value)) fields)
  | `List values -> `List (List.map (substitute fixture) values)
  | value -> value

module Units = Protocol_cases.Client_state_units
module Timing = Protocol_cases.Client_timing

(* A timing of client/timing.json that is a duration, in milliseconds. *)
let duration name =
  match
    (List.find
       (fun (entry : Timing.timing_item) -> entry.name = name)
       Timing.table.timing)
      .value
  with
  | Integer milliseconds -> milliseconds
  | Object _ -> failwith (name ^ " is no duration")

(* A time a case passes: milliseconds, or a timing scaled and extended. *)
let elapsed : Units.pass -> int = function
  | Integer milliseconds -> milliseconds
  | Object { timing; times; plus_ms } ->
      int_of_float
        ((float (duration timing) *. Option.value times ~default:1.)
        +. float (Option.value plus_ms ~default:0))

(* A time an invocation's arguments pass, which the model leaves as JSON. *)
let elapsed_json = function
  | `Int milliseconds -> milliseconds
  | value ->
      int_of_float
        (float (duration (string "timing" value))
         *. Option.value (J.to_number_option (field "times" value)) ~default:1.
        +. Option.value (J.to_number_option (field "plusMs" value)) ~default:0.
        )

(* Public units driven by the shared client/state-units.json cases. *)
let run_case ~fixture (row : Units.cases_item) =
  let sub = substitute fixture in
  Eio_main.run @@ fun env ->
  Switch.run @@ fun sw ->
  let mono = Eio_mock.Clock.Mono.make () in
  let clock =
    Clock.make ~monotonic:mono ~wall:(Eio.Stdenv.clock env)
      ~jitter:(Random.State.make [| 1 |])
  in
  let settle () =
    for _ = 1 to 40 do
      Fiber.yield ()
    done
  in
  let listen = Option.value row.listen ~default:[] in
  let heard = ref [] in
  let on_event = function
    | Ok (Wire_stream.Frame { route; payload = Ok payload; _ })
      when List.mem route.channel listen ->
        heard :=
          ( route.channel,
            route.correlation_id,
            Yojson.Safe.from_string (B.encode payload) )
          :: !heard
    | _ -> ()
  in
  let read, write = Eio.Process.pipe ~sw (Eio.Stdenv.process_mgr env) in
  let sent = ref [] in
  let send_frame ?correlation_id channel payload =
    let fields =
      [ ("channel", text channel); ("payload", payload) ]
      @ Option.to_list
          (Option.map (fun id -> ("correlationId", text id)) correlation_id)
    in
    Eio.Flow.copy_string
      ("event: bus-event\ndata: " ^ json (assoc fields) ^ "\n\n")
      write
  in
  let transport = row.transport in
  let replies = Hashtbl.create 4 in
  List.iter
    (fun (name, values) -> Hashtbl.replace replies name (List.map sub values))
    (Option.value transport.replies ~default:[]);
  let enqueue name response =
    let values = Option.value (Hashtbl.find_opt replies name) ~default:[] in
    Hashtbl.replace replies name (values @ [ response ])
  in
  let automatic request =
    let name = string "channel" request in
    let explicit =
      match Hashtbl.find_opt replies name with
      | Some (response :: rest) ->
          Hashtbl.replace replies name rest;
          Some response
      | _ -> None
    in
    let response =
      match (explicit, transport.answers, name) with
      | Some response, _, _ -> Some response
      | None, Jobs, "job:create" -> Some (assoc [ ("jobId", text "job-1") ])
      | None, Jobs, "job:status-requested" ->
          Some
            (assoc
               [
                 ("jobId", text "job-1");
                 ("status", text "running");
                 ("type", text row.unit);
                 ("userId", text "did:web:example.org:users:alice");
                 ("created", text "2026-10-01T00:00:00.000Z");
               ])
      | _ -> None
    in
    let operation =
      List.find_opt
        (fun (B.Operation operation) -> B.name (B.request operation) = name)
        B.operations
    in
    match (operation, response) with
    | Some (B.Operation operation), Some response -> (
        let correlation_id = string "correlationId" request in
        let reply = B.name (B.result operation) in
        let deliver () =
          send_frame ~correlation_id reply (assoc [ ("response", response) ])
        in
        match transport.delay_ms with
        | Some delay ->
            let deadline =
              Option.get
                (Mtime.add_span
                   (Clock.monotonic_now clock)
                   Mtime.Span.(delay * ms))
            in
            Fiber.fork_daemon ~sw (fun () ->
                Clock.sleep_until clock deadline;
                deliver ();
                `Stop_daemon)
        | None -> deliver ())
    | Some (B.Operation operation), None
      when transport.answers = Refuses
           || (name = "mark:create-request" && transport.answers = Jobs) ->
        send_frame
          ~correlation_id:(string "correlationId" request)
          (B.name (B.failure operation))
          (assoc [ ("message", text "refused") ])
    | _ -> ()
  in
  let call ~sw:_ ~meth:_ ~path ~headers:_ ~body ~progress:_ =
    match path with
    | "/bus/subscribe" -> (200, [], (read :> Eio.Flow.source_ty Eio.Resource.t))
    | "/bus/emit" ->
        let request = Yojson.Safe.from_string body in
        sent := !sent @ [ request ];
        automatic request;
        (202, [], Eio.Flow.string_source "{}")
    | _ -> failwith "unexpected HTTP request in state unit case"
  in
  let on_channel name =
    List.filter (fun row -> string "channel" row = name) !sent
  in
  let correlation channel nth =
    string "correlationId" (List.nth (on_channel channel) nth)
  in
  let session =
    Session.start ~sw ~clock ~initial_token:(Some "state-token")
      ~renew:(fun ~holding:_ -> Session.Refused)
      ()
  in
  let serial = ref 0 in
  let client =
    Client.connect ~sw ~clock ~session ~client_id:"state-test"
      ~key:(fun () ->
        incr serial;
        "state-" ^ string_of_int !serial)
      ~call ~global:Bus_registry.bridged_channels ~on_event ()
  in
  let local ?correlation_id channel payload =
    let (B.Channel channel) =
      List.find (fun (B.Channel value) -> B.name value = channel) B.channels
    in
    Client.publish client ?correlation_id channel
      (Result.get_ok (B.decode channel (json payload)))
  in
  let searched = ref [] and answers = ref [] in
  let lookup query receive =
    let active = ref true in
    searched := !searched @ [ query ];
    answers := !answers @ [ (fun value -> if !active then receive value) ];
    fun () -> active := false
  in
  let ended = Hashtbl.create 8 in
  let watch unit_name name state encode =
    let _release =
      V.observe state ~on_value:ignore ~on_close:(fun () ->
          Hashtbl.replace ended (unit_name, name) ())
    in
    (name, fun () -> encode (V.get state))
  in
  let make unit_name (made : Units.made_value) =
    let watch name state encode = watch unit_name name state encode in
    let resource_id () =
      Result.get_ok
        (Identifiers.Resource_id.of_string (Option.get made.resource_id))
    in
    match row.unit with
    | "mark" ->
        let module M = U.Mark in
        let unit = M.make client ~resource:(resource_id ()) in
        let invoke name args =
          match name with
          | "cancelPending" -> M.cancel_pending unit
          | "dismissProgress" -> M.dismiss_progress unit
          | "requestDelegate" ->
              M.request_delegate unit
                (Result.get_ok
                   (Models.decode Models.mark_job_params
                      (json (field "params" args))))
          | _ -> assert false
        in
        let failure (value : Delegation.failure) =
          assoc
            ([ ("code", text (Delegation.failure_code value.code)) ]
            @ Option.to_list
                (Option.map
                   (fun message -> ("message", text message))
                   value.message))
        in
        ( (fun () -> M.dispose unit),
          invoke,
          [
            watch "pendingAnnotation"
              (M.pending_annotation unit)
              (nullable (fun (pending : Records.Pending_annotation.t) ->
                   let json value =
                     Yojson.Safe.from_string (Models.encode value)
                   in
                   assoc
                     [
                       ("selector", json pending.selector);
                       ( "motivation",
                         `String (Enums.Motivation.to_string pending.motivation)
                       );
                     ]));
            watch "delegatingMotivation"
              (M.delegating_motivation unit)
              (nullable text);
            watch "progressMotivation"
              (M.progress_motivation unit)
              (nullable text);
            watch "progress" (M.progress unit) (nullable Fun.id);
            watch "failure" (M.failure unit) (nullable failure);
            watch "jobId" (M.job_id unit) (nullable text);
          ] )
    | "yield" ->
        let module Y = U.Yield in
        let unit = Y.make client ~locale:(Option.get made.locale) in
        let invoke name args =
          match name with
          | "dismissProgress" -> Y.dismiss_progress unit
          | "generate" ->
              Y.generate unit
                ?stall_ms:(option elapsed_json (field "stallDeadlineMs" args))
                (Result.get_ok
                   (Models.decode Models.generation_job_request
                      (json (field "params" args))))
          | _ -> assert false
        in
        let failure (value : Delegation.failure) =
          assoc
            ([ ("code", text (Delegation.failure_code value.code)) ]
            @ Option.to_list
                (Option.map
                   (fun message -> ("message", text message))
                   value.message))
        in
        ( (fun () -> Y.dispose unit),
          invoke,
          [
            watch "isGenerating" (Y.is_generating unit) (fun value ->
                `Bool value);
            watch "progress" (Y.progress unit) (nullable Fun.id);
            watch "outcome" (Y.outcome unit) (nullable Fun.id);
            watch "failure" (Y.failure unit) (nullable failure);
            watch "jobId" (Y.job_id unit) (nullable text);
          ] )
    | "match" ->
        let unit = U.Match.make client in
        ((fun () -> U.Match.dispose unit), (fun _ _ -> assert false), [])
    | "gather" ->
        let module G = U.Gather in
        let resource name value =
          Result.get_ok (Identifiers.Resource_id.of_string (string name value))
        in
        let unit = G.make client ~resource:(resource_id ()) in
        let invoke name args =
          match name with
          | "gatherAnnotation" ->
              let options =
                option
                  (fun stated ->
                    Records.Gather_annotation_options.of_model
                      (Result.get_ok
                         (Models.decode Models.gather_annotation_options
                            (json stated))))
                  (field "options" args)
              in
              G.gather_annotation unit
                ?context_window:
                  (Option.bind options (fun stated ->
                       stated.Records.Gather_annotation_options.context_window))
                ?include_source_context:
                  (Option.bind options (fun stated ->
                       stated.Records.Gather_annotation_options
                         .include_source_context))
                ?include_target_context:
                  (Option.bind options (fun stated ->
                       stated.Records.Gather_annotation_options
                         .include_target_context))
                (id (field "annotationId" args))
          | "gatherResource" ->
              G.gather_resource unit (resource "resourceId" args)
          | _ -> assert false
        in
        let identity value = value and bool value = `Bool value in
        ( (fun () -> G.dispose unit),
          invoke,
          [
            watch "context" (G.context unit) (nullable identity);
            watch "loading" (G.loading unit) bool;
            watch "error" (G.error unit) (nullable identity);
            watch "annotationId" (G.annotation_id unit) annotation;
            watch "resourceContext" (G.resource_context unit)
              (nullable identity);
            watch "resourceLoading" (G.resource_loading unit) bool;
            watch "resourceError" (G.resource_error unit) (nullable identity);
          ] )
    | "hoverDwell" ->
        let unit =
          U.Hover_dwell.make
            ~delay_ms:(elapsed (Option.get made.delay_ms))
            client
        in
        ( (fun () -> U.Hover_dwell.dispose unit),
          (fun name args ->
            match name with
            | "enter" ->
                U.Hover_dwell.enter unit (id (field "annotationId" args))
            | "leave" -> U.Hover_dwell.leave unit
            | _ -> assert false),
          [] )
    | "beckon" ->
        let unit = U.Beckon.make client ~resource:(resource_id ()) in
        ( (fun () -> U.Beckon.dispose unit),
          (fun name args ->
            assert (name = "focus");
            U.Beckon.focus unit (id (field "annotationId" args))),
          [
            watch "hoveredAnnotationId"
              (U.Beckon.hovered_annotation_id unit)
              annotation;
          ] )
    | "search" ->
        let unit =
          U.Search.make ?debounce_ms:made.debounce_ms
            ?initial_query:made.initial_query ~sw ~clock ~search:lookup ()
        in
        ( (fun () -> U.Search.dispose unit),
          (fun name args ->
            assert (name = "setQuery");
            U.Search.set_query unit (string "value" args)),
          [
            watch "query" (U.Search.query unit) text;
            watch "state" (U.Search.state unit) (fun state ->
                assoc
                  [
                    ("results", `List state.results);
                    ("isSearching", `Bool state.is_searching);
                  ]);
          ] )
    | "sessionSignals" ->
        let module N = U.Session_signals in
        let unit = N.make () in
        ( (fun () -> N.dispose unit),
          (fun name args ->
            match name with
            | "notifySessionEnded" ->
                N.notify_session_ended unit
                  ~reason:
                    (Option.get
                       (Enums.Session_end_reason.of_string
                          (string "reason" args)))
            | "notifyPermissionDenied" ->
                N.notify_permission_denied unit
                  ~detail:(option J.to_string (field "detail" args))
            | "notifyKbIdentityConflict" ->
                let row = field "conflict" args in
                N.notify_kb_identity_conflict unit
                  {
                    Records.Kb_identity_conflict.expected_did =
                      string "expectedDid" row;
                    observed_did = string "observedDid" row;
                  }
            | "acknowledgeSessionEnded" -> N.acknowledge_session_ended unit
            | "acknowledgePermissionDenied" ->
                N.acknowledge_permission_denied unit
            | "acknowledgeKbIdentityConflict" ->
                N.acknowledge_kb_identity_conflict unit
            | _ -> assert false),
          [
            watch "sessionEnded" (N.session_ended unit)
              (nullable (fun (value : Records.Session_ended.t) ->
                   assoc
                     [
                       ( "reason",
                         text (Enums.Session_end_reason.to_string value.reason)
                       );
                     ]));
            watch "permissionDenied" (N.permission_denied unit)
              (nullable (fun (value : Records.Permission_denied.t) ->
                   assoc [ ("detail", nullable text value.detail) ]));
            watch "kbIdentityConflict"
              (N.kb_identity_conflict unit)
              (nullable (fun (value : Records.Kb_identity_conflict.t) ->
                   assoc
                     [
                       ("expectedDid", text value.expected_did);
                       ("observedDid", text value.observed_did);
                     ]));
          ] )
    | _ -> assert false
  in
  let units = List.map (fun (name, made) -> (name, make name made)) row.made in
  let pass milliseconds =
    settle ();
    Eio_mock.Clock.Mono.set_time mono
      (Option.get
         (Mtime.add_span
            (Clock.monotonic_now clock)
            Mtime.Span.(milliseconds * ms)));
    settle ()
  in
  List.iter
    (fun (step : Units.steps_item) ->
      match step with
      | String -> settle ()
      | Invoke { invoke; of_; args } ->
          let _, run, _ = List.assoc of_ units in
          run invoke
            (`Assoc (List.map (fun (name, value) -> (name, sub value)) args))
      | Dispose { dispose } ->
          let dispose, _, _ = List.assoc dispose units in
          dispose ()
      | Pass { pass = time } -> pass (elapsed time)
      | Queue_reply { queue_reply; response } ->
          enqueue queue_reply (sub response)
      | Say { say; payload; _ } when String.starts_with ~prefix:"job:" say ->
          send_frame say (sub payload)
      | Say { say; correlation_id; payload } ->
          local ?correlation_id say (sub payload)
      | Deliver { deliver; payload; _ } ->
          settle ();
          send_frame deliver (sub payload);
          settle ()
      | Nothing_sent _ ->
          settle ();
          check (`List []) (`List !sent)
      | Sent_count { sent = channel; count } ->
          settle ();
          Alcotest.(check int)
            "sent count" count
            (List.length (on_channel channel))
      | Sent_payloads { sent = channel; payloads } ->
          settle ();
          let expected = `List (List.map sub payloads) in
          let actual =
            `List (List.map (field "payload") (on_channel channel))
          in
          if not (matches expected actual) then check expected actual
      | Answer { answer; nth; reply; payload } ->
          settle ();
          send_frame ~correlation_id:(correlation answer nth) reply
            (sub payload);
          settle ()
      | Expect { expect } ->
          List.iter
            (fun (unit_name, expected) ->
              let _, _, values = List.assoc unit_name units in
              List.iter
                (fun (name, value) ->
                  let value = sub value
                  and actual = (List.assoc name values) () in
                  if not (matches value actual) then check value actual)
                expected)
            expect
      | Heard { heard = expected } ->
          settle ();
          let actual = List.rev !heard in
          Alcotest.(check int)
            "heard" (List.length expected) (List.length actual);
          List.iter2
            (fun (expected : Units.heard_item)
                 (channel, correlation_id, payload) ->
              Alcotest.(check string) "heard channel" expected.channel channel;
              Alcotest.(check (option string))
                "heard correlation"
                (Option.map
                   (fun (id : Units.correlation_id) ->
                     match id with
                     | String id -> id
                     | Object { sent; nth } -> correlation sent nth)
                   expected.correlation_id)
                correlation_id;
              let expected = sub expected.payload in
              if not (matches expected payload) then check expected payload)
            expected actual;
          heard := []
      | Searched { searched = expected } ->
          settle ();
          Alcotest.(check (list string)) "searched" expected !searched
      | Answer_search { answer_search; results } ->
          (List.nth !answers answer_search) (Option.map (List.map text) results);
          settle ()
      | Ended { ended = expected } ->
          List.iter
            (fun (unit_name, names) ->
              List.iter
                (fun name -> assert (Hashtbl.mem ended (unit_name, name)))
                names)
            expected
      | Bus_destroyed { bus_destroyed } ->
          assert (
            Subscription.state (Client.subscription client)
            = Xynolog.Enums.Connection_state.Closed = bus_destroyed))
    row.steps;
  List.iter (fun (_, (dispose, _, _)) -> dispose ()) units;
  Client.close client;
  Session.close session

let () =
  let fixture = Units.fixtures_json Units.table.fixtures in
  Alcotest.run "OCaml state units"
    [
      ( "shared",
        List.map
          (fun (row : Units.cases_item) ->
            Alcotest.test_case row.case `Quick (fun () -> run_case ~fixture row))
          Units.table.cases );
    ]
