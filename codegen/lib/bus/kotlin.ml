(* The bus as the Kotlin SDK reads it: the channels (xynolog.channels), each
   typed by the payload a frame on it carries and with the stamps that
   payload declares, the audiences and the trace field; the operations
   (xynolog.bus), each typed by its three channels. *)

module K = Kotlin_syntax
module R = Tables.Bus_registry
module Names = Kotlin_sdk.Names
module Types = Kotlin_sdk.Types

let generated = K.annotation "Generated"

(* The types xynolog.channels declares beside the channels, which no
   component schema may share a name with. *)
let channel_types = [ "Channel"; "ScopedChannel"; "Response" ]

(* What a channel carries, in Kotlin: its type, that type's serializer, the
   types of xynolog.types it names (a component schema, or the generator's
   EmptyObject for a channel that carries nothing) and the types of
   xynolog.channels it names. *)
type carried = {
  type_ : K.type_;
  serializer : K.expr;
  components : string list;
  own : string list;
}

let serializer_of name = K.call (K.Member (K.Name name, "serializer")) []

let carried ~(types : Types.spec) (c : R.channels_item) =
  let component name =
    if List.mem name channel_types then
      Names.refuse
        "%s carries %s, which xynolog.channels names a type of its own"
        (Registry.name c) name;
    if not (List.mem_assoc name types.definitions) then
      Names.refuse "%s carries %s, which is no component schema"
        (Registry.name c) name
  in
  (match c with Stored_event { payload; _ } -> component payload | _ -> ());
  match Registry.carried c with
  | Component name ->
      component name;
      {
        type_ = K.Type name;
        serializer = serializer_of name;
        components = [ name ];
        own = [];
      }
  | Response name ->
      component name;
      {
        type_ = K.Generic ("Response", [ K.Type name ]);
        serializer =
          K.call
            (K.Member (K.Name "Response", "serializer"))
            [ serializer_of name ];
        components = [ name ];
        own = [ "Response" ];
      }
  | Nothing ->
      {
        type_ = K.Type Types.empty_object;
        serializer = serializer_of Types.empty_object;
        components = [ Types.empty_object ];
        own = [];
      }

(* The stamps a channel's payload declares: those of the component it
   carries. *)
let stamps ~ids ~component (c : R.channels_item) =
  match Registry.carried c with
  | Component name -> (
      match
        Registry.stamps ~ids component ~of_:name (Registry.named component name)
      with
      | stamps -> List.sort_uniq String.compare stamps
      | exception Registry.Problem message ->
          Names.refuse "%s: %s" (Registry.name c) message)
  | Response _ | Nothing -> []

let constant = Names.constant_name
let strings list = K.call (K.Name "listOf") (List.map (fun s -> K.Str s) list)

let imports ~types carried =
  List.sort_uniq String.compare
    (List.concat_map
       (fun c ->
         List.concat_map
           (fun n -> Types.imports_of types (K.Type n))
           c.components)
       carried)

let channels_file ~component ~types (bus : Registry.t) =
  let reg = bus.registry in
  let rows =
    List.map (fun (c : R.channels_item) -> (c, carried ~types c)) reg.channels
  in
  let scoped (c : R.channels_item) =
    List.mem (Registry.name c) reg.audience.scoped
  in
  let member ((c : R.channels_item), carried) =
    let kind = if scoped c then "ScopedChannel" else "Channel" in
    let stamps =
      match stamps ~ids:bus.ids ~component c with
      | [] -> K.call (K.Name "emptySet") []
      | stamps -> K.call (K.Name "setOf") (List.map (fun s -> K.Str s) stamps)
    in
    K.property
      ~annotations:[ K.annotation "JvmField" ]
      ~visibility:K.Public
      ~type_:(K.Generic (kind, [ carried.type_ ]))
      ~value:
        (K.Same_line
           (K.call (K.Name kind)
              [ K.Str (Registry.name c); carried.serializer; stamps ]))
      (constant (Registry.name c))
  in
  let names ?(visibility = K.Public) ~about name list =
    K.property ~about:(K.Doc about)
      ~annotations:(if visibility = K.Public then [ generated ] else [])
      ~visibility
      ~type_:(K.Generic ("List", [ K.Type "String" ]))
      ~value:(K.Same_line (strings list))
      name
  in
  let replies =
    List.concat_map
      (fun (o : R.operations_item) -> [ o.result; o.failure ])
      reg.operations
  in
  let bridged =
    List.fold_left
      (fun seen ch -> if List.mem ch seen then seen else seen @ [ ch ])
      []
      (reg.audience.everyone @ replies)
  in
  let persisted =
    List.filter_map
      (fun (c : R.channels_item) ->
        match c with Stored_event { event; _ } -> Some event | _ -> None)
      reg.channels
  in
  Kotlin_sdk.table ~from_:Registry.file __FILE__ ~package:"xynolog.channels"
    ~name:"Channels"
    ~imports:("xynolog.Generated" :: imports ~types (List.map snd rows))
    [
      K.property
        ~about:
          (K.Block
             "The field of a relayed frame's payload its trace rides in (the \
              bus registry's `trace`).")
        ~annotations:[ generated ] ~visibility:K.Public ~const:true
        ~type_:(K.Type "String") ~value:(K.Same_line (K.Str reg.trace.field))
        "TRACE_FIELD";
      K.property ~about:(K.Block User_stamp.about) ~annotations:[ generated ]
        ~visibility:K.Internal ~const:true ~type_:(K.Type "String")
        ~value:(K.Same_line (K.Str bus.user_field)) "USER_FIELD";
      K.class_
        ~about:
          (K.Doc
             "Every channel of the bus, by name, each typed by the payload a \
              frame on it carries; a channel a resource's scope carries is a \
              `ScopedChannel`.")
        ~annotations:[ generated ] ~visibility:K.Public
        ~members:(List.map member rows) K.Object "Channels";
      names ~about:"Every channel's name, in the registry's order."
        "CHANNEL_NAMES"
        (List.map (fun (c : R.channels_item) -> Registry.name c) reg.channels);
      names
        ~about:
          "What a full client gives its transport to name on no scope: the \
           channels every client hears, and every operation's reply channels."
        "BRIDGED_CHANNELS" bridged;
      names ~about:"The channels a resource's scope carries."
        "RESOURCE_SCOPED_CHANNELS" reg.audience.scoped;
      names ~visibility:K.Internal
        ~about:"The type of every event of the record." "PERSISTED" persisted;
    ]

