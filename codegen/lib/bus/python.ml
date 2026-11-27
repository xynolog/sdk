(* The Python SDK's bus vocabulary, in python/sdk/src/xynolog:

   channels.py    every channel, typed by its payload, and the field a relayed
                  frame's trace rides in
   operations.py  every request, with its two replies

   The payload classes are the OpenAPI schemas', in xynolog/types.py. A
   channel that carries a stored event names the type of the event's own
   payload too, from the entry's payload. *)

module R = Tables.Bus_registry
module P = Python_syntax

let header =
  Banner.python_lines ~from_:"protocol/specs/src/bus/registry.json" __FILE__

let is_lower_or_digit = function 'a' .. 'z' | '0' .. '9' -> true | _ -> false
let is_upper = function 'A' .. 'Z' -> true | _ -> false
let is_alnum c = is_lower_or_digit c || is_upper c

(* [emitRetry] is [EMIT_RETRY]; [mark:delegate-timeout] is
   [MARK_DELEGATE_TIMEOUT]. *)
let constant name =
  let out = Buffer.create (String.length name + 8) in
  String.iteri
    (fun i c ->
      if i > 0 && is_upper c && is_lower_or_digit name.[i - 1] then
        Buffer.add_char out '_';
      if is_alnum c then Buffer.add_char out (Char.uppercase_ascii c)
      else if i = 0 || is_alnum name.[i - 1] then Buffer.add_char out '_')
    name;
  Buffer.contents out

let type_of (carried : Registry.carried) =
  match carried with
  | Component schema -> P.Name schema
  | Response schema -> P.sub "Response" [ P.item (P.Name schema) ]
  | Nothing -> P.Name "Empty"

(* The schemas a channel's type names: for a stored event, the event's own
   payload's too. *)
let names (c : R.channels_item) =
  match (c, Registry.carried c) with
  | Stored_event { payload; _ }, Component event -> [ event; payload ]
  | _, (Component schema | Response schema) -> [ schema ]
  | _, Nothing -> []

let exported names =
  P.assign "__all__"
    ~value:
      (P.List (P.items ~magic:true (List.map (fun n -> P.item (P.Str n)) names)))

let final_tuple of_ =
  P.sub "Final"
    [ P.item (P.sub "tuple" [ P.item (P.Name of_); P.item P.Ellipsis ]) ]

let by_name ~about ~value_type names =
  P.assign ~about
    ~annotation:
      (P.sub "Final"
         [
           P.item
             (P.sub "Mapping"
                [ P.item (P.Name "str"); P.item (P.Name value_type) ]);
         ])
    ~value:
      (P.call "MappingProxyType"
         [
           P.item
             (P.Dict
                (P.items ~magic:true
                   (List.map
                      (fun name ->
                        P.entry (P.Str name) (P.Name (constant name)))
                      names)));
         ])

let channels (bus : Registry.t) =
  let reg = bus.registry in
  let scoped = reg.audience.scoped in
  let declaration (c : R.channels_item) =
    let type_ = type_of (Registry.carried c) in
    let name = P.item (P.Str (Registry.name c)) in
    let call =
      match c with
      | Stored_event { payload; _ } ->
          P.Call
            ( P.sub
                (if List.mem (Registry.name c) scoped then "ScopedChannel"
                 else "RecordedChannel")
                [ P.item type_; P.item (P.Name payload) ],
              P.items [ name; P.item type_; P.item (P.Name payload) ] )
      | _ ->
          P.Call
            (P.sub "Channel" [ P.item type_ ], P.items [ name; P.item type_ ])
    in
    P.assign
      (constant (Registry.name c))
      ~annotation:(P.Name "Final") ~value:call
  in
  let all_names =
    List.map (fun (c : R.channels_item) -> Registry.name c) reg.channels
  in
  let bridged =
    List.concat_map
      (fun (o : R.operations_item) -> [ o.result; o.failure ])
      reg.operations
    @ reg.audience.everyone
  in
  let listed ~about name channels =
    P.assign ~about name
      ~annotation:(final_tuple "ChannelName")
      ~value:(P.strings ~magic:true channels)
  in
  P.text
    {
      header;
      doc =
        As_is
          "Every channel of the bus, typed by the payload it carries.\n\n\
           A constant names its channel and holds its payload's type, so a \
           function that\n\
           takes a `Channel[P]` and a `P` is refused another channel's payload \
           by a type\n\
           checker. The payload types are the protocol's own \
           (`xynolog.types`); which\n\
           belongs to which channel is the registry's to say, and is derived \
           here from\n\
           each channel's shape.\n\n\
           A channel a resource's scope carries is a `ScopedChannel[P, E]`, by \
           the\n\
           registry's `audience`: it is read for a resource, and a type \
           checker refuses\n\
           a read of one that names none.\n\n\
           A channel that carries events of the record carries the stored \
           event, and\n\
           names the type `E` of the event's own payload too, by the registry's\n\
           `payload`: a `ScopedChannel[P, E]`, or a `RecordedChannel[P, E]` \
           where\n\
           the event concerns the whole knowledge base. \
           `MARK_ADDED.event(stored)` is\n\
           an `AnnotationAddedPayload`, and a stored event of another type is \
           refused.\n";
      imports =
        [
          [
            P.From ("collections.abc", [ "Mapping" ]);
            P.From ("types", [ "MappingProxyType" ]);
            P.From ("typing", [ "Final"; "Literal" ]);
          ];
          [
            From
              ( "xynolog.channel",
                [ "AnyChannel"; "Channel"; "RecordedChannel"; "ScopedChannel" ]
              );
            From ("xynolog.model", [ "Empty"; "Response" ]);
            From
              ( "xynolog.types",
                List.sort_uniq String.compare
                  (List.concat_map names reg.channels) );
          ];
        ];
      body =
        [
          exported
            ([
               "BRIDGED_CHANNELS";
               "CHANNELS";
               "CHANNEL_NAMES";
               "PERSISTED_EVENT_TYPES";
               "RESOURCE_SCOPED_CHANNELS";
               "TRACE_FIELD";
               "USER_FIELD";
             ]
            @ List.sort String.compare (List.map constant all_names)
            @ [ "ChannelName" ]);
          P.alias
            ~about:[ Line "Every channel's name." ]
            "ChannelName"
            (P.sub ~magic:true "Literal"
               (List.map (fun n -> P.item (P.Str n)) all_names));
          P.assign "CHANNEL_NAMES"
            ~annotation:(final_tuple "ChannelName")
            ~value:(P.strings ~magic:true all_names);
          P.Adjacent (List.map declaration reg.channels);
          by_name
            ~about:
              [
                Line
                  "Every channel, by its name: for code that is given a name \
                   and not a constant.";
              ]
            ~value_type:"AnyChannel" all_names "CHANNELS";
          listed
            ~about:
              (P.verbatim
                 "The channels a client hears with no scope held, unless it \
                  names a narrower list: every\n\
                  operation's result and failure, and the events sent to every \
                  client.")
            "BRIDGED_CHANNELS" bridged;
          listed
            ~about:
              [
                Line
                  "The channels a resource's scope carries: what holding a \
                   resource adds to a client's stream.";
              ]
            "RESOURCE_SCOPED_CHANNELS" scoped;
          listed
            ~about:
              (P.verbatim
                 "The channels of the events of the record, each named for the \
                  event it carries: every event the event log\n\
                  holds. A follower of the record receives each of them \
                  (protocol/contract/TRANSPORT-CONTRACT.md § What repairs\n\
                  a passing frame).")
            "PERSISTED_EVENT_TYPES"
            (List.filter_map
               (fun (c : R.channels_item) ->
                 if Registry.is_recorded c then Some (Registry.name c) else None)
               reg.channels);
          P.assign
            ~about:[ Prose reg.trace.meaning ]
            "TRACE_FIELD" ~annotation:(P.Name "Final")
            ~value:(P.Str reg.trace.field);
          P.assign ~about:[ Prose User_stamp.about ] "USER_FIELD"
            ~annotation:(P.Name "Final") ~value:(P.Str bus.user_field);
        ];
    }

let operations (bus : Registry.t) =
  let reg = bus.registry in
  let first, rest = bus.limits in
  let operation (o : R.operations_item) =
    let channel name = P.Name ("channels." ^ constant name) in
    P.assign (constant o.request) ~annotation:(P.Name "Final")
      ~value:
        (P.call ~magic:true "Operation"
           [
             P.keyword "request" (channel o.request);
             P.keyword "result" (channel o.result);
             P.keyword "failure" (channel o.failure);
           ])
  in
  let requests =
    List.map (fun (o : R.operations_item) -> o.request) reg.operations
  in
  P.text
    {
      header;
      doc =
        As_is
          "Every request of the bus, with the two channels it is answered on.\n\n\
           An operation is named for its request channel. Its type says what \
           is sent and\n\
           what a reply carries, so a request is refused another operation's \
           payload, and\n\
           its answer is typed, by a type checker.\n";
      imports =
        [
          [
            P.From ("collections.abc", [ "Mapping" ]);
            P.From ("types", [ "MappingProxyType" ]);
            P.From ("typing", [ "Final" ]);
          ];
          [
            P.From ("xynolog", [ "channels" ]);
            P.From ("xynolog.channel", [ "AnyOperation"; "Operation" ]);
          ];
        ];
      body =
        [
          exported
            ([ "LIMITS_OPERATIONS"; "OPERATIONS" ]
            @ List.sort String.compare (List.map constant requests));
          P.Adjacent (List.map operation reg.operations);
          by_name
            ~about:
              [
                Line
                  "Every operation, by the name of its request channel: for \
                   code that is given a name and not a constant.";
              ]
            ~value_type:"AnyOperation" requests "OPERATIONS";
          P.assign
            ~about:
              (P.verbatim
                 "The operations that report the limits of the models a \
                  service holds credentials for: one per\n\
                  such service, each named `<flow>:limits-requested`. A new \
                  key holder's joins by being registered.")
            "LIMITS_OPERATIONS" ~annotation:(P.Name "Final")
            ~value:
              (P.tuple ~magic:true
                 (List.map
                    (fun (o : R.operations_item) ->
                      P.item (P.Name (constant o.request)))
                    (first :: rest)));
        ];
    }

(* Two channels whose Python constants are one would be one constant. *)
let collisions (bus : Registry.t) =
  let seen = Hashtbl.create 256 in
  List.filter_map
    (fun (c : R.channels_item) ->
      let python = constant (Registry.name c) in
      match Hashtbl.find_opt seen python with
      | Some other ->
          Some
            {
              Decode.file = Registry.file;
              pointer = "/channels";
              message =
                Printf.sprintf "%S and %S would both be the Python constant %s"
                  other (Registry.name c) python;
            }
      | None ->
          Hashtbl.replace seen python (Registry.name c);
          None)
    bus.registry.channels

let files bus : (Output.file list, Decode.error list) result =
  match collisions bus with
  | _ :: _ as problems -> Error problems
  | [] ->
      let at name text =
        { Output.path = "python/sdk/src/xynolog/" ^ name; text }
      in
      Ok
        [ at "channels.py" (channels bus); at "operations.py" (operations bus) ]
