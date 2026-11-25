(* The C# SDK's models, in Xynolog.Types, of Protocol's schemas as [Typing]
   reads them: a record of its properties per object, an enum per string
   enumeration, a closed record of a case per member per union, each with
   the converter System.Text.Json reads and writes it with; a schema of
   plain text is a string, and a kind of id is Xynolog.Identifiers'. What a
   schema states in place is a model of its own, named as [Typing] names it.
   Every schema the models are made from, those made in place too, is what
   the SDK validates a value against (WireSchemas), read at the place
   [Typing] reads its shape.

   A schema that states an allOf is validated as what its validated parts
   merge to ([Normalize]). An object's properties are in order of name. One
   that is required is [required]; one that is required, not nullable and
   admits one string is that string, and is no property to set; and one
   that is optional is nullable. An object that admits properties it
   does not name keeps them (AdditionalProperties). A union's value is read
   as the one member whose signature ([Typing]) admits it ([Members]). Where C# reads otherwise
   than [Typing], [Deviations] names it. *)

module C = Csharp_syntax
module T = Typing

exception Refused of string

let refuse fmt = Printf.ksprintf (fun m -> raise (Refused m)) fmt
let types = "global::Xynolog.Types."
let json name = Csharp_converter.json name
let element = C.T (json "JsonElement")

let generic name args =
  C.Generic ("global::System.Collections.Generic." ^ name, args)

(* [name] as C# takes it: [Value] before a name that is empty or would
   begin with a digit. *)
let identifier name =
  if name = "" || match name.[0] with '0' .. '9' -> true | _ -> false then
    "Value" ^ name
  else name

