(* The TypeScript SDK's protocol types (typescript/core/src/types.ts): every
   component schema of the gateway's document as a member of
   [components['schemas']], and every record Protocol states in its tables
   ([Table_records]), with every other schema only they reach, as a member of
   [records]; every table the SDK carries as a value, with what only it
   reaches, as a member of [tables]; each written as the schema states it,
   each type of its own written in place an alias of the name [Typing] gives
   it, and each kind of id branded, so that a property of one kind is of no
   other. *)

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

(* What a type refers to by name: each schema by the type [named] gives it,
   and each type written in place that [Typing] names by an alias of that
   name, [aliases] of each in the order they are met. *)
type names = {
  named : string -> T.type_;
  aliases : (string, T.decl) Hashtbl.t;
  mutable met : string list;
}

let names named = { named; aliases = Hashtbl.create 64; met = [] }

(* The aliases [names] has met, in the order it met them. *)
let aliases names =
  List.rev_map (fun name -> Hashtbl.find names.aliases name) names.met

(* Whether a type written in place is a type of its own: an object of
   members, an [allOf], a union, or an enumeration of several values. One
   value is its literal, and any other object its form. *)
let aliased (i : Typing.inline) =
  match (i.form, i.composition) with
  | _, Some _ | (Record _ | Union _ | Enum { values = _ :: _ :: _; _ }), None ->
      true
  | _ -> false

(* A type's TypeScript type, each schema it names and each type of its own in
   place by its name in [names], any other written in place as the schema
   states it. *)
let rec type_of ~(names : names) (ty : Typing.ty) : T.type_ =
  match ty with
  | Typing.Named name -> names.named name
  | Null -> T_name "null"
  | Any -> unknown
  | Nothing -> T_name "never"
  | Nullable ty -> union [ type_of ~names ty; T_name "null" ]
  | Scalar (Text _) -> T_name "string"
  | Scalar (Code vocabulary) -> T_name (fst (Error_codes.Table.named vocabulary))
  | Scalar (Integer _ | Number) -> T_name "number"
  | Scalar Boolean -> T_name "boolean"
  | List items ->
      T_array (operand (Option.fold ~none:unknown ~some:(type_of ~names) items))
  | Inline i when aliased i ->
      if not (Hashtbl.mem names.aliases i.name) then (
        names.met <- i.name :: names.met;
        Hashtbl.replace names.aliases i.name
          (T.type_alias i.name ~about:(about i.description)
             (form_of ~names i.form i.composition)));
      T_name i.name
  | Inline i -> form_of ~names i.form i.composition

(* A declaration's or an inline's type: an [allOf] as its parts and what it
   states beside them, each held to the values it states, as a union's tag
   is held to a value of its vocabulary; anything else as its form. *)
and form_of ~names (form : Typing.form)
    (composition : Typing.composition option) : T.type_ =
  match composition with
  | Some { parts; beside } ->
      let own =
        (match beside.members with
          | [] -> []
          | members -> [ object_of ~names members beside.rest ])
        @
        match beside.values with
        | None -> []
        | Some values -> [ union (List.map literal values) ]
      in
      intersection (List.map (type_of ~names) parts @ own)
  | None -> (
      match form with
      | Record { members; rest } -> object_of ~names members rest
      | Empty { rest; _ } -> object_of ~names [] rest
      | Map { key = Some key; value } ->
          T_generic ("Record", [ names.named key; type_of ~names value ])
      | Map { key = None; value } -> object_of ~names [] (Of value)
      | Enum { values; _ } -> union (List.map literal values)
      | Alias ty -> type_of ~names ty
      | Union { branches; _ } ->
          union
            (List.map (fun (b : Typing.branch) -> type_of ~names b.ty) branches)
      | Identifier _ | Json -> unknown)

