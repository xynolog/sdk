(* The Python SDK's protocol types (python/sdk/src/xynolog/types.py): a
   frozen [WireModel] for every component schema and every record Protocol
   states in its tables ([Table_records]), with every schema they reach,
   that is an object, and a type alias for every other, but the kinds of id,
   which [xynolog.identifiers] holds. They are types, and state no rule beside
   what a type says: what a value must be is the required table's
   ([_required_table.py]), which the SDK holds what it reads to.

   It spells Protocol's schemas as [Typing] reads them. A schema written in
   place is declared on its own by the name [Typing] gives it: an object of
   properties or one that holds no member, a closed set of more than one
   word, an [allOf] that merges to an object, and a union an array holds. An
   [allOf] of schemas and of properties beside them is a class of those
   schemas, unless it restates one of their properties, when it is written
   whole. *)

module P = Python_syntax
module T = Typing

let path = "python/sdk/src/xynolog/types.py"
let refuse = Definitions.refuse

type state = {
  typing : T.t;
  tagged : (string * string) list;
      (** A class and the property a discriminated union it is a member of tells
          its members apart by, which pydantic reads as a [Literal] written in
          place. *)
  mutable declared : (string * P.stmt) list;
      (** In-place declarations, the latest first. *)
}

let name n = P.Name n
let none = name "None"
let json = name "JsonValue"
let sub f args = P.sub f (List.map P.item args)

let union = function
  | [] -> invalid_arg "Python_types: a union of no member"
  | first :: rest ->
      List.fold_left (fun a b -> P.Binary (a, P.Or, b)) first rest

let literal (l : Schema.literal) : P.expr =
  match l with
  | String_literal v -> Str v
  | Int_literal n -> Int n
  | Bool_literal b -> Name (if b then "True" else "False")

let literals values = sub "Literal" (List.map literal values)

let keywords =
  [
    "False";
    "None";
    "True";
    "and";
    "as";
    "assert";
    "async";
    "await";
    "break";
    "class";
    "continue";
    "def";
    "del";
    "elif";
    "else";
    "except";
    "finally";
    "for";
    "from";
    "global";
    "if";
    "import";
    "in";
    "is";
    "lambda";
    "nonlocal";
    "not";
    "or";
    "pass";
    "raise";
    "return";
    "try";
    "while";
    "with";
    "yield";
  ]

(* What a pydantic model is given by [BaseModel], which a field of that name
   would shadow. *)
let taken =
  [
    "construct";
    "copy";
    "dict";
    "from_orm";
    "json";
    "parse_file";
    "parse_obj";
    "parse_raw";
    "schema";
    "schema_json";
    "update_forward_refs";
    "validate";
  ]

(* A property's Python name: what marks it ([@], [_]) dropped, then snake
   case, and an [_] after one that is a keyword or a name [BaseModel]
   gives. *)
let python_name wire =
  let rec unmarked s =
    if s <> "" && (s.[0] = '@' || s.[0] = '_' || s.[0] = '$') then
      unmarked (String.sub s 1 (String.length s - 1))
    else s
  in
  let name =
    String.map (function '-' -> '_' | c -> c) (Text.snake (unmarked wire))
  in
  if List.mem name keywords || List.mem name taken then name ^ "_" else name

let docstring = function
  | None -> None
  | Some d -> Some (P.As_is ("\n" ^ d ^ "\n"))

(* An object a class declares: one that names members, or holds none. *)
let is_class (form : T.form) =
  match form with T.Record _ -> true | form -> T.holds_none form

(* What pydantic does with the members a class does not name. *)
let extra (form : T.form) =
  let of_rest = function
    | T.Closed -> Some "forbid"
    | T.Open -> Some "allow"
    | T.Unstated -> None
    | T.Of _ ->
        refuse "an object of properties whose other members are of a schema"
  in
  match form with
  | form when T.holds_none form -> Some "forbid"
  | T.Record { rest; _ } | T.Empty { rest; _ } -> of_rest rest
  | T.Map _ -> of_rest (T.Of T.Any)
  | T.Enum _ | T.Alias _ | T.Identifier _ | T.Union _ | T.Json -> None

