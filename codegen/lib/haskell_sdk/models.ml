(* The Haskell SDK's models: a type, and its FromJSON and ToJSON, for every
   schema the SDK reads or writes, each in the module of its strongly
   connected component of references, so a module imports only those it
   needs and none imports back. What each schema and member is, is its
   declaration in [Typing], made of the SDK's definitions; the schema itself
   is kept beside it, as the SDK validates a value against it.

   Haskell's own choices are this writer's rules, and where they are not
   [Typing]'s they are [Deviations]. A type is named as [Typing] names it,
   a union's constructor as the union and its member's variant, a field as
   its record and its member, and an enumeration's constructor as the
   enumeration and its value. A string, integer, number and boolean are
   Text, Integer, Scientific and Bool. Words are a type of constructors, with
   a function that gives each its word, branches a type of one constructor
   each, an object a record, a map or a scalar whose schema states nothing
   its type cannot carry that type, and anything else a newtype; an
   identifier's newtype is opaque, made only by its module's mk. A member
   the object needn't state is a Maybe, and an object open to other members
   keeps them. *)

module H = Haskell_syntax
module T = Typing

let ( let* ) = Result.bind

module Names = Set.Make (String)
module Named = Map.Make (String)

let lower = String.uncapitalize_ascii

(* An enumeration's constructor for [value]: the enumeration's name and the
   value's ([Naming.variant]). *)
let constructor enumeration : Schema.literal -> string = function
  | String_literal text -> enumeration ^ Naming.variant text
  | Int_literal n -> enumeration ^ Naming.variant (string_of_int n)
  | Bool_literal b -> enumeration ^ if b then "True" else "False"

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
  keys : Names.t;  (** The identifiers a named map's members are named by. *)
  mutable enumerations : (string * Schema.literal list) list;
      (** Every enumeration declared, and its values. *)
  mutable union_members : Names.t;
      (** The types written in place as a union's members. *)
  mutable unions : (string * T.branch list) list;
      (** Every union declared, and its members. *)
  typing : T.t;
}

let find state name =
  match Named.find_opt name state.definitions with
  | Some s -> Ok s
  | None -> Error ("unknown schema reference: " ^ name)

let normalize state schema =
  Normalize.normalize state.ids
    ~find:(fun r -> find state (Definitions.referenced r))
    schema

let checked name = H.Apply (Name "checked", [ Str name ])

let instance_from name body =
  H.instance "FromJSON" (T_name name)
    [ H.method_ "parseJSON" (Dollar (checked name, body)) ]

let to_json clauses name =
  H.instance "ToJSON" (T_name name) (List.map (fun c -> ("toJSON", c)) clauses)

(* A record's member of type [t] under [key]: the type the record holds it
   as, how its parser reads it from the object it names [row], and how its
   encoder writes [held], its value. A member that may be absent is a Maybe,
   and one that is required its own type, or a Maybe if it may be null. *)
let member ~row ~key ~held ~nullable ~mandatory t =
  if mandatory then
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

(* The function that gives each value of the enumeration [name] its word. *)
let words_of name = lower name ^ "Text"

(* The words of an enumeration of [values] that is one of words, and so has
   [words_of]. *)
let words values =
  let words =
    List.filter_map
      (fun (v : Schema.literal) ->
        match v with
        | String_literal text -> Some text
        | Int_literal _ | Bool_literal _ -> None)
      values
  in
  if List.length words = List.length values then Some words else None

let enumeration name values =
  let members =
    List.map
      (fun (v : Schema.literal) -> (constructor name v, literal_value v))
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
    let text =
      match words values with
      | None -> []
      | Some words ->
          [
            H.Value
              {
                about = [];
                name = words_of name;
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

(* A value's kind, as [Xynolog.Internal.Codec.Kind] names it. *)
let kind : T.kind -> string = function
  | Text_kind -> "TextKind"
  | Integer_kind -> "IntegerKind"
  | Number_kind -> "NumberKind"
  | Boolean_kind -> "BooleanKind"
  | List_kind -> "ListKind"
  | Object_kind -> "ObjectKind"
  | Null_kind -> "NullKind"
  | Any_kind -> "AnyKind"

(* What a union's member admits, as [Xynolog.Internal.Codec.Signature] holds
   it. *)
let signature (s : T.signature) =
  let keys names = H.List (List.map (fun n -> H.Str n) names) in
  let values vs = H.List (List.map literal_value vs) in
  let maybe f = function
    | None -> H.Name "Nothing"
    | Some v -> H.Apply (Name "Just", [ f v ])
  in
  H.Construct
    ( "Signature",
      [
        ("signatureKind", Name (kind s.kind));
        ("signatureRequired", keys s.required);
        ("signatureAllowed", maybe keys s.allowed);
        ( "signatureFixed",
          List
            (List.map
               (fun (name, vs) -> H.Tuple [ Str name; values vs ])
               s.fixed) );
        ("signaturePattern", maybe (fun p -> H.Str p) s.pattern);
        ("signatureValues", maybe values s.values);
      ] )

(* A union's type, a constructor of each member's type, read as the member
   whose signatures admit the value. *)
let union_decls name members =
  let member (constructor, _, signatures) =
    H.Tuple
      [
        List (List.map signature signatures);
        Infix
          ( Name constructor,
            [ ("<$>", Apply (Name "parseJSON", [ Name "value" ])) ] );
      ]
  in
  Ok
    [
      H.data name ~deriving:[ "Eq"; "Show" ]
        (List.map (fun (c, t, _) -> H.constructor c ~fields:[ t ]) members);
      instance_from name
        (Lambda
           ( "value",
             Apply
               ( Name "readMember",
                 [ Str name; List (List.map member members); Name "value" ] ) ));
      to_json
        (List.map
           (fun (c, _, _) ->
             {
               H.patterns = [ Constructor (c, [ Var "value" ]) ];
               body = Apply (Name "toJSON", [ Name "value" ]);
             })
           members)
        name;
    ]

(* A newtype of [value_type]: an identifier's opaque, made only by its
   module's mk, and a map's [key] read and written as the map's keys. Its
   instances read and write the value with [read] and [write]: aeson's own,
   or Codec's base64 of bytes, which aeson has no JSON of. *)
let newtype_decls name ~constructor ~read ~write value_type opaque ~key =
  let accessor = lower name ^ "Value" in
  let maker = "mk" ^ name in
  let newtype =
    H.Newtype
      {
        about = [];
        name;
        constructor;
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
               ( Name constructor,
                 [ ("<$>", Apply (Name read, [ Name "value" ])) ] ) ));
      to_json
        [
          {
            H.patterns = [ Constructor (constructor, [ Var "value" ]) ];
            body = Apply (Name write, [ Name "value" ]);
          };
        ]
        name;
    ]
  in
  let keyed =
    if key then
      [
        H.instance "FromJSONKey" (T_name name)
          [
            H.method_ "fromJSONKey"
              (Apply
                 ( Name "FromJSONKeyTextParser",
                   [ Compose (Name "parseJSON", Name "String") ] ));
          ];
        H.instance "ToJSONKey" (T_name name)
          [
            H.method_ "toJSONKey"
              (Apply (Name "toJSONKeyText", [ Name accessor ]));
          ];
      ]
    else []
  in
  if opaque then
    Ok
      ((newtype :: instances) @ keyed
      @ [
          Value
            {
              about = [];
              name = accessor;
              type_ = T_fun (T_name name, value_type);
              clauses =
                [
                  {
                    patterns = [ Constructor (constructor, [ Var "value" ]) ];
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

(* A record of [members], each its field, type, parser and encoder, and the
   members of an open object beside them. *)
let object_decls name ~constructor ~open_ ~names ~extra_type members =
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
    | [] -> H.data name ~deriving:[ "Eq"; "Show" ] [ H.constructor constructor ]
    | fields -> H.record name ~constructor ~deriving:[ "Eq"; "Show" ] fields
  in
  let reader =
    match parsers with
    | [] -> H.Lambda ("_", Apply (Name "pure", [ Name constructor ]))
    | first :: rest ->
        Lambda
          ( "fields",
            Infix
              ( Name constructor,
                ("<$>", first) :: List.map (fun p -> ("<*>", p)) rest ) )
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

let scalar_of : T.scalar -> H.type_ = function
  | Text { binary = true; _ } -> T_name "ByteString"
  | Text _ -> T_name "Text"
  | Code vocabulary -> T_name (Error_codes.Haskell.type_of vocabulary)
  | Integer _ -> T_name "Integer"
  | Number -> T_name "Scientific"
  | Boolean -> T_name "Bool"

(* The schema [original] states in place at [part]: its property [key], its
   items, or its union's members, after its [allOf] merges. *)
let property state name original key =
  let* s = normalize state original in
  match Option.bind s.properties (List.assoc_opt key) with
  | Some p -> Ok p
  | None -> Error (name ^ " has no property " ^ key)

let items state name original =
  let* s = normalize state original in
  match s.items with
  | Some item -> Ok item
  | None -> Error (name ^ ": array schema has no items")

let union_parts state name original =
  let* s = normalize state original in
  match (s.one_of, s.any_of) with
  | Some parts, _ | None, Some parts -> Ok parts
  | None, None -> Error (name ^ ": a union of no members")

(* The schema beside null of [original], or [original]. *)
let beside_null name original =
  let* fields = Normalize.layer original in
  let* beside =
    Result.map_error
      (fun message -> name ^ ": " ^ message)
      (Null_form.without_null Fun.id fields)
  in
  Ok (Schema.Schema (Option.value beside ~default:fields))

(* Whether [original] states no keyword but [keywords]: no constraint the
   type it is held as cannot carry. *)
let holds_only state original keywords =
  let* s = normalize state original in
  match Schema.runtime (Schema.Schema s) with
  | `Assoc stated ->
      Ok (List.for_all (fun (k, _) -> List.mem k keywords) stated)
  | _ -> Ok false

(* The keywords a map's type carries: its kind, its members' values and, of a
   named key, their names. *)
let map_keywords key =
  [ "type"; "additionalProperties" ]
  @ match key with Some _ -> [ "propertyNames" ] | None -> []

(* The type [ty] is in Haskell, [original] the schema it is read from, at
   [at]. *)
let rec type_of state at original (ty : T.ty) : (H.type_, string) result =
  let* raw = Normalize.layer original in
  match (raw.ref_, raw.all_of, ty) with
  | None, Some [ part ], _ -> (
      (* Deviations.haskell_one_all_of *)
      match part with
      | Schema.Schema { ref_ = Some r; _ } ->
          let target = Definitions.referenced r in
          depend state target;
          Ok (H.T_name target)
      | _ -> type_of state at part ty)
  | _, _, Inline { form = Enum { base = Some s; _ }; _ } ->
      let* merged = normalize state original in
      if Deviations.haskell_enumeration merged then stated state at original ty
      else Ok (scalar_of s)
  | _ -> stated state at original ty

and stated state at original (ty : T.ty) =
  match ty with
  | Named target ->
      depend state target;
      Ok (H.T_name target)
  | Scalar (Text { binary = true; _ }) ->
      Error
        (at
       ^ ": bytes stated in place, which aeson has no JSON of; a named schema \
          of bytes is a newtype that reads and writes them as base64")
  | Scalar s -> Ok (scalar_of s)
  | List (Some item) ->
      let* item_schema = items state at original in
      Result.map (fun t -> H.T_list t) (type_of state at item_schema item)
  | Any -> Ok (H.T_name "Value")
  | Inline ({ form = Map { key; value }; _ } as i) ->
      let* only = holds_only state original (map_keywords key) in
      if only then map_of state i.name original key value
      else inline state original i
  | Inline i -> inline state original i
  | List None | Null | Nothing | Nullable _ ->
      Error (at ^ ": unsupported type shape")

(* The map [original] states, its members named by [key] and each of
   [value]: a [Map] by a named key's type, else a [KM.KeyMap]. *)
and map_of state at original key value =
  let* s = normalize state original in
  let additional =
    match s.additional_properties with
    | Some (Schema _ as typed) -> typed
    | _ -> Schema.Boolean_schema true
  in
  let* held = type_of state at additional value in
  match key with
  | None -> Ok (H.T_apply ("KM.KeyMap", [ held ]))
  | Some key ->
      depend state key;
      Ok (H.T_apply ("Map.Map", [ T_name key; held ]))

(* The type written in place as [i], declared once, by [Typing]'s name. *)
and inline state schema (i : T.inline) =
  let* () =
    match Named.find_opt i.name state.declarations with
    | Some (Some { owner; _ }) ->
        if owner <> state.owner then depend state owner;
        Ok ()
    | Some None -> Ok ()
    | None when Named.mem i.name state.definitions ->
        Error ("two schemas written in place would both be " ^ i.name)
    | None ->
        state.definitions <- Named.add i.name schema state.definitions;
        declare state i.name schema i.form
  in
  Ok (H.T_name i.name)

(* [component] declared as its own module's, before a schema that inherits
   its properties refers to the types written in place for them. *)
and declare_parent state component =
  let holder = state.owner in
  let* schema = find state component in
  state.owner <- component;
  let declared =
    declare state component schema (state.typing.find component).form
  in
  state.owner <- holder;
  declared

and declare state name original (form : T.form) =
  if Named.mem name state.declarations then Ok ()
  else (
    state.declarations <- Named.add name None state.declarations;
    let owner = state.owner in
    let* decls =
      match form with
      | Alias (Nullable _) ->
          Error
            (name ^ ": nullable named schemas need an explicit representation")
      | Enum { values; _ }
        when Result.fold ~ok:Deviations.haskell_enumeration
               ~error:(fun _ -> false)
               (normalize state original) ->
          state.enumerations <- (name, values) :: state.enumerations;
          enumeration name values
      | Union u -> union state name original u
      | Record { members; rest } ->
          object_ state name original members rest
            ~open_:
              (match rest with
              | Open | Of _ -> true
              | Closed | Unstated -> false)
      (* Deviations: an object that names no member and says nothing of
         others holds whatever members it is given. *)
      | Empty { rest; _ } ->
          object_ state name original [] rest ~open_:(rest <> Closed)
      | Map { key; value } ->
          let* only = holds_only state original (map_keywords key) in
          if only then
            let* held = map_of state name original key value in
            Ok [ H.alias name held ]
          else object_ state name original [] (Of value) ~open_:true
      | Enum { base; _ } -> (
          match base with
          | Some s -> newtype state name (scalar_of s)
          | None -> newtype state name (H.T_name "Value"))
      | Identifier _ -> newtype state name (H.T_name "Text")
      | Json -> newtype state name (H.T_name "Value")
      | Alias (Scalar (Text { binary = true; _ } as bytes)) ->
          newtype_decls name ~constructor:(constructed state name)
            ~read:"base64Bytes" ~write:"base64Value" (scalar_of bytes)
            (Names.mem name state.identifiers)
            ~key:(Names.mem name state.keys)
      | Alias ty -> (
          let* value_type = type_of state name original ty in
          match ty with
          | Scalar _ ->
              let* only = holds_only state original [ "type" ] in
              if only then Ok [ H.alias name value_type ]
              else newtype state name value_type
          | _ -> newtype state name value_type)
    in
    state.declarations <-
      Named.add name (Some { owner; decls }) state.declarations;
    Ok ())

and union state name original (u : T.union) =
  let* parts = union_parts state name original in
  let* () =
    if List.length parts = List.length u.branches then Ok ()
    else Error (name ^ ": its members are not Typing's")
  in
  let* members =
    Result.map List.rev
      (List.fold_left2
         (fun found part (b : T.branch) ->
           let* found = found in
           (match b.ty with
           | Inline i ->
               state.union_members <- Names.add i.name state.union_members
           | _ -> ());
           let* t = type_of state name part b.ty in
           Ok ((name ^ b.variant, t, b.signature) :: found))
         (Ok []) parts u.branches)
  in
  state.unions <- (name, u.branches) :: state.unions;
  union_decls name members

(* What constructs the record or newtype [name]:
   [Deviations.haskell_union_member]. *)
and constructed state name =
  if Names.mem name state.union_members then "Mk" ^ name else name

and newtype state name value_type =
  newtype_decls name ~constructor:(constructed state name) ~read:"parseJSON"
    ~write:"toJSON" value_type
    (Names.mem name state.identifiers)
    ~key:(Names.mem name state.keys)

and object_ state name original (members : T.member list) (rest : T.rest) ~open_
    =
  let names = H.List (List.map (fun (m : T.member) -> H.Str m.wire) members) in
  let* fields =
    Result.map List.rev
      (List.fold_left
         (fun found (m : T.member) ->
           let* found = found in
           let key = m.wire in
           let accessor = H.field name key in
           let nullable, ty =
             match m.ty with Nullable ty -> (true, ty) | ty -> (false, ty)
           in
           (* A member a named schema states is its; one stated in place, the
              record's. *)
           let owner =
             if m.owner <> name && state.typing.defined m.owner then m.owner
             else name
           in
           let* () =
             if owner = name then Ok () else declare_parent state owner
           in
           let* stated = property state name original key in
           let* beside = beside_null (name ^ "." ^ key) stated in
           let* t = type_of state (name ^ "." ^ key) beside ty in
           let held = H.Apply (Name accessor, [ Name "value" ]) in
           let typ, parser, encoder =
             member ~row:"fields" ~key ~held ~nullable ~mandatory:m.required t
           in
           Ok ((accessor, typ, parser, encoder) :: found))
         (Ok []) members)
  in
  let* extra_type =
    match rest with
    | Of value ->
        let* s = normalize state original in
        let additional =
          match s.additional_properties with
          | Some (Schema _ as typed) -> typed
          | _ -> Schema.Boolean_schema true
        in
        type_of state name additional value
    | Closed | Unstated | Open -> Ok (H.T_name "Value")
  in
  object_decls name ~constructor:(constructed state name) ~open_ ~names
    ~extra_type fields

(* The type [typing] writes in place for member [key] of record [record]. *)
let member_type (typing : T.t) record key =
  match (typing.find record).form with
  | Record { members; _ } -> (
      match List.find_opt (fun (m : T.member) -> m.wire = key) members with
      | Some { ty = Inline i | Nullable (Inline i); _ } -> Ok i.name
      | _ -> Error (record ^ "." ^ key ^ " is no type written in place"))
  | _ -> Error (record ^ " is no record")

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
  typing : T.t;
  enumerations : (string * Schema.literal list) list;
      (** Every enumeration declared, and its values, by name. *)
  unions : (string * T.branch list) list;
      (** Every union declared, and its members, by name. *)
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
    (`Type, "FromJSONKey", All "FromJSONKey");
    (`Value, "FromJSONKeyTextParser", All "FromJSONKeyFunction");
    (`Type, "ToJSONKey", All "ToJSONKey");
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
  when_ (aeson <> []) (H.import "Data.Aeson" ~items:aeson)
  @ (match List.filter value [ "parseEither"; "toJSONKeyText" ] with
    | [] -> []
    | used ->
        [
          H.import "Data.Aeson.Types"
            ~items:(List.map (fun n -> H.Plain n) used);
        ])
  @ when_
      (List.exists
         (fun n -> String.starts_with ~prefix:"KM." n)
         (used.types @ used.values))
      (H.import "Data.Aeson.KeyMap" ~qualified:"KM")
  @ when_ (type_ "Map.Map") (H.import "Data.Map.Strict" ~qualified:"Map")
  @ when_ (type_ "Scientific")
      (H.import "Data.Scientific" ~items:[ Plain "Scientific" ])
  @ when_ (type_ "ByteString")
      (H.import "Data.ByteString" ~items:[ Plain "ByteString" ])
  @ when_ (type_ "Text") (H.import "Data.Text" ~items:[ Plain "Text" ])
  @ when_
      (List.exists value
         [
           "base64Bytes";
           "base64Value";
           "checked";
           "optional";
           "optionalPair";
           "readMember";
           "withoutFields";
         ])
      (H.import "Xynolog.Internal.Codec")
  @ (match
       List.filter type_
         (List.map
            (fun (member, _) -> Error_codes.Haskell.type_of member)
            Code_names.names)
     with
    | [] -> []
    | codes ->
        [
          H.import "Xynolog.ErrorCodes"
            ~items:(List.map (fun code -> H.All code) codes);
        ])
  @ List.map (fun m -> H.import m) dependencies

(* What [Typing] makes of [definitions]: each schema under its name's file
   and under every key a reference to it resolves to, a reference naming the
   schema of its file's base name ([Definitions.referenced]). *)
let typing ~ids ~identifiers ~keys definitions =
  let by_name = Hashtbl.create 512 in
  List.iter
    (fun (name, s) -> Hashtbl.replace by_name name (Normalize.shape_only s))
    definitions;
  let stem key = Filename.remove_extension (Filename.basename key) in
  let schemas = Hashtbl.create 1024 in
  let keep key =
    match Hashtbl.find_opt by_name (stem key) with
    | Some s -> Hashtbl.replace schemas key s
    | None -> ()
  in
  List.iter
    (fun (name, s) ->
      keep (name ^ ".json");
      List.iter
        (fun r -> keep (Table_records.key ids r))
        (Schema.cata
           ~boolean:(fun _ -> [])
           ~schema:(fun l ->
             Option.to_list l.ref_ @ List.concat (Schema.children l))
           s))
    definitions;
  let named key =
    if Hashtbl.mem by_name (stem key) then Some (stem key) else None
  in
  let view = T.D.view ~ids ~named ~schemas in
  match
    T.make
      {
        names = List.map fst definitions;
        schema = (fun name -> view (Hashtbl.find by_name name));
      }
      ~roots:(List.map fst definitions) ~identifiers ~keys
  with
  | typing -> Ok typing
  | exception T.D.Refused message -> Error message

let generate ~banner ~ids ~identifiers ~keys definitions =
  let* typing = typing ~ids ~identifiers ~keys definitions in
  let state =
    {
      definitions = Named.of_list definitions;
      declarations = Named.empty;
      owner = "";
      dependencies = Named.empty;
      ids;
      identifiers = Names.of_list identifiers;
      keys = Names.of_list (List.map snd keys);
      enumerations = [];
      union_members = Names.empty;
      unions = [];
      typing;
    }
  in
  let* () =
    List.fold_left
      (fun ok (name, schema) ->
        let* () = ok in
        state.owner <- name;
        declare state name schema (typing.find name).form)
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
      typing;
      enumerations =
        List.sort (fun (a, _) (b, _) -> String.compare a b) state.enumerations;
      unions = List.sort (fun (a, _) (b, _) -> String.compare a b) state.unions;
    }
