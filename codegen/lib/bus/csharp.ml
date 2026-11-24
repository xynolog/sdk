(* The C# SDK's bus: each channel typed by its payload, the channels of the
   scoped and the everyone audiences and of the record, each channel's
   reading by name, each operation typed by its three channels and named with
   its failure's schema, the limits operations, and what each result states
   beside its response. A channel
   that carries no component carries one the registry makes: the empty
   payload, or a component's response in an envelope. *)

module C = Csharp_syntax
module R = Tables.Bus_registry

let path = "csharp/sdk/src/Xynolog/Generated/BusDescriptors.g.cs"
let empty = "EmptyBusPayload"
let envelope schema = schema ^ "BusEnvelope"

(* The type a frame on [c] carries. *)
let payload (c : R.channels_item) =
  match Registry.carried c with
  | Component name -> name
  | Response schema -> envelope schema
  | Nothing -> empty

(* The payload types the registry makes, each as a JSON Schema, in the
   registry's order: the empty payload, then each envelope once. An
   envelope's reference is read as one written beside the components. *)
let made (reg : R.t) =
  let enveloped =
    List.fold_left
      (fun found (c : R.channels_item) ->
        match c with
        | Envelope { schema; _ } when not (List.mem schema found) ->
            found @ [ schema ]
        | _ -> found)
      [] reg.channels
  in
  (empty, `Assoc [ ("type", `String "object"); ("maxProperties", `Int 0) ])
  :: List.map
       (fun schema ->
         ( envelope schema,
           `Assoc
             [
               ("type", `String "object");
               ( "properties",
                 `Assoc
                   [
                     ( "response",
                       `Assoc [ ("$ref", `String (schema ^ ".json")) ] );
                   ] );
               ("required", `List [ `String "response" ]);
               ("additionalProperties", `Bool false);
             ] ))
       enveloped

(* Each made payload's schema, decoded as Protocol's are. *)
let payloads (reg : R.t) =
  List.map
    (fun (name, json) ->
      let file = "components/schemas/" ^ name ^ ".json" in
      match Decode.run ~file json Schema.decode with
      | Ok (schema, _) -> Ok (name, json, schema)
      | Error error -> Error error)
    (made reg)

(* A channel's name as a member: each part between [:] and [-] capitalised,
   [beckon:focus] as [BeckonFocus]. *)
let member channel =
  String.concat ""
    (List.map String.capitalize_ascii
       (List.concat_map (String.split_on_char '-')
          (String.split_on_char ':' channel)))

let property ~modifiers type_ name value =
  C.Property
    {
      attributes = [];
      modifiers;
      type_;
      name;
      accessors = [ Get ];
      value = Some value;
    }

let readings_type =
  C.Generic
    ( "global::System.Collections.Generic.IReadOnlyDictionary",
      [
        C.T "string";
        C.Generic ("global::System.Func", [ C.T "Carried"; C.T "bool" ]);
      ] )

let readings (reg : R.t) =
  property ~modifiers:[ Internal; Static ] readings_type "Readings"
    (C.New
       {
         type_ =
           Some
             (C.Generic
                ( "global::System.Collections.Generic.Dictionary",
                  [
                    C.T "string";
                    C.Generic
                      ("global::System.Func", [ C.T "Carried"; C.T "bool" ]);
                  ] ));
         args = Some [ Arg (Name "global::System.StringComparer.Ordinal") ];
         init =
           Some
             (Keyed
                (List.map
                   (fun (c : R.channels_item) ->
                     let t = C.T (payload c) in
                     ( C.Str (Registry.name c),
                       C.Lambda
                         ( "carried",
                           C.Is
                             ( C.Call
                                 ( Name "Bus.HeardOf",
                                   [ t ],
                                   [ Arg (Name "carried") ] ),
                               C.Member_type
                                 (C.Generic ("Heard", [ t ]), "Delivered") ) )
                     ))
                   reg.channels));
       })

let channels (reg : R.t) =
  List.map
    (fun (c : R.channels_item) ->
      property ~modifiers:[ Public; Static ]
        (C.Generic ("BusChannel", [ C.T (payload c) ]))
        (member (Registry.name c))
        (C.New
           {
             type_ = None;
             args =
               Some
                 [
                   Arg (Str (Registry.name c));
                   Arg (Bool (List.mem (Registry.name c) reg.audience.scoped));
                 ];
             init = None;
           }))
    reg.channels
  @ [ readings reg ]

let operation_type (bus : Registry.t) (o : R.operations_item) =
  C.Generic
    ( "BusOperation",
      List.map
        (fun ch -> C.T (payload (bus.channel ch)))
        [ o.request; o.result; o.failure ] )

let operations (bus : Registry.t) =
  let first, rest = bus.limits in
  List.map
    (fun (o : R.operations_item) ->
      property ~modifiers:[ Public; Static ] (operation_type bus o)
        (member o.request)
        (C.New
           {
             type_ = None;
             args =
               Some
                 (List.map
                    (fun ch -> C.Arg (Member (Name "BusChannels", member ch)))
                    [ o.request; o.result; o.failure ]);
             init = None;
           }))
    bus.registry.operations
  @ [
      property ~modifiers:[ Internal; Static ]
        (C.Generic
           ( "global::System.Collections.Generic.IReadOnlyList",
             [
               C.Tuple
                 (List.map
                    (fun name -> (C.T "string", name))
                    [ "Request"; "Result"; "Failure"; "FailureSchema" ]);
             ] ))
        "Replies"
        (C.Collection
           (List.map
              (fun (o : R.operations_item) ->
                C.New
                  {
                    type_ = None;
                    args =
                      Some
                        (List.map
                           (fun name -> C.Arg (Str name))
                           [
                             o.request;
                             o.result;
                             o.failure;
                             payload (bus.channel o.failure);
                           ]);
                    init = None;
                  })
              bus.registry.operations));
      property ~modifiers:[ Internal; Static ]
        (C.Generic
           ( "System.Collections.Generic.IReadOnlyList",
             [ operation_type bus first ] ))
        "Limits"
        (C.Collection
           (List.map
              (fun (o : R.operations_item) -> C.Name (member o.request))
              (first :: rest)));
      C.Method
        {
          modifiers = [ Internal; Static ];
          returns = C.Array (C.T "string");
          name = "ReplyFields";
          params = [ { by = `Value; type_ = C.T "string"; name = "operation" } ];
          body =
            Arrow
              (C.Switch
                 ( Name "operation",
                   List.filter_map
                     (fun (request, names) ->
                       if names = [] then None
                       else
                         Some
                           ( C.Value (C.Str request),
                             C.Collection (List.map (fun n -> C.Str n) names) ))
                     bus.reply_names
                   @ [ (Discard, C.Collection []) ] ));
        };
    ]