let wires (form : T.form) =
  match form with
  | T.Record { members; _ } -> List.map (fun (m : T.member) -> m.wire) members
  | _ -> []

(* The name of a type declared in place, which no other declared in place
   has. *)
let named st name =
  if List.mem_assoc name st.declared then
    refuse "two schemas written in place would both be named %s" name;
  name

let declare st name decl = st.declared <- (name, decl) :: st.declared

(* The Python type of a value of [ty], [what] holding it: [tag] when it is
   the property its class's union tells its members apart by. *)
let rec placed st ~what ?(tag = false) (ty : T.ty) : P.expr =
  match ty with
  | T.Nullable inner -> union [ placed st ~what ~tag inner; none ]
  | T.Named n -> name n
  | T.Null -> none
  | T.Any -> json
  | T.Nothing -> refuse "%s: a schema that admits nothing" what
  | T.Scalar (T.Text { binary; _ }) -> name (if binary then "bytes" else "str")
  | T.Scalar (T.Code vocabulary) -> name (fst (Code_names.named vocabulary))
  | T.Scalar (T.Integer _) -> name "int"
  | T.Scalar T.Number -> name "float"
  | T.Scalar T.Boolean -> name "bool"
  | T.List items -> sub "list" [ item st ~what items ]
  | T.Inline i -> in_place st ~what ~tag i

(* A schema in place: declared on its own where it is a class, or a closed
   set of other than one word that is not its class's tag; otherwise what it
   holds. An [allOf] is a class of its parts where it merges to a class, and
   otherwise what it merges to, described as its merge is. *)
and in_place st ~what ~tag (i : T.inline) =
  let declared composition description =
    let name = named st i.name in
    declare st name (declaration st name i.form composition description);
    P.Name name
  in
  match i.form with
  | form when is_class form -> declared i.composition i.description
  | T.Enum { base = Some (T.Text _); values }
    when List.length values <> 1 && not tag ->
      declared None
        (if i.composition = None then i.description else i.node_description)
  | form -> spelled st ~what ~owner:i.name form

(* What a schema of [form] holds, spelled where it is: [owner] the name its
   union's members are named after. *)
and spelled st ~what ~owner (form : T.form) =
  match form with
  | T.Union u -> union (List.map (member st ~what:owner) u.branches)
  | T.Enum { values; _ } -> literals values
  | T.Empty _ -> sub "dict" [ name "str"; json ]
  | T.Map { value; _ } -> sub "dict" [ name "str"; placed st ~what value ]
  | T.Alias ty -> placed st ~what ty
  | T.Record _ | T.Identifier _ | T.Json -> json

(* What an array holds; a union it holds is named. *)
and item st ~what items =
  match items with
  | None -> json
  | Some (T.Inline ({ form = T.Union u; _ } as i) as items) ->
      let t = placed st ~what items in
      let name = named st i.name in
      declare st name (typed_alias name ~description:i.description ~union:u t);
      P.Name name
  | Some items -> placed st ~what items

(* [name] for [t], with its description, and the property the union [t] is
   told apart by. *)
and typed_alias name ~description ?union t =
  let keywords =
    (match description with
      | Some d -> [ P.keyword "description" (Str d) ]
      | None -> [])
    @
    match union with
    | Some { T.tag = Some { property; _ }; _ } ->
        [ P.keyword "discriminator" (Str (python_name property)) ]
    | _ -> []
  in
  P.alias name
    (if keywords = [] then t else sub "Annotated" [ t; P.call "Field" keywords ])

(* One member of the union [what]: a class declared by its name in the
   union, a list, or what it holds. *)
and member st ~what (b : T.branch) =
  match b.ty with
  | T.Inline ({ form; _ } as i) when is_class form ->
      let name = named st i.name in
      declare st name (declaration st name form i.composition i.description);
      P.Name name
  | T.List items -> sub "list" [ item st ~what items ]
  | ty -> placed st ~what ty

and field st owner (m : T.member) =
  let before = List.map fst st.declared in
  let t =
    placed st
      ~what:(owner ^ "." ^ m.wire)
      ~tag:(List.mem (owner, m.wire) st.tagged)
      m.ty
  in
  (* A type declared for this property alone says what the property is. *)
  let declared_here = function
    | P.Name n | P.Binary (P.Name n, P.Or, P.Name "None") ->
        List.mem_assoc n st.declared && not (List.mem n before)
    | _ -> false
  in
  let nullable = match m.ty with T.Nullable _ -> true | _ -> false in
  let optional = not m.required in
  let t = if optional && not nullable then union [ t; none ] else t in
  let python = python_name m.wire in
  let keywords =
    (if python <> m.wire then [ P.keyword "alias" (Str m.wire) ] else [])
    @
    match m.description with
    | Some d when not (declared_here t) -> [ P.keyword "description" (Str d) ]
    | _ -> []
  in
  P.field python
    (if keywords = [] then t else sub "Annotated" [ t; P.call "Field" keywords ])
    ?default:(if optional then Some none else None)

and fields st owner (members : T.member list) =
  let seen = Hashtbl.create 8 in
  List.iter
    (fun (m : T.member) ->
      let python = python_name m.wire in
      match Hashtbl.find_opt seen python with
      | Some other ->
          refuse
            "%s: the properties %S and %S would both be the Python field %s"
            owner other m.wire python
      | None -> Hashtbl.replace seen python m.wire)
    members;
  List.map (field st owner) members

and class_ name ~bases ~extra ~doc body =
  P.Class
    {
      decorators = [];
      name;
      bases =
        (List.map (fun b -> P.item (P.Name b)) bases
        @ [ P.keyword "frozen" (Name "True") ]
        @
        match extra with
        | Some e -> [ P.keyword "extra" (Str e) ]
        | None -> []);
      doc;
      spacing = P.Packed;
      body = (if body = [] && doc = None then [ P.Pass ] else body);
    }

and object_class st name (form : T.form) ~doc =
  let members =
    match form with T.Record { members; _ } -> members | _ -> []
  in
  class_ name ~bases:[ "WireModel" ] ~extra:(extra form) ~doc
    (fields st name members)

(* A schema declared by [name]. *)
and declaration st name (form : T.form) (composition : T.composition option)
    description : P.stmt =
  let doc = docstring description in
  let alias ?union t = typed_alias name ~description ?union t in
  match (form, composition) with
  | form, Some c -> inherited st name form c ~doc
  | T.Union u, None ->
      alias ~union:u (union (List.map (member st ~what:name) u.branches))
  | (T.Record _ | T.Empty { rest = T.Unstated; _ }), None ->
      object_class st name form ~doc
  | T.Empty _, None when T.holds_none form -> object_class st name form ~doc
  | T.Alias (T.List items), None ->
      alias (sub "list" [ item st ~what:name items ])
  | T.Enum { values; _ }, None -> alias (literals values)
  | T.Map { key; value }, None ->
      alias
        (sub "dict"
           [
             P.Name (Option.value key ~default:"str");
             placed st ~what:name value;
           ])
  | (T.Empty _ | T.Alias _ | T.Identifier _ | T.Json), None ->
      alias (spelled st ~what:name ~owner:name form)

(* An [allOf]: a class of the schemas it names, with the members stated
   beside them, or, when its parts restate one of theirs, the whole of what
   they merge to. *)
and inherited st name (form : T.form) (c : T.composition) ~doc =
  let bases =
    List.filter_map (function T.Named b -> Some b | _ -> None) c.parts
  in
  let own =
    List.filter_map (function T.Inline i -> Some i.form | _ -> None) c.parts
  in
  let inherited_properties =
    List.concat_map (fun b -> wires (st.typing.find b).form) bases
  in
  let restated =
    List.exists
      (fun o ->
        List.exists (fun w -> List.mem w inherited_properties) (wires o))
      own
  in
  if restated || bases = [] then object_class st name form ~doc
  else
    let members =
      match form with
      | T.Record { members; _ } ->
          List.filter (fun (m : T.member) -> m.owner = name) members
      | _ -> []
    in
    let extras = List.filter_map extra own in
    class_ name ~bases
      ~extra:(match extras with [] -> None | e :: _ -> Some e)
      ~doc (fields st name members)

(* The type a value of [s] is held as where it is stated, [at] being the
   schema and its member that state it: what types.py names it there, or, a
   value stated alone, what it is. One stated alone that types.py would have
   to declare is refused, since none does. *)
let held (typing : T.t) ?at (s : Definitions.t) =
  let st = { typing; tagged = []; declared = [] } in
  match at with
  | Some (owner, part) ->
      placed st ~what:(owner ^ "." ^ part) (typing.place { T.owner; part } s)
  | None ->
      let t = placed st ~what:"" (typing.place { T.owner = ""; part = "" } s) in
      if st.declared <> [] then
        refuse "a value stated alone is a type types.py declares nowhere";
      t

(* Pydantic reads a model's annotations as Python runs its class, and a name
   not yet defined leaves the model unbuilt until it is first used; so each
   declaration follows every one it names, as far as a cycle allows. *)
let rec names_in = function
  | P.Name name -> [ name ]
  | Str _ | Ascii _ | Int _ | Octal _ | Hex _ | Ellipsis | Joined _ -> []
  | Binary (a, _, b) -> names_in a @ names_in b
  | Call (e, items) | Subscript (e, items) ->
      names_in e @ names_in_items items.elements
  | Tuple items | List items | Dict items | Set items ->
      names_in_items items.elements

and names_in_items elements =
  List.concat_map
    (fun { P.label; value; _ } ->
      (match label with Key key -> names_in key | Plain | Keyword _ -> [])
      @ names_in value)
    elements

let rec names_read = function
  | P.Class { bases; body; _ } ->
      names_in_items bases @ List.concat_map names_read body
  | Assign { annotation; value; _ } ->
      List.concat_map names_in (Option.to_list annotation @ Option.to_list value)
  | Alias { value; _ } -> names_in value
  | _ -> []

let ordered decls =
  let rec visit (written, out) ((name, stmt) as decl) =
    if List.mem name written then (written, out)
    else
      let written, out =
        List.fold_left
          (fun acc used ->
            match List.assoc_opt used decls with
            | Some stmt -> visit acc (used, stmt)
            | None -> acc)
          (name :: written, out)
          (names_read stmt)
      in
      (written, decl :: out)
  in
  List.rev (snd (List.fold_left visit ([], []) decls))

(* Each class a union told apart names, and the property it tells them apart
   by. *)
let tagged (typing : T.t) =
  let rec of_ty (ty : T.ty) =
    match ty with
    | T.Inline i -> of_form i.form @ of_composition i.composition
    | T.Nullable ty | T.List (Some ty) -> of_ty ty
    | T.Named _ | T.Scalar _ | T.Null | T.List None | T.Any | T.Nothing -> []
  and of_form (form : T.form) =
    match form with
    | T.Union { branches; tag } ->
        (match tag with
          | Some { property; _ } ->
              List.filter_map
                (fun (b : T.branch) ->
                  match b.ty with T.Named r -> Some (r, property) | _ -> None)
                branches
          | None -> [])
        @ List.concat_map (fun (b : T.branch) -> of_ty b.ty) branches
    | T.Record { members; rest } ->
        List.concat_map (fun (m : T.member) -> of_ty m.ty) members
        @ of_rest rest
    | T.Map { value; _ } -> of_ty value
    | T.Alias ty -> of_ty ty
    | T.Empty _ | T.Enum _ | T.Identifier _ | T.Json -> []
  and of_rest = function T.Of ty -> of_ty ty | _ -> []
  and of_composition = function
    | Some (c : T.composition) ->
        List.concat_map of_ty c.parts
        @ List.concat_map (fun (m : T.member) -> of_ty m.ty) c.beside.members
    | None -> []
  in
  List.concat_map
    (fun name ->
      let d = typing.find name in
      of_form d.form @ of_composition d.composition)
    typing.names

let identifier (typing : T.t) name =
  match (typing.find name).form with T.Identifier _ -> true | _ -> false

(* The module for [typing]'s generation, whose kinds of id are
   xynolog.identifiers'. *)
let module_ (typing : T.t) =
  let kinds = List.filter (identifier typing) typing.names in
  let st = { typing; tagged = tagged typing; declared = [] } in
  let decls =
    List.concat_map
      (fun component ->
        if List.mem component kinds then []
        else
          let before = st.declared in
          let d = typing.find component in
          let decl =
            declaration st component d.form d.composition d.description
          in
          let placed =
            List.rev
              (List.filter (fun d -> not (List.memq d before)) st.declared)
          in
          (component, decl) :: placed)
      typing.names
  in
  let names = List.sort compare (List.map fst decls) in
  P.text
    {
      header =
        Banner.python_lines
          ~from_:
            "the component schemas of protocol/specs/src/openapi.json, the \
             records of its tables, its client types, the services' tables' \
             schemas and client/discovery-absent.json"
          __FILE__;
      doc =
        As_is
          "The protocol's shapes: a model for every component schema, table \
           record and service table that is an object, and a type for every \
           other.";
      imports =
        [
          [ P.From ("__future__", [ "annotations" ]) ];
          ([
             P.From ("typing", [ "Annotated"; "Literal" ]);
             P.From ("pydantic", [ "JsonValue"; "Field" ]);
             P.From ("xynolog.model", [ "WireModel" ]);
             P.From ("xynolog.identifiers", kinds);
           ]
          @
          match T.codes typing with
          | [] -> []
          | codes ->
              [
                P.From
                  ( "xynolog.error_codes",
                    List.map (fun v -> fst (Code_names.named v)) codes );
              ]);
        ];
      body =
        P.assign "__all__"
          ~value:
            (P.List
               (P.items ~magic:true
                  (List.map (fun n -> P.item (P.Str n)) names)))
        :: List.map snd (ordered decls);
    }

(* Each service table ([Roots.service_tables]) is read as its schema's model
   of types.py, named as its file is, and is that model's value in
   service_tables.py. *)
let table_model table = Definitions.stem (Places.schema_of table)

(* The fields of the class types.py declares of [name], each by its Python
   name, with its type and what it is. *)
let fields (spec : Spec.t) name =
  let typing = Typing.of_spec spec ~tables:(Roots.service_tables spec) in
  let st = { typing; tagged = tagged typing; declared = [] } in
  match (typing.find name).form with
  | T.Record { members; _ } ->
      List.map
        (fun (m : T.member) ->
          let t = placed st ~what:(name ^ "." ^ m.wire) m.ty in
          ( python_name m.wire,
            (if m.required then t else union [ t; none ]),
            m.description ))
        members
  | _ -> refuse "%s: types.py declares no class of it" name

(* The module a type types.py names is imported from: a kind of id's,
   xynolog.identifiers, and any other's, xynolog.types. *)
let home (spec : Spec.t) name =
  let typing = Typing.of_spec spec ~tables:(Roots.service_tables spec) in
  if identifier typing name then "xynolog.identifiers" else "xynolog.types"

let text (spec : Spec.t) =
  module_ (Typing.of_spec spec ~tables:(Roots.service_tables spec))

(* The launcher's control API as the Python SDK reads it
   (python/sdk/src/xynolog/control_methods.py, from
   protocol/specs/src/control/methods.json): its version, each notification
   with who sends it and its params' model, and each method with its params'
   and its result's models, whether it runs alone and the notifications it
   sends. Each model is one of types.py; the rows are xynolog.control's
   classes. *)
module C = Tables.Control_methods

let control_path = "python/sdk/src/xynolog/control_methods.py"

let control_text (spec : Spec.t) =
  let typing = Typing.of_spec spec ~tables:[] in
  let t = spec.tables.control_methods in
  let component id =
    let name = Filename.remove_extension (Filename.basename id) in
    if not (List.mem name typing.gateway) then
      refuse "control/methods.json names %s, which is no component schema" id;
    name
  in
  let api_version =
    match (typing.find (component t.api_version)).form with
    | Enum { values = [ Schema.String_literal v ]; _ } -> v
    | _ -> refuse "control/methods.json: its apiVersion states no const"
  in
  let constant = Bus.Python.constant in
  let notification (n : C.notifications_item) =
    let params = component n.params in
    P.assign (constant n.name) ~annotation:(P.Name "Final")
      ~value:
        (P.Call
           ( P.sub "ControlNotification" [ P.item (P.Name params) ],
             P.items ~magic:true
               [
                 P.keyword "name" (P.Str n.name);
                 P.keyword "sent_by" (P.Str (C.control_sender_value n.from));
                 P.keyword "params" (P.Name params);
               ] ))
      ~doc:(Wrapped n.docs)
  in
  let method_ (m : C.methods_item) =
    let params = component m.params and result = component m.result in
    P.assign (constant m.name) ~annotation:(P.Name "Final")
      ~value:
        (P.Call
           ( P.sub "ControlMethod"
               [ P.item (P.Name params); P.item (P.Name result) ],
             P.items ~magic:true
               [
                 P.keyword "name" (P.Str m.name);
                 P.keyword "params" (P.Name params);
                 P.keyword "result" (P.Name result);
                 P.keyword "exclusive"
                   (P.Name (if m.exclusive then "True" else "False"));
                 P.keyword "sends"
                   (P.tuple
                      (List.map (fun s -> P.item (P.Name (constant s))) m.sends));
               ] ))
      ~doc:(Wrapped m.docs)
  in
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
  in
  let notifications =
    List.map (fun (n : C.notifications_item) -> n.name) t.notifications
  in
  let methods = List.map (fun (m : C.methods_item) -> m.name) t.methods in
  let models =
    List.sort_uniq compare
      (component t.api_version
       :: List.map
            (fun (n : C.notifications_item) -> component n.params)
            t.notifications
      @ List.concat_map
          (fun (m : C.methods_item) ->
            [ component m.params; component m.result ])
          t.methods)
  in
  P.text
    {
      header =
        Banner.python_lines ~from_:"protocol/specs/src/control/methods.json"
          __FILE__;
      doc =
        Wrapped
          (Printf.sprintf
             "The launcher's control API: its version, each of its \
              notifications, and each of its methods, with the models of what \
              each carries. A request that fails carries its error's data as \
              `%s`."
             (component t.error_data));
      imports =
        [
          [
            P.From ("collections.abc", [ "Mapping" ]);
            P.From ("types", [ "MappingProxyType" ]);
            P.From ("typing", [ "Final" ]);
          ];
          [
            P.From
              ( "xynolog.control",
                [
                  "AnyControlMethod";
                  "AnyControlNotification";
                  "ControlMethod";
                  "ControlNotification";
                ] );
            P.From ("xynolog.types", models);
          ];
        ];
      body =
        [
          P.assign "__all__"
            ~value:
              (P.List
                 (P.items ~magic:true
                    (List.map
                       (fun n -> P.item (P.Str n))
                       (List.sort compare
                          ([
                             "CONTROL_API_VERSION";
                             "CONTROL_METHODS";
                             "CONTROL_NOTIFICATIONS";
                           ]
                          @ List.map constant (notifications @ methods))))));
          P.assign "CONTROL_API_VERSION"
            ~annotation:
              (P.sub "Final" [ P.item (P.Name (component t.api_version)) ])
            ~value:(P.Str api_version)
            ~doc:
              (Wrapped
                 "The version of the control API these tables state, which \
                  every request's params state.");
        ]
        @ List.map notification t.notifications
        @ List.map method_ t.methods
        @ [
            by_name
              ~about:
                [
                  Line
                    "Every notification, by its name: for code that is given a \
                     name and not a constant.";
                ]
              ~value_type:"AnyControlNotification" notifications
              "CONTROL_NOTIFICATIONS";
            by_name
              ~about:
                [
                  Line
                    "Every method, by its name: for code that is given a name \
                     and not a constant.";
                ]
              ~value_type:"AnyControlMethod" methods "CONTROL_METHODS";
          ];
    }

(* The languages Xynolog supports, as the Python SDK reads them
   (python/sdk/src/xynolog/locales.py, from
   protocol/specs/src/locales/registry.json): each language's code, what it
   calls itself and its name in English, in the registry's order. A native
   name is written in ASCII, its other characters escaped. *)
module L = Tables.Locales_registry

let locales_path = "python/sdk/src/xynolog/locales.py"

let locales_text (t : L.t) =
  let codes = List.map (fun (l : L.locales_item) -> l.code) t.locales in
  P.text
    {
      header =
        Banner.python_lines ~from_:"protocol/specs/src/locales/registry.json"
          __FILE__;
      doc =
        Wrapped
          "The languages Xynolog supports: each one's code, what it calls \
           itself, and its name in English. A person reads the interface in \
           one of them, a resource is written in one, and a model is told \
           which by its English name.";
      imports =
        [
          [
            P.From ("dataclasses", [ "dataclass" ]);
            P.From ("typing", [ "Final"; "Literal"; "final" ]);
          ];
        ];
      body =
        [
          P.assign "__all__"
            ~value:
              (P.List
                 (P.items ~magic:true
                    (List.map
                       (fun n -> P.item (P.Str n))
                       [ "LOCALES"; "LOCALE_CODES"; "LocaleCode"; "LocaleInfo" ])));
          P.alias "LocaleCode"
            ~doc:(Wrapped "The code of a supported language.")
            (P.sub ~magic:true "Literal"
               (List.map (fun c -> P.item (P.Str c)) codes));
          P.assign "LOCALE_CODES"
            ~annotation:(Bus.Python.final_tuple "LocaleCode")
            ~value:(P.strings ~magic:true codes)
            ~doc:
              (Wrapped
                 "The code of every supported language, in the registry's \
                  order.");
          P.frozen_dataclass "LocaleInfo"
            "A supported language: its code, what it calls itself, and its \
             name in English."
            [
              P.field "code" (P.Name "LocaleCode");
              P.field "native_name" (P.Name "str");
              P.field "english_name" (P.Name "str")
                ~doc:"What a model is told a text is written in.";
            ];
          P.assign "LOCALES"
            ~annotation:(Bus.Python.final_tuple "LocaleInfo")
            ~value:
              (P.tuple ~magic:true
                 (List.map
                    (fun (l : L.locales_item) ->
                      P.item
                        (P.call "LocaleInfo"
                           [
                             P.keyword "code" (P.Str l.code);
                             P.keyword "native_name" (P.Ascii l.native_name);
                             P.keyword "english_name" (P.Str l.english_name);
                           ]))
                    t.locales))
            ~doc:
              (Wrapped "A row per supported language, in the registry's order.");
        ];
    }

let tables_path = "python/sdk/src/xynolog/service_tables.py"

(* [text], JSON, in ASCII: every other character as JSON escapes it. *)
let ascii_json text =
  let out = Buffer.create (String.length text) in
  Text.fold_uchars
    (fun () u ->
      let code = Uchar.to_int u in
      if code < 0x80 then Buffer.add_char out (Char.chr code)
      else if code <= 0xFFFF then
        Buffer.add_string out (Printf.sprintf "\\u%04x" code)
      else
        let v = code - 0x10000 in
        Buffer.add_string out
          (Printf.sprintf "\\u%04x\\u%04x"
             (0xD800 lor (v lsr 10))
             (0xDC00 lor (v land 0x3FF))))
    () text;
  Buffer.contents out

(* [text] in pieces of [size] characters, the last the rest. *)
let rec pieces size text =
  if String.length text <= size then [ text ]
  else
    String.sub text 0 size
    :: pieces size (String.sub text size (String.length text - size))

let tables_text ~root (spec : Spec.t) =
  let tables = Roots.service_tables spec in
  let constant table = Bus.Python.constant (Filename.remove_extension table) in
  let read table =
    ascii_json
      (Yojson.Safe.to_string
         (Yojson.Safe.from_file
            (Filename.concat root ("protocol/specs/src/" ^ table))))
  in
  let table t =
    P.assign (constant t) ~annotation:(P.Name "Final")
      ~value:
        (P.Call
           ( P.Name (table_model t ^ ".model_validate_json"),
             P.items [ P.item (P.Joined (pieces 80 (read t))) ] ))
      ~doc:
        (Wrapped
           (Printf.sprintf "protocol/specs/src/%s, read as `%s`." t
              (table_model t)))
  in
  P.text
    {
      header =
        Banner.python_lines ~from_:"the services' tables of protocol/specs/src"
          __FILE__;
      doc =
        Wrapped
          "The tables the services keep to, each read as its schema's model: \
           the variables a service reads and why it refuses to start, what it \
           tells OpenTelemetry and logs, its messages, its jobs' budgets, the \
           bounds of the bus's replies, and the rest. `SERVICE_TABLES` holds \
           each by its file.";
      imports =
        [
          [
            P.From ("collections.abc", [ "Mapping" ]);
            P.From ("types", [ "MappingProxyType" ]);
            P.From ("typing", [ "Final" ]);
          ];
          [
            P.From ("xynolog.model", [ "WireModel" ]);
            P.From
              ( "xynolog.types",
                List.sort_uniq compare (List.map table_model tables) );
          ];
        ];
      body =
        [
          P.assign "__all__"
            ~value:
              (P.List
                 (P.items ~magic:true
                    (List.map
                       (fun n -> P.item (P.Str n))
                       (List.sort compare
                          ("SERVICE_TABLES" :: List.map constant tables)))));
        ]
        @ List.map table tables
        @ [
            P.assign
              ~about:
                [ Line "Every table, by its file under protocol/specs/src." ]
              "SERVICE_TABLES"
              ~annotation:
                (P.sub "Final"
                   [
                     P.item
                       (P.sub "Mapping"
                          [ P.item (P.Name "str"); P.item (P.Name "WireModel") ]);
                   ])
              ~value:
                (P.call "MappingProxyType"
                   [
                     P.item
                       (P.Dict
                          (P.items ~magic:true
                             (List.map
                                (fun t ->
                                  P.entry (P.Str t) (P.Name (constant t)))
                                tables)));
                   ]);
          ];
    }

(* The Archivist's HTTP surface as the Python SDK reads it
   (python/sdk/src/xynolog/http/archivist_http.py, from
   protocol/specs/src/archivist/openapi.json and its paths): each operation as
   an ArchivistRoute named for its operationId, with its method and its path,
   a [{name}] for each parameter, which the caller fills. *)
let archivist_path = "python/sdk/src/xynolog/http/archivist_http.py"
let archivist_route_name operation_id = Text.upper_snake operation_id

let archivist_text (spec : Spec.t) =
  let operations = Archivist_routes.all spec in
  P.text
    {
      header =
        Banner.python_lines
          ~from_:"protocol/specs/src/archivist/openapi.json and its paths"
          __FILE__;
      doc =
        Wrapped
          "The Archivist's HTTP surface: each of its operations, with its \
           method and its path.";
      imports =
        [
          [
            P.From ("dataclasses", [ "dataclass" ]);
            P.From ("typing", [ "Final"; "final" ]);
          ];
        ];
      body =
        [
          P.assign "__all__"
            ~value:
              (P.List
                 (P.items ~magic:true
                    (List.map
                       (fun n -> P.item (P.Str n))
                       (List.sort compare
                          ("ArchivistRoute"
                          :: List.map
                               (fun (r : Archivist_routes.route) ->
                                 archivist_route_name r.operation.operation_id)
                               operations)))));
          P.frozen_dataclass "ArchivistRoute"
            "An operation of the Archivist: its method, and its path, a \
             `{name}` for each parameter, which the caller fills."
            [ P.field "method" (P.Name "str"); P.field "path" (P.Name "str") ];
        ]
        @ List.map
            (fun { Archivist_routes.method_; path; operation } ->
              let operation_id = operation.operation_id in
              P.assign
                ~about:[ Line ("`" ^ operation_id ^ "`.") ]
                ~annotation:(P.Name "Final")
                ~value:
                  (P.call "ArchivistRoute"
                     [
                       P.keyword "method" (P.Str method_);
                       P.keyword "path" (P.Str path);
                     ])
                (archivist_route_name operation_id))
            operations;
    }

let files ~root (spec : Spec.t) =
  match
    (text spec, control_text spec, Locales.derive spec.tables.locales_registry)
  with
  | _, _, Error errors -> Error errors
  | text, control, Ok locales ->
      Ok
        [
          { Output.path; text };
          { Output.path = control_path; text = control };
          { Output.path = locales_path; text = locales_text locales };
          { Output.path = tables_path; text = tables_text ~root spec };
          { Output.path = archivist_path; text = archivist_text spec };
        ]
  | exception Definitions.Refused message ->
      Error [ { Decode.file = "openapi.json"; pointer = ""; message } ]
