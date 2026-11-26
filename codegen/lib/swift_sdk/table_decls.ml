(* The tables of protocol/specs/src as typed Swift values, with no JSON
   parser or fallback in the SDK: the timing, the error codes and how a
   status or a wire code becomes one, the tables held whole, the bus's
   channels and operations, what each schema requires, the cache's refresh
   rows and what a client keeps. Each table's own types are declared here,
   and the schemas they name join the models. *)

module S = Swift_syntax
module D = Definitions
module M = Models
module Shape = Required.Shape

let refuse = D.refuse
let name = M.name
let member = M.member
let call = M.call
let arg = M.arg
let labelled = M.labelled
let decl = M.decl
let string_type = M.string_type
let strings texts = S.Array (S.Inline, List.map (fun t -> S.String t) texts)
let case text = S.Implicit_member (M.enum_case text)

let string_schema =
  D.Node { (D.node [ "type" ]) with type_ = Some (D.One Schema.String) }

let constant ?(doc = []) modifiers n type_ value =
  decl ~doc modifiers
    (S.Property { var = false; name = n; type_; value = Some value })

let string_enumeration modifiers n values =
  M.enumeration ~modifiers n
    (List.map (fun v -> Schema.String_literal v) values)
    ~text:true

(* A schema without its null, and whether it allows null. *)
let nonnull = function
  | D.Node ({ type_ = Some (D.Or_null t); _ } as n) ->
      (D.Node { n with type_ = Some (D.One t) }, true)
  | D.Node { keys = [ "anyOf" ]; any_of = Some [ D.Null; inner ]; _ } ->
      (inner, true)
  | s -> (s, false)

let is_type kind = function
  | D.Node { type_ = Some (D.One k); _ } -> k = kind
  | _ -> false

(* A schema that says nothing of a value, only what it is or a note to its
   reader, as JsonSchema.json written in place does, admits any value. *)
let is_empty = function
  | D.Node { keys; _ } ->
      List.for_all
        (fun k -> List.mem k [ "$comment"; "description"; "title" ])
        keys
  | _ -> false

let properties_of = function
  | D.Node { properties = Some ps; _ } -> ps
  | _ -> []

let required_of = function D.Node { required = Some r; _ } -> r | _ -> []

(* The JSON value a table holds, as JSON Schema infers it: what every one of
   [values] is, each member of an object required where every object states
   it. *)
let rec infer (values : Yojson.Safe.t list) =
  let nonnull = List.filter (fun v -> v <> `Null) values in
  let typed kind = { (D.node [ "type" ]) with type_ = Some (D.One kind) } in
  let inferred =
    match nonnull with
    | [] -> None
    | `String _ :: _ ->
        if List.exists (function `String _ -> false | _ -> true) nonnull then
          refuse "mixed table field";
        Some (typed Schema.String)
    | (`Int _ | `Float _) :: _ ->
        let whole =
          List.for_all
            (function
              | `Int _ -> true
              | `Float f -> Float.is_integer f
              | _ -> refuse "mixed table field")
            nonnull
        in
        Some (typed (if whole then Schema.Integer else Schema.Number))
    | `Bool _ :: _ -> Some (typed Schema.Boolean)
    | `List _ :: _ ->
        let elements =
          List.concat_map
            (function `List l -> l | _ -> refuse "mixed table field")
            nonnull
        in
        Some
          {
            (D.node [ "type"; "items" ]) with
            type_ = Some (D.One Schema.Array);
            items = Some (infer elements);
          }
    | `Assoc _ :: _ ->
        let objects =
          List.map
            (function `Assoc o -> o | _ -> refuse "mixed table field")
            nonnull
        in
        let keys =
          List.sort_uniq String.compare (List.concat_map (List.map fst) objects)
        in
        let entries key = List.filter_map (List.assoc_opt key) objects in
        Some
          {
            (D.node [ "type"; "properties"; "required" ]) with
            type_ = Some (D.One Schema.Object);
            properties = Some (List.map (fun k -> (k, infer (entries k))) keys);
            required =
              Some
                (List.filter
                   (fun k -> List.length (entries k) = List.length objects)
                   keys);
          }
    | _ -> refuse "a table value of no kind"
  in
  match inferred with
  | None -> D.Node (D.node [])
  | Some n when List.length nonnull = List.length values -> D.Node n
  | Some ({ type_ = Some (D.One kind); _ } as n) ->
      D.Node { n with type_ = Some (D.Or_null kind) }
  | Some n -> D.Node n

