(* The TypeScript bus authority, in typescript/core/src:

   bus-protocol.ts        EventMap, CHANNEL_SCHEMAS, TRACE_FIELD, CHANNEL_STAMPS
                          and CHANNEL_PAYLOADS
   persisted-events.ts    the persisted-event catalog
   bus-operations.ts      BUS_OPERATIONS, and REPLY_NAMES
   bridged-channels.ts    the broadcasts, and the channels a resource's scope
                          carries
   bus-classification.ts  CHANNEL_ATTRS *)

module R = Tables.Bus_registry
module T = Typescript_syntax

let banner =
  Banner.typescript_lines
    ~authority:
      [
        "protocol/specs/src/bus/registry.json  (channels, payloads, operations)";
      ]
    ~notes:
      [
        "Go counterpart: codegen/lib/bus/go.ml → go/bus";
        "";
        "Payload schemas themselves live in the OpenAPI components; the \
         registry";
        "names which one each channel carries, and every payload type here is";
        "derived from that. Add or change a channel THERE.";
      ]
    __FILE__

let str text = T.T_str text
let word text = T.Str text
let channel_key channel = T.Quoted channel

(* How a section heads a part of a listing: the event map's between two
   rules of [=], a schema's or an operation's on one rule of [─]. *)
type heading = Banner | Rule

let section heading title : T.comment list =
  match heading with
  | Banner ->
      let rule = T.Line (String.make 72 '=') in
      [ rule; Line_prose [ Words title ]; rule ]
  | Rule ->
      let head = "── " ^ title ^ " " in
      let rule = max 3 (64 - Text.length head) in
      [ Line (head ^ String.concat "" (List.init rule (fun _ -> "─"))) ]

(* What the registry writes before an entry, as comments. *)
let lead heading (docs : R.docs) =
  List.concat_map
    (fun (block : R.lead_item) ->
      match block with
      | String -> [ T.Gap ]
      | Section { section = title } -> section heading title
      | Comment { comment } -> [ Line_prose (Registry.prose comment) ]
      | Doc { doc } -> [ Doc_prose (Registry.prose doc) ])
    docs.lead

(* Each item with its lead and trailing note. *)
let with_docs heading docs make items =
  List.map
    (fun item ->
      let d : R.docs = docs item in
      make ~about:(lead heading d) ~trailing:d.trailing item)
    items

let schemas = T.T_index (T_name "components", str "schemas")
let component_name = T.T_keyof schemas

let satisfies_channels value =
  T.T_generic ("Record", [ T_name "EventName"; value ])

let channel_list ?(about = []) name channels ~of_ =
  T.const name ~about ~as_const:true
    ~satisfies:(T_readonly (T_array (T_name of_)))
    (T.array (List.map word channels))

let payload_type (c : R.channels_item) : T.type_ =
  match c with
  | Schema { schema; _ } -> T.schema schema
  | Envelope { schema; _ } ->
      T_object (Inline, [ T.member (Ident "response") (T.schema schema) ])
  | Stored_event { event; enriched; _ } ->
      T_generic
        ( (if enriched = Some true then "EnrichedEvent" else "StoredEvent"),
          [ T_generic ("EventOfType", [ str event ]) ] )
  | Void _ -> T_name "void"
  | Empty _ -> T_generic ("Record", [ T_name "string"; T_name "never" ])

let payload_schema (c : R.channels_item) =
  let one name schema =
    T.Object
      { layout = Inline; entries = [ T.entry (Ident name) (word schema) ] }
  in
  match c with
  | Schema { schema; _ } -> one "payload" schema
  | Envelope { schema; _ } -> one "response" schema
  | Stored_event { enriched; _ } ->
      one "payload"
        (Registry.stored_event_component ~enriched:(enriched = Some true))
  | Void _ | Empty _ -> T.Object { layout = Inline; entries = [] }

