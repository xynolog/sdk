(* The Haskell SDK's models: a type, and its FromJSON and ToJSON, for every
   schema the SDK reads or writes, each in the module of its strongly
   connected component of references, so a module imports only those it
   needs and none imports back.

   Haskell's own choices are this writer's rules. A schema's type is named as
   the schema is; one stated in place takes the name of the schema that
   states its member (through an allOf, the member's own schema) and the
   member's, made unique by "Inline". A string, integer, number and boolean
   are Text, Integer, Scientific and Bool. Words are a type of constructors,
   with a function that gives each its word, branches a type of one
   constructor each, an object a record, and anything
   else a newtype; an identifier's newtype is opaque, made only by its
   module's mk. A member the object needn't state is a Maybe, one it may
   state as null too a Presence, and an object open to other members keeps
   them. *)

module H = Haskell_syntax

let ( let* ) = Result.bind

module Names = Set.Make (String)
module Named = Map.Make (String)

(* What a name is in Haskell: its letters and digits, every other character
   by its code point between U and _, begun upper case, and V before it if it
   would begin with a digit. *)
let identifier value =
  let out = Buffer.create (String.length value) in
  Text.fold_uchars
    (fun () u ->
      match Uchar.to_int u with
      | c
        when (c >= Char.code 'a' && c <= Char.code 'z')
             || (c >= Char.code 'A' && c <= Char.code 'Z')
             || (c >= Char.code '0' && c <= Char.code '9') ->
          Buffer.add_char out (Char.chr c)
      | c -> Buffer.add_string out (Printf.sprintf "U%x_" c))
    () value;
  match Buffer.contents out with
  | "" -> "Value"
  | encoded when encoded.[0] >= '0' && encoded.[0] <= '9' -> "V" ^ encoded
  | encoded -> String.capitalize_ascii encoded

let lower = String.uncapitalize_ascii

(* The name of the type written in place for member [key] of [owner], the
   schema that states it. *)
let member_type owner key = owner ^ identifier key

(* A number as Haskell's Scientific shows it: a whole number below ten
   million with ".0" after it. *)
let scientific n =
  if Float.is_integer n && Float.abs n < 1e7 then Printf.sprintf "%.0f.0" n
  else invalid_arg (Printf.sprintf "Models: no rule shows the number %g" n)

let literal_value : Schema.literal -> H.expr = function
  | String_literal text -> Apply (Name "String", [ Str text ])
  | Int_literal n ->
      Apply
        ( Name "Number",
          [ Apply (Name "read", [ Str (scientific (Float.of_int n)) ]) ] )
  | Bool_literal b ->
      Apply (Name "Bool", [ Name (if b then "True" else "False") ])

type declaration = { owner : string; decls : H.decl list }

type state = {
  mutable definitions : Schema.t Named.t;
  mutable declarations : declaration option Named.t;
      (** [None] while the declaration is being made. *)
  mutable owner : string;
  mutable dependencies : Names.t Named.t;
  ids : Decode.ids;  (** Each schema's [$id]: what a reference names. *)
  identifiers : Names.t;
}

let find state name =
  match Named.find_opt name state.definitions with
  | Some s -> Ok s
  | None -> Error ("unknown schema reference: " ^ name)

let normalize state schema =
  Normalize.normalize state.ids
    ~find:(fun r -> find state (Definitions.referenced r))
    schema

let scalar_type : Schema.type_name -> H.type_ option = function
  | String -> Some (T_name "Text")
  | Integer -> Some (T_name "Integer")
  | Number -> Some (T_name "Scientific")
  | Boolean -> Some (T_name "Bool")
  | Array | Object | Null -> None

let one_type name (s : Schema.schema) =
  match s.type_ with
  | None -> Ok None
  | Some [ t ] -> Ok (Some t)
  | Some _ -> Error (name ^ ": a type of more than one name")

let stated_only keep (s : Schema.schema) =
  List.for_all (fun k -> List.mem k keep) (Schema.keywords s)

let checked name = H.Apply (Name "checked", [ Str name ])

let instance_from name body =
  H.instance "FromJSON" (T_name name)
    [ H.method_ "parseJSON" (Dollar (checked name, body)) ]

let to_json clauses name =
  H.instance "ToJSON" (T_name name) (List.map (fun c -> ("toJSON", c)) clauses)

(* A record's member of type [t] under [key]: the type the record holds it
   as, how its parser reads it from the object it names [row], and how its
   encoder writes [held], its value. A member that may be absent or null is
   a Presence, one that may be absent a Maybe, and one that is required its
   own type, or a Maybe if it may be null. *)
let member ~row ~key ~held ~nullable ~mandatory t =
  if nullable && not mandatory then
    ( H.T_apply ("Presence", [ t ]),
      H.Apply (Name "presence", [ Name row; Str key ]),
      H.Apply (Name "presencePair", [ Str key; held ]) )
  else if mandatory then
    ( (if nullable then H.T_apply ("Maybe", [ t ]) else t),
      H.Infix (Name row, [ (".:", Str key) ]),
      H.List [ Tuple [ Str key; Apply (Name "toJSON", [ held ]) ] ] )
  else
    ( H.T_apply ("Maybe", [ t ]),
      H.Apply (Name "optional", [ Name row; Str key ]),
      H.Apply (Name "optionalPair", [ Str key; held ]) )

(* That the module of what is being declared refers to [component]'s. *)
let depend state component =
  state.dependencies <-
    Named.update state.owner
      (fun found ->
        Some (Names.add component (Option.value found ~default:Names.empty)))
      state.dependencies

let rec type_of state proposed original : (H.type_, string) result =
  let* raw = Normalize.layer original in
  match raw.ref_ with
  | Some r ->
      let target = Definitions.referenced r in
      let* _ = find state target in
      depend state target;
      Ok (H.T_name target)
  | None -> (
      match raw.all_of with
      | Some [ part ] -> type_of state proposed part
      | _ -> structural state proposed original)

and structural state proposed original =
  let* s = normalize state original in
  match s.ref_ with
  | Some r -> Ok (H.T_name (Definitions.referenced r))
  | None when s.one_of <> None || s.any_of <> None || s.enum <> None ->
      inline state proposed original
  | None -> (
      let* t = one_type proposed s in
      match t with
      | Some Array -> (
          match s.items with
          | Some item ->
              Result.map
                (fun t -> H.T_list t)
                (type_of state (proposed ^ "Item") item)
          | None -> Error "array schema has no items")
      | Some Object -> inline state proposed original
      | Some t -> Ok (Option.get (scalar_type t))
      | None when stated_only [ "description"; "$comment" ] s ->
          Ok (H.T_name "Value")
      | None -> Error (proposed ^ ": unsupported type shape"))

and inline state proposed schema =
  match
    ( Named.find_opt proposed state.definitions,
      Named.find_opt proposed state.declarations )
  with
  | Some written, Some (Some { owner; _ }) when written = schema ->
      if owner <> state.owner then depend state owner;
      Ok (H.T_name proposed)
  | _ ->
      let rec unique candidate =
        if Named.mem candidate state.definitions then
          unique (candidate ^ "Inline")
        else candidate
      in
      let name = unique proposed in
      state.definitions <- Named.add name schema state.definitions;
      let* () = declare state name schema in
      Ok (H.T_name name)

(* [component] declared as its own module's, before a schema that inherits
   its properties refers to the types written in place for them. *)
and declare_parent state component =
  let holder = state.owner in
  let* schema = find state component in
  state.owner <- component;
  let declared = declare state component schema in
  state.owner <- holder;
  declared

and declare state name original =
  if Named.mem name state.declarations then Ok ()
  else (
    state.declarations <- Named.add name None state.declarations;
    let owner = state.owner in
    let* s = normalize state original in
    let* () =
      match Null_form.without_null Fun.id s with
      | Ok None -> Ok ()
      | Ok (Some _) ->
          Error
            (name ^ ": nullable named schemas need an explicit representation")
      | Error message -> Error (name ^ ": " ^ message)
    in
    let* decls =
      match (s.enum, s.one_of, s.any_of) with
      | Some values, _, _ -> enumeration name values
      | None, Some parts, _ | None, None, Some parts -> union state name parts
      | None, None, None -> (
          let* t = one_type name s in
          match t with
          | Some Object ->
              object_ state name
                ~owner:
                  (Inherited.of_schemas
                     ~find:(fun n -> Named.find n state.definitions)
                     ~referenced:Definitions.referenced name original)
                s
          | _ -> scalar state name original (Names.mem name state.identifiers))
    in
    state.declarations <-
      Named.add name (Some { owner; decls }) state.declarations;
    Ok ())

and enumeration name values =
  let members =
    List.map
      (fun (v : Schema.literal) ->
        let constructor =
          match v with
          | String_literal text -> name ^ identifier text
          | Int_literal n -> name ^ identifier (scientific (Float.of_int n))
          | Bool_literal b -> name ^ if b then "True" else "False"
        in
        (constructor, literal_value v))
      values
  in
  let constructors = List.map fst members in
  if
    List.length (List.sort_uniq String.compare constructors)
    <> List.length constructors
  then Error "enum name collision"
  else
    let chain =
      List.fold_right
        (fun (constructor, value) rest ->
          H.If
            ( Infix (Name "value", [ ("==", value) ]),
              Apply (Name "pure", [ Name constructor ]),
              rest ))
        members
        (H.Apply (Name "fail", [ Str "unknown enumeration member" ]))
    in
    let words =
      List.filter_map
        (fun (v : Schema.literal) ->
          match v with String_literal text -> Some text | _ -> None)
        values
    in
    let text =
      if List.length words <> List.length values then []
      else
        [
          H.Value
            {
              about = [];
              name = lower name ^ "Text";
              type_ = T_fun (T_name name, T_name "Text");
              clauses =
                List.map2
                  (fun constructor word ->
                    {
                      H.patterns = [ Constructor (constructor, []) ];
                      body = Str word;
                    })
                  constructors words;
            };
        ]
    in
    Ok
      ([
         H.data name ~deriving:[ "Eq"; "Show" ]
           (List.map (fun c -> H.constructor c) constructors);
         instance_from name (Lambda ("value", chain));
         to_json
           (List.map
              (fun (constructor, value) ->
                { H.patterns = [ Constructor (constructor, []) ]; body = value })
              members)
           name;
       ]
      @ text)

(* What a union's member is named by: the schema it names, its kind when it
   is a list or a scalar, and, stated in place as an object, the one string
   its discriminating property admits, else its title. *)
and branch name part =
  let* raw = Normalize.layer part in
  match (raw.ref_, raw.all_of) with
  | Some r, _ -> Ok (Definitions.referenced r)
  | None, Some [ only ] -> branch name only
  | None, _ -> (
      let* t = one_type name raw in
      match t with
      | Some Array -> Ok "List"
      | Some Object | None -> (
          let discriminant =
            List.find_map
              (fun (_, property) ->
                match property with
                | Schema.Schema { const = Some (String_literal v); _ }
                | Schema.Schema { enum = Some [ String_literal v ]; _ } ->
                    Some v
                | _ -> None)
              (Option.value raw.properties ~default:[])
          in
          match (discriminant, raw.title) with
          | Some value, _ -> Ok (Text.pascal value)
          | None, Some title -> Ok (Text.pascal title)
          | None, None -> Ok "Object")
      | Some scalar -> (
          match scalar_type scalar with
          | Some (T_name haskell) -> Ok haskell
          | _ -> Error (name ^ ": a union member of no Haskell scalar")))

and union state name parts =
  let* members =
    Result.map List.rev
      (List.fold_left
         (fun found part ->
           let* found = found in
           let* named = branch name part in
           let constructor = name ^ named in
           if List.mem_assoc constructor found then
             Error (name ^ ": two union members would both be " ^ constructor)
           else
             let* t = type_of state (constructor ^ "Value") part in
             Ok ((constructor, t) :: found))
         (Ok []) parts)
  in
  let parse (constructor, _) =
    H.Infix
      (Name constructor, [ ("<$>", Apply (Name "parseJSON", [ Name "value" ])) ])
  in
  let alternatives =
    match List.map parse members with
    | [] -> assert false
    | first :: rest -> (
        match rest with
        | [] -> first
        | rest -> H.Infix (first, List.map (fun e -> ("<|>", e)) rest))
  in
  Ok
    [
      H.data name ~deriving:[ "Eq"; "Show" ]
        (List.map (fun (c, t) -> H.constructor c ~fields:[ t ]) members);
      instance_from name (Lambda ("value", alternatives));
      to_json
        (List.map
           (fun (c, _) ->
             {
               H.patterns = [ Constructor (c, [ Var "value" ]) ];
               body = Apply (Name "toJSON", [ Name "value" ]);
             })
           members)
        name;
    ]

and scalar state name original opaque =
  let* shape = normalize state original in
  let* value_type =
    match shape.ref_ with
    | Some _ -> type_of state name original
    | None -> (
        let* t = one_type name shape in
        match t with
        | Some Array -> (
            match shape.items with
            | Some item ->
                Result.map
                  (fun t -> H.T_list t)
                  (type_of state (name ^ "Item") item)
            | None -> Error "array has no item schema")
        | Some Object -> Error (name ^ ": unsupported scalar")
        | Some t -> Ok (Option.get (scalar_type t))
        | None when Schema.keywords shape = [] -> Ok (H.T_name "Value")
        | None -> Error (name ^ ": unsupported scalar"))
  in
  let accessor = lower name ^ "Value" in
  let maker = "mk" ^ name in
  let newtype =
    H.Newtype
      {
        about = [];
        name;
        field = (if opaque then None else Some accessor);
        type_ = value_type;
        opaque;
        deriving =
          (if opaque then [ "Eq"; "Ord"; "Show" ] else [ "Eq"; "Show" ]);
      }
  in
  let instances =
    [
      instance_from name
        (Lambda
           ( "value",
             Infix
               ( Name name,
                 [ ("<$>", Apply (Name "parseJSON", [ Name "value" ])) ] ) ));
      to_json
        [
          {
            H.patterns = [ Constructor (name, [ Var "value" ]) ];
            body = Apply (Name "toJSON", [ Name "value" ]);
          };
        ]
        name;
    ]
  in
  if opaque then
    Ok
      ((newtype :: instances)
      @ [
          Value
            {
              about = [];
              name = accessor;
              type_ = T_fun (T_name name, value_type);
              clauses =
                [
                  {
                    patterns = [ Constructor (name, [ Var "value" ]) ];
                    body = Name "value";
                  };
                ];
            };
          Value
            {
              about = [];
              name = maker;
              type_ =
                T_fun
                  ( value_type,
                    T_apply ("Either", [ T_name "String"; T_name name ]) );
              clauses =
                [
                  {
                    patterns = [ Var "value" ];
                    body =
                      Apply
                        ( Name "parseEither",
                          [
                            Name "parseJSON";
                            Apply (Name "toJSON", [ Name "value" ]);
                          ] );
                  };
                ];
            };
        ])
  else Ok (newtype :: instances)

and object_ state name ~owner (s : Schema.schema) =
  let properties =
    List.sort
      (fun (a, _) (b, _) -> String.compare a b)
      (Option.value s.properties ~default:[])
  in
  let required = Option.value s.required ~default:[] in
  let open_ = s.additional_properties <> Some (Boolean_schema false) in
  let names = H.List (List.map (fun (k, _) -> H.Str k) properties) in
  let* members =
    Result.map List.rev
      (List.fold_left
         (fun found (key, property) ->
           let* found = found in
           let* fields = Normalize.layer property in
           let suffix = identifier key in
           let field = lower name ^ suffix in
           let* beside =
             Result.map_error
               (fun message -> name ^ "." ^ key ^ ": " ^ message)
               (Null_form.without_null Fun.id fields)
           in
           let nullable = Option.is_some beside in
           let mandatory = List.mem key required in
           let owner = owner key in
           let* () =
             if owner = name then Ok () else declare_parent state owner
           in
           let* t =
             type_of state (member_type owner key)
               (Schema (Option.value beside ~default:fields))
           in
           let held = H.Apply (Name field, [ Name "value" ]) in
           let typ, parser, encoder =
             member ~row:"fields" ~key ~held ~nullable ~mandatory t
           in
           Ok ((field, typ, parser, encoder) :: found))
         (Ok []) properties)
  in
  let* extra_type =
    match s.additional_properties with
    | Some (Schema _ as typed) -> type_of state (name ^ "AdditionalValue") typed
    | _ -> Ok (H.T_name "Value")
  in
  let extras = lower name ^ "AdditionalProperties" in
  let without held = H.Apply (Name "withoutFields", [ names; held ]) in
  let fields =
    List.map (fun (f, t, _, _) -> (f, t)) members
    @
    if open_ then [ (extras, H.T_apply ("KM.KeyMap", [ extra_type ])) ] else []
  in
  let parsers =
    List.map (fun (_, _, p, _) -> p) members
    @
    if open_ then
      [
        H.Apply (Name "traverse", [ Name "parseJSON"; without (Name "fields") ]);
      ]
    else []
  in
  let declaration =
    match fields with
    | [] -> H.data name ~deriving:[ "Eq"; "Show" ] [ H.constructor name ]
    | fields -> H.record name ~deriving:[ "Eq"; "Show" ] fields
  in
  let reader =
    match parsers with
    | [] -> H.Lambda ("_", Apply (Name "pure", [ Name name ]))
    | first :: rest ->
        Lambda
          ( "fields",
            Infix
              (Name name, ("<$>", first) :: List.map (fun p -> ("<*>", p)) rest)
          )
  in
  let known =
    H.Apply
      ( Name "KM.fromList",
        [
          Apply
            (Name "concat", [ List (List.map (fun (_, _, _, e) -> e) members) ]);
        ] )
  in
  let encoded =
    if open_ then
      H.Infix
        ( known,
          [
            ( "<>",
              Apply
                ( Name "fmap",
                  [
                    Name "toJSON";
                    without (Apply (Name extras, [ Name "value" ]));
                  ] ) );
          ] )
    else known
  in
  let argument =
    if members = [] && not open_ then H.Otherwise else Var "value"
  in
  Ok
    [
      declaration;
      instance_from name (Apply (Name "withObject", [ Str name; reader ]));
      to_json
        [
          {
            H.patterns = [ argument ];
            body = Apply (Name "Object", [ encoded ]);
          };
        ]
        name;
    ]

(* Tarjan's strongly connected components of [names] by [edges], each sorted
   by name. *)
let components names edges =
  let index = Hashtbl.create 64
  and low = Hashtbl.create 64
  and on_stack = Hashtbl.create 64 in
  let stack = ref [] and counter = ref 0 and found = ref [] in
  let rec visit v =
    Hashtbl.replace index v !counter;
    Hashtbl.replace low v !counter;
    incr counter;
    stack := v :: !stack;
    Hashtbl.replace on_stack v ();
    Names.iter
      (fun w ->
        if Names.mem w names then
          if not (Hashtbl.mem index w) then (
            visit w;
            Hashtbl.replace low v
              (min (Hashtbl.find low v) (Hashtbl.find low w)))
          else if Hashtbl.mem on_stack w then
            Hashtbl.replace low v
              (min (Hashtbl.find low v) (Hashtbl.find index w)))
      (edges v);
    if Hashtbl.find low v = Hashtbl.find index v then
      let rec pop acc =
        match !stack with
        | w :: rest ->
            stack := rest;
            Hashtbl.remove on_stack w;
            if w = v then w :: acc else pop (w :: acc)
        | [] -> acc
      in
      found := List.sort String.compare (pop []) :: !found
  in
  Names.iter (fun v -> if not (Hashtbl.mem index v) then visit v) names;
  !found

type t = {
  modules : H.module_ list;  (** One a component, by its module's name. *)
  module_names : string list;  (** In order of name. *)
  definitions : (string * Schema.t) list;
      (** Every schema a type was made for, those stated in place among them, by
          name. *)
}

let prefix = "Xynolog.Internal.Generated.Models."

let aeson_names =
  [
    (`Type, "FromJSON", H.All "FromJSON");
    (`Value, "parseJSON", All "FromJSON");
    (`Type, "ToJSON", All "ToJSON");
    (`Value, "toJSON", All "ToJSON");
    (`Type, "Value", All "Value");
    (`Value, "String", All "Value");
    (`Value, "Number", All "Value");
    (`Value, "Bool", All "Value");
    (`Value, "Object", All "Value");
    (`Value, "withObject", Plain "withObject");
    (`Value, ".:", Op ".:");
  ]

(* The imports of a model module: those of the fixed modules it uses, then
   those of the components it refers to. *)
let imports body dependencies =
  let used = H.uses body in
  let value name = List.mem name used.values
  and type_ name = List.mem name used.types in
  let aeson =
    List.fold_left
      (fun kept (namespace, name, item) ->
        let uses =
          match namespace with `Type -> type_ name | `Value -> value name
        in
        if uses && not (List.mem item kept) then kept @ [ item ] else kept)
      [] aeson_names
  in
  let when_ condition import = if condition then [ import ] else [] in
  when_ (value "<|>") (H.import "Control.Applicative" ~items:[ Op "<|>" ])
  @ when_ (aeson <> []) (H.import "Data.Aeson" ~items:aeson)
  @ when_ (value "parseEither")
      (H.import "Data.Aeson.Types" ~items:[ Plain "parseEither" ])
  @ when_
      (List.exists
         (fun n -> String.starts_with ~prefix:"KM." n)
         (used.types @ used.values))
      (H.import "Data.Aeson.KeyMap" ~qualified:"KM")
  @ when_ (type_ "Scientific")
      (H.import "Data.Scientific" ~items:[ Plain "Scientific" ])
  @ when_ (type_ "Text") (H.import "Data.Text" ~items:[ Plain "Text" ])
  @ when_
      (List.exists value
         [
           "checked";
           "optional";
           "presence";
           "optionalPair";
           "presencePair";
           "withoutFields";
         ])
      (H.import "Xynolog.Internal.Codec")
  @ when_ (type_ "Presence")
      (H.import "Xynolog.Types.Presence" ~items:[ Plain "Presence" ])
  @ List.map (fun m -> H.import m) dependencies

let generate ~banner ~ids ~identifiers definitions =
  let state =
    {
      definitions = Named.of_list definitions;
      declarations = Named.empty;
      owner = "";
      dependencies = Named.empty;
      ids;
      identifiers = Names.of_list identifiers;
    }
  in
  let* () =
    List.fold_left
      (fun ok (name, schema) ->
        let* () = ok in
        state.owner <- name;
        declare state name schema)
      (Ok ())
      (Named.bindings state.definitions)
  in
  let roots = Names.of_list (List.map fst definitions) in
  let edges name =
    Option.value (Named.find_opt name state.dependencies) ~default:Names.empty
  in
  let groups = components roots edges in
  let module_of = Hashtbl.create 64 in
  List.iter
    (fun group ->
      let m = prefix ^ List.hd group in
      List.iter (fun root -> Hashtbl.replace module_of root m) group)
    groups;
  let declared =
    List.filter_map (fun (_, d) -> d) (Named.bindings state.declarations)
  in
  let modules =
    List.map
      (fun group ->
        let name = prefix ^ List.hd group in
        let owned =
          List.filter (fun (d : declaration) -> List.mem d.owner group) declared
        in
        let dependencies =
          Names.elements
            (Names.of_list
               (List.filter_map
                  (fun dependency ->
                    match Hashtbl.find_opt module_of dependency with
                    | Some m when m <> name -> Some m
                    | _ -> None)
                  (List.concat_map
                     (fun root -> Names.elements (edges root))
                     group)))
        in
        let body = List.concat_map (fun (d : declaration) -> d.decls) owned in
        {
          H.banner;
          extensions = [ "OverloadedStrings" ];
          name;
          imports = imports body dependencies;
          body;
        })
      groups
  in
  Ok
    {
      modules;
      module_names =
        List.sort String.compare (List.map (fun m -> m.H.name) modules);
      definitions = Named.bindings state.definitions;
    }