(* An object's members, and what it holds beside them: an open object holds
   any member, and one whose [additionalProperties] is a schema holds members
   of it. An object that states neither holds no member beside its own
   ([Deviations], TypeScript's unstated object). *)
and object_of ~names (members : Typing.member list) (rest : Typing.rest) :
    T.type_ =
  let members =
    List.map
      (fun (m : Typing.member) ->
        T.member (key m.wire) (type_of ~names m.ty) ~about:(about m.description)
          ~optional:(not m.required))
      members
  in
  let beside =
    match rest with
    | Unstated | Closed -> []
    | Open -> [ T.T_index_signature unknown ]
    | Of ty -> [ T.T_index_signature (type_of ~names ty) ]
  in
  match (members, beside) with
  | [], [] -> T_generic ("Record", [ T_name "string"; T_name "never" ])
  | [], [ signature ] -> signature
  | members, beside -> intersection (T_object (Rows, members) :: beside)

(* A kind of id: text, and a type of its own. *)
let branded name =
  T.T_intersection
    [
      T_name "string";
      T_object
        (Inline, [ T.member ~readonly:true (Ident "__brand") (T_str name) ]);
    ]

(* A declaration's type: a kind of id branded, any other as its form. *)
let declared ~names (d : Typing.declaration) =
  match d.form with
  | Identifier _ -> branded d.name
  | form -> form_of ~names form d.composition

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

(* [tables[name]]: the type of a table the SDK carries as a value, or of a
   schema only such tables reach. *)
let table name = T.T_index (T_name "tables", T_str name)

(* The tables the SDK carries as values (Table_modules.tables): the services'
   (Roots.service_tables) and the retry rules. Each table's schema is a
   record, named as its file is ([Places.schema_of]). *)
let text (spec : Spec.t) =
  let tables = Table_modules.tables spec in
  let typing = Typing.of_spec spec ~tables in
  let components = typing.gateway in
  let records =
    List.filter
      (fun name -> not (List.mem name components))
      (Typing.reached typing.find
         (List.map (fun (_, name, _) -> name) (Definitions.records spec)
         @ Definitions.generated_client_types spec))
  in
  let table_names =
    List.filter
      (fun name -> not (List.mem name components || List.mem name records))
      (Typing.reached typing.find
         (List.map
            (fun table -> Definitions.stem (Places.schema_of table))
            tables))
  in
  let named name =
    if List.mem name records then record name
    else if List.mem name table_names then table name
    else T.schema name
  in
  let names = names named in
  let schema name =
    let d = typing.find name in
    T.member (key name) (declared ~names d) ~about:(about d.description)
  in
  let interfaces =
    [
      T.Interface
        {
          about = [];
          export = true;
          name = "components";
          members =
            [
              T.member (Ident "schemas")
                (T_object (Rows, List.map schema components));
            ];
        };
      T.Interface
        {
          about =
            [
              Doc_prose
                [
                  Text.Words
                    "The records Protocol states in its tables and the client \
                     types, which no wire message carries, and what only they \
                     reach.";
                ];
            ];
          export = true;
          name = "records";
          members = List.map schema records @ [ discovery_absent spec ];
        };
      T.Interface
        {
          about =
            [
              Doc_prose
                [
                  Text.Words
                    "The tables the SDK carries as values, and what only they \
                     reach.";
                ];
            ];
          export = true;
          name = "tables";
          members = List.map schema table_names;
        };
    ]
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
        (match Typing.codes typing with
        | [] -> []
        | vocabularies ->
            [
              T.import ~type_only:true
                (List.map
                   (fun v -> fst (Error_codes.Table.named v))
                   vocabularies)
                "./error-codes";
            ])
        @ interfaces @ aliases names;
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
  let typing = Typing.of_spec spec ~tables:[] in
  let t = spec.tables.control_methods in
  let component id =
    let name = Filename.remove_extension (Filename.basename id) in
    if not (List.mem name typing.gateway) then
      Definitions.refuse
        "control/methods.json names %s, which is no component schema" id;
    name
  in
  let named id = T.Str (component id) in
  let api_version =
    match (typing.find (component t.api_version)).form with
    | Enum { values = [ Schema.String_literal v ]; _ } -> v
    | _ ->
        Definitions.refuse
          "control/methods.json: its apiVersion states no const"
  in
  let inline entries = T.Object { layout = Inline; entries } in
  let from = function C.Launcher -> "launcher" | C.Client -> "client" in
  let schema_name =
    T.T_keyof (T.T_index (T_name "components", T_str "schemas"))
  in
  let indexed table key member =
    T.T_index
      ( T_index (T_name "components", T_str "schemas"),
        T_index (T_index (T_paren (T_typeof table), T_name key), T_str member)
      )
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
                  "Each notification of the control API: who sends it, and the \
                   schema of its params.";
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
            ~about:
              [
                Doc
                  "What a failed request of the control API carries as its \
                   error's data.";
              ]
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
