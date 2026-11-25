(* The bus as the Rust SDK reads it: the operations and what their replies
   state (rust/sdk/src/bus.rs), and the channels (rust/sdk/src/channels.rs):
   which a client hears globally and which a resource's scope carries, the
   trace's field, a type per channel naming its payload's, each operation's
   request tied to its replies, and what each channel's payload must be. *)

module R = Rust_syntax
module Reg = Tables.Bus_registry

let operations_path = "rust/sdk/src/generated/operations.rs"
let channels_path = "rust/sdk/src/generated/channels.rs"
let header = Banner.lines ~from_:"protocol/specs/src/bus/registry.json"
let strings names = R.Ref_of (R.Array (List.map (fun n -> R.Str n) names))
let str_slice = R.Ref (None, R.Slice R.str_ty)
let static_strs = R.Ref (Some "'static", R.Slice R.static_str)

(* A channel's marker type, which names it in channels.rs. *)
let marker channel = Text.pascal channel

let constant ?(doc = []) name ty value =
  R.Const { doc; attrs = []; vis = Pub; name; ty; value }

let operations (bus : Registry.t) =
  let reg = bus.registry in
  {
    Output.path = operations_path;
    text =
      R.text ~header:(header __FILE__)
        [
          constant "OPERATIONS"
            (R.Ref (None, R.Slice (R.named "Operation")))
            (R.Ref_of
               (R.Array
                  (List.map
                     (fun (o : Reg.operations_item) ->
                       R.Struct
                         ( [ "Operation" ],
                           [
                             ("request", R.Str o.request);
                             ("result", R.Str o.result);
                             ("failure", R.Str o.failure);
                           ],
                           None ))
                     reg.operations)));
          constant
            ~doc:
              [
                "What an operation's reply states beside its `response`, by \
                 the request's channel: each a\n\
                 property of the request, which the reply states again. An \
                 operation that is not here states\n\
                 nothing beside it.";
              ]
            "REPLY_NAMES"
            (R.Ref (None, R.Slice (R.Tuple_of [ R.str_ty; str_slice ])))
            (R.Ref_of
               (R.Array
                  (List.filter_map
                     (fun (request, names) ->
                       if names = [] then None
                       else Some (R.Tuple [ R.Str request; strings names ]))
                     bus.reply_names)));
          constant
            ~doc:
              [
                "The operations that report the limits of the engines a \
                 service holds a client for.";
              ]
            "LIMITS_OPERATIONS" str_slice
            (strings
               (List.map
                  (fun (o : Reg.operations_item) -> o.request)
                  (fst bus.limits :: snd bus.limits)));
        ];
  }

(* A channel's type, its payload's type, and what its payload must be, by
   the channel's shape. *)
let reference name =
  R.Struct
    ( [ "Shape" ],
      [ ("reference", R.call "Some" [ R.Str name ]) ],
      Some (R.p "NONE") )

let object_kind = R.call "Some" [ R.Ref_of (R.Array [ R.p "Kind::Object" ]) ]

let carried (c : Reg.channels_item) =
  let component name = R.Named ([ "crate"; "types"; name ], []) in
  match c with
  | Schema { schema; _ } -> (component schema, reference schema)
  | Envelope { schema; _ } ->
      ( R.Named ([ "Response" ], [ component schema ]),
        R.Struct
          ( [ "Shape" ],
            [
              ("kinds", object_kind);
              ("required", strings [ "response" ]);
              ( "members",
                R.Ref_of
                  (R.Array [ R.Tuple [ R.Str "response"; reference schema ] ])
              );
            ],
            Some (R.p "NONE") ) )
  | Stored_event { enriched; _ } ->
      let name =
        Registry.stored_event_component ~enriched:(enriched = Some true)
      in
      (component name, reference name)
  | Void _ | Empty _ ->
      ( R.named "Empty",
        R.Struct ([ "Shape" ], [ ("kinds", object_kind) ], Some (R.p "NONE")) )

let channel_items (bus : Registry.t) component (c : Reg.channels_item) =
  let marker = marker (Registry.name c) in
  let payload, _ = carried c in
  let stamps =
    match c with
    | Schema { schema; _ } ->
        List.sort_uniq String.compare
          (Registry.stamps ~ids:bus.ids component ~of_:schema
             (Registry.named component schema))
    | _ -> []
  in
  let delivered =
    if List.mem (Registry.name c) bus.registry.audience.scoped then "Scoped"
    else "Unscoped"
  in
  [
    R.Unit_struct
      {
        attrs = [];
        doc = [ "`" ^ Registry.name c ^ "`" ];
        vis = Pub;
        name = marker;
      };
    R.Impl
      {
        generics = [];
        trait_ = Some (R.named "Channel");
        for_ = R.named marker;
        items =
          [
            R.I_const
              {
                doc = [];
                vis = Private;
                name = "NAME";
                ty = R.static_str;
                value = Some (R.Str (Registry.name c));
              };
            R.I_const
              {
                doc = [];
                vis = Private;
                name = "STAMPS";
                ty = static_strs;
                value = Some (strings stamps);
              };
            R.I_type ("Payload", payload);
          ];
      };
    R.Impl
      {
        generics = [];
        trait_ = Some (R.named delivered);
        for_ = R.named marker;
        items = [];
      };
  ]
  @
  match c with
  | Stored_event { payload; _ } ->
      [
        R.Impl
          {
            generics = [];
            trait_ = Some (R.named "Recorded");
            for_ = R.named marker;
            items =
              [
                R.I_type ("Event", R.Named ([ "crate"; "types"; payload ], []));
                R.I_fn
                  (R.fn_ "event"
                     ~params:
                       [
                         R.Param
                           ( "stored",
                             R.Ref (None, R.Assoc [ "Self"; "Payload" ]) );
                       ]
                     ~ret:
                       (R.named "Result"
                          ~args:
                            [
                              R.Assoc [ "Self"; "Event" ];
                              R.named "serde_json::Error";
                            ])
                     [
                       R.Tail
                         (R.call "own"
                            [
                              R.p "Self::NAME";
                              R.Ref_of (R.Field (R.p "stored", "type"));
                              R.Ref_of (R.Field (R.p "stored", "id"));
                              R.Ref_of (R.Field (R.p "stored", "payload"));
                            ]);
                     ]);
              ];
          };
      ]
  | _ -> []

let no_channel =
  R.Macro ("panic", [ R.Str "{other} is no channel of the registry" ])

(* Each channel's attributes, as Registry derives them: where it sits
   relative to the hub, whether the record keeps it, whether emitting it
   changes the knowledge base, and how it is delivered. *)
let attributes (bus : Registry.t) =
  let copy =
    R.List
      ( [ "derive" ],
        List.map
          (fun d -> R.Word [ d ])
          [ "Debug"; "Clone"; "Copy"; "PartialEq"; "Eq" ] )
  in
  let enum name doc variants =
    R.Enum
      {
        doc = [ doc ];
        attrs = [ copy ];
        vis = Pub;
        name;
        variants = List.map (fun (v, d) -> R.variant ~doc:[ d ] v) variants;
      }
  in
  let direction : Registry.direction -> string = function
    | Outbound -> "Outbound"
    | Inbound -> "Inbound"
    | In_process -> "InProcess"
  in
  let delivery : Registry.delivery -> string = function
    | Positioned -> "Positioned"
    | Correlated -> "Correlated"
    | Passing -> "Passing"
  in
  let option f = function
    | Some v -> R.Call (R.p "Some", [ f v ])
    | None -> R.p "None"
  in
  [
    enum "ChannelDirection" "Where a channel sits relative to the hub."
      [
        ("Outbound", "Emitted toward it: an operation's request, or a command.");
        ("Inbound", "Delivered from it: a reply, or an event of an audience.");
        ("InProcess", "Never on the wire.");
      ];
    R.Blank;
    enum "ChannelDelivery"
      "What a subscriber is promised about a frame on a channel when its \
       stream drops (protocol/contract/TRANSPORT-CONTRACT.md § Delivery)."
      [
        ( "Positioned",
          "A recorded event on its resource's scope: what a subscriber missed \
           is sent again." );
        ( "Correlated",
          "The reply to a request, routed to the client that asked, and sent \
           again while it is retained." );
        ("Passing", "Every other frame. Nothing replays it.");
      ];
    R.Blank;
    R.Struct_def
      {
        doc = [ "A channel's attributes." ];
        attrs = [ copy ];
        vis = Pub;
        name = "ChannelAttributes";
        generics = [];
        body =
          R.Fields
            [
              R.field
                ~doc:[ "The event log keeps it: it is an event of the record." ]
                "recorded" (R.named "bool");
              R.field "direction" (R.named "ChannelDirection");
              R.field
                ~doc:
                  [
                    "Whether emitting it changes the knowledge base, or only \
                     asks it something; absent on a channel nobody emits.";
                  ]
                "writes"
                (R.named ~args:[ R.named "bool" ] "Option");
              R.field
                ~doc:
                  [ "Absent exactly when the channel never crosses the wire." ]
                "delivery"
                (R.named ~args:[ R.named "ChannelDelivery" ] "Option");
            ];
      };
    R.Blank;
    constant
      ~doc:[ "Each channel's attributes, by its name." ]
      "CHANNEL_ATTRIBUTES"
      (R.Ref
         (None, R.Slice (R.Tuple_of [ R.str_ty; R.named "ChannelAttributes" ])))
      (R.Ref_of
         (R.Array
            (List.map
               (fun (a : Registry.attrs) ->
                 R.Tuple
                   [
                     R.Str a.channel;
                     R.Struct
                       ( [ "ChannelAttributes" ],
                         [
                           ("recorded", R.Bool a.recorded);
                           ( "direction",
                             R.p ("ChannelDirection::" ^ direction a.direction)
                           );
                           ("writes", option (fun w -> R.Bool w) a.writes);
                           ( "delivery",
                             option
                               (fun d -> R.p ("ChannelDelivery::" ^ delivery d))
                               a.delivery );
                         ],
                         None );
                   ])
               bus.attrs)));
  ]

let channels (bus : Registry.t) component =
  let reg = bus.registry in
  let bridged =
    List.concat_map
      (fun (o : Reg.operations_item) -> [ o.result; o.failure ])
      reg.operations
    @ reg.audience.everyone
  in
  let markers =
    List.map
      (fun (c : Reg.channels_item) ->
        (marker (Registry.name c), Registry.name c))
      reg.channels
  in
  let refusals =
    List.filter_map
      (fun ch ->
        if List.mem ch bridged then
          Some
            {
              Decode.file = Registry.file;
              pointer = "/audience/scoped";
              message =
                ch
                ^ " is delivered both globally and per scope: a client would \
                   be given it twice";
            }
        else None)
      reg.audience.scoped
    @ List.filter_map
        (fun (marker, ch) ->
          match
            List.find_opt (fun (m, other) -> m = marker && other <> ch) markers
          with
          | Some (_, other) ->
              Some
                {
                  Decode.file = Registry.file;
                  pointer = "/channels";
                  message =
                    Printf.sprintf "%s and %s would both be the Rust type %s" ch
                      other marker;
                }
          | None -> None)
        markers
  in
  if refusals <> [] then Error refusals
  else
    let by_name f =
      List.map
        (fun (c : Reg.channels_item) -> (R.Str (Registry.name c), f c))
        reg.channels
      @ [ (R.p "other", no_channel) ]
    in
    Ok
      {
        Output.path = channels_path;
        text =
          R.text ~header:(header __FILE__)
            ([
               constant
                 ~doc:
                   [
                     "The channels a full client hears globally, which it \
                      gives its transport: every operation's result and \
                      failure, and the events sent to every client.";
                   ]
                 "BRIDGED_CHANNELS" str_slice (strings bridged);
               constant
                 ~doc:
                   [
                     "The channels a resource's scope carries: what holding a \
                      resource adds to a client's stream.";
                   ]
                 "RESOURCE_SCOPED_CHANNELS" str_slice
                 (strings reg.audience.scoped);
               constant ~doc:[ reg.trace.meaning ] "TRACE_FIELD" R.str_ty
                 (R.Str reg.trace.field);
               constant ~doc:[ User_stamp.about ] "USER_FIELD" R.str_ty
                 (R.Str bus.user_field);
             ]
            @ attributes bus
            @ List.concat_map (channel_items bus component) reg.channels
            @ List.map
                (fun (o : Reg.operations_item) ->
                  R.Impl
                    {
                      generics = [];
                      trait_ = Some (R.named "Request");
                      for_ = R.named (marker o.request);
                      items =
                        [
                          R.I_type ("Result", R.named (marker o.result));
                          R.I_type ("Failure", R.named (marker o.failure));
                        ];
                    })
                reg.operations
            @ [
                R.Fn
                  (R.fn_
                     ~doc:
                       [
                         "What a payload on each channel must be, by the \
                          channel's name, as\n\
                          `crate::required` holds a payload to it.";
                       ]
                     ~vis:Pub_crate "payload_shape"
                     ~params:[ R.Param ("channel", R.str_ty) ]
                     ~ret:
                       (R.Ref (Some "'static", R.named "crate::required::Shape"))
                     [
                       R.Use "crate::required::{Kind, NONE, Shape}";
                       R.Tail
                         (R.Match
                            ( R.p "channel",
                              by_name (fun c ->
                                  let _, shape = carried c in
                                  R.Ref_of shape) ));
                     ]);
                R.Fn
                  (R.fn_
                     ~doc:
                       [
                         "The stamps each channel's payload type declares \
                          (`Channel::STAMPS`), by\n\
                          the channel's name.";
                       ]
                     ~vis:Pub_crate "payload_stamps"
                     ~params:[ R.Param ("channel", R.str_ty) ]
                     ~ret:static_strs
                     [
                       R.Tail
                         (R.Match
                            ( R.p "channel",
                              by_name (fun c ->
                                  R.Qualified
                                    ( R.named (marker (Registry.name c)),
                                      R.named "Channel",
                                      [ "STAMPS" ] )) ));
                     ]);
              ]);
      }

let files bus component =
  Result.map
    (fun channels -> [ operations bus; channels ])
    (channels bus component)