let protocol (bus : Registry.t) =
  let reg = bus.registry in
  let channels = List.map bus.channel in
  let mapped ?(layout = T.Rows) key in_ value =
    T.T_mapped { layout; readonly = false; key; in_; value }
  in
  T.text
    {
      banner;
      body =
        [
          T.Comment
            [
              Block
                [
                  "Bus Protocol";
                  "";
                  "The complete EventMap for the RxJS EventBus. Every channel \
                   name and";
                  "its payload type is defined here — domain events, commands, \
                   reads,";
                  "results, SSE stream payloads, and Browser UI events. What \
                   TypeScript";
                  "narrows in a payload is bus-refinements.ts's.";
                  "";
                  "Organized by flow (verb), then by category within each flow.";
                ];
            ];
          T.Adjacent
            [
              T.import ~type_only:true [ "components" ] "./types";
              T.import ~type_only:true
                [ "EnrichedEvent"; "StoredEvent" ]
                "./event-base";
              T.import ~type_only:true
                [ "EventOfType"; "PersistedEventType" ]
                "./persisted-events";
              T.import ~type_only:true [ "ChannelRefinements" ]
                "./bus-refinements";
            ];
          T.type_alias "StatedEventMap"
            ~about:[ Doc "Each channel's payload as the registry states it." ]
            (T_object
               ( Rows,
                 with_docs Banner Registry.docs
                   (fun ~about ~trailing (c : R.channels_item) ->
                     T.member ~about ~trailing
                       (channel_key (Registry.name c))
                       (payload_type c))
                   (channels reg.channel_order.event_map) ));
          T.type_alias "EventMap"
            ~about:
              [
                Block
                  [
                    "The unified EventMap — every channel on the EventBus: \
                     each channel's";
                    "stated payload, or its refinement where \
                     bus-refinements.ts narrows it.";
                    "";
                    "Convention:";
                    "- Domain events (past tense): StoredEvent<Interface> — \
                     branded types";
                    "- Annotation-mutating events: EnrichedEvent<Interface> — \
                     the stored event";
                    "  plus the annotation the EventStore attaches before \
                     publishing";
                    "- Commands/reads/results/UI: OpenAPI schema refs — plain \
                     strings";
                    "- void: UI-only signals with no payload";
                  ];
              ]
            (mapped "K" (T_keyof (T_name "StatedEventMap"))
               (T_conditional
                  {
                    layout = Inline;
                    check = T_name "K";
                    extends = T_keyof (T_name "ChannelRefinements");
                    then_ = T_index (T_name "ChannelRefinements", T_name "K");
                    else_ = T_index (T_name "StatedEventMap", T_name "K");
                  }));
          T.type_alias "EventName"
            ~about:[ Doc_prose (Registry.prose reg.docs.event_name) ]
            (T_keyof (T_name "EventMap"));
          channel_list "ENRICHED_EVENT_TYPES"
            ~about:[ Doc_prose (Registry.prose reg.docs.enriched_events) ]
            ~of_:"PersistedEventType"
            (List.filter_map
               (fun (c : R.channels_item) ->
                 match c with
                 | Stored_event { enriched = Some true; _ } ->
                     Some (Registry.name c)
                 | _ -> None)
               reg.channels);
          T.type_alias "EnrichedEventType"
            (T_index (T_typeof "ENRICHED_EVENT_TYPES", T_name "number"));
          T.const "CHANNEL_SCHEMAS" ~as_const:true
            ~about:[ Doc_prose (Registry.prose reg.docs.channel_schemas) ]
            ~satisfies:
              (satisfies_channels (T_union [ component_name; T_name "null" ]))
            (T.rows
               (with_docs Rule Registry.schema_docs
                  (fun ~about ~trailing (c : R.channels_item) ->
                    T.entry ~about ~trailing
                      (channel_key (Registry.name c))
                      (match Registry.validate_of c with
                      | None -> Null
                      | Some validate -> word validate))
                  (channels reg.channel_order.schemas)));
          T.type_alias "EmittableChannel"
            ~about:[ Doc_prose (Registry.prose reg.docs.emittable_channel) ]
            (T_index
               ( mapped "K" (T_name "EventName")
                   (T_conditional
                      {
                        layout = Inline;
                        check = T_index (T_typeof "CHANNEL_SCHEMAS", T_name "K");
                        extends = T_name "null";
                        then_ = T_name "never";
                        else_ = T_name "K";
                      }),
                 T_name "EventName" ));
          T.const "TRACE_FIELD" ~about:[ Doc reg.trace.meaning ]
            (word reg.trace.field);
          T.const "USER_FIELD" ~about:[ Doc User_stamp.about ]
            (word bus.user_field);
          T.const "CHANNEL_STAMPS" ~as_const:true
            ~about:
              [
                Block
                  [
                    "The stamps a gateway puts on a payload (`_userId`, \
                     `_roles`) that each";
                    "channel's payload type declares, and so reads. Any other \
                     is the bus's, not";
                    "the payload's, and is left out of what the SDK delivers.";
                  ];
              ]
            ~satisfies:
              (satisfies_channels (T_readonly (T_array (T_name "string"))))
            (T.rows
               (List.map
                  (fun (channel, stamps) ->
                    T.entry (channel_key channel) (T.strings stamps))
                  bus.stamps));
          T.const "CHANNEL_PAYLOADS" ~as_const:true
            ~about:
              [
                Block
                  [
                    "What each channel's payload is, as a reader holds it: the \
                     component schema";
                    "it is (`payload`), a `{ response }` whose response is one \
                     (`response`), or";
                    "nothing a schema states (`{}`). A stored event is its \
                     stored form; what it";
                    "records is the channel's own. A payload read off the wire \
                     with a fault as";
                    "its schema's, a member it lacks or one that is malformed, \
                     is not its";
                    "channel's.";
                  ];
              ]
            ~satisfies:
              (satisfies_channels
                 (T_union
                    [
                      T_object
                        ( Inline,
                          [
                            T.member ~readonly:true (Ident "payload")
                              component_name;
                          ] );
                      T_object
                        ( Inline,
                          [
                            T.member ~readonly:true (Ident "response")
                              component_name;
                          ] );
                      T_generic ("Record", [ T_name "string"; T_name "never" ]);
                    ]))
            (T.rows
               (List.map
                  (fun (c : R.channels_item) ->
                    T.entry (channel_key (Registry.name c)) (payload_schema c))
                  (channels reg.channel_order.event_map)));
        ];
    }