(* A list of channels, by name. *)
let named name channels =
  property ~modifiers:[ Internal; Static ]
    (C.Generic
       ("global::System.Collections.Generic.IReadOnlyList", [ C.T "string" ]))
    name
    (C.Collection (List.map (fun channel -> C.Str channel) channels))

let static_class name members =
  C.Type
    {
      attributes = [];
      modifiers = [ Public; Static ];
      kind = Class;
      name;
      params = None;
      base = None;
      body = Some (Packed, members);
    }

let file (bus : Registry.t) =
  {
    Output.path;
    text =
      C.text
        {
          header =
            Banner.lines ~from_:"protocol/specs/src/bus/registry.json" __FILE__;
          nullable = false;
          usings = [ "Xynolog.Types" ];
          namespace = "Xynolog";
          decls =
            [
              static_class "BusChannels"
                (C.Field
                   {
                     modifiers = [ Internal; Const ];
                     type_ = C.T "string";
                     name = "UserField";
                     value = Some (C.Str bus.user_field);
                   }
                :: named "Scoped" bus.registry.audience.scoped
                :: named "Everyone" bus.registry.audience.everyone
                :: named "Recorded"
                     (List.filter_map
                        (fun (c : R.channels_item) ->
                          match c with
                          | Stored_event { channel; _ } -> Some channel
                          | _ -> None)
                        bus.registry.channels)
                :: channels bus.registry);
              static_class "BusOperations" (operations bus);
            ];
        };
  }