(* The constant an enumeration's [value] is. *)
let enum_constant value = identifier (Naming.variant value)

(* The C# name of [owner]'s property [property]: no member is named as its
   type is. *)
let field_name owner property =
  let field = identifier (Text.pascal property) in
  if field = owner then field ^ "Value" else field

let layer what = function
  | Schema.Schema s -> s
  | Boolean_schema _ -> refuse "%s is not a schema object." what

(* What a validated schema states at a place its shape states, which the
   shape keeps of it ([Normalize.shape_only]). *)
let stated what = function
  | Some s -> s
  | None -> refuse "the schema validated states no %s" what

let property_of key v =
  stated key (Option.bind (layer key v).properties (List.assoc_opt key))

let items_of v = stated "items" (layer "items" v).items

let values_of v =
  match (layer "additionalProperties" v).additional_properties with
  | Some (Schema _ as values) -> values
  | Some (Boolean_schema _) | None ->
      refuse "the schema validated states no additionalProperties"

(* The [i]th member of the union [v] states. *)
let member_of i v =
  let l = layer "a union" v in
  stated "union member"
    (Option.bind
       (match (l.one_of, l.any_of) with
       | Some members, _ | None, Some members -> Some members
       | None, None -> None)
       (fun members -> List.nth_opt members i))

type state = {
  find : string -> T.declaration;
  validated : (string, Schema.t) Hashtbl.t;
      (** Each model's schema, as the SDK validates a value against it. *)
  mutable order : string list;  (** The models' names, last first. *)
  read_from : (string, string) Hashtbl.t;
      (** A root's name, by the file, or the place in a file, it is read from.
      *)
  ids : Decode.ids;  (** Each schema's [$id]: what a reference names. *)
  written : (string, C.decl list) Hashtbl.t;
  inlined : (string, string) Hashtbl.t;  (** [owner.property] → model. *)
}

let define state name validated =
  if Hashtbl.mem state.validated name then
    refuse "%s is named twice among the schemas the models are made from" name;
  Hashtbl.replace state.validated name validated;
  state.order <- name :: state.order

let validated state name =
  match Hashtbl.find_opt state.validated name with
  | Some v -> v
  | None -> refuse "No component schema names %s." name

(* The schema a reference names: the root read from where it points. *)
let referenced state (r : Decode.reference) =
  match Hashtbl.find_opt state.read_from (Table_records.key state.ids r) with
  | Some name -> name
  | None -> refuse "%s names no schema the models are made from" r.target

(* The C# type of a schema of one plain value, text of no enumeration or a
   number or a boolean, which is no model of its own. *)
let rec plain state (form : T.form) =
  match form with
  | T.Alias (T.Named name) -> plain state (state.find name).form
  | T.Alias (T.Scalar (T.Text _)) | T.Identifier _ -> Some (C.T "string")
  | T.Alias (T.Scalar (T.Integer _)) -> Some (C.T "long")
  | T.Alias (T.Scalar T.Number) -> Some (C.T "double")
  | T.Alias (T.Scalar T.Boolean) -> Some (C.T "bool")
  | T.Union u when Deviations.text_union u -> Some (C.T "string")
  | _ -> None

type field = {
  wire : string;
  name : string;
  type_ : C.type_;
  required : bool;
  nullable : bool;
  constant : string option;
}

let rec named state name =
  let d = state.find name in
  match d.form with
  | T.Identifier _ -> C.T ("global::Xynolog.Identifiers." ^ name)
  | form -> (
      match plain state form with
      | Some type_ -> type_
      | None ->
          if not (Hashtbl.mem state.written name) then (
            Hashtbl.replace state.written name [];
            Hashtbl.replace state.written name
              (declare state name form d.composition (validated state name)));
          C.T (types ^ name))

(* A model of its own written in place, named as [Typing] names it. *)
and inline state owner property (i : T.inline) validated =
  if not (Hashtbl.mem state.written i.name) then (
    define state i.name validated;
    Hashtbl.replace state.written i.name [];
    Hashtbl.replace state.written i.name
      (declare state i.name i.form i.composition validated));
  Hashtbl.replace state.inlined (owner ^ "." ^ property) i.name;
  C.T (types ^ i.name)

(* The type of a value of [owner]'s [property], of [ty], validated as
   [validated]. *)
and type_of state owner property ((ty : T.ty), validated) =
  match ty with
  | T.Nullable inner -> type_of state owner property (inner, validated)
  | T.Named name -> named state name
  | T.Inline i -> in_place state owner property i validated
  | T.Scalar (T.Text { binary = true; _ }) -> C.Array (T "byte")
  | T.Scalar (T.Text _) -> T "string"
  | T.Scalar (T.Integer _) -> T "long"
  | T.Scalar T.Number -> T "double"
  | T.Scalar T.Boolean -> T "bool"
  | T.List (Some items) ->
      generic "IReadOnlyList"
        [ type_of state owner (property ^ "Item") (items, items_of validated) ]
  | T.Any -> element
  | T.List None | T.Null | T.Nothing ->
      refuse "%s.%s has an unsupported type shape." owner property

and in_place state owner property (i : T.inline) validated =
  let inline () = inline state owner property i validated in
  match (i.form, i.composition) with
  | T.Union u, None when Deviations.text_union u -> T "string"
  | _, Some _
  | (T.Record _ | T.Union _ | T.Enum { base = Some (T.Text _); _ }), None ->
      inline ()
  | T.Enum { base = Some (T.Integer _); _ }, None -> T "long"
  | T.Enum { base = Some T.Number; _ }, None -> T "double"
  | T.Enum { base = Some T.Boolean; _ }, None -> T "bool"
  | (T.Empty _ as form), None when T.holds_none form -> inline ()
  | T.Empty _, None -> element
  | T.Map { value; _ }, None ->
      generic "IReadOnlyDictionary"
        [
          T "string";
          type_of state owner (property ^ "Value") (value, values_of validated);
        ]
  | (T.Enum { base = None; _ } | T.Alias _ | T.Identifier _ | T.Json), None ->
      refuse "%s.%s has an unsupported type shape." owner property

(* A model as the record, union or enumeration it is, named to the
   hand-written converter that reads and writes it, validated as
   [validated], or what its allOf's validated parts merge to. *)
and declare state name (form : T.form) composition validated =
  let read_as attribute : C.attribute =
    { name = "global::Xynolog.Serialization." ^ attribute; args = [] }
  in
  let validated =
    match composition with
    | Some _ -> Schema.Schema (merged state name validated)
    | None -> validated
  in
  match form with
  | T.Enum { values; _ } -> enum name ~attribute:(read_as "WireEnum") values
  | T.Union u -> union state name u validated
  | T.Record { members; rest } ->
      object_ state name ~attribute:(read_as "WireObject") members rest
        ~key:None validated
  | T.Empty { rest; _ } ->
      object_ state name ~attribute:(read_as "WireObject") [] rest ~key:None
        validated
  | T.Map { key; value } ->
      object_ state name ~attribute:(read_as "WireObject") [] (T.Of value) ~key
        validated
  | T.Alias _ | T.Identifier _ | T.Json ->
      refuse "%s is not an object schema." name

(* [name]'s validated [schema] with its allOf merged ([Normalize]). *)
and merged state name schema =
  match
    Normalize.normalize state.ids
      ~find:(fun r -> Ok (validated state (referenced state r)))
      schema
  with
  | Ok s -> s
  | Error message -> refuse "%s: %s" name message

and enum name ~attribute values =
  let members =
    List.map
      (function
        | Schema.String_literal v -> v
        | Int_literal _ | Bool_literal _ ->
            refuse "%s: an enumeration contains a non-string." name)
      values
  in
  let constants = List.map enum_constant members in
  if
    List.length (List.sort_uniq String.compare constants) <> List.length members
  then refuse "%s has colliding C# enumeration names." name;
  [
    C.Enum
      {
        attributes = [ attribute ];
        modifiers = [ Public ];
        name;
        members =
          List.map
            (fun member ->
              ( [
                  {
                    C.name = json "Serialization.JsonStringEnumMemberName";
                    args = [ Str member ];
                  };
                ],
                enum_constant member ))
            members;
      };
  ]

and object_ state name ~attribute (members : T.member list) (rest : T.rest) ~key
    validated =
  (* An object whose other members are anything keeps them as JSON; one whose
     other members are of a schema keeps them as that schema's type, keyed as
     its member names' schema is, where that is a schema of its own. *)
  let rest =
    match rest with
    | T.Open -> Some (C.T "string", element)
    | T.Of value ->
        Some
          ( (match key with Some key -> named state key | None -> C.T "string"),
            type_of state name "Value" (value, values_of validated) )
    | T.Closed | T.Unstated -> None
  in
  (* A property another schema states is that schema's, and so are the
     models made in place of it: that schema is modelled first, from what
     Protocol writes of it. *)
  List.iter
    (fun (m : T.member) -> if m.owner <> name then ignore (named state m.owner))
    members;
  let fields =
    List.map
      (fun (m : T.member) ->
        let field = field_name name m.wire in
        let nullable = match m.ty with T.Nullable _ -> true | _ -> false in
        let constant =
          match m.fixed with
          | Some (Schema.String_literal c) when m.required && not nullable ->
              Some c
          | _ -> None
        in
        let type_ =
          match constant with
          | Some _ -> C.T "string"
          | None ->
              type_of state m.owner field (m.ty, property_of m.wire validated)
        in
        {
          wire = m.wire;
          name = field;
          type_;
          required = m.required;
          nullable;
          constant;
        })
      (List.sort
         (fun (a : T.member) (b : T.member) -> String.compare a.wire b.wire)
         members)
  in
  (* A constant member's value is also the model's own, so code that reads
     the wire before it is a model names it. *)
  let constant_name f = f.name ^ "Value" in
  let names =
    List.concat_map
      (fun f ->
        match f.constant with
        | Some _ -> [ f.name; constant_name f ]
        | None -> [ f.name ])
      fields
  in
  if
    List.length (List.sort_uniq String.compare names) <> List.length names
    || (Option.is_some rest && List.mem "AdditionalProperties" names)
  then refuse "%s has colliding C# property names." name;
  let wire_name f : C.attribute =
    { name = "global::Xynolog.Serialization.Wire"; args = [ Str f.wire ] }
  in
  let members =
    List.concat_map
      (fun f ->
        match f.constant with
        | Some c ->
            [
              C.Field
                {
                  modifiers = [ Public; Const ];
                  type_ = T "string";
                  name = constant_name f;
                  value = Some (Str c);
                };
              C.Expression_property
                {
                  attributes = [ wire_name f ];
                  modifiers = [ Public ];
                  type_ = T "string";
                  name = f.name;
                  value = Name (constant_name f);
                };
            ]
        | None ->
            [
              C.Property
                {
                  attributes = [ wire_name f ];
                  modifiers =
                    (if f.required then [ Public; Required ] else [ Public ]);
                  type_ =
                    (if (not f.required) || f.nullable then Nullable f.type_
                     else f.type_);
                  name = f.name;
                  accessors = [ Get; Init ];
                  value = None;
                };
            ])
      fields
    @
    match rest with
    | Some (key, value) ->
        [
          C.Property
            {
              attributes =
                [
                  { name = "global::Xynolog.Serialization.WireRest"; args = [] };
                ];
              modifiers = [ Public ];
              type_ = generic "IReadOnlyDictionary" [ key; value ];
              name = "AdditionalProperties";
              accessors = [ Get; Init ];
              value =
                Some
                  (New
                     {
                       type_ = Some (generic "Dictionary" [ key; value ]);
                       args = Some [];
                       init = None;
                     });
            };
        ]
    | None -> []
  in
  [
    C.Type
      {
        attributes = [ attribute ];
        modifiers = [ Public; Sealed ];
        kind = Record;
        name;
        params = None;
        base = None;
        body = Some (Packed, members);
      };
  ]

(* The case a union's member is: what it refers to, Array, Text, an object's
   variant ([Typing]), else Object. *)
and union state name (u : T.union) validated =
  (match T.apart_by_pattern_only u with
  | Some (a, b) ->
      refuse
        "%s: its members %s and %s are told apart only by a pattern, which the \
         C# SDK does not read"
        name a b
  | None -> ());
  let variant (b : T.branch) =
    match b.ty with
    | T.Named _ -> b.variant
    | T.List _ -> "Array"
    | T.Scalar (T.Text _) -> "Text"
    | T.Inline { form = T.Record _; _ } -> b.variant
    | _ -> "Object"
  in
  (* A member of no named member is the union's [Object], and a list's
     items its [ArrayItem] ([Deviations]). *)
  let renamed part (i : T.inline) =
    T.Inline
      {
        i with
        name =
          Naming.inline
            ~defined:(fun n ->
              Hashtbl.mem state.validated n || Hashtbl.mem state.written n)
            name part;
      }
  in
  let held (ty : T.ty) =
    match ty with
    | T.Inline ({ form = T.Empty _; _ } as i) -> renamed "Object" i
    | T.List (Some (T.Inline i)) -> T.List (Some (renamed "ArrayItem" i))
    | ty -> ty
  in
  let cases =
    List.mapi
      (fun i (b : T.branch) ->
        let v = variant b in
        ( identifier (Text.pascal v) ^ "Case",
          type_of state name v (held b.ty, member_of i validated) ))
      u.branches
  in
  let names = List.map fst cases in
  if List.length (List.sort_uniq String.compare names) <> List.length names then
    refuse "%s has colliding C# union cases." name;
  let attribute : C.attribute =
    {
      name = "global::Xynolog.Serialization.WireUnion";
      args = List.map (fun case -> C.Typeof (C.T (name ^ "." ^ case))) names;
    }
  in
  let serialization = "global::Xynolog.Serialization." in
  let words ws = C.Collection (List.map (fun w -> C.Str w) ws) in
  let made type_ args =
    C.New
      {
        type_ = Option.map (fun t -> C.T (serialization ^ t)) type_;
        args = Some (List.map (fun a -> C.Arg a) args);
        init = None;
      }
  in
  let literal (l : Schema.literal) =
    match l with
    | Schema.String_literal s -> made (Some "Literal.Text") [ C.Str s ]
    | Schema.Int_literal n -> made (Some "Literal.Integer") [ C.Int n ]
    | Schema.Bool_literal b -> made (Some "Literal.Boolean") [ C.Bool b ]
  in
  let literals ls = C.Collection (List.map literal ls) in
  let stated f = function Some v -> f v | None -> C.Null in
  let signature (s : T.signature) =
    let kind =
      match s.kind with
      | T.Text_kind -> "Text"
      | T.Integer_kind -> "Integer"
      | T.Number_kind -> "Number"
      | T.Boolean_kind -> "Boolean"
      | T.List_kind -> "List"
      | T.Object_kind -> "Object"
      | T.Null_kind -> "Null"
      | T.Any_kind -> "Any"
    in
    made None
      [
        C.Name (serialization ^ "Kind." ^ kind);
        words s.required;
        stated words s.allowed;
        C.Collection
          (List.map (fun (p, vs) -> made None [ C.Str p; literals vs ]) s.fixed);
        stated literals s.values;
      ]
  in
  let members =
    C.Field
      {
        modifiers = [ Internal; Static; Readonly ];
        type_ = C.Array (C.Array (C.T (serialization ^ "Signature")));
        name = "Members";
        value =
          Some
            (C.Collection
               (List.map
                  (fun (b : T.branch) ->
                    C.Collection (List.map signature b.signature))
                  u.branches));
      }
  in
  [
    C.Type
      {
        attributes = [ attribute ];
        modifiers = [ Public; Closed ];
        kind = Record;
        name;
        params = None;
        base = None;
        body =
          Some
            ( Packed,
              members
              :: List.map
                   (fun (case, t) ->
                     C.Nested
                       (Type
                          {
                            attributes = [];
                            modifiers = [ Public; Sealed ];
                            kind = Record;
                            name = case;
                            params =
                              Some
                                [ { by = `Value; type_ = t; name = "Value" } ];
                            base = Some (T name);
                            body = None;
                          }))
                   cases );
      };
  ]

type t = {
  models : (string * C.decl list) list;  (** By name. *)
  schemas : (string * Schema.t) list;
      (** Every schema the models are made from, as the SDK validates a value
          against it, in the order each was named. *)
  member_type : string -> string -> string option;
      (** The model of its own a member of a model is made as. *)
}

(* The models of [typings]' schemas: [roots] are the schemas the models are
   made from, in order, each validated, and each what a [$ref] to where it
   is read from names; [made] are the bus's payload types beside them. *)
let make ~ids ~(typings : T.t list) ~roots ~made =
  let state =
    {
      find =
        (fun name ->
          match
            List.find_opt (fun (t : T.t) -> List.mem name t.names) typings
          with
          | Some t -> t.find name
          | None -> refuse "No component schema names %s." name);
      validated = Hashtbl.create 1024;
      order = [];
      read_from = Hashtbl.create 1024;
      ids;
      written = Hashtbl.create 1024;
      inlined = Hashtbl.create 256;
    }
  in
  try
    List.iter
      (fun (name, path, validated) ->
        Hashtbl.replace state.read_from path name;
        define state name validated)
      roots;
    List.iter (fun (name, validated) -> define state name validated) made;
    List.iter
      (fun name -> ignore (named state name))
      (List.sort String.compare (List.rev state.order));
    Ok
      {
        models =
          Hashtbl.fold
            (fun name decls acc -> (name, decls) :: acc)
            state.written []
          |> List.sort (fun (a, _) (b, _) -> String.compare a b);
        schemas =
          List.rev_map (fun name -> (name, validated state name)) state.order;
        member_type =
          (fun owner property ->
            Hashtbl.find_opt state.inlined
              (owner ^ "." ^ field_name owner property));
      }
  with
  | Refused message -> Error message
  | Definitions.Refused message -> Error message