(* The catalog is the registry's stored-event channels, in their order: the
   payload each names, and the system flag of those that belong to no
   resource. *)
type stored = { event : string; payload : string; system : bool }

let stored (reg : R.t) =
  List.filter_map
    (fun (c : R.channels_item) ->
      match c with
      | Stored_event { event; payload; system; _ } ->
          Some { event; payload; system = system = Some true }
      | _ -> None)
    reg.channels

let persisted (bus : Registry.t) =
  let stored = stored bus.registry in
  let catalog_k = T.T_index (T_name "PersistedEventCatalog", T_name "K") in
  let event members =
    T.T_intersection [ T_name "EventBase"; T_object (Inline, members) ]
  in
  T.text
    {
      banner;
      body =
        [
          T.Comment
            [
              Block
                [
                  "Persisted Events";
                  "";
                  "The event types that get appended to the JSONL event log, \
                   each with the";
                  "component schema of its payload. The PersistedEvent union \
                   derives from this";
                  "catalog.";
                ];
            ];
          T.Adjacent
            [
              T.import ~type_only:true [ "components" ] "./types";
              T.import ~type_only:true [ "ResourceId" ] "./identifiers";
              T.import ~type_only:true [ "EventBase" ] "./event-base";
            ];
          T.type_alias "PersistedEventCatalog" ~export:false
            ~about:
              [
                Doc
                  "Each persisted event type and the payload the registry \
                   states it carries.";
              ]
            (T_object
               ( Rows,
                 List.map
                   (fun s ->
                     T.member (channel_key s.event) (T.schema s.payload))
                   stored ));
          T.type_alias "SystemEventType" ~export:false
            ~about:
              [
                Doc
                  "System event types — persisted events that have no \
                   resourceId.";
              ]
            (T_union
               (List.filter_map
                  (fun s -> if s.system then Some (str s.event) else None)
                  stored));
          T.type_alias "EventOfType"
            ~about:
              [
                Doc
                  "Extract the concrete persisted event type for a given type \
                   string.";
              ]
            ~params:
              [
                {
                  param = "K";
                  bound = Some (T_keyof (T_name "PersistedEventCatalog"));
                };
              ]
            (T_conditional
               {
                 layout = Rows;
                 check = T_name "K";
                 extends = T_name "SystemEventType";
                 then_ =
                   event
                     [
                       T.member (Ident "type") (T_name "K");
                       T.member (Ident "payload") catalog_k;
                     ];
                 else_ =
                   event
                     [
                       T.member (Ident "type") (T_name "K");
                       T.member (Ident "resourceId") (T_name "ResourceId");
                       T.member (Ident "payload") catalog_k;
                     ];
               });
          T.type_alias "PersistedEvent"
            ~about:
              [
                Doc
                  "The union of all persisted event types. Discriminated on \
                   `type`.";
              ]
            (T_index
               ( T_mapped
                   {
                     layout = Rows;
                     readonly = false;
                     key = "K";
                     in_ = T_keyof (T_name "PersistedEventCatalog");
                     value = T_generic ("EventOfType", [ T_name "K" ]);
                   },
                 T_keyof (T_name "PersistedEventCatalog") ));
          T.type_alias "PersistedEventType"
            (T_index (T_name "PersistedEvent", str "type"));
          channel_list "PERSISTED_EVENT_TYPES"
            ~about:
              [
                Doc
                  "Every persisted event type, for code that enumerates them \
                   at runtime.";
              ]
            ~of_:"PersistedEventType"
            (List.map (fun s -> s.event) stored);
          T.type_alias "EventInput"
            ~about:
              [
                Doc
                  "Input type for appendEvent — PersistedEvent without \
                   id/timestamp (assigned at persistence time).";
              ]
            (T_generic
               ( "Omit",
                 [
                   T_name "PersistedEvent";
                   T_union [ str "id"; str "timestamp" ];
                 ] ));
        ];
    }

