(* The TypeScript SDK's protocol types (typescript/core/src/types.ts): every
   component schema of the gateway's document as a member of
   [components['schemas']], and every record Protocol states in its tables
   ([Table_records]), with every other schema only they reach, as a member of
   [records], each written as the schema states it, and each kind of id
   branded, so that a property of one kind is of no other. *)

module D = Definitions
module T = Typescript_syntax

let path = "typescript/core/src/types.ts"
let unknown = T.T_name "unknown"

(* A description as a doc comment: its paragraphs, each a run of words. *)
let about description =
  match description with
  | None -> []
  | Some d ->
      let paragraphs =
        List.filter_map
          (fun p ->
            match String.trim p with "" -> None | p -> Some (Text.Words p))
          (Text.split ~sub:"\n\n" d)
      in
      [ T.Doc_prose paragraphs ]

let key name = if T.identifier name then T.Ident name else T.Quoted name

(* [t] where it is an operand of [&] or of [[]], parenthesized when it is
   itself one of [|] or [&]. *)
let operand (t : T.type_) =
  match t with T_union _ | T_intersection _ -> T.T_paren t | _ -> t

let union ts =
  let flat = List.concat_map (function T.T_union ts -> ts | t -> [ t ]) ts in
  let null = T.T_name "null" in
  match
    List.filter (fun t -> t <> null) flat @ List.filter (( = ) null) flat
  with
  | [ only ] -> only
  | ts -> T_union ts

let intersection = function
  | [ only ] -> only
  | ts -> T.T_intersection (List.map operand ts)

let literal (l : Schema.literal) : T.type_ =
  match l with
  | String_literal v -> T_str v
  | Int_literal n -> T_int n
  | Bool_literal b -> T_bool b