let rec json_expression (value : Yojson.Safe.t) =
  match value with
  | `Null -> S.Implicit_member "null"
  | `Bool b -> call (S.Implicit_member "bool") [ S.Bool b ]
  | `Int i -> call (S.Implicit_member "number") [ S.Float (float_of_int i) ]
  | `Float f -> call (S.Implicit_member "number") [ S.Float f ]
  | `String s -> call (S.Implicit_member "string") [ S.String s ]
  | `List l ->
      call (S.Implicit_member "array")
        [ S.Array (S.Inline, List.map json_expression l) ]
  | `Assoc o ->
      call (S.Implicit_member "object")
        [
          S.Dictionary
            ( S.Inline,
              List.map
                (fun (k, v) -> (S.String k, json_expression v))
                (List.sort (fun (a, _) (b, _) -> String.compare a b) o) );
        ]
  | _ -> refuse "a table value of no kind"

let rec expression models (value : Yojson.Safe.t) type_ ~owner ~part =
  let resolved, _ = nonnull type_ in
  if is_empty resolved then json_expression value
  else
    match value with
    | `Null -> S.Nil
    | `Bool b -> S.Bool b
    | `String s -> (
        (* A word of a vocabulary ([vocabulary]) is its enumeration's case. *)
        match resolved with
        | D.Ref _ -> case s
        | _ -> S.String s)
    | `Int i -> S.Int i
    | `Float f ->
        if Float.is_integer f then S.Int (int_of_float f) else S.Float f
    | `List l ->
        let item =
          match resolved with
          | D.Node { items = Some item; _ } -> item
          | _ -> refuse "table lacks items"
        in
        S.Array
          ( S.Inline,
            List.map
              (fun v -> expression models v item ~owner ~part:(part ^ "Item"))
              l )
    | `Assoc o ->
        let type_name =
          match M.type_ models owner part resolved with
          | S.Named n -> n
          | _ -> refuse "%s.%s is no object" owner part
        in
        let required = required_of resolved in
        labelled (name type_name)
          (List.filter_map
             (fun (key, field) ->
               match List.assoc_opt key o with
               | None -> None
               | Some entry ->
                   let v =
                     expression models entry field ~owner:type_name ~part:key
                   in
                   let v =
                     if (not (List.mem key required)) && snd (nonnull field)
                     then
                       if entry = `Null then S.Implicit_member "null"
                       else call (S.Implicit_member "value") [ v ]
                     else v
                   in
                   Some (arg (M.member_name key) v))
             (List.sort
                (fun (a, _) (b, _) -> String.compare a b)
                (properties_of resolved)))
    | _ -> refuse "a table value of no kind"

(* A vocabulary a table states, as the public enumeration [n] of its words,
   and the type of a member that states one of them. *)
let vocabulary models n words =
  match
    M.inline models ~modifiers:[ "public" ] "" n
      (D.Node
         {
           (D.node [ "type"; "enum" ]) with
           type_ = Some (D.One Schema.String);
           enum = Some (List.map (fun w -> Schema.String_literal w) words);
         })
  with
  | S.Named name when name = n -> D.Ref { name; description = None }
  | _ -> refuse "the vocabulary %s is declared by another name" n

(* [shape], the rows of a list, with its rows' member [key] typed [type_]. *)
let typing_rows ~key type_ = function
  | D.Node
      ({ items = Some (D.Node ({ properties = Some ps; _ } as row)); _ } as list)
    when List.mem_assoc key ps ->
      D.Node
        {
          list with
          items =
            Some
              (D.Node
                 {
                   row with
                   properties =
                     Some
                       (List.map
                          (fun (k, s) -> (k, if k = key then type_ else s))
                          ps);
                 });
        }
  | _ -> refuse "a table's rows state no %s" key

(* Timings *)

(* Each entry a constant, a retry budget the model of client/RetryBudget.json. *)
let timings (entries : Timing.Table.t) =
  [
    decl [ "public" ]
      (S.Enum
         {
           name = "Timings";
           inherits = [];
           layout = S.Lines;
           members =
             List.map
               (fun (entry : Timing.Table.entry) ->
                 match entry.value with
                 | Duration n | Count n ->
                     constant [ "public"; "static" ] entry.name
                       (Some (S.Named "Int")) (S.Int n)
                 | Budget { attempts; initial_delay_ms; max_delay_ms } ->
                     constant [ "public"; "static" ] entry.name None
                       (labelled (name "RetryBudget")
                          [
                            arg "attempts" (S.Int attempts);
                            arg "initialDelayMs" (S.Int initial_delay_ms);
                            arg "maxDelayMs" (S.Int max_delay_ms);
                          ]))
               entries;
         });
  ]

(* Error codes *)

let error_codes models ~shapes (codes : Error_codes.Table.t) =
  let wire_codes = Error_codes.Table.wire_codes in
  let enums =
    List.map
      (fun (v : Error_codes.Table.vocabulary) ->
        string_enumeration [ "public" ]
          (snd (Code_names.named v.member))
          (List.map (fun (c : Error_codes.Table.code) -> c.code) v.codes))
      (List.sort
         (fun (a : Error_codes.Table.vocabulary) b ->
           String.compare a.member b.member)
         (Error_codes.Table.vocabularies codes))
  in
  let returns (code : Error_codes.Table.code) =
    S.Return (Some (case code.code))
  in
  let status = name "status" in
  let transport =
    decl [ "internal" ]
      (S.Func
         {
           name = "transportErrorCode";
           generics = [];
           params =
             [
               {
                 label = Some "for";
                 name = "status";
                 type_ = S.Named "Int";
                 default = None;
               };
             ];
           throws = false;
           result = Some (S.Named codes.transport.name);
           body =
             M.line_block
               (List.map
                  (fun (op, (n, code)) ->
                    S.If
                      {
                        conditions = [ S.Is (S.Binary (status, op, S.Int n)) ];
                        body = M.inline_block [ returns code ];
                        else_ = None;
                      })
                  (List.map (fun e -> ("==", e)) codes.exact
                  @ List.map (fun e -> (">=", e)) (Option.to_list codes.from))
               @ [ returns codes.unclassified ]);
         })
  in
  let code_schema =
    match
      List.assoc_opt "code" (properties_of (M.schema models "CommandError"))
    with
    | Some s -> s
    | None -> refuse "CommandError has no code"
  in
  let recognized =
    match List.assoc_opt "CommandError" shapes with
    | Some (Shape.Shape { members; _ }) -> (
        match List.assoc_opt "code" members with
        | Some (Shape.Shape { recognized = Some r; _ }) -> r
        | _ ->
            refuse
              "the table of what each schema requires recognizes no \
               CommandError code")
    | _ ->
        refuse "the table of what each schema requires states no CommandError"
  in
  if List.sort String.compare recognized <> List.sort String.compare wire_codes
  then
    refuse "the table recognizes the codes [%s], and CommandError lists [%s]"
      (String.concat ", " recognized)
      (String.concat ", " wire_codes);
  let bus =
    decl [ "internal" ]
      (S.Func
         {
           name = "busRequestCode";
           generics = [];
           params =
             [
               {
                 label = Some "for";
                 name = "wire";
                 type_ = M.type_ models "CommandError" "code" code_schema;
                 default = None;
               };
             ];
           throws = false;
           result = Some (S.Named codes.bus.name);
           body =
             M.line_block
               [
                 S.Switch
                   {
                     subject = name "wire";
                     layout = S.Lines;
                     cases =
                       List.map
                         (fun wire ->
                           match List.assoc_opt wire codes.wire with
                           | Some code ->
                               {
                                 S.patterns = [ case wire ];
                                 body = [ returns code ];
                               }
                           | None ->
                               refuse
                                 "CommandError's code %s becomes no bus \
                                  request code in codes.json"
                                 wire)
                         wire_codes;
                   };
               ];
         })
  in
  enums
  @ [
      transport;
      bus;
      constant [ "internal" ] "unrecognizedBusFailure"
        (Some (S.Named codes.bus.name))
        (case codes.unrecognized.code);
      constant
        ~doc:
          [
            "Each gateway refusal of a limit that is a transport code too: its \
             status, its LimitRefusal code, and the transport code it is.";
          ]
        [ "internal" ] "limitRefusalTransportCodes"
        (Some
           (S.Array_of
              (S.Tuple_of
                 [
                   S.Named "Int"; S.Named "String"; S.Named codes.transport.name;
                 ])))
        (S.Array
           ( S.Lines,
             List.map
               (fun (status, limit, (c : Error_codes.Table.code)) ->
                 S.Tuple [ S.Int status; S.String limit; case c.code ])
               codes.limit_refusals ));
    ]

(* What each schema requires, as Sources/Xynolog/Bus/Required.swift reads it *)

let rec shape_literal : Shape.shape -> S.expr = function
  | Ref n -> labelled (name "Shape") [ arg "ref" (S.String n) ]
  | Shape
      {
        kinds;
        recognized;
        enum;
        pattern;
        min_length;
        max_length;
        minimum;
        maximum;
        min_items;
        max_items;
        required;
        members;
        closed;
        items;
        values;
        one_of;
        discriminator;
        all_of;
        not_all;
        min_members;
        names;
      } ->
      let part label write = Option.map (fun v -> arg label (write v)) in
      let listed label write = function
        | [] -> None
        | items -> Some (arg label (S.Array (S.Inline, List.map write items)))
      in
      let listed_literal : Schema.literal -> S.expr = function
        | String_literal s -> call (S.Implicit_member "string") [ S.String s ]
        | Int_literal i ->
            call (S.Implicit_member "number") [ S.Float (float_of_int i) ]
        | Bool_literal b -> call (S.Implicit_member "bool") [ S.Bool b ]
      in
      let max = function Some m -> S.Int m | None -> S.Nil in
      let rec term : Shape.term -> S.expr = function
        | Step { of_; min; max = most } ->
            call (S.Implicit_member "step")
              [
                labelled (name "Step")
                  [
                    arg "of"
                      (S.Array
                         ( S.Inline,
                           List.map
                             (fun (lo, hi) ->
                               S.Binary (S.Int lo, "...", S.Int hi))
                             of_ ));
                    arg "min" (S.Int min);
                    arg "max" (max most);
                  ];
              ]
        | Group { either; min; max = most } ->
            call (S.Implicit_member "group")
              [
                labelled (name "Group")
                  [
                    arg "either"
                      (S.Array
                         ( S.Inline,
                           List.map
                             (fun terms ->
                               S.Array (S.Inline, List.map term terms))
                             either ));
                    arg "min" (S.Int min);
                    arg "max" (max most);
                  ];
              ]
      in
      labelled (name "Shape")
        (List.filter_map Fun.id
           [
             part "kinds"
               (fun ks ->
                 S.Array
                   ( S.Inline,
                     List.map
                       (fun k -> S.Implicit_member (Shape.kind_name k))
                       ks ))
               kinds;
             part "recognized" strings recognized;
             part "enumeration"
               (fun vs -> S.Array (S.Inline, List.map listed_literal vs))
               enum;
             part "pattern"
               (fun terms -> S.Array (S.Inline, List.map term terms))
               pattern;
             part "minLength" (fun n -> S.Int n) min_length;
             part "maxLength" (fun n -> S.Int n) max_length;
             part "minimum" (fun f -> S.Float f) minimum;
             part "maximum" (fun f -> S.Float f) maximum;
             part "minItems" (fun n -> S.Int n) min_items;
             part "maxItems" (fun n -> S.Int n) max_items;
             part "required" strings required;
             (match members with
             | [] -> None
             | members ->
                 Some
                   (arg "members"
                      (S.Dictionary
                         ( S.Inline,
                           List.map
                             (fun (k, s) -> (S.String k, shape_literal s))
                             (List.sort
                                (fun (a, _) (b, _) -> String.compare a b)
                                members) ))));
             part "closed" strings closed;
             part "items" shape_literal items;
             part "values" shape_literal values;
             listed "oneOf" shape_literal one_of;
             part "discriminator"
               (fun ({ property; mapping } : Shape.discriminator) ->
                 labelled (name "Discriminator")
                   [
                     arg "property" (S.String property);
                     arg "mapping"
                       (S.Dictionary
                          ( S.Inline,
                            List.map
                              (fun (v, i) -> (S.String v, S.Int i))
                              (List.sort
                                 (fun (a, _) (b, _) -> String.compare a b)
                                 mapping) ));
                   ])
               discriminator;
             listed "allOf" shape_literal all_of;
             listed "notAll" strings not_all;
             part "minMembers" (fun n -> S.Int n) min_members;
             part "names" shape_literal names;
           ])

(* A table of shapes by name, built one entry to a statement: the type
   checker takes one dictionary literal of every shape as a single
   expression, which outgrows its time and memory. *)
let shape_table n entries =
  let shape_type = M.dictionary_of (S.Named "Shape") in
  constant [ "internal" ] n (Some shape_type)
    (call
       (S.Closure
          {
            params = [];
            layout = S.Lines;
            body =
              S.Let
                {
                  var = true;
                  name = "shapes";
                  type_ = Some shape_type;
                  value = S.Dictionary (S.Inline, []);
                }
              :: List.map
                   (fun (key, shape) ->
                     M.assign
                       (S.Subscript
                          ( name "shapes",
                            [ { label = None; value = S.String key } ] ))
                       shape)
                   (List.sort (fun (a, _) (b, _) -> String.compare a b) entries)
              @ [ S.Return (Some (name "shapes")) ];
          })
       [])

(* The stamps a schema's members declare: its members whose names begin
   with an underscore. *)
let rec stamps models ?(seen = []) raw =
  let s, _ = nonnull raw in
  match s with
  | D.Ref { name = r; _ } ->
      if List.mem r seen then []
      else stamps models ~seen:(r :: seen) (M.schema models r)
  | D.Node { one_of = Some members; _ } | D.Node { any_of = Some members; _ }
    -> (
      match List.map (stamps models ~seen) members with
      | first :: others when List.for_all (( = ) first) others -> first
      | _ -> refuse "union members have different stamps")
  | D.Node n ->
      List.sort_uniq String.compare
        (List.filter
           (fun k -> String.starts_with ~prefix:"_" k)
           (List.map fst (Option.value n.properties ~default:[]))
        @ List.concat_map (stamps models ~seen)
            (Option.value n.all_of ~default:[]))
  | D.Null | D.Bool _ -> []

let channel_types =
  let payload_generic n =
    {
      S.name = n;
      conforms = S.Composition [ S.Named "Codable"; S.Named "Sendable" ];
    }
  in
  let field ?(modifiers = []) n type_ =
    decl modifiers
      (S.Property { var = false; name = n; type_ = Some type_; value = None })
  in
  let structure n generics inherits members =
    decl [ "public" ]
      (S.Struct
         {
           name = n;
           generics = List.map payload_generic generics;
           inherits;
           layout = S.Lines;
           members;
         })
  in
  let channel n =
    structure n [ "Payload" ] [ S.Named "Sendable" ]
      [
        field ~modifiers:[ "public" ] "name" string_type;
        field ~modifiers:[ "public" ] "stamps"
          (S.Generic ("Set", [ string_type ]));
      ]
  in
  [
    channel "Channel";
    channel "ScopedChannel";
    structure "ResponseEnvelope" [ "Payload" ] M.codable
      [ field ~modifiers:[ "public" ] "response" (S.Named "Payload") ];
    structure "Operation"
      [ "Request"; "Result"; "Failure" ]
      [ S.Named "Sendable" ]
      [
        field ~modifiers:[ "public" ] "request"
          (S.Generic ("Channel", [ S.Named "Request" ]));
        field ~modifiers:[ "public" ] "result"
          (S.Generic ("Channel", [ S.Named "Result" ]));
        field ~modifiers:[ "public" ] "failure"
          (S.Generic ("Channel", [ S.Named "Failure" ]));
        field ~modifiers:[ "public" ] "replyNames" (S.Array_of string_type);
      ];
  ]

type row = { payload : S.type_; schema : D.t option; stamps : string list }

let channels models ~shapes (registry : Tables.Bus_registry.t) =
  let scoped = registry.audience.scoped
  and everyone = registry.audience.everyone in
  let component n =
    if not (List.mem_assoc n shapes) then
      refuse "%s is in no table of what a schema requires" n;
    labelled (name "Shape") [ arg "ref" (S.String n) ]
  in
  ignore
    (M.inline models ~modifiers:[ "public" ] "Bus" "EmptyPayload"
       (D.Node
          {
            (D.node [ "type"; "additionalProperties" ]) with
            type_ = Some (D.One Schema.Object);
            additional_properties = Some (D.Bool false);
          }));
  let rows = Hashtbl.create 128
  and stored_events = ref []
  and payload_shapes = ref [] in
  let channel_decls =
    List.map
      (fun (c : Tables.Bus_registry.channels_item) ->
        let n = Bus.Registry.name c in
        if Hashtbl.mem rows n then refuse "duplicate channel %s" n;
        let row, shape =
          match c with
          | Schema { schema; _ } ->
              let s = M.schema models schema in
              ignore (M.named models schema);
              ( {
                  payload = S.Named schema;
                  schema = Some s;
                  stamps = stamps models s;
                },
                component schema )
          | Envelope { schema; _ } ->
              ignore (M.named models schema);
              ( {
                  payload = S.Generic ("ResponseEnvelope", [ S.Named schema ]);
                  schema = None;
                  stamps = [];
                },
                labelled (name "Shape")
                  [
                    arg "kinds"
                      (S.Array (S.Inline, [ S.Implicit_member "object" ]));
                    arg "required" (strings [ "response" ]);
                    arg "members"
                      (S.Dictionary
                         (S.Inline, [ (S.String "response", component schema) ]));
                  ] )
          | Stored_event { payload; enriched; _ } ->
              stored_events := n :: !stored_events;
              ignore (M.schema models payload);
              let p =
                if enriched = Some true then "EnrichedResourceEvent"
                else "StoredEventResponse"
              in
              ignore (M.named models p);
              ( {
                  payload = S.Named p;
                  schema = None;
                  stamps = stamps models (M.schema models p);
                },
                component p )
          | Void _ | Empty _ ->
              ( {
                  payload = S.Named "BusEmptyPayload";
                  schema = None;
                  stamps = [];
                },
                labelled (name "Shape")
                  [
                    arg "kinds"
                      (S.Array (S.Inline, [ S.Implicit_member "object" ]));
                  ] )
        in
        Hashtbl.replace rows n row;
        payload_shapes := (n, shape) :: !payload_shapes;
        decl [ "public"; "static" ]
          (S.Property
             {
               var = false;
               name = M.member_name n;
               type_ =
                 Some
                   (S.Generic
                      ( (if List.mem n scoped then "ScopedChannel" else "Channel"),
                        [ row.payload ] ));
               value =
                 Some
                   (labelled (S.Implicit_member "init")
                      [
                        arg "name" (S.String n);
                        arg "stamps" (call (name "Set") [ strings row.stamps ]);
                      ]);
             }))
      registry.channels
  in
  if List.exists (fun n -> not (Hashtbl.mem rows n)) (scoped @ everyone) then
    refuse "audience names an unknown channel";
  let row n =
    match Hashtbl.find_opt rows n with
    | Some r when not (List.mem n scoped) -> r
    | _ -> refuse "operation channel %s is missing or scoped" n
  in
  let channel_of n = member (name "Channels") (M.member_name n) in
  let replies = ref [] and limits = ref [] in
  let operation_decls =
    List.map
      (fun (op : Tables.Bus_registry.operations_item) ->
        let request = row op.request
        and result = row op.result
        and failure = row op.failure in
        replies := op.result :: op.failure :: !replies;
        if String.ends_with ~suffix:":limits-requested" op.request then
          limits := name (M.member_name op.request) :: !limits;
        let answer = Option.map D.meant result.schema in
        (match answer with
        | Some (D.Node { one_of = Some _; _ } | D.Node { any_of = Some _; _ })
          ->
            refuse "union reply needs explicit reply-name handling"
        | _ -> ());
        let reply_names =
          List.filter (( <> ) "response")
            (Option.fold ~none:[] ~some:required_of answer)
        in
        (if reply_names <> [] then
           let request_schema =
             match request.schema with
             | Some s -> s
             | None -> refuse "reply names without request schema"
           in
           let properties = properties_of (D.meant request_schema) in
           if
             not
               (List.for_all (fun r -> List.mem_assoc r properties) reply_names)
           then refuse "reply names missing from request");
        decl [ "public"; "static" ]
          (S.Property
             {
               var = false;
               name = M.member_name op.request;
               type_ =
                 Some
                   (S.Generic
                      ( "Operation",
                        [ request.payload; result.payload; failure.payload ] ));
               value =
                 Some
                   (labelled (S.Implicit_member "init")
                      [
                        arg "request" (channel_of op.request);
                        arg "result" (channel_of op.result);
                        arg "failure" (channel_of op.failure);
                        arg "replyNames" (strings reply_names);
                      ]);
             }))
      registry.operations
  in
  let wire_operations =
    List.map
      (fun (op : Tables.Bus_registry.operations_item) ->
        let request = Hashtbl.find rows op.request
        and response = Hashtbl.find rows op.result in
        let failure_schema =
          match (Hashtbl.find rows op.failure).schema with
          | Some s -> D.meant s
          | None -> refuse "failure channel has no schema"
        in
        (match List.assoc_opt "message" (properties_of failure_schema) with
        | Some message
          when List.mem "message" (required_of failure_schema)
               && is_type Schema.String (fst (nonnull message)) ->
            ()
        | _ -> refuse "failure message must be a required string");
        let stamps_of n = member (channel_of n) "stamps" in
        let project (r : row) n =
          S.Closure
            {
              params = [];
              layout = S.Inline;
              body =
                [
                  S.Expr
                    (S.Try
                       (labelled (name "projectWire")
                          [
                            { label = None; value = M.type_self r.payload };
                            { label = None; value = name "$0" };
                            arg "stamps" (stamps_of n);
                          ]));
                ];
            }
        in
        ( S.String op.request,
          labelled (name "WireOperation")
            [
              arg "result" (S.String op.result);
              arg "resultStamps" (stamps_of op.result);
              arg "failure" (S.String op.failure);
              arg "failureStamps" (stamps_of op.failure);
              arg "request" (project request op.request);
              arg "response" (project response op.result);
            ] ))
      registry.operations
  in
  let replies = !replies in
  if List.exists (fun n -> List.mem n everyone || List.mem n replies) scoped
  then refuse "channel delivered both scoped and everywhere";
  let enum n members =
    decl [ "public" ]
      (S.Enum { name = n; inherits = []; layout = S.Lines; members })
  in
  let limits_decl =
    decl [ "public"; "static" ]
      (S.Property
         {
           var = false;
           name = "limits";
           type_ =
             Some
               (S.Array_of
                  (S.Generic
                     ( "Operation",
                       [
                         S.Named "InferenceLimitsRequest";
                         S.Named "InferenceLimitsResult";
                         S.Named "CommandError";
                       ] )));
           value = Some (S.Array (S.Inline, List.rev !limits));
         })
  in
  ( channel_types
    @ [
        enum "Channels" channel_decls;
        enum "Operations" (operation_decls @ [ limits_decl ]);
        constant [ "internal" ] "wireOperations"
          (Some (M.dictionary_of (S.Named "WireOperation")))
          (S.Dictionary (S.Lines, wire_operations));
        constant
          ~doc:
            [
              "The global channels a full client's transport is given: every \
               channel delivered to everyone, and every operation's reply \
               channels.";
            ]
          [ "public" ] "bridgedChannels" None
          (strings (List.sort_uniq String.compare (everyone @ replies)));
        constant
          ~doc:
            [
              "The channels delivered to a transport for each resource whose \
               scope it holds, as the registry orders them.";
            ]
          [ "public" ] "resourceScopedChannels" None (strings scoped);
        constant [ "public" ] "persistedEventTypes" None
          (strings (List.rev !stored_events));
        shape_table "requiredSchemas"
          (List.map (fun (n, s) -> (n, shape_literal s)) shapes);
        shape_table "requiredPayloadShapes" !payload_shapes;
      ],
    List.of_seq (Hashtbl.to_seq_keys rows) )

(* client/refresh.json as typed rows *)

let cache_refresh (refresh : Tables.Client_refresh.t) ~channels =
  let queries =
    List.map
      (fun q ->
        let name, _, _, _, _ = Cache_refresh.Table.query_fields q in
        name)
      refresh.queries
  in
  if List.length (List.sort_uniq String.compare queries) <> List.length queries
  then refuse "duplicate cache query";
  let triggers = ref [] in
  let way = function
    | None -> S.Nil
    | Some text ->
        let names = String.split_on_char '.' text in
        if List.mem "" names then refuse "%s is no way to a member" text;
        strings names
  in
  let rows =
    List.map
      (fun (row : Tables.Client_refresh.refresh_item) ->
        let module R = Cache_refresh.Table in
        let trigger = R.trigger_name row in
        (match row with
        | On { on = channel; _ } when not (List.mem channel channels) ->
            refuse "unknown cache refresh trigger %s" channel
        | On _ | Stream _ -> ());
        if not (List.mem trigger !triggers) then
          triggers := !triggers @ [ trigger ];
        let names =
          Option.value (R.names_of row)
            ~default:
              { Tables.Client_refresh.resource = None; annotation = None }
        in
        let listed key (queries_named : string list option) =
          arg key
            (S.Array
               ( S.Inline,
                 List.map
                   (fun q ->
                     if not (List.mem q queries) then
                       refuse "unknown cache query %s" q;
                     case q)
                   (Option.value queries_named ~default:[]) ))
        in
        labelled (name "CacheRefreshRow")
          [
            arg "trigger" (case trigger);
            arg "when"
              (match R.when_of row with
              | None -> S.Nil
              | Some Enriched -> case "enriched"
              | Some Unenriched -> case "unenriched");
            arg "reach"
              (case
                 (match R.reach_of row with
                 | None | Some Subject -> "subject"
                 | Some Held -> "held"));
            arg "resource" (way names.resource);
            arg "annotation" (way names.annotation);
            arg "carries" (way (R.carries_of row));
            listed "refetches" (R.refetches_of row);
            listed "writes" (R.writes_of row);
            listed "removes" (R.removes_of row);
          ])
      refresh.refresh
  in
  let triggers = !triggers in
  let field n type_ =
    decl []
      (S.Property { var = false; name = n; type_ = Some type_; value = None })
  in
  let query_list = S.Array_of (S.Named "CacheQuery") in
  let ways = S.Optional (S.Array_of string_type) in
  List.map
    (fun (n, values) -> string_enumeration [ "internal" ] n values)
    [
      ("CacheQuery", queries);
      ("CacheRefreshTrigger", triggers);
      ("CacheRefreshWhen", [ "enriched"; "unenriched" ]);
      ("CacheRefreshReach", [ "subject"; "held" ]);
    ]
  @ [
      decl
        ~doc:
          [
            "What one trigger does to the cache. `resource` and `annotation` \
             are the ways into its";
            "event's payload to the keys a `subject` row reaches, and \
             `carries` the way to the value";
            "it writes: each the names of the members it is within, and its \
             own.";
          ]
        [ "internal" ]
        (S.Struct
           {
             name = "CacheRefreshRow";
             generics = [];
             inherits = [ S.Named "Sendable" ];
             layout = S.Lines;
             members =
               [
                 field "trigger" (S.Named "CacheRefreshTrigger");
                 field "when" (S.Optional (S.Named "CacheRefreshWhen"));
                 field "reach" (S.Named "CacheRefreshReach");
                 field "resource" ways;
                 field "annotation" ways;
                 field "carries" ways;
                 field "refetches" query_list;
                 field "writes" query_list;
                 field "removes" query_list;
               ];
           });
      constant [ "internal" ] "cacheRefresh"
        (Some (S.Array_of (S.Named "CacheRefreshRow")))
        (S.Array (S.Lines, rows));
      constant
        ~doc:
          [
            "The triggers that are channels of the bus, with the stamps each \
             payload declares.";
          ]
        [ "internal" ] "cacheRefreshChannels"
        (Some
           (S.Dictionary_of
              (S.Named "CacheRefreshTrigger", S.Generic ("Set", [ string_type ]))))
        (S.Dictionary
           ( S.Lines,
             List.filter_map
               (fun trigger ->
                 if List.mem trigger channels then
                   Some
                     ( case trigger,
                       member
                         (member (name "Channels") (M.member_name trigger))
                         "stamps" )
                 else None)
               triggers ));
    ]

(* What a client keeps, as Sources/Xynolog/CachePersistence.swift reads it *)

let component_name path = Filename.remove_extension (Filename.basename path)

(* The type a table's schema refers to: a component schema, or one member of
   one. *)
let stored_type models ~of_ (target : string) =
  match String.split_on_char '#' target with
  | [ file ] -> M.named models (component_name file)
  | [ file; way ] -> (
      let n = component_name file in
      match String.split_on_char '/' way with
      | [ ""; "properties"; m ] -> (
          match List.assoc_opt m (properties_of (M.schema models n)) with
          | Some s -> M.type_ models n m s
          | None -> refuse "%s refers to no member of %s" of_ n)
      | _ -> refuse "%s refers to no member of %s" of_ n)
  | _ -> refuse "%s is no reference to a component schema" of_

let kept models ~shapes (refresh : Tables.Client_refresh.t)
    (stored : Tables.Session_stored.t) =
  let persisted =
    List.filter_map
      (fun q ->
        let name, per, persisted, value, _ =
          Cache_refresh.Table.query_fields q
        in
        if not persisted then None
        else
          let key =
            match per with
            | None -> "WholeKey"
            | Some Resource -> "ResourceId"
            | Some Annotation -> "AnnotationId"
            | Some Filters ->
                refuse "%s is persisted per filters, which keeps nothing" name
          in
          Some (name, key, stored_type models ~of_:name value.target))
      refresh.queries
  in
  let kept_name q = "Kept" ^ Text.pascal q in
  let version =
    let at pointer = Decode.at_pointer pointer stored.cache_document in
    let items = "/properties/entries/items" in
    let required =
      match at "/required" with
      | Some (`List names) ->
          List.sort compare
            (List.filter_map
               (function `String name -> Some name | _ -> None)
               names)
      | _ -> []
    in
    match (at (items ^ "/prefixItems/2"), at "/properties/version/const") with
    | Some (`Assoc stamp), Some (`Int version)
      when required = [ "entries"; "version" ]
           && at (items ^ "/minItems") = Some (`Int 3)
           && at (items ^ "/maxItems") = Some (`Int 3)
           && List.assoc_opt "type" stamp = Some (`String "integer")
           && List.assoc_opt "minimum" stamp = Some (`Int 0) ->
        version
    | _ ->
        refuse
          "session/stored.json's cacheDocument is not the document \
           Sources/Xynolog/CachePersistence.swift reads"
  in
  let referred : Schema.t option -> string = function
    | Some (Schema { ref_ = Some r; _ }) -> r.target
    | _ -> refuse "session/stored.json's lastEventIds names no schema"
  in
  let places =
    match stored.last_event_ids with
    | Schema s -> s
    | Boolean_schema _ ->
        refuse "session/stored.json's lastEventIds is no schema"
  in
  (match
     stored_type models ~of_:"lastEventIds" (referred places.property_names)
   with
  | S.Named "ResourceId" -> ()
  | _ -> refuse "places are kept by a type no scope is");
  let place = component_name (referred places.additional_properties) in
  if not (List.mem_assoc place shapes) then
    refuse "places are held to %s, which no shape states" place;
  let enum =
    string_enumeration [ "internal" ] "KeptQuery"
      (List.map (fun (n, _, _) -> n) persisted)
  in
  [
    {
      enum with
      S.doc =
        [
          "The live queries whose answers a client keeps across its lives, for \
           the person";
          "signed in.";
        ];
    };
  ]
  @ List.map
      (fun (n, _, value) ->
        decl [ "internal" ] (S.Typealias { name = kept_name n; type_ = value }))
      persisted
  @ [
      decl []
        (S.Extension
           {
             name = "KeptQuery";
             layout = S.Lines;
             members =
               [
                 decl
                   ~doc:
                     [
                       "What `text` keeps of this query: each entry whose key \
                        and value it keeps.";
                     ]
                   []
                   (S.Func
                      {
                        name = "document";
                        generics = [];
                        params =
                          [
                            {
                              label = Some "_";
                              name = "text";
                              type_ = S.Optional string_type;
                              default = None;
                            };
                          ];
                        throws = false;
                        result = Some (S.Named "KeptDocument");
                        body =
                          M.line_block
                            [
                              S.Switch
                                {
                                  subject = name "self";
                                  layout = S.Lines;
                                  cases =
                                    List.map
                                      (fun (n, key, _) ->
                                        {
                                          S.patterns = [ case n ];
                                          body =
                                            [
                                              S.Expr
                                                (labelled (name "KeptDocument")
                                                   [
                                                     {
                                                       label = None;
                                                       value = name "text";
                                                     };
                                                     arg "keys"
                                                       (M.type_self
                                                          (S.Named key));
                                                     arg "values"
                                                       (M.type_self
                                                          (S.Named (kept_name n)));
                                                   ]);
                                            ];
                                        })
                                      persisted;
                                };
                            ];
                      });
               ];
           });
      constant [ "internal" ] "wholeKey" None (S.String stored.whole_key.key);
      constant [ "internal" ] "cacheDocumentVersion" None (S.Int version);
      constant [ "internal" ] "keptPlace" None (S.String place);
    ]

(* Control *)

(* The control API's methods and notifications (control/methods.json), each
   by the types of what it carries, and who sends a notification. *)
let control models (spec : Spec.t) =
  let module T = Tables.Control_methods in
  let t = spec.tables.control_methods in
  let named =
    match Schema_names.named spec with
    | Ok named -> named
    | Error message -> refuse "%s" message
  in
  let type_of target =
    let file, _ =
      Decode.resolve spec.ids
        { Decode.target; file = "control/methods.json"; pointer = "" }
    in
    match named file with
    | Some n -> M.named models n
    | None -> refuse "control/methods.json names %s, which no type is" target
  in
  let party = function T.Client -> "client" | T.Launcher -> "launcher" in
  let generic n =
    {
      S.name = n;
      conforms = S.Composition [ S.Named "Codable"; S.Named "Sendable" ];
    }
  in
  let field n type_ =
    decl [ "public" ]
      (S.Property { var = false; name = n; type_ = Some type_; value = None })
  in
  let structure n generics members =
    decl [ "public" ]
      (S.Struct
         {
           name = n;
           generics = List.map generic generics;
           inherits = [ S.Named "Sendable" ];
           layout = S.Lines;
           members;
         })
  in
  let entry docs n type_ args =
    decl
      ~doc:(Text.wrapped ~lead:"  /// " ~width:100 docs)
      [ "public"; "static" ]
      (S.Property
         {
           var = false;
           name = M.member_name n;
           type_ = Some type_;
           value = Some (labelled (S.Implicit_member "init") args);
         })
  in
  let methods =
    List.map
      (fun (m : T.methods_item) ->
        entry m.docs m.name
          (S.Generic ("ControlMethod", [ type_of m.params; type_of m.result ]))
          [
            arg "name" (S.String m.name);
            arg "exclusive" (S.Bool m.exclusive);
            arg "sends" (strings m.sends);
          ])
      t.methods
  in
  let notifications =
    List.map
      (fun (n : T.notifications_item) ->
        entry n.docs n.name
          (S.Generic ("ControlNotification", [ type_of n.params ]))
          [ arg "name" (S.String n.name); arg "from" (case (party n.from)) ])
      t.notifications
  in
  [
    structure "ControlMethod" [ "Params"; "Result" ]
      [
        field "name" string_type;
        field "exclusive" (S.Named "Bool");
        field "sends" (S.Array_of string_type);
      ];
    string_enumeration [ "public" ] "ControlParty"
      (List.sort_uniq String.compare
         (List.map
            (fun (n : T.notifications_item) -> party n.from)
            t.notifications));
    structure "ControlNotification" [ "Params" ]
      [ field "name" string_type; field "from" (S.Named "ControlParty") ];
    decl [ "public" ]
      (S.Enum
         {
           name = "Control";
           inherits = [];
           layout = S.Lines;
           members = methods @ notifications;
         });
  ]

(* Every table declaration, in the order the SDK's file holds them. *)
let declarations models ~(spec : Spec.t) ~view ~shapes ~timing ~codes
    ~user_field =
  let tables = spec.tables in
  (match
     List.assoc_opt "client/types/GatherResourceOptions.json" spec.schemas
   with
  | Some s ->
      ignore
        (M.inline models ~modifiers:[ "public" ] "" "GatherResourceOptions"
           (view s))
  | None -> refuse "Protocol states no client type GatherResourceOptions");
  let frame = M.schema models "BusFrame" in
  let metadata =
    [
      ("eventId", string_schema);
      ("trace", D.Ref { name = "TraceCarrier"; description = None });
    ]
  in
  let fields =
    List.filter
      (fun (k, _) -> not (List.mem_assoc k metadata))
      (properties_of frame)
    @ metadata
    |> List.sort (fun (a, _) (b, _) -> String.compare a b)
  in
  let projection =
    List.map
      (fun (wire, _) ->
        let m = M.member_name wire in
        arg m
          (if List.mem_assoc wire metadata then name m
           else member (name "frame") m))
      fields
  in
  let received_frame =
    decl []
      (S.Extension
         {
           name = "ReceivedFrame";
           layout = S.Inline;
           members =
             [
               decl [ "internal" ]
                 (S.Init
                    {
                      params =
                        [
                          {
                            label = Some "_";
                            name = "frame";
                            type_ = S.Named "BusFrame";
                            default = None;
                          };
                          {
                            label = None;
                            name = "trace";
                            type_ = S.Optional (S.Named "TraceCarrier");
                            default = None;
                          };
                          {
                            label = None;
                            name = "eventId";
                            type_ = S.Optional string_type;
                            default = None;
                          };
                        ];
                      throws = false;
                      body =
                        M.inline_block
                          [ S.Expr (labelled (M.self_ "init") projection) ];
                    });
             ];
         })
  in
  (match frame with
  | D.Node n ->
      ignore
        (M.inline models ~modifiers:[ "public" ] "" "ReceivedFrame"
           (D.Node { n with properties = Some fields }))
  | _ -> refuse "BusFrame is no object");
  let telemetry key rows = string_enumeration [ "public" ] key rows in
  let spans =
    List.map
      (fun (s : Tables.Sdk_telemetry_telemetry.spans_item) -> s.name)
      tables.sdk_telemetry_telemetry.spans
  in
  let metrics =
    List.map
      (fun (m : Tables.Sdk_telemetry_telemetry.metrics_item) -> m.name)
      tables.sdk_telemetry_telemetry.metrics
  in
  let error_decls = error_codes models ~shapes codes in
  let text_source =
    vocabulary models "TextSource" tables.media_types_registry.text_source
  in
  let typed = [ ("mediaTypes", typing_rows ~key:"textSource" text_source) ] in
  let values =
    List.map
      (fun (_, _, n, value) ->
        let shape = infer [ value ] in
        let shape =
          match List.assoc_opt n typed with
          | Some type_rows -> type_rows shape
          | None -> shape
        in
        let type_ = M.type_ models "Spec" n shape in
        constant [ "public" ] n (Some type_)
          (expression models value shape ~owner:"Spec" ~part:n))
      (Spec_values.all tables)
  in
  let aliases =
    constant [ "public" ] "extensionAliases"
      (Some (M.dictionary_of string_type))
      (S.Dictionary
         ( S.Lines,
           List.map
             (fun (suffix, type_) -> (S.String suffix, S.String type_))
             (List.sort
                (fun (a, _) (b, _) -> String.compare a b)
                tables.media_types_registry.extension_aliases) ))
  in
  let trace =
    constant [ "public" ] "traceField" None
      (S.String tables.bus_registry.trace.field)
  in
  let user = constant [ "public" ] "userField" None (S.String user_field) in
  let channel_decls, channels = channels models ~shapes tables.bus_registry in
  let refresh = cache_refresh tables.client_refresh ~channels in
  let kept_decls =
    kept models ~shapes tables.client_refresh tables.session_stored
  in
  [ received_frame ] @ timings timing
  @ [ telemetry "TransportSpan" spans; telemetry "TransportMetric" metrics ]
  @ error_decls @ values @ [ aliases; trace; user ] @ channel_decls @ refresh
  @ kept_decls @ control models spec
