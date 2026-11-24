type route = {
  channel : string;
  correlation_id : string option;
  scope : Identifiers.Resource_id.t option;
}

type trace = { parent : string; state : string option }

type frame =
  | Frame : {
      id : string option;
      route : route;
      channel : 'a Bus_registry.channel;
      trace : trace option;
      payload : ('a Bus_registry.decoded, Bus_registry.decode_error) result;
    }
      -> frame

type refusal =
  | Invalid_frame of route option * Models.decode_error
  | Unknown_channel of route

let channels =
  List.to_seq Bus_registry.channels
  |> Seq.map (fun (Bus_registry.Channel channel as packed) ->
      (Bus_registry.name channel, packed))
  |> Hashtbl.of_seq

let string = function
  | `Stringlit literal -> (
      match Yojson.Safe.from_string literal with
      | `String value when value <> "" -> Some value
      | _ -> None)
  | _ -> None

let scope value =
  Option.bind (string value) (fun value ->
      Result.to_option (Identifiers.Resource_id.of_string value))

let recover_route source =
  match Strict_json.parse source with
  | Ok (`Assoc fields) -> (
      let get key read = Option.bind (List.assoc_opt key fields) read in
      let valid_scope =
        match List.assoc_opt Gateway_http.Bus_frame.scope fields with
        | None -> Some None
        | Some value -> Option.map Option.some (scope value)
      in
      match (get Gateway_http.Bus_frame.channel string, valid_scope) with
      | Some channel, Some scope ->
          Some
            {
              channel;
              scope;
              correlation_id = get Gateway_http.Bus_frame.correlation_id string;
            }
      | _ -> None)
  | _ -> None

let take_trace = function
  | `Assoc fields ->
      let trace =
        match List.assoc_opt Bus_registry.trace_field fields with
        | Some (`Assoc carrier) ->
            let get key = Option.bind (List.assoc_opt key carrier) string in
            Option.map
              (fun parent -> { parent; state = get "tracestate" })
              (get "traceparent")
        | _ -> None
      in
      ( `Assoc
          (List.filter (fun (key, _) -> key <> Bus_registry.trace_field) fields),
        trace )
  | raw -> (raw, None)

let decode id source =
  match Models.decode Models.bus_frame source with
  | Error fault -> Error (Invalid_frame (recover_route source, fault))
  | Ok model -> (
      let fields = Records.Bus_frame.of_model model in
      let route =
        {
          channel = fields.channel;
          correlation_id = fields.correlation_id;
          scope =
            Option.bind fields.scope (fun value ->
                Result.to_option (Identifiers.Resource_id.of_string value));
        }
      in
      match Hashtbl.find_opt channels route.channel with
      | None -> Error (Unknown_channel route)
      | Some (Bus_registry.Channel channel) ->
          let raw, trace = take_trace fields.payload in
          let payload =
            Bus_registry.decode_received channel (Yojson.Raw.to_string raw)
          in
          Ok (Frame { id; route; channel; trace; payload }))

let field line =
  match String.index_opt line ':' with
  | None -> (line, "")
  | Some index ->
      let first = index + 1 in
      let first =
        if first < String.length line && line.[first] = ' ' then first + 1
        else first
      in
      ( String.sub line 0 index,
        String.sub line first (String.length line - first) )

let read reader =
  let rec next event id data =
    match Eio.Buf_read.line reader with
    | exception End_of_file -> None
    | "" ->
        if event = Some Bus_registry.stream_event && data <> [] then
          Some (decode id (String.concat "\n" (List.rev data)))
        else next None None []
    | line -> (
        match field line with
        | "event", value -> next (Some value) id data
        | "id", value -> next event (Some value) data
        | "data", value -> next event id (value :: data)
        | _ -> next event id data)
  in
  next None None []

type emit_error =
  | Not_emittable
  | Invalid_payload of Bus_registry.decode_error
  | Invalid_envelope of Models.decode_error

let encode_emit ?scope ?client_id ?correlation_id channel source =
  if not (Bus_registry.emittable channel) then Error Not_emittable
  else
    match Bus_registry.decode channel source with
    | Error fault -> Error (Invalid_payload fault)
    | Ok payload -> (
        match
          Records.Bus_emit_request.to_model
            {
              channel = Bus_registry.name channel;
              payload = Bus_registry.json payload;
              scope = Option.map Identifiers.Resource_id.to_string scope;
              client_id;
              correlation_id;
              extra = [];
            }
        with
        | Ok model -> Ok (Models.encode model)
        | Error fault -> Error (Invalid_envelope fault))

type frame_refusal = {
  route : route option;
  member : string;
  reason : Enums.Frame_refusal_reason.t;
}

let normalized = function
  | Ok (Frame { route; payload = Error fault; _ }) ->
      let member, reason =
        match fault with
        | Bus_registry.Invalid_json _ ->
            ( Gateway_http.Bus_frame.payload,
              Enums.Frame_refusal_reason.Malformed )
        | Invalid_payload { member = ""; reason } ->
            (Gateway_http.Bus_frame.payload, reason)
        | Invalid_payload { member; reason } ->
            (Gateway_http.Bus_frame.payload ^ "." ^ member, reason)
      in
      Error { route = Some route; member; reason }
  | Ok frame -> Ok frame
  | Error (Invalid_frame (route, fault)) ->
      let { Refusals.member; reason } = Refusals.of_error fault in
      Error { route; member; reason }
  | Error (Unknown_channel route) ->
      Error
        {
          route = Some route;
          member = Gateway_http.Bus_frame.channel;
          reason = Malformed;
        }

let refusal_message (fault : frame_refusal) =
  let problem =
    Refusals.said { member = fault.member; reason = fault.reason }
  in
  match fault.route with
  | None -> "the stream carried what is not a frame: " ^ problem
  | Some route ->
      "a frame on " ^ route.channel ^ " is not that channel's: " ^ problem
