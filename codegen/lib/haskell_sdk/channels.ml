(* The Haskell SDK's bus: a constructor of Channel for each of the registry's
   channels, typed by its scope and its payload's model, and of Operation for
   each operation, typed by what it asks, answers and fails with; each
   failure's words and code, the code read as one of the bus request codes as
   errors/codes.json reads it; and the round trips the tests drive. A
   channel's payload is its schema's model, a stored event's the stored or
   enriched event response, an envelope's a model of the one response it
   holds, and an empty one's EmptyBusPayload. *)

module H = Haskell_syntax
module R = Tables.Bus_registry

let ( let* ) = Result.bind

type channel = {
  name : string;
  constructor : string;
  payload : string;  (** Its model's name. *)
  scoped : bool;
}

type operation = { request : channel; result : channel; failure : channel }

type t = {
  channels : channel list;
  operations : operation list;
  registry : R.t;
  envelopes : (string * Schema.t) list;
}

let each f xs =
  Result.map List.rev
    (List.fold_left
       (fun found x ->
         let* found = found in
         let* y = f x in
         Ok (y :: found))
       (Ok []) xs)

(* A channel's constructor: its name in Pascal case. *)
let member = Text.pascal

let reference name =
  Schema.Schema
    {
      Schema.empty with
      ref_ = Some { Decode.target = name ^ ".json"; file = ""; pointer = "" };
    }

let envelope response =
  Schema.Schema
    {
      Schema.empty with
      type_ = Some [ Object ];
      properties = Some [ ("response", reference response) ];
      required = Some [ "response" ];
      additional_properties = Some (Boolean_schema false);
    }

let empty_payload =
  Schema.Schema
    {
      Schema.empty with
      type_ = Some [ Object ];
      max_properties = Some 0;
      additional_properties = Some (Boolean_schema false);
    }

let derive (registry : R.t) =
  let scoped = registry.audience.scoped in
  let typed =
    List.map
      (fun (c : R.channels_item) ->
        let payload, extra =
          match c with
          | Schema { schema; _ } -> (schema, [])
          | Stored_event { enriched; _ } ->
              ( Bus.Registry.stored_event_component
                  ~enriched:(enriched = Some true),
                [] )
          | Envelope { schema; _ } ->
              let name = schema ^ "BusEnvelope" in
              (name, [ (name, envelope schema) ])
          | Empty _ | Void _ -> ("EmptyBusPayload", [])
        in
        ( {
            name = Bus.Registry.name c;
            constructor = member (Bus.Registry.name c);
            payload;
            scoped = List.mem (Bus.Registry.name c) scoped;
          },
          extra ))
      registry.channels
  in
  let channels = List.map fst typed in
  let distinct xs =
    List.length (List.sort_uniq String.compare xs) = List.length xs
  in
  let* () =
    if not (distinct (List.map (fun c -> c.name) channels)) then
      Error "duplicate bus channel"
    else if not (distinct (List.map (fun c -> c.constructor) channels)) then
      Error "colliding Haskell channel names"
    else Ok ()
  in
  let find name =
    match List.find_opt (fun c -> c.name = name) channels with
    | Some c -> Ok c
    | None -> Error ("operation names missing channel: " ^ name)
  in
  let* operations =
    each
      (fun (o : R.operations_item) ->
        let* request = find o.request in
        let* result = find o.result in
        let* failure = find o.failure in
        if request.scoped || result.scoped || failure.scoped then
          Error "operation channel unexpectedly needs resource scope"
        else Ok { request; result; failure })
      registry.operations
  in
  Ok
    {
      channels;
      operations;
      registry;
      envelopes =
        List.concat_map snd typed @ [ ("EmptyBusPayload", empty_payload) ];
    }

(* Each payload is a model. *)
let check t ~models =
  match List.find_opt (fun c -> not (List.mem c.payload models)) t.channels with
  | Some c -> Error ("unknown bus payload schema: " ^ c.payload)
  | None -> Ok ()

let limits t =
  let asked =
    List.filter
      (fun o ->
        o.request.payload = "InferenceLimitsRequest"
        && o.result.payload = "InferenceLimitsResult"
        && o.failure.payload = "CommandError")
      t.operations
  in
  let named =
    List.filter
      (fun c -> String.ends_with ~suffix:":limits-requested" c.name)
      t.channels
  in
  let sorted xs = List.sort String.compare xs in
  if
    sorted (List.map (fun o -> o.request.constructor) asked)
    = sorted (List.map (fun c -> c.constructor) named)
  then Ok asked
  else Error "inference limits operations changed shape"

let t_name n = H.T_name n
let types n = H.T_name ("Types." ^ n)
let scope_of c = H.T_promoted (if c.scoped then "Scoped" else "Global")
let channel_type scope payload = H.T_apply ("Channel", [ scope; payload ])
let any_channel = channel_type (t_name "scope") (t_name "payload")

let operation_type =
  H.T_apply ("Operation", [ t_name "input"; t_name "output"; t_name "failure" ])

let constructor_of o = o.request.constructor ^ "Operation"

let dispatch name type_ channels body =
  H.Value
    {
      about = [];
      name;
      type_;
      clauses =
        List.map
          (fun c ->
            { H.patterns = [ Constructor (c.constructor, []) ]; body = body c })
          channels;
    }

let texts values = H.List (List.map (fun v -> H.Str v) values)
let extensions = [ "DataKinds"; "GADTs"; "KindSignatures"; "OverloadedStrings" ]

let channels_file ~banner t ~limits =
  let registry = t.registry in
  let globals =
    List.fold_left
      (fun kept n -> if List.mem n kept then kept else kept @ [ n ])
      []
      (registry.audience.everyone
      @ List.concat_map
          (fun (o : R.operations_item) -> [ o.result; o.failure ])
          registry.operations)
  in
  let events =
    List.filter_map
      (fun (c : R.channels_item) ->
        match c with Stored_event { event; _ } -> Some event | _ -> None)
      registry.channels
  in
  let body =
    [
      H.data "Scope" [ H.constructor "Global"; H.constructor "Scoped" ];
      Gadt
        {
          about = [];
          name = "ScopeArg";
          params = [ ("scope", Some "Scope") ];
          constructors =
            [
              ("NoScope", T_apply ("ScopeArg", [ T_promoted "Global" ]));
              ( "InScope",
                T_fun
                  ( types "ResourceId",
                    T_apply ("ScopeArg", [ T_promoted "Scoped" ]) ) );
            ];
        };
      Gadt
        {
          about = [];
          name = "Channel";
          params = [ ("scope", Some "Scope"); ("payload", None) ];
          constructors =
            List.map
              (fun c ->
                (c.constructor, channel_type (scope_of c) (types c.payload)))
              t.channels;
        };
      dispatch "channelName"
        (T_fun (any_channel, t_name "Text"))
        t.channels
        (fun c -> Str c.name);
      H.value "channelNames"
        (T_list (t_name "Text"))
        (texts (List.map (fun c -> c.name) t.channels));
      H.value "globalChannels" (T_list (t_name "Text")) (texts globals);
      H.value "scopedChannels"
        (T_list (t_name "Text"))
        (texts registry.audience.scoped);
      dispatch "channelSchema"
        (T_fun (any_channel, t_name "Text"))
        t.channels
        (fun c -> Str c.payload);
      H.value "persistedEventTypes" (T_list (t_name "Text")) (texts events);
      dispatch "channelIsScoped"
        (T_fun (any_channel, t_name "Bool"))
        t.channels
        (fun c -> Name (if c.scoped then "True" else "False"));
      dispatch "encodePayload"
        (T_fun (any_channel, T_fun (t_name "payload", t_name "Value")))
        t.channels
        (fun _ -> Name "toJSON");
      dispatch "decodePayload"
        (T_fun
           ( any_channel,
             T_fun
               ( t_name "Value",
                 T_apply ("Either", [ t_name "String"; t_name "payload" ]) ) ))
        t.channels
        (fun c ->
          Compose
            ( Apply (Name "parseEither", [ Name "parseJSON" ]),
              Apply
                ( Name "Required.channelValue",
                  [ Apply (Name "channelName", [ Name c.constructor ]) ] ) ));
      Gadt
        {
          about = [];
          name = "Operation";
          params = [ ("input", None); ("output", None); ("failure", None) ];
          constructors =
            List.map
              (fun o ->
                ( constructor_of o,
                  H.T_apply
                    ( "Operation",
                      [
                        types o.request.payload;
                        types o.result.payload;
                        types o.failure.payload;
                      ] ) ))
              t.operations;
        };
      Gadt
        {
          about = [];
          name = "SomeOperation";
          params = [];
          constructors =
            [
              ("SomeOperation", T_fun (operation_type, t_name "SomeOperation"));
            ];
        };
      H.value "allOperations"
        (T_list (t_name "SomeOperation"))
        (List
           (List.map
              (fun o ->
                H.Apply (Name "SomeOperation", [ Name (constructor_of o) ]))
              t.operations));
      H.value "limitsOperations"
        (T_list
           (T_apply
              ( "Operation",
                [
                  types "InferenceLimitsRequest";
                  types "InferenceLimitsResult";
                  types "CommandError";
                ] )))
        (List (List.map (fun o -> H.Name (constructor_of o)) limits));
      Value
        {
          about = [];
          name = "operationChannels";
          type_ =
            T_fun
              ( operation_type,
                T_tuple
                  [
                    channel_type (T_promoted "Global") (t_name "input");
                    channel_type (T_promoted "Global") (t_name "output");
                    channel_type (T_promoted "Global") (t_name "failure");
                  ] );
          clauses =
            List.map
              (fun o ->
                {
                  H.patterns = [ Constructor (constructor_of o, []) ];
                  body =
                    Tuple
                      [
                        Name o.request.constructor;
                        Name o.result.constructor;
                        Name o.failure.constructor;
                      ];
                })
              t.operations;
        };
    ]
  in
  {
    H.banner;
    extensions;
    name = "Xynolog.Channels";
    imports =
      [
        H.import "Data.Aeson"
          ~items:[ Plain "Value"; Plain "toJSON"; Plain "parseJSON" ];
        H.import "Data.Aeson.Types" ~items:[ Plain "parseEither" ];
        H.import "Data.Text" ~items:[ Plain "Text" ];
        H.import "Xynolog.Internal.Required" ~qualified:"Required";
        H.import "Xynolog.Types" ~qualified:"Types";
      ];
    body;
  }

let round_trip_file ~banner t =
  let name_and_value = [ H.Var "name"; Var "value" ] in
  let by_name result fallback alternative =
    H.Case
      ( Name "name",
        List.map (fun c -> (H.Literal c.name, alternative c)) t.channels
        @ [ (H.Otherwise, H.Apply (Name "Left", [ Str fallback ])) ] )
    |> fun body -> (result, body)
  in
  let round_type, round_body =
    by_name
      (H.T_fun
         ( t_name "Text",
           T_fun
             ( t_name "Value",
               T_apply ("Either", [ t_name "String"; t_name "Value" ]) ) ))
      "unknown channel in round-trip dispatcher"
      (fun c ->
        Infix
          ( Apply (Name "encodePayload", [ Name c.constructor ]),
            [
              ( "<$>",
                Apply
                  (Name "decodePayload", [ Name c.constructor; Name "value" ])
              );
            ] ))
  in
  let metadata_type, metadata_body =
    by_name
      (H.T_fun
         ( t_name "Text",
           T_apply
             ( "Either",
               [
                 t_name "String";
                 T_tuple [ t_name "Text"; t_name "Text"; t_name "Bool" ];
               ] ) ))
      "unknown channel in metadata dispatcher"
      (fun c ->
        Apply
          ( Name "Right",
            [
              Tuple
                [
                  Apply (Name "channelName", [ Name c.constructor ]);
                  Apply (Name "channelSchema", [ Name c.constructor ]);
                  Apply (Name "channelIsScoped", [ Name c.constructor ]);
                ];
            ] ))
  in
  let name_of c = H.Apply (Name "channelName", [ Name c.constructor ]) in
  {
    H.banner;
    extensions;
    name = "Xynolog.Internal.Generated.ChannelRoundTrip";
    imports =
      [
        H.import "Data.Aeson" ~items:[ Plain "Value" ];
        H.import "Data.Text" ~items:[ Plain "Text" ];
        H.import "Xynolog.Channels";
      ];
    body =
      [
        Value
          {
            about = [];
            name = "roundTripChannel";
            type_ = round_type;
            clauses = [ { patterns = name_and_value; body = round_body } ];
          };
        Value
          {
            about = [];
            name = "channelMetadata";
            type_ = metadata_type;
            clauses = [ { patterns = [ Var "name" ]; body = metadata_body } ];
          };
        H.value "operationMetadata"
          (T_list (T_tuple [ t_name "Text"; t_name "Text"; t_name "Text" ]))
          (List
             (List.map
                (fun o ->
                  H.Tuple
                    [ name_of o.request; name_of o.result; name_of o.failure ])
                t.operations));
      ];
  }

type reader = {
  operation : operation;
  accessor : string;  (** The failure's words. *)
  failure : string;  (** The failure's model. *)
  code_type : string;  (** The model of its [code]. *)
  codes : (string * string) list;
      (** Each code it states, and the bus request code it is read as. *)
}

(* Each operation's failure: a model that requires its words as a string
   [message] and may state its [code], one of codes.json's wire codes. *)
let readers t ~normalize ~definition ~typing (codes : Tables.Errors_codes.t) =
  let wires =
    List.filter_map
      (fun (c : Tables.Errors_codes.codes_item) ->
        Option.map
          (fun w ->
            ( Tables.Errors_codes.command_error_code_value w,
              Error_codes.Haskell.code_constructor "busRequest" c.code ))
          c.wire)
      codes.bus_request.codes
  in
  each
    (fun (o : operation) ->
      let failure = o.failure.payload in
      let* schema = definition failure in
      let* s = normalize schema in
      let* code_type = Models.member_type typing failure "code" in
      let properties = Option.value s.Schema.properties ~default:[] in
      let required = Option.value s.required ~default:[] in
      let* () =
        if List.mem "code" required then
          Error
            "failure codes became required: update typed error classification"
        else
          match List.assoc_opt "message" properties with
          | Some (Schema.Schema { type_ = Some [ String ]; _ })
            when List.mem "message" required ->
              Ok ()
          | _ ->
              Error
                "operation failure does not require its words as a string \
                 `message`"
      in
      let* stated =
        match List.assoc_opt "code" properties with
        | Some (Schema.Schema { enum = Some values; _ }) ->
            each
              (function
                | Schema.String_literal v -> Ok v
                | _ -> Error "bus name is not a string")
              values
        | _ ->
            Error
              "operation failure states its code as one of no list: update \
               typed error classification"
      in
      let* mapped =
        each
          (fun v ->
            match List.assoc_opt v wires with
            | Some code -> Ok (v, code)
            | None ->
                Error
                  ("codes.json reads the failure code " ^ v
                 ^ " as no bus request code"))
          stated
      in
      Ok
        {
          operation = o;
          accessor = H.field failure "message";
          failure;
          code_type;
          codes = mapped;
        })
    t.operations

let failure_file ~banner ~unrecognized readers =
  let reader_of code_type = "from" ^ code_type in
  let operation_failure result =
    H.T_fun (operation_type, T_fun (t_name "failure", result))
  in
  let distinct =
    List.fold_left
      (fun kept r ->
        if List.exists (fun (t, c) -> t = r.code_type && c = r.codes) kept then
          kept
        else kept @ [ (r.code_type, r.codes) ])
      [] readers
  in
  {
    H.banner;
    extensions;
    name = "Xynolog.Internal.Generated.OperationFailure";
    imports =
      [
        H.import "Data.Text" ~items:[ Plain "Text" ];
        H.import "Xynolog.Channels";
        H.import "Xynolog.ErrorCodes" ~items:[ All "BusRequestCode" ];
        H.import "Xynolog.Types" ~qualified:"Types";
      ];
    body =
      Value
        {
          about = [];
          name = "message";
          type_ = operation_failure (t_name "Text");
          clauses =
            List.map
              (fun r ->
                {
                  H.patterns = [ Constructor (constructor_of r.operation, []) ];
                  body = Name ("Types." ^ r.accessor);
                })
              readers;
        }
      :: Value
           {
             about =
               [
                 "The bus request code of an operation's failure: the one its \
                  code is read as, and for no code the";
                 "unrecognized failure's.";
               ];
             name = "code";
             type_ = operation_failure (t_name "BusRequestCode");
             clauses =
               List.map
                 (fun r ->
                   {
                     H.patterns =
                       [ Constructor (constructor_of r.operation, []) ];
                     body =
                       Compose
                         ( Name (reader_of r.code_type),
                           Name ("Types." ^ H.field r.failure "code") );
                   })
                 readers;
           }
      :: List.map
           (fun (code_type, codes) ->
             H.Private
               (H.Value
                  {
                    about = [];
                    name = reader_of code_type;
                    type_ =
                      T_fun
                        ( T_apply ("Maybe", [ types code_type ]),
                          t_name "BusRequestCode" );
                    clauses =
                      [
                        {
                          patterns = [ Var "value" ];
                          body =
                            Case
                              ( Name "value",
                                ( H.Constructor ("Nothing", []),
                                  H.Name unrecognized )
                                :: List.map
                                     (fun (wire, code) ->
                                       ( H.Constructor
                                           ( "Just",
                                             [
                                               Constructor
                                                 ( "Types."
                                                   ^ Models.constructor
                                                       code_type
                                                       (String_literal wire),
                                                   [] );
                                             ] ),
                                         H.Name code ))
                                     codes );
                        };
                      ];
                  }))
           distinct;
  }