let operations (bus : Registry.t) =
  let reg = bus.registry in
  let bus_operations = T.T_typeof "BUS_OPERATIONS" in
  T.text
    {
      banner;
      body =
        [
          T.import ~type_only:true
            [ "EventMap"; "EventName"; "EmittableChannel" ]
            "./bus-protocol";
          T.Interface
            {
              about =
                [
                  Block
                    [
                      "BUS_OPERATIONS — the request/reply operations registry.";
                      "";
                      "Each entry declares ONE operation as a triple, so its \
                       three facts are";
                      "stated together rather than maintained independently \
                       across call sites:";
                      "  - the request channel (the key — an \
                       `EmittableChannel`),";
                      "  - the `result` channel (success reply),";
                      "  - and the `failure` channel.";
                      "";
                      "`BridgedChannel` / `BRIDGED_CHANNELS` are DERIVED from \
                       this map";
                      "(bridging.ts): every reply lands in the bridged fan-in \
                       set by";
                      "construction, so \"a reply channel forgotten from \
                       BRIDGED_CHANNELS\" is not";
                      "representable.";
                      "";
                      "`Partial<Record<EmittableChannel, …>>` enforces that \
                       every key is a real";
                      "emittable request. `result`/`failure` stay `EventName` \
                       rather than";
                      "`BridgedChannel` to avoid a circular reference \
                       (BridgedChannel derives from";
                      "this map); the derivation closes the loop instead.";
                    ];
                ];
              export = true;
              name = "BusOperationSpec";
              members =
                [
                  T.member (Ident "result") (T_name "EventName");
                  T.member (Ident "failure") (T_name "EventName");
                ];
            };
          T.const "BUS_OPERATIONS" ~as_const:true
            ~satisfies:
              (T_generic
                 ( "Partial",
                   [
                     T_generic
                       ( "Record",
                         [
                           T_name "EmittableChannel"; T_name "BusOperationSpec";
                         ] );
                   ] ))
            (T.rows
               (with_docs Rule
                  (fun (o : R.operations_item) -> o.docs)
                  (fun ~about ~trailing (o : R.operations_item) ->
                    T.entry ~about ~trailing (channel_key o.request)
                      (Object
                         {
                           layout = Inline;
                           entries =
                             [
                               T.entry (Ident "result") (word o.result);
                               T.entry (Ident "failure") (word o.failure);
                             ];
                         }))
                  reg.operations));
          T.type_alias "BusOperationKey"
            ~about:
              [
                Doc
                  "The request-channel key of a registered operation — what \
                   `Bus.request` takes.";
              ]
            (T_keyof bus_operations);
          T.const "REPLY_NAMES" ~as_const:true
            ~about:
              [
                Block
                  [
                    "REPLY_NAMES — what each operation's reply states beside \
                     its `response`.";
                    "";
                    "A reply names what it answers for by stating a property \
                     of its request";
                    "again: the annotation or the resource a context was \
                     gathered for, the";
                    "reference a search was for. Whoever answers takes each \
                     from the request.";
                    "Most replies name nothing.";
                    "";
                    "Each list is what the reply's component schema requires, \
                     without";
                    "`response`. The generator refuses a name the request's \
                     schema does not";
                    "state, and the `satisfies` below holds each to the \
                     TypeScript types of both";
                    "payloads.";
                  ];
              ]
            ~satisfies:
              (T_mapped
                 {
                   layout = Rows;
                   readonly = true;
                   key = "Op";
                   in_ = T_name "BusOperationKey";
                   value =
                     T_readonly
                       (T_array
                          (T_paren
                             (T_intersection
                                [
                                  T_keyof
                                    (T_index (T_name "EventMap", T_name "Op"));
                                  T_keyof
                                    (T_index
                                       ( T_name "EventMap",
                                         T_intersection
                                           [
                                             T_index
                                               ( T_index
                                                   ( T_paren bus_operations,
                                                     T_name "Op" ),
                                                 str "result" );
                                             T_name "EventName";
                                           ] ));
                                ])));
                 })
            (T.rows
               (List.map
                  (fun (request, names) ->
                    T.entry (channel_key request) (T.strings names))
                  bus.reply_names));
        ];
    }