(* [s]'s type, each schema it names the type [named] gives it. *)
let type_of ~(named : string -> T.type_) =
  let rec type_of (s : D.t) : T.type_ =
    match s with
    | D.Ref { name; _ } -> named name
    | D.Null -> T_name "null"
    | D.Bool true -> unknown
    | D.Bool false -> T_name "never"
    | D.Node n -> (
        match (n.all_of, View.union s, n.enum, n.type_) with
        | Some members, _, _, _ ->
            (* What it states beside its parts: its members, and the values it
             holds them to, as a union's tag is held to a value of its
             vocabulary. *)
            let own =
              (match n.properties with
                | None | Some [] -> []
                | Some _ -> [ object_of n ])
              @
              match n.enum with
              | None -> []
              | Some values -> [ union (List.map literal values) ]
            in
            intersection (List.map type_of members @ own)
        | None, Some members, _, _ -> union (List.map type_of members)
        | None, None, Some values, types ->
            let values = List.map literal values in
            union
              (match types with
              | Some (D.Or_null _) -> values @ [ T_name "null" ]
              | _ -> values)
        | None, None, None, Some (D.One t) -> base n t
        | None, None, None, Some (D.Or_null t) ->
            union [ base n t; T_name "null" ]
        | None, None, None, None ->
            if Option.is_some n.properties then object_of n else unknown)
  and base (n : D.node) (t : Schema.type_name) : T.type_ =
    match t with
    | String -> T_name "string"
    | Integer | Number -> T_name "number"
    | Boolean -> T_name "boolean"
    | Null -> T_name "null"
    | Array ->
        T_array (operand (Option.fold ~none:unknown ~some:type_of n.items))
    | Object -> object_of n
  (* An object's properties, and what it holds beside them: an open object
   holds any member, and one whose [additionalProperties] is a schema holds
   members of it. An object that states neither holds no member. *)
  and object_of (n : D.node) : T.type_ =
    let required = Option.value n.required ~default:[] in
    let members =
      List.map
        (fun (name, s) ->
          T.member (key name) (type_of s)
            ~about:(about (View.description s))
            ~optional:(not (List.mem name required)))
        (Option.value n.properties ~default:[])
    in
    let beside =
      match n.additional_properties with
      | None | Some (D.Bool false) -> []
      | Some s -> [ T.T_index_signature (type_of s) ]
    in
    match (members, beside) with
    | [], [] -> T_generic ("Record", [ T_name "string"; T_name "never" ])
    | [], [ signature ] -> signature
    | members, beside -> intersection (T_object (Rows, members) :: beside)
  in
  type_of

(* A kind of id: text, and a type of its own. *)
let branded definitions name =
  if not (View.is_string definitions (definitions.D.schema name)) then
    D.refuse "%s: a kind of id whose schema is not a string" name;
  T.T_intersection
    [
      T_name "string";
      T_object
        (Inline, [ T.member ~readonly:true (Ident "__brand") (T_str name) ]);
    ]

(* Every schema [s] names. *)
let rec names_in (s : D.t) =
  match s with
  | D.Ref { name; _ } -> [ name ]
  | D.Null | D.Bool _ -> []
  | D.Node n ->
      List.concat_map names_in
        (Option.to_list n.items
        @ Option.to_list n.additional_properties
        @ List.map snd (Option.value n.properties ~default:[])
        @ List.concat_map (Option.value ~default:[])
            [ n.all_of; n.any_of; n.one_of ])

(* [names], and every schema they reach. *)
let reached (definitions : D.definitions) names =
  let rec reach seen name =
    if List.mem name seen then seen
    else
      List.fold_left reach (name :: seen) (names_in (definitions.schema name))
  in
  List.sort String.compare (List.fold_left reach [] names)

(* Why a client that read a launcher's discovery document found no launcher
   (protocol/specs/src/client/discovery-absent.json): a reason a case. *)
let discovery_absent (spec : Spec.t) =
  T.member (Ident "DiscoveryAbsentReason")
    ~about:[ Doc "Why no launcher was found." ]
    (T_cases
       (List.map
          (fun (r : Tables.Client_discovery_absent.reasons_item) ->
            T.case ~about:[ Doc_prose [ Text.Words r.docs ] ] (T_str r.reason))
          spec.tables.client_discovery_absent.reasons))

(* [records[name]]: the type of a record Protocol states in a table, or of a
   schema only such records reach. *)
let record name = T.T_index (T_name "records", T_str name)

(* The tables the SDK carries as values (Table_modules.tables): the services'
   (Roots.service_tables) and the retry rules. Each table's schema is a
   record, named as its file is ([Places.schema_of]). *)
let table_schemas (bundle : Definitions.bundle) (spec : Spec.t) =
  let declared name =
    match bundle.definitions.schema name with
    | _ -> true
    | exception D.Refused _ -> false
  in
  List.map
    (fun table ->
      let file = Places.schema_of table in
      let name = D.stem file in
      if declared name then
        D.refuse "%s, the schema of %s, is named as a schema already is" file
          table;
      match List.assoc_opt file spec.schemas with
      | Some s -> (name, bundle.view (Normalize.shape_only s))
      | None -> D.refuse "%s has no schema %s" table file)
    (Table_modules.tables spec)

let text (spec : Spec.t) =
  let bundle = Definitions.bundle spec in
  let tables = table_schemas bundle spec in
  let definitions =
    {
      bundle.definitions with
      schema =
        (fun name ->
          match List.assoc_opt name tables with
          | Some s -> s
          | None -> bundle.definitions.schema name);
    }
  in
  let records =
    List.filter
      (fun name -> not (List.mem name definitions.names))
      (reached definitions
         (List.map (fun (_, name, _) -> name) (Definitions.records spec)
         @ Definitions.generated_client_types spec
         @ List.map fst tables))
  in
  let named name =
    if List.mem name records then record name else T.schema name
  in
  let kinds =
    List.map
      (fun (k : Tables.Identifiers_kinds.kinds_item) -> k.schema)
      spec.tables.identifiers_kinds.kinds
  in
  let schema name =
    let s = definitions.schema name in
    T.member (key name)
      (if List.mem name kinds then branded definitions name
       else type_of ~named s)
      ~about:(about (View.description s))
  in
  T.text
    {
      banner =
        Banner.typescript_lines
          ~authority:
            [
              "the component schemas of protocol/specs/src/openapi.json";
              "the records Protocol states in its tables \
               (codegen/lib/table_records.ml)";
              "the client types it names, of protocol/specs/src/client/types";
              "the schemas of the tables it carries as values \
               (codegen/lib/typescript_types/table_modules.ml)";
              "protocol/specs/src/client/discovery-absent.json";
              "protocol/specs/src/identifiers/kinds.json, for the brands";
            ]
          __FILE__;
      body =
        [
          T.Interface
            {
              about = [];
              export = true;
              name = "components";
              members =
                [
                  T.member (Ident "schemas")
                    (T_object (Rows, List.map schema definitions.names));
                ];
            };
          T.Interface
            {
              about =
                [
                  Doc_prose
                    [
                      Text.Words
                        "The records Protocol states in its tables, the \
                         client types and the tables the SDK carries as values, \
                         which no wire message carries, and what only they \
                         reach.";
                    ];
                ];
              export = true;
              name = "records";
              members = List.map schema records @ [ discovery_absent spec ];
            };
        ];
    }

(* The launcher's control API as the TypeScript SDK reads it
   (typescript/core/src/control-methods.ts, from
   protocol/specs/src/control/methods.json): its version, each method with the
   names of its params' and its result's schemas, whether it runs alone and
   the notifications it sends, and each notification with who sends it and
   its params' schema. Each schema a component of types.ts. *)
module C = Tables.Control_methods

let control_path = "typescript/core/src/control-methods.ts"

let control_text (spec : Spec.t) =
  let definitions = (Definitions.bundle spec).definitions in
  let t = spec.tables.control_methods in
  let component id =
    let name = Filename.remove_extension (Filename.basename id) in
    if not (List.mem name definitions.names) then
      D.refuse "control/methods.json names %s, which is no component schema"
        id;
    name
  in
  let named id = T.Str (component id) in
  let api_version =
    match definitions.schema (component t.api_version) with
    | D.Node { enum = Some [ Schema.String_literal v ]; _ } -> v
    | _ -> D.refuse "control/methods.json: its apiVersion states no const"
  in
  let inline entries = T.Object { layout = Inline; entries } in
  let from = function C.Launcher -> "launcher" | C.Client -> "client" in
  let schema_name = T.T_keyof (T.T_index (T_name "components", T_str "schemas")) in
  let indexed table key member =
    T.T_index
      ( T_index (T_name "components", T_str "schemas"),
        T_index (T_index (T_paren (T_typeof table), T_name key), T_str member) )
  in
  let over table key =
    [ { T.param = key; bound = Some (T.T_keyof (T_typeof table)) } ]
  in
  T.text
    {
      banner =
        Banner.typescript_lines
          ~authority:[ "protocol/specs/src/control/methods.json" ]
          __FILE__;
      body =
        [
          T.import ~type_only:true [ "components" ] "./types";
          T.const "CONTROL_API_VERSION" ~as_const:true
            ~about:[ Doc "The version of the control API these tables state." ]
            (T.Str api_version);
          T.const "CONTROL_NOTIFICATIONS" ~as_const:true
            ~about:
              [
                Doc
                  "Each notification of the control API: who sends it, and \
                   the schema of its params.";
              ]
            ~satisfies:
              (T_index_signature
                 (T_object
                    ( Inline,
                      [
                        T.member ~readonly:true (Ident "from")
                          (T_union [ T_str "launcher"; T_str "client" ]);
                        T.member ~readonly:true (Ident "params") schema_name;
                      ] )))
            (T.rows
               (List.map
                  (fun (n : C.notifications_item) ->
                    T.entry
                      ~about:[ Doc_prose [ Text.Words n.docs ] ]
                      (Quoted n.name)
                      (inline
                         [
                           T.entry (Ident "from") (T.Str (from n.from));
                           T.entry (Ident "params") (named n.params);
                         ]))
                  t.notifications));
          T.type_alias "ControlNotification"
            ~about:[ Doc "A notification of the control API, by its name." ]
            (T_keyof (T_typeof "CONTROL_NOTIFICATIONS"));
          T.const "CONTROL_METHODS" ~as_const:true
            ~about:
              [
                Doc
                  "Each method of the control API: the schemas of its params \
                   and its result, whether it runs alone, and the \
                   notifications it sends while it runs.";
              ]
            ~satisfies:
              (T_index_signature
                 (T_object
                    ( Inline,
                      [
                        T.member ~readonly:true (Ident "params") schema_name;
                        T.member ~readonly:true (Ident "result") schema_name;
                        T.member ~readonly:true (Ident "exclusive")
                          (T_name "boolean");
                        T.member ~readonly:true (Ident "sends")
                          (T_readonly (T_array (T_name "ControlNotification")));
                      ] )))
            (T.rows
               (List.map
                  (fun (m : C.methods_item) ->
                    T.entry
                      ~about:[ Doc_prose [ Text.Words m.docs ] ]
                      (Quoted m.name)
                      (inline
                         [
                           T.entry (Ident "params") (named m.params);
                           T.entry (Ident "result") (named m.result);
                           T.entry (Ident "exclusive") (T.Bool m.exclusive);
                           T.entry (Ident "sends") (T.strings m.sends);
                         ]))
                  t.methods));
          T.type_alias "ControlMethod"
            ~about:[ Doc "A method of the control API, by its name." ]
            (T_keyof (T_typeof "CONTROL_METHODS"));
          T.type_alias "ControlParams"
            ~params:(over "CONTROL_METHODS" "M")
            ~about:[ Doc "What a method of the control API is asked with." ]
            (indexed "CONTROL_METHODS" "M" "params");
          T.type_alias "ControlResult"
            ~params:(over "CONTROL_METHODS" "M")
            ~about:[ Doc "What a method of the control API answers." ]
            (indexed "CONTROL_METHODS" "M" "result");
          T.type_alias "ControlNotificationParams"
            ~params:(over "CONTROL_NOTIFICATIONS" "N")
            ~about:[ Doc "What a notification of the control API carries." ]
            (indexed "CONTROL_NOTIFICATIONS" "N" "params");
          T.type_alias "ControlErrorData"
            ~about:[ Doc "What a failed request of the control API carries as its error's data." ]
            (T.schema (component t.error_data));
        ];
    }

let files ~root (spec : Spec.t) =
  match (text spec, control_text spec) with
  | text, control ->
      Result.map
        (fun tables ->
          { Output.path; text }
          :: { Output.path = control_path; text = control }
          :: tables)
        (Table_modules.files ~root spec)
  | exception Definitions.Refused message ->
      Error [ { Decode.file = "openapi.json"; pointer = ""; message } ]