let operations_file ~types (bus : Registry.t) =
  let reg = bus.registry in
  let carried name = carried ~types (bus.channel name) in
  let channels (o : R.operations_item) =
    List.map carried [ o.request; o.result; o.failure ]
  in
  let operation_type o =
    K.Generic ("Operation", List.map (fun c -> c.type_) (channels o))
  in
  let channel name = K.Name ("Channels." ^ constant name) in
  let operation (o : R.operations_item) =
    K.Name ("Operations." ^ constant o.request)
  in
  let member (o : R.operations_item) =
    let names =
      match List.assoc o.request bus.reply_names with
      | [] -> K.call (K.Name "emptyList") []
      | names -> strings names
    in
    K.property
      ~annotations:[ K.annotation "JvmField" ]
      ~visibility:K.Public ~type_:(operation_type o)
      ~value:
        (K.Below
           (K.call (K.Name "Operation")
              [ channel o.request; channel o.result; channel o.failure; names ]))
      (constant o.request)
  in
  let first, rest = bus.limits in
  let all = List.concat_map channels reg.operations in
  Kotlin_sdk.table ~from_:Registry.file __FILE__ ~package:"xynolog.bus"
    ~name:"Operations"
    ~imports:
      ([ "xynolog.Generated"; "xynolog.channels.Channels" ]
      @ List.map
          (fun n -> "xynolog.channels." ^ n)
          (List.sort_uniq String.compare (List.concat_map (fun c -> c.own) all))
      @ imports ~types all)
    [
      K.class_
        ~about:
          (K.Doc
             "Every operation of the registry, named for its request's \
              channel, each typed by what it sends and what each reply \
              carries.")
        ~annotations:[ generated ] ~visibility:K.Public
        ~members:(List.map member reg.operations)
        K.Object "Operations";
      K.property
        ~about:
          (K.Doc "Each operation of the registry, by its request's channel.")
        ~annotations:[ generated ] ~visibility:K.Public
        ~type_:
          (K.Generic
             ( "Map",
               [
                 K.Type "String";
                 K.Generic ("Operation", [ K.Star; K.Star; K.Star ]);
               ] ))
        ~value:
          (K.Same_line
             (K.call ~layout:K.Lines (K.Name "mapOf")
                (List.map
                   (fun (o : R.operations_item) ->
                     K.Binary (K.Str o.request, K.To, operation o))
                   reg.operations)))
        "OPERATIONS";
      K.property
        ~about:
          (K.Doc
             "The operations that report the limits of the models a service \
              holds credentials for.")
        ~annotations:[ generated ] ~visibility:K.Public
        ~type_:(K.Generic ("List", [ operation_type first ]))
        ~value:
          (K.Same_line
             (K.call (K.Name "listOf") (List.map operation (first :: rest))))
        "LIMITS_OPERATIONS";
    ]

let files ~component ~types bus =
  Kotlin_sdk.written ~from_:Registry.file (fun () ->
      [ channels_file ~component ~types bus; operations_file ~types bus ])