let bridged (bus : Registry.t) =
  let reg = bus.registry in
  T.text
    {
      banner;
      body =
        [
          T.import ~type_only:true [ "EventName" ] "./bus-protocol";
          channel_list "BRIDGED_BROADCASTS"
            ~about:[ Doc_prose (Registry.prose reg.audience.doc) ]
            ~of_:"EventName" reg.audience.everyone;
          channel_list "RESOURCE_SCOPED_CHANNELS"
            ~about:
              [
                Block
                  [
                    "The channels a client receives per RESOURCE SCOPE rather \
                     than globally —";
                    "what `subscribeToResource` joins. `audience: scoped` in \
                     the registry.";
                  ];
              ]
            ~of_:"EventName" reg.audience.scoped;
          T.type_alias "ResourceScopedChannel"
            ~about:
              [
                Doc
                  "A channel a resource's scope carries. A read of one names \
                   its resource.";
              ]
            (T_index
               (T_paren (T_typeof "RESOURCE_SCOPED_CHANNELS"), T_name "number"));
          T.type_alias "UnscopedChannel"
            ~about:
              [ Doc "A channel of no resource's scope: every other channel." ]
            (T_generic
               ( "Exclude",
                 [ T_name "EventName"; T_name "ResourceScopedChannel" ] ));
        ];
    }

let direction : Registry.direction -> string = function
  | Outbound -> "outbound"
  | Inbound -> "inbound"
  | In_process -> "in-process"

let delivery : Registry.delivery -> string = function
  | Positioned -> "positioned"
  | Correlated -> "correlated"
  | Passing -> "passing"

