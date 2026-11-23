(* The Python SDK's protocol types (python/sdk/src/xynolog/types.py): a
   frozen [WireModel] for every component schema and every record Protocol
   states in its tables ([Table_records]), with every schema they reach,
   that is an object, and a type alias for every other, but the kinds of id,
   which [xynolog.identifiers] holds. They are types, and state no rule beside
   what a type says: what a value must be is the required table's
   ([_required_table.py]), which the SDK holds what it reads to.

   A schema written in place is declared on its own, named for where it is
   ([Naming.inline]): an object of properties, a closed set of more than one
   word, an [allOf], and a union an array holds. A union's member that is no
   schema is named by the one value its discriminating property takes, or
   [Object] or [Empty]. An [allOf] of schemas and of properties beside them
   is a class of those schemas, unless it restates one of their properties,
   when it is written whole. *)

module D = Definitions
module P = Python_syntax

let path = "python/sdk/src/xynolog/types.py"
let refuse = D.refuse

type state = {
  definitions : D.definitions;
  kinds : string list;
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
    if s <> "" && (s.[0] = '@' || s.[0] = '_') then
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

let properties (n : D.node) = Option.value n.properties ~default:[]

(* An object no member of which is allowed. *)
let is_empty (n : D.node) = properties n = [] && n.max_properties = Some 0

(* An object a class declares: one of properties, or one closed to any. *)
let is_class (n : D.node) =
  (n.type_ = Some (D.One Object) || (n.type_ = None && properties n <> []))
  && (properties n <> []
     || n.additional_properties = Some (D.Bool false)
     || is_empty n)

let named st owner part =
  let name =
    Naming.inline ~defined:(fun n -> List.mem n st.definitions.names) owner part
  in
  if List.mem_assoc name st.declared then
    refuse "two schemas written in place would both be named %s" name;
  name

let declare st name decl = st.declared <- (name, decl) :: st.declared

(* The one value an object's discriminating property takes: the first of
   its properties that admits exactly one text. *)
let discriminant (n : D.node) =
  List.find_map (fun (_, p) -> View.only_value p) (properties n)

let rec placed st owner held_as (s : D.t) : P.expr =
  match View.without_null s with
  | Some inner -> union [ placed st owner held_as inner; none ]
  | None -> (
      match s with
      | D.Ref { name = n; _ } -> name n
      | D.Null -> none
      | D.Bool true -> json
      | D.Bool false ->
          refuse "%s.%s: a schema that admits nothing" owner held_as
      | D.Node n -> (
          match (n.all_of, View.union s, n.enum) with
          | Some _, _, _ -> (
              match D.meant s with
              | D.Node m when is_class m ->
                  let name = named st owner held_as in
                  declare st name (declaration st name s);
                  P.Name name
              | merged -> placed st owner held_as merged)
          | None, Some members, _ ->
              union (List.map (member st (owner ^ Text.pascal held_as)) members)
          | None, None, Some ([ _ ] as one) -> literals one
          | None, None, Some values
            when n.type_ = Some (D.One String)
                 && not (List.mem (owner, held_as) st.tagged) ->
              let name = named st owner held_as in
              declare st name (declaration st name s);
              P.Name name
          | None, None, Some values -> literals values
          | None, None, None when is_class n ->
              let name = named st owner held_as in
              declare st name (declaration st name s);
              P.Name name
          | None, None, None -> (
              match n.type_ with
              | Some (D.One t) -> scalar st owner held_as n t
              | Some (D.Or_null _) | None -> json)))

and scalar st owner held_as (n : D.node) (t : Schema.type_name) : P.expr =
  match t with
  | String -> name (if n.format = Some Binary then "bytes" else "str")
  | Integer -> name "int"
  | Number -> name "float"
  | Boolean -> name "bool"
  | Null -> none
  | Array -> sub "list" [ item st owner (held_as ^ "Item") n.items ]
  | Object -> (
      match n.additional_properties with
      | Some (D.Bool true) | None -> sub "dict" [ name "str"; json ]
      | Some values ->
          sub "dict" [ name "str"; placed st owner (held_as ^ "Value") values ])

(* What an array holds; a union it holds is named. *)
and item st owner held_as items =
  match items with
  | None -> json
  | Some items -> (
      let t = placed st owner held_as items in
      match (View.without_null items, View.union items) with
      | None, Some _ ->
          let name = named st owner held_as in
          declare st name (typed_alias name items t);
          P.Name name
      | _ -> t)

(* [name] for [t], with what [s] says of it: its description, and the
   property a union is told apart by. *)
and typed_alias name (s : D.t) t =
  let keywords =
    (match View.description s with
      | Some d -> [ P.keyword "description" (Str d) ]
      | None -> [])
    @
    match s with
    | D.Node { discriminator = Some tag; _ } ->
        [ P.keyword "discriminator" (Str (python_name tag)) ]
    | _ -> []
  in
  P.alias name
    (if keywords = [] then t else sub "Annotated" [ t; P.call "Field" keywords ])

(* One member of the union [union] names. *)
and member st union (s : D.t) =
  match s with
  | D.Node n when View.without_null s = None && is_class n ->
      let variant =
        match discriminant n with
        | Some v -> v
        | None -> if properties n = [] then "Empty" else "Object"
      in
      let name = named st union variant in
      declare st name (declaration st name s);
      P.Name name
  | D.Node ({ type_ = Some (D.One Array); _ } as n)
    when View.without_null s = None ->
      sub "list" [ item st union "Item" n.items ]
  | _ -> placed st union "Value" s

and field st owner ~required (wire, (s : D.t)) =
  let before = List.map fst st.declared in
  let t = placed st owner wire s in
  (* A type declared for this property alone says what the property is. *)
  let declared_here = function
    | P.Name n | P.Binary (P.Name n, P.Or, P.Name "None") ->
        List.mem_assoc n st.declared && not (List.mem n before)
    | _ -> false
  in
  let optional = not (List.mem wire required) in
  let t =
    if optional && View.without_null s = None then union [ t; none ] else t
  in
  let python = python_name wire in
  let keywords =
    (if python <> wire then [ P.keyword "alias" (Str wire) ] else [])
    @
    match View.description s with
    | Some d when not (declared_here t) -> [ P.keyword "description" (Str d) ]
    | _ -> []
  in
  P.field python
    (if keywords = [] then t else sub "Annotated" [ t; P.call "Field" keywords ])
    ?default:(if optional then Some none else None)

and fields st owner (n : D.node) =
  let required = Option.value n.required ~default:[] in
  let seen = Hashtbl.create 8 in
  List.iter
    (fun (wire, _) ->
      let python = python_name wire in
      match Hashtbl.find_opt seen python with
      | Some other ->
          refuse
            "%s: the properties %S and %S would both be the Python field %s"
            owner other wire python
      | None -> Hashtbl.replace seen python wire)
    (properties n);
  List.map (field st owner ~required) (properties n)

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

and extra (n : D.node) =
  match n.additional_properties with
  | _ when is_empty n -> Some "forbid"
  | Some (D.Bool false) -> Some "forbid"
  | Some (D.Bool true) -> Some "allow"
  | Some _ ->
      refuse "an object of properties whose other members are of a schema"
  | None -> None

and object_class st name (n : D.node) ~doc =
  class_ name ~bases:[ "WireModel" ] ~extra:(extra n) ~doc (fields st name n)

(* A schema declared by [name]. *)
and declaration st name (s : D.t) : P.stmt =
  let doc = docstring (View.description s) in
  let alias t = typed_alias name s t in
  match s with
  | D.Node ({ all_of = Some parts; _ } as n) -> inherited st name n parts ~doc
  | D.Node _
    when Option.fold ~none:false
           ~some:(fun ms -> not (List.mem D.Null ms))
           (View.union s) ->
      alias (union (List.map (member st name) (Option.get (View.union s))))
  | D.Node n
    when is_class n
         || (n.type_ = Some (D.One Object) && n.additional_properties = None) ->
      object_class st name n ~doc
  | D.Node ({ type_ = Some (D.One Array); _ } as n) ->
      alias (sub "list" [ item st name "Item" n.items ])
  | _ -> (
      match (s : D.t) with
      | D.Node { enum = Some values; _ } -> alias (literals values)
      | _ -> alias (placed st name "" s))

(* An [allOf]: a class of the schemas it names, with the properties stated
   beside them, or, when those restate one of theirs, the whole of what
   they say. *)
and inherited st name (n : D.node) parts ~doc =
  let bases = List.filter_map View.reference parts in
  let own = List.filter_map (function D.Node o -> Some o | _ -> None) parts in
  let rec stated (s : D.t) =
    match View.resolved st.definitions s with
    | D.Node m ->
        List.map fst (properties m)
        @ List.concat_map stated (Option.value m.all_of ~default:[])
    | _ -> []
  in
  let inherited_properties =
    List.concat_map
      (fun b -> stated (D.Ref { name = b; description = None }))
      bases
  in
  let restated =
    List.exists
      (fun (o : D.node) ->
        List.exists
          (fun (k, _) -> List.mem k inherited_properties)
          (properties o))
      own
  in
  if restated || bases = [] then
    match D.meant (D.Node n) with
    | D.Node merged -> object_class st name merged ~doc
    | _ -> refuse "%s: an allOf whose parts merge to no object" name
  else
    let body =
      List.concat_map
        (fun o -> fields st name o)
        (own @ if properties n = [] then [] else [ n ])
    in
    let extras = List.filter_map extra own in
    class_ name ~bases
      ~extra:(match extras with [] -> None | e :: _ -> Some e)
      ~doc body

(* The type a value of [s] is held as where it is stated, [at] being the
   schema and its member that state it: what types.py names it there, or, a
   value stated alone, what it is. One stated alone that types.py would have
   to declare is refused, since none does. *)
let held ~(definitions : D.definitions) ?at (s : D.t) =
  let st = { definitions; kinds = []; tagged = []; declared = [] } in
  match at with
  | Some (owner, member) -> placed st owner member s
  | None ->
      let t = placed st "" "" s in
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

(* The module for [definitions], whose [kinds] of id are xynolog.identifiers'. *)
let module_ ~kinds ~also (definitions : D.definitions) =
  let rec tagged (s : D.t) =
    match s with
    | D.Node n ->
        let here =
          match (n.discriminator, View.union s) with
          | Some tag, Some members ->
              List.filter_map
                (fun m -> Option.map (fun r -> (r, tag)) (View.reference m))
                members
          | _ -> []
        in
        here
        @ List.concat_map (fun (_, p) -> tagged p) (properties n)
        @ List.concat_map tagged
            (Option.to_list n.items
            @ Option.value n.all_of ~default:[]
            @ Option.value (View.union s) ~default:[])
    | _ -> []
  in
  let st =
    {
      definitions;
      kinds;
      tagged =
        List.concat_map
          (fun c -> tagged (definitions.schema c))
          definitions.names;
      declared = [];
    }
  in
  let decls =
    List.concat_map
      (fun component ->
        if List.mem component kinds then []
        else
          let before = st.declared in
          let decl = declaration st component (definitions.schema component) in
          let placed =
            List.rev
              (List.filter (fun d -> not (List.memq d before)) st.declared)
          in
          (component, decl) :: placed)
      definitions.names
    @ also
  in
  let names = List.sort compare (List.map fst decls) in
  P.text
    {
      header =
        Banner.python_lines
          ~from_:
            "the component schemas of protocol/specs/src/openapi.json, the \
             records of its tables, its client types and \
             client/discovery-absent.json"
          __FILE__;
      doc =
        As_is
          "The protocol's shapes: a model for every component schema and table \
           record that is an object, and a type for every other.";
      imports =
        [
          [ P.From ("__future__", [ "annotations" ]) ];
          [
            P.From ("typing", [ "Annotated"; "Literal" ]);
            P.From ("pydantic", [ "JsonValue"; "Field" ]);
            P.From ("xynolog.model", [ "WireModel" ]);
            P.From ("xynolog.identifiers", kinds);
          ];
        ];
      body =
        P.assign "__all__"
          ~value:
            (P.List
               (P.items ~magic:true
                  (List.map (fun n -> P.item (P.Str n)) names)))
        :: List.map snd (ordered decls);
    }

(* The schemas [s] names. *)
let rec named_in (s : D.t) =
  match s with
  | D.Ref { name; _ } -> [ name ]
  | D.Null | D.Bool _ -> []
  | D.Node n ->
      List.concat_map named_in
        (List.map snd (properties n)
        @ Option.to_list n.additional_properties
        @ Option.to_list n.items
        @ List.concat (List.filter_map Fun.id [ n.all_of; n.any_of; n.one_of ])
        )

(* Why a client that read a launcher's discovery document found no launcher
   (protocol/specs/src/client/discovery-absent.json): a word a reason, each
   reason's meaning in the docstring. *)
let discovery_absent (spec : Spec.t) =
  let reasons = spec.tables.client_discovery_absent.reasons in
  ( "DiscoveryAbsentReason",
    P.alias
      ~doc:
        (As_is
           (String.concat "\n\n"
              ("Why no launcher was found."
              :: List.map
                   (fun (r : Tables.Client_discovery_absent.reasons_item) ->
                     Printf.sprintf "`%s`: %s" r.reason r.docs)
                   reasons)))
      "DiscoveryAbsentReason"
      (P.sub "Literal"
         (List.map
            (fun (r : Tables.Client_discovery_absent.reasons_item) ->
              P.item (P.Str r.reason))
            reasons)) )

let text (spec : Spec.t) =
  let definitions = (Definitions.bundle spec).definitions in
  let rec reach written = function
    | [] -> written
    | name :: rest when List.mem name written -> reach written rest
    | name :: rest ->
        reach (name :: written) (named_in (definitions.schema name) @ rest)
  in
  module_
    ~also:[ discovery_absent spec ]
    ~kinds:
      (List.sort compare
         (List.map
            (fun (k : Tables.Identifiers_kinds.kinds_item) -> k.schema)
            spec.tables.identifiers_kinds.kinds))
    {
      definitions with
      names =
        List.sort compare
          (reach definitions.names
             (List.map (fun (_, name, _) -> name) (Definitions.records spec)
             @ Definitions.generated_client_types spec));
    }

let files ~root:_ (spec : Spec.t) =
  match text spec with
  | text -> Ok [ { Output.path; text } ]
  | exception Definitions.Refused message ->
      Error [ { Decode.file = "openapi.json"; pointer = ""; message } ]
