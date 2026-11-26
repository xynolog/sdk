open Eio.Std
open Xynolog
module C = Client
module B = Bus_registry
module J = Yojson.Safe.Util

let field = J.member
let string name value = J.to_string (field name value)
let text value = `String value
let json = Yojson.Safe.to_string

let fields = function
  | `Assoc fields -> fields
  | `Null -> []
  | _ -> invalid_arg "object expected"

let get = function
  | Ok value -> value
  | Error _ -> failwith "invalid test input"

let member name fields = List.assoc_opt name fields
let option_text name value = Option.map J.to_string (member name (fields value))
let decode = Surface_dispatch.decode

let rec resolve fixtures = function
  | `Assoc [ ("$fixture", `String name) ] -> field name fixtures
  | `Assoc fields ->
      `Assoc
        (List.map (fun (key, value) -> (key, resolve fixtures value)) fields)
  | `List values -> `List (List.map (resolve fixtures) values)
  | value -> value

let rec normalize = function
  | `Assoc fields ->
      `Assoc
        (List.sort compare
           (List.map (fun (key, value) -> (key, normalize value)) fields))
  | `List values -> `List (List.map normalize values)
  | value -> value

let check label expected actual =
  Alcotest.(check string)
    label
    (json (normalize expected))
    (json (normalize actual))

let defaults value base =
  let actual = fields value in
  `Assoc
    (actual
    @ List.filter (fun (name, _) -> not (List.mem_assoc name actual)) base)

let filters args = fields (field "filters" args)

let args_payload name args =
  match name with
  | "frame.addEntityType" -> `Assoc [ ("tag", field "type" args) ]
  | "browse.files" ->
      `Assoc
        [
          ( "path",
            Option.value (member "dirPath" (fields args)) ~default:(text ".") );
          ( "sort",
            Option.value (member "sort" (fields args)) ~default:(text "name") );
        ]
  | "mark.annotation" ->
      let input = field "input" args in
      `Assoc
        [
          ("resourceId", field "source" (field "target" input));
          ("request", input);
        ]
  | "mark.updateEntityTypes" ->
      `Assoc
        [
          ("resourceId", field "resourceId" args);
          ("currentEntityTypes", field "current" args);
          ("updatedEntityTypes", field "updated" args);
        ]
  | "gather.resource" ->
      let options =
        `Assoc
          (List.filter
             (fun pair -> pair <> ("excludeEntityTypes", `List []))
             (fields (field "options" args)))
      in
      `Assoc
        (( "options",
           defaults options
             [
               ("depth", `Int 2);
               ("maxResources", `Int 10);
               ("includeContent", `Bool true);
               ("includeSummary", `Bool false);
             ] )
        :: List.remove_assoc "options" (fields args))
  | "match.search" ->
      let options = defaults (field "options" args) [ ("limit", `Int 10) ] in
      `Assoc (fields options @ List.remove_assoc "options" (fields args))
  | _ -> (
      match member "input" (fields args) with
      | Some input -> input
      | None -> args)

let await_open client =
  let bus = C.subscription client in
  let rec wait = function
    | Xynolog.Enums.Connection_state.Open -> ()
    | Xynolog.Enums.Connection_state.Closed ->
        failwith "test subscription closed"
    | previous -> wait (Subscription.await_state_change bus ~from:previous)
  in
  wait (Subscription.state bus)

type observation =
  | Bus of string * string option * Yojson.Safe.t
  | Http of string * string * string

module Surface = Protocol_cases.Client_surface

let resolved = resolve (Surface.fixtures_json Surface.table.fixtures)

(* Where a call is seen: on a channel of the bus, or as the HTTP request of
   the content or gateway operation it names. *)
type seen = On_bus of string | Over_http of string

let seen : Surface.item_via -> seen = function
  | Request { request = channel }
  | Emit { emit = channel }
  | Local { local = channel }
  | Observes { observes = channel } ->
      On_bus channel
  | Content { content = operation } | Gateway { gateway = operation } ->
      Over_http operation

let tests env ~name ~(via : Surface.item_via) ~(row : Surface.cases_item) =
  Switch.run @@ fun sw ->
  let stream = Eio.Stream.create 32 in
  let read, write = Eio.Process.pipe ~sw (Eio.Stdenv.process_mgr env) in
  let clock =
    Clock.make ~wall:(Eio.Stdenv.clock env)
      ~monotonic:(Eio.Stdenv.mono_clock env)
      ~jitter:(Random.State.make [| 1 |])
  in
  let serial = ref 0 in
  let key () =
    incr serial;
    Printf.sprintf "surface-%d" !serial
  in
  let session =
    Session.start ~sw ~clock ~initial_token:(Some "test-token")
      ~renew:(fun ~holding:_ -> Session.Refused)
      ()
  in
  let frame channel correlation payload =
    let body =
      `Assoc
        ([ ("channel", text channel); ("payload", payload) ]
        @ Option.to_list
            (Option.map (fun key -> ("correlationId", text key)) correlation))
    in
    Eio.Flow.copy_string ("event: bus-event\ndata: " ^ json body ^ "\n\n") write
  in
  let args = resolved row.args in
  let request =
    match via with Request { request } -> Some request | _ -> None
  in
  let observed =
    match via with Observes { observes } -> Some observes | _ -> None
  in
  let correlation = row.correlation_id in
  let sends = resolved row.sends in
  let remaining = ref (Option.to_list (Option.map resolved row.answers)) in
  let call ~sw:_ ~meth ~path ~headers:_ ~body ~progress =
    let response status body =
      (status, [ ("content-type", "text/plain") ], Eio.Flow.string_source body)
    in
    match path with
    | "/bus/subscribe" -> (200, [], (read :> Eio.Flow.source_ty Eio.Resource.t))
    | "/bus/emit" ->
        let envelope = Yojson.Safe.from_string body in
        let channel = string "channel" envelope in
        let key = option_text "correlationId" envelope in
        Eio.Stream.add stream (Bus (channel, key, field "payload" envelope));
        (match (!remaining, request) with
        | answer :: rest, Some requested when channel = requested ->
            remaining := rest;
            let operation =
              List.find
                (fun (B.Operation operation) ->
                  B.name (B.request operation) = channel)
                B.operations
            in
            let (B.Operation operation) = operation in
            let reply = B.result operation in
            let answer =
              match B.payload reply with
              | B.Empty | B.Void -> `Assoc []
              | _ -> `Assoc [ ("response", answer) ]
            in
            frame (B.name reply) key answer
        | _ -> ());
        response 202 {|{"subscribers":3}|}
    | _ ->
        Eio.Stream.add stream (Http (meth, path, body));
        Option.iter (fun report -> report (String.length body)) progress;
        if meth = "POST" && path = "/resources" then
          response 202 {|{"resourceId":"uploaded"}|}
        else response 200 {|{"annotations":[]}|}
  in
  let on_event = function
    | Ok (Wire_stream.Frame { route; payload = Ok payload; _ })
      when via = Local { local = route.channel } ->
        Eio.Stream.add stream
          (Bus
             ( route.channel,
               route.correlation_id,
               Yojson.Safe.from_string (B.encode payload) ))
    | _ -> ()
  in
  let client =
    C.connect ~sw ~clock ~session ~client_id:"surface" ~key ~call
      ~global:Bus_registry.bridged_channels ~on_event ()
  in
  let resource () =
    get (Identifiers.Resource_id.of_string (string "resourceId" args))
  in
  let annotation () =
    get (Identifiers.Annotation_id.of_string (string "annotationId" args))
  in
  let notify channel payload =
    Eio.Stream.add stream
      (Bus (B.name channel, None, Yojson.Safe.from_string (B.encode payload)))
  in
  let send_upload data =
    match Records.Put_binary_request.of_json data with
    | Ok request ->
        ignore
          (Upload.await (C.Yield.resource client request ~on_progress:ignore))
    | Error _ -> failwith "upload arguments are not a PutBinaryRequest"
  in
  let invoke () =
    match name with
    | "frame.addEntityTypes" ->
        let payloads =
          J.to_list (field "types" args)
          |> List.map (fun tag ->
              decode B.Channels.frame_add_entity_type (`Assoc [ ("tag", tag) ]))
        in
        ignore (C.Frame.add_entity_types client payloads)
    | "browse.resource" ->
        ignore (C.fresh (C.Browse.resource client (resource ())))
    | "browse.resources" ->
        ignore
          (C.fresh
             (C.Browse.resources client
                (decode B.Channels.browse_resources_requested
                   (`Assoc (filters args)))))
    | "browse.annotations" ->
        ignore (C.fresh (C.Browse.annotations client (resource ())))
    | "browse.annotation" ->
        ignore
          (C.fresh (C.Browse.annotation client (resource ()) (annotation ())))
    | "browse.entityTypes" -> ignore (C.fresh (C.Browse.entity_types client))
    | "browse.tagSchemas" -> ignore (C.fresh (C.Browse.tag_schemas client))
    | "browse.engines" -> ignore (C.fresh (C.Browse.engines client))
    | "browse.events" -> ignore (C.fresh (C.Browse.events client (resource ())))
    | "browse.resourceContent" ->
        ignore (C.Browse.resource_content client (resource ()))
    | "browse.resourceGraph" ->
        ignore (C.Browse.resource_graph client (resource ()))
    | "browse.resourceAnchoredText" ->
        ignore (C.Browse.resource_anchored_text client (resource ()))
    | "browse.resourceRepresentation" ->
        ignore (C.Browse.resource_representation client (resource ()))
    | "browse.resourceRepresentationStream" ->
        ignore
          (C.Browse.resource_representation_stream client (resource ())
             (fun ~content_type:_ _ -> ()))
    | "gather.annotation" ->
        ignore
          (Running.await
             (C.Gather.annotation client
                (decode B.Channels.gather_requested (args_payload name args))))
    | "gather.referencedBy" ->
        ignore (C.fresh (C.Gather.referenced_by client (resource ())))
    | "match.search" ->
        ignore
          (Running.await
             (C.Match.search client
                (decode B.Channels.match_search_requested
                   (args_payload name args))))
    | "match.resources" ->
        let payload =
          `Assoc (("search", field "search" args) :: filters args)
        in
        ignore
          (C.fresh
             (C.Match.resources client
                (decode B.Channels.match_resources_requested payload)))
    | "yield.resource" -> send_upload (field "data" args)
    | "yield.createFromToken" ->
        let options = field "options" args in
        ignore
          (C.Yield.create_from_token client ~token:(string "token" options)
             ~name:(string "name" options) ~content:(string "content" options)
             ())
    | "mark.delegate" | "yield.delegate" ->
        let descriptor = field "params" args |> json in
        let follower = C.delegation client in
        let on_report _ _ = () and on_failure _ = () and on_close () = () in
        let _release =
          if name = "mark.delegate" then
            C.Mark.delegate follower ~resource:(resource ())
              ~params:(get (Models.decode Models.mark_job_params descriptor))
              ~on_report ~on_failure ~on_close ()
          else
            C.Yield.delegate follower
              ~params:
                (get (Models.decode Models.generation_job_request descriptor))
              ~on_report ~on_failure ~on_close ()
        in
        ()
    | "job.queued" | "job.progress" | "job.complete" | "job.fail" ->
        let _release =
          match name with
          | "job.queued" -> C.Job.queued client (notify B.Channels.job_queued)
          | "job.progress" ->
              C.Job.progress client (notify B.Channels.job_report_progress)
          | "job.complete" ->
              C.Job.complete client (notify B.Channels.job_complete)
          | _ -> C.Job.fail client (notify B.Channels.job_fail)
        in
        await_open client;
        frame (Option.get observed) None sends
    | "job.pollUntilComplete" ->
        ignore
          (C.Job.poll_until_complete client ~within_ms:1000 ~on_status:ignore
             (decode B.Channels.job_status_requested args))
    | "job.claim" ->
        let filters =
          field "accepts" (field "options" args)
          |> J.to_list
          |> List.map (fun filter ->
              get (Models.decode Models.job_filter (json filter)))
        in
        ignore (Claims.next (C.Job.claim client filters))
    | "auth.me" -> ignore (C.Auth.me client)
    | "auth.mediaToken" -> ignore (C.Auth.media_token client (resource ()))
    | "auth.protectedResourceMetadata" ->
        ignore (C.Auth.protected_resource_metadata client)
    | "system.healthCheck" -> ignore (C.System.health_check client)
    | "system.status" -> ignore (C.System.status client)
    | name ->
        if
          not
            (Surface_dispatch.invoke client ~correlation_id:correlation name
               (args_payload name args))
        then failwith ("missing surface case dispatch for " ^ name)
  in
  let expect ~seen sends =
    let next () = Eio.Stream.take stream in
    match seen with
    | On_bus channel ->
        let matching () =
          match next () with
          | Bus (actual, key, payload) ->
              Alcotest.(check string) "channel" channel actual;
              Option.iter
                (fun key' ->
                  Alcotest.(check (option string))
                    "correlation id" (Some key') key)
                correlation;
              check "payload" sends payload
          | _ -> failwith "expected a bus operation"
        in
        matching ()
    | Over_http operation -> (
        let id = Option.value (option_text "resourceId" sends) ~default:"" in
        let expected =
          match operation with
          | "getAnnotations" -> ("GET", "/resources/" ^ id ^ "/annotations")
          | "getResourceGraph" -> ("GET", "/resources/" ^ id ^ "/jsonld")
          | "getAnchoredText" -> ("GET", "/resources/" ^ id ^ "/anchored-text")
          | "getBinary" | "getBinaryStream" -> ("GET", "/resources/" ^ id)
          | "putBinary" -> ("POST", "/resources")
          | "getCurrentUser" -> ("GET", "/api/users/me")
          | "getMediaToken" -> ("POST", "/api/tokens/media")
          | "getProtectedResourceMetadata" ->
              ("GET", "/.well-known/oauth-protected-resource")
          | "healthCheck" -> ("GET", "/api/health")
          | "getStatus" -> ("GET", "/api/status")
          | _ -> failwith "unknown HTTP surface operation"
        in
        match next () with
        | Http (meth, path, body) ->
            Alcotest.(check (pair string string))
              "HTTP request" expected (meth, path);
            if path = "/api/tokens/media" then
              check "HTTP payload" sends (Yojson.Safe.from_string body);
            if path = "/resources" then
              List.iter
                (fun (name, value) ->
                  let value = J.to_string value in
                  let substring =
                    if name = "content" then "\r\n\r\n" ^ value ^ "\r\n"
                    else "name=\"" ^ name ^ "\"\r\n\r\n" ^ value ^ "\r\n"
                  in
                  let rec contains i =
                    i + String.length substring <= String.length body
                    && (String.sub body i (String.length substring) = substring
                       || contains (i + 1))
                  in
                  if not (contains 0) then
                    Alcotest.fail ("missing multipart field " ^ name))
                (fields sends)
        | _ -> failwith "expected an HTTP request")
  in
  let expected () =
    expect ~seen:(seen via) sends;
    (if name = "browse.engines" then
       let limits =
         List.init 3 (fun _ ->
             match Eio.Stream.take stream with
             | Bus (channel, _, payload) ->
                 check "limits payload" (`Assoc []) payload;
                 channel
             | _ -> failwith "expected inference limits request")
         |> List.sort String.compare
       in
       Alcotest.(check (list string))
         "all limits follow metadata"
         [
           "gather:limits-requested";
           "job:limits-requested";
           "match:limits-requested";
         ]
         limits);

    List.iter
      (fun (step : Surface.then_item) ->
        match step with
        | Request { request; sends } ->
            expect ~seen:(On_bus request) (resolved sends)
        | Content { content; sends } ->
            expect ~seen:(Over_http content) (resolved sends))
      (Option.value row.then_ ~default:[])
  in
  let deadline = Eio.Stdenv.clock env in
  Eio.Time.with_timeout_exn deadline 2.0 (fun () ->
      let pending, _ = Promise.create () in
      Fiber.first
        (fun () ->
          invoke ();
          Promise.await pending)
        expected);
  C.close client;
  Session.close session

let () =
  let suites =
    List.map
      (fun (namespace : Surface.namespaces_item) ->
        let prefix = namespace.namespace in
        ( prefix,
          List.concat_map
            (fun (method_ : Surface.methods_item) ->
              let name = prefix ^ "." ^ method_.method_ in
              List.mapi
                (fun index row ->
                  Alcotest.test_case
                    (Printf.sprintf "%s %d" name (index + 1))
                    `Quick
                    (fun () ->
                      Eio_main.run (fun env ->
                          tests env ~name ~via:method_.via ~row)))
                method_.cases)
            namespace.methods ))
      Surface.table.namespaces
  in
  Alcotest.run "OCaml client surface" suites