let classification (bus : Registry.t) =
  let reg = bus.registry in
  let attrs (a : Registry.attrs) =
    let field name value = T.entry (Ident name) value in
    T.Object
      {
        layout = Inline;
        entries =
          [
            field "recorded" (Bool a.recorded);
            field "direction" (word (direction a.direction));
          ]
          @ Option.to_list
              (Option.map (fun w -> field "writes" (Bool w)) a.writes)
          @ Option.to_list
              (Option.map
                 (fun d -> field "delivery" (word (delivery d)))
                 a.delivery);
      }
  in
  T.text
    {
      banner;
      body =
        [
          T.import ~type_only:true [ "EventName" ] "./bus-protocol";
          T.type_alias "ChannelDirection"
            ~about:
              [
                Block
                  [
                    "Where a channel sits relative to the hub: emitted toward \
                     it, delivered";
                    "from it (the fan-in set — BRIDGED_CHANNELS, by \
                     construction), or never on";
                    "the wire at all.";
                  ];
              ]
            (T_union [ str "outbound"; str "inbound"; str "in-process" ]);
          T.type_alias "ChannelDelivery"
            ~about:
              [
                Block
                  [
                    "A channel's delivery class: what a subscriber is promised \
                     about a frame on";
                    "it when its stream drops, or is handed to another. The \
                     promise comes from";
                    "the frame's identity \
                     (protocol/contract/TRANSPORT-CONTRACT.md § Delivery).";
                    "";
                    "  positioned — a recorded event delivered on its \
                     resource's scope. Its id";
                    "               is its place in that resource's record: a \
                     subscriber that";
                    "               names the last one it holds is sent what \
                     it missed.";
                    "  correlated — the reply to a claimed request, routed to \
                     the client that";
                    "               asked. Its id is the request's: it is \
                     recognised when it";
                    "               arrives twice, and sent again while it is \
                     retained.";
                    "  passing    — every other frame. Nothing replays it.";
                    "";
                    "Derived from the registry's axes, never declared: an \
                     operation's replies";
                    "are correlated; a recorded event whose audience is \
                     `scoped` is positioned;";
                    "everything else that crosses the wire is passing. Who \
                     RECEIVES a frame is";
                    "the audience axis, and a different question.";
                  ];
              ]
            (T_union [ str "positioned"; str "correlated"; str "passing" ]);
          T.Interface
            {
              about = [];
              export = true;
              name = "ChannelAttrs";
              members =
                [
                  T.member ~readonly:true (Ident "recorded")
                    ~about:
                      [
                        Doc
                          "In PERSISTED_EVENT_TYPES — lands in the event log, \
                           the system of record.";
                      ]
                    (T_name "boolean");
                  T.member ~readonly:true (Ident "direction")
                    (T_name "ChannelDirection");
                  T.member ~readonly:true ~optional:true (Ident "writes")
                    ~about:[ Doc_prose (Registry.prose reg.effect_.doc) ]
                    (T_name "boolean");
                  T.member ~readonly:true ~optional:true (Ident "delivery")
                    ~about:
                      [
                        Doc
                          "Absent exactly when the channel never crosses the \
                           wire (`in-process`).";
                      ]
                    (T_name "ChannelDelivery");
                ];
            };
          T.const "CHANNEL_ATTRS" ~as_const:true
            ~satisfies:(satisfies_channels (T_name "ChannelAttrs"))
            (T.rows
               (List.map
                  (fun (a : Registry.attrs) ->
                    T.entry (channel_key a.channel) (attrs a))
                  bus.attrs));
        ];
    }

let files bus : Output.file list =
  let at name text = { Output.path = "typescript/core/src/" ^ name; text } in
  [
    at "bus-protocol.ts" (protocol bus);
    at "persisted-events.ts" (persisted bus);
    at "bus-operations.ts" (operations bus);
    at "bridged-channels.ts" (bridged bus);
    at "bus-classification.ts" (classification bus);
  ]
