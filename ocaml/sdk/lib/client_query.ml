open Eio.Std
module B = Bus_registry
module J = Yojson.Safe.Util

let scoped_channels =
  List.filter (fun (B.Channel ch) -> B.audience ch = Some B.Scoped) B.channels

let limits_operations =
  List.filter
    (fun (B.Operation op) ->
      String.ends_with ~suffix:":limits-requested" (B.name (B.request op)))
    B.operations

let request ?(on_sent = ignore) bus http ~client_id ~key operation payload =
  let correlation_id = key () in
  let send () =
    ignore
      (Http_wire.emit http ~client_id ~correlation_id (B.request operation)
         (Yojson.Safe.to_string payload));
    on_sent ()
  in
  try
    match Subscription.request bus ~correlation_id operation ~send with
    | Ok (Subscription.Result response) ->
        Ok (J.member "response" (Yojson.Safe.from_string (B.encode response)))
    | Ok (Subscription.Failure failure) ->
        Error (Http_wire.Bus (Http_wire.bus_failure failure))
    | Error Subscription.Timeout ->
        Error (Http_wire.Bus Error_codes.Bus_request.Timeout)
    | Error Subscription.Transport_closed ->
        Error (Http_wire.Bus Error_codes.Bus_request.Closed)
    | Error Subscription.Unsubscribed ->
        Error (Http_wire.Bus Error_codes.Bus_request.Unsubscribed)
    | Error _ -> Error (Http_wire.Bus Error_codes.Bus_request.Rejected)
  with Http_wire.Failed failure -> Error (Http_wire.Transport failure.code)

let join_limits engines limits =
  let list = function `List values -> values | _ -> [] in
  let identity entry = J.member "engine" entry in
  let lookup engine =
    List.find_opt (fun limit -> identity limit = identity engine) limits
  in
  `List
    (List.map
       (fun engine ->
         match (engine, lookup engine) with
         | `Assoc fields, Some limit ->
             `Assoc (("limits", J.member "limits" limit) :: fields)
         | _ -> engine)
       (list engines))

let listing name =
  name = Live_facts.Query.resources || name = Live_facts.Query.matched_resources

let make ?window_ms ?restore ?save ~sw ~clock ~bus ~http ~client_id ~key () =
  let load (name, resource, argument) =
    match List.assoc_opt name Live_query.operations with
    | None when name = Live_facts.Query.annotations -> (
        match
          Option.bind resource (fun id ->
              Result.to_option (Identifiers.Resource_id.of_string id))
        with
        | None -> Error (Http_wire.Transport Error_codes.Transport.Bad_request)
        | Some id -> (
            try
              Ok
                (J.member "annotations"
                   (Yojson.Safe.from_string (Http_wire.annotations http id)))
            with Http_wire.Failed failure ->
              Error (Http_wire.Transport failure.code)))
    | None -> Error (Http_wire.Transport Error_codes.Transport.Bad_request)
    | Some (B.Operation operation) ->
        let field name = Option.map (fun value -> (name, `String value)) in
        let payload =
          match argument with
          | Some encoded when listing name -> Yojson.Safe.from_string encoded
          | _ ->
              `Assoc
                (List.filter_map Fun.id
                   [
                     field "resourceId" resource; field "annotationId" argument;
                   ])
        in
        let read ?on_sent () =
          request ?on_sent bus http ~client_id ~key operation payload
        in
        if name = Live_facts.Query.engines then (
          let answer =
            ref (Error (Http_wire.Bus Error_codes.Bus_request.Closed))
          in
          let limits = ref [] in
          let sent, mark_sent = Promise.create () in
          let ready () =
            if not (Promise.is_resolved sent) then Promise.resolve mark_sent ()
          in
          Fiber.both
            (fun () ->
              Fun.protect ~finally:ready (fun () ->
                  answer := read ~on_sent:ready ()))
            (fun () ->
              Promise.await sent;
              Fiber.all
                (List.map
                   (fun (B.Operation op) () ->
                     match request bus http ~client_id ~key op (`Assoc []) with
                     | Ok response -> (
                         match J.member "limits" response with
                         | `List values -> limits := values @ !limits
                         | _ -> ())
                     | Error _ -> ())
                   limits_operations));
          Result.map
            (fun json -> join_limits (J.member "engines" json) !limits)
            !answer)
        else
          Result.map
            (fun json -> if listing name then json else J.member name json)
            (read ())
  in
  let hold (_, id, _) =
    match
      Option.bind id (fun id ->
          Result.to_option (Identifiers.Resource_id.of_string id))
    with
    | None -> Fun.id
    | Some resource ->
        Subscription.hold_scope bus { resource; channels = scoped_channels }
  in
  Live_query.make ?window_ms ?restore ?save ~sw ~clock ~load ~hold ()

let on_frame cache = function
  | Ok (Wire_stream.Frame { route; payload; _ }) ->
      let payload =
        Result.to_option payload
        |> Option.map (fun value -> Yojson.Safe.from_string (B.encode value))
      in
      Live_query.refetch cache ~on:route.channel ~payload
  | Error (Wire_stream.Invalid_frame (Some route, _)) ->
      Live_query.refetch cache ~on:route.channel ~payload:None
  | _ -> ()
