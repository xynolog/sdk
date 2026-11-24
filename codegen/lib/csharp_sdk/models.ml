(* The C# SDK's models, in Xynolog.Types: a record of its properties per
   object schema, an enum per string enumeration, a closed record of a case
   per member per union, each with the converter System.Text.Json reads and
   writes it with; a schema of plain text is a string, and a kind of id is
   Xynolog.Identifiers'. What a schema states in place is a model of its own,
   named for its owner and its place. Every schema the models are made from,
   those made in place too, is what the SDK validates a value against
   (WireSchemas).

   A schema that states an allOf is modelled as what its validated parts
   merge to ([Normalize]), and validated as that merge. An object's properties are in order of
   name. One that is required is [required]; one that
   is required, not nullable and admits one string is that string, and is no
   property to set; one that is optional is nullable; and one that is
   optional and nullable is a [Stated]: absent, null or a value. An object
   that admits properties it does not name keeps them
   (AdditionalProperties). A union's value is read as the member
   [WireJson.Variant] says it is. *)

module C = Csharp_syntax

type definition = {
  schema : Schema.t;  (** As a writer of types reads it. *)
  validated : Schema.t;
      (** As the SDK validates a value against it (WireSchemas), of which
          [schema] is the shape ([Normalize.shape_only]). *)
}

exception Refused of string

let refuse fmt = Printf.ksprintf (fun m -> raise (Refused m)) fmt
let types = "global::Xynolog.Types."
let json name = Csharp_converter.json name
let element = C.T (json "JsonElement")

(* A keyword that says something of a schema but holds a value to nothing: a
   schema of only these, as JsonSchema.json written in place is, admits any
   value, an element. *)
let annotation keyword =
  List.mem keyword [ "$schema"; "$id"; "$comment"; "title"; "description" ]

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

let member_of keyword i v =
  let l = layer keyword v in
  stated keyword
    (Option.bind
       (match keyword with
       | "oneOf" -> l.one_of
       | "anyOf" -> l.any_of
       | "allOf" -> l.all_of
       | _ -> refuse "%s composes no schema" keyword)
       (fun members -> List.nth_opt members i))

(* What the models read of a schema: every part a schema object, and a type
   one name, where the model of a schema reads a list of one type as that
   type. A schema of parts the models cannot read fails the run rather than
   making a model of less than it says. *)
let rec readable path ((schema : Schema.t), validated) =
  let s = layer path schema in
  (match s.type_ with
  | Some ([ _ ] | [ _; Null ]) | None -> ()
  | Some _ -> refuse "%s has an unsupported type." path);
  Option.iter
    (List.iter (fun (name, p) ->
         readable (path ^ "." ^ name) (p, property_of name validated)))
    s.properties;
  Option.iter (fun i -> readable (path ^ "[]") (i, items_of validated)) s.items;
  (match s.additional_properties with
  | Some (Schema _ as v) -> readable (path ^ ".*") (v, values_of validated)
  | Some (Boolean_schema _) | None -> ());
  List.iter
    (fun (keyword, parts) ->
      Option.iter
        (List.iteri (fun i part ->
             readable
               (path ^ "." ^ keyword)
               (part, member_of keyword i validated)))
        parts)
    [ ("oneOf", s.one_of); ("anyOf", s.any_of); ("allOf", s.all_of) ]

type state = {
  definitions : (string, definition) Hashtbl.t;
  mutable order : string list;  (** The definitions' names, last first. *)
  read_from : (string, string) Hashtbl.t;
      (** A root's name, by the file, or the place in a file, it is read from.
      *)
  ids : Decode.ids;  (** Each schema's [$id]: what a reference names. *)
  identifiers : string list;
  written : (string, C.decl list) Hashtbl.t;
  inlined : (string, string) Hashtbl.t;  (** [owner.property] → model. *)
}

let define state name definition =
  if Hashtbl.mem state.definitions name then
    refuse "%s is named twice among the schemas the models are made from" name;
  Hashtbl.replace state.definitions name definition;
  state.order <- name :: state.order

let definition state name =
  match Hashtbl.find_opt state.definitions name with
  | Some d -> d
  | None -> refuse "No component schema names %s." name

(* The schema a reference names: the root read from where it points. *)
let referenced state (r : Decode.reference) =
  match Hashtbl.find_opt state.read_from (Table_records.key state.ids r) with
  | Some name -> name
  | None -> refuse "%s names no schema the models are made from" r.target

(* The C# type of a schema of one plain value, text of no enumeration or a
   number or a boolean, which is no model of its own. *)
let rec plain state (s : Schema.schema) =
  match s with
  | { ref_ = Some r; _ } ->
      let name = referenced state r in
      plain state (layer name (definition state name).schema)
  | { type_ = Some [ String ]; enum = None; _ } -> Some (C.T "string")
  | { type_ = Some [ Integer ]; enum = None; _ } -> Some (C.T "long")
  | { type_ = Some [ Number ]; enum = None; _ } -> Some (C.T "double")
  | { type_ = Some [ Boolean ]; enum = None; _ } -> Some (C.T "bool")
  | _ -> None

(* A schema's one string value, when it admits one. *)
let constant (s : Schema.schema) =
  match s.enum with Some [ String_literal c ] -> Some c | _ -> None

(* What [s] is beside null, when it may be null ([Null_form]). *)
let beside_null (s : Schema.schema) =
  match Null_form.without_null Fun.id s with
  | Ok beside -> beside
  | Error message -> refuse "%s" message

let nullable s = Option.is_some (beside_null s)

type field = {
  wire : string;
  name : string;
  type_ : C.type_;
  required : bool;
  nullable : bool;
  constant : string option;
}

let rec named state name =
  if List.mem name state.identifiers then
    C.T ("global::Xynolog.Identifiers." ^ name)
  else
    let d = definition state name in
    match plain state (layer name d.schema) with
    | Some type_ -> type_
    | None ->
        if not (Hashtbl.mem state.written name) then (
          Hashtbl.replace state.written name [];
          Hashtbl.replace state.written name (declare state name d));
        C.T (types ^ name)

and inline state owner property (schema, validated) =
  let key = owner ^ "." ^ property in
  match Hashtbl.find_opt state.inlined key with
  | Some known -> C.T (types ^ known)
  | None ->
      let name =
        Naming.inline
          ~defined:(fun n ->
            Hashtbl.mem state.definitions n || Hashtbl.mem state.written n)
          owner property
      in
      Hashtbl.replace state.inlined key name;
      let d = { schema; validated } in
      define state name d;
      Hashtbl.replace state.written name [];
      Hashtbl.replace state.written name (declare state name d);
      C.T (types ^ name)

(* The type of a value of [owner]'s [property], whose schema is [schema]. *)
and type_of state owner property ((schema, validated) as node) =
  let s = layer (owner ^ "." ^ property) schema in
  match beside_null s with
  | Some beside -> type_of state owner property (Schema.Schema beside, validated)
  | None -> type_of_beside_null state owner property node s

and type_of_beside_null state owner property ((_, validated) as node) s =
  let inline () = inline state owner property node in
  match s with
  | { ref_ = Some r; _ } -> named state (referenced state r)
  | { all_of = Some _; _ } | { one_of = Some _; _ } | { any_of = Some _; _ } ->
      inline ()
  | { type_ = Some [ String ]; format = Some Binary; _ } -> C.Array (T "byte")
  | { type_ = Some [ String ]; enum = Some _; _ } -> inline ()
  | { type_ = Some [ String ]; _ } -> T "string"
  | { type_ = Some [ Integer ]; _ } -> T "long"
  | { type_ = Some [ Number ]; _ } -> T "double"
  | { type_ = Some [ Boolean ]; _ } -> T "bool"
  | { type_ = Some [ Array ]; items = Some items; _ } ->
      generic "IReadOnlyList"
        [ type_of state owner (property ^ "Item") (items, items_of validated) ]
  | { type_ = Some [ Object ]; properties = Some (_ :: _); _ }
  | { type_ = Some [ Object ]; max_properties = Some 0; _ }
  | {
      type_ = Some [ Object ];
      additional_properties = Some (Boolean_schema false);
      _;
    } ->
      inline ()
  | {
   type_ = Some [ Object ];
   additional_properties = Some (Schema _ as values);
   _;
  } ->
      generic "IReadOnlyDictionary"
        [
          T "string";
          type_of state owner (property ^ "Value") (values, values_of validated);
        ]
  | { type_ = Some [ Object ]; _ } -> element
  | { type_ = None; _ } when List.for_all annotation (Schema.keywords s) ->
      element
  | _ -> refuse "%s.%s has an unsupported type shape." owner property

(* A model as the record, union or enumeration it is, named to the
   hand-written converter that reads and writes it. *)
and declare state name original =
  let read_as attribute : C.attribute =
    { name = "global::Xynolog.Serialization." ^ attribute; args = [] }
  in
  let d = meant state name original in
  match layer name d.schema with
  | { enum = Some values; _ } ->
      enum name ~attribute:(read_as "WireEnum") values
  | { one_of = Some members; _ } ->
      union state name "oneOf" (members, d.validated)
  | { any_of = Some members; _ } ->
      union state name "anyOf" (members, d.validated)
  | _ -> object_ state name ~attribute:(read_as "WireObject") ~original d

(* [d] as what it means: one that states an allOf, what its validated
   parts merge to, of which the model is the shape. *)
and meant state name d =
  match layer name d.schema with
  | { all_of = None; _ } -> d
  | _ ->
      let validated = Schema.Schema (merged state name d.validated) in
      { schema = Normalize.shape_only validated; validated }

(* [name]'s validated [schema] with its allOf merged ([Normalize]). *)
and merged state name schema =
  match
    Normalize.normalize state.ids
      ~find:(fun r -> Ok (definition state (referenced state r)).validated)
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

and object_ state name ~attribute ~original d =
  let s = layer name d.schema in
  if s.type_ <> Some [ Object ] && (layer name original.schema).all_of = None
  then refuse "%s is not an object schema." name;
  let properties =
    match s.properties with
    | Some own ->
        List.map (fun (key, p) -> (key, (p, property_of key d.validated))) own
    | None -> []
  in
  let required = Option.value s.required ~default:[] in
  (* An object whose other members are of a schema keeps them, as one whose
     other members are anything does: the schema each is of holds them as the
     model is read. *)
  let open_ =
    match s.additional_properties with
    | Some (Boolean_schema true | Schema _) -> true
    | Some (Boolean_schema false) | None -> false
  in
  let owner =
    Inherited.of_schemas
      ~find:(fun n -> (definition state n).schema)
      ~referenced:(referenced state) name original.schema
  in
  (* A property another schema states is that schema's, and so are the
     models made in place of it: that schema is modelled first, from what
     Protocol writes of it. *)
  List.iter
    (fun (wire, _) ->
      if owner wire <> name then ignore (named state (owner wire)))
    properties;
  let fields =
    List.map
      (fun (wire, ((schema, _) as node)) ->
        let field = field_name name wire in
        let p = layer (name ^ "." ^ wire) schema in
        let required = List.mem wire required in
        let nullable = nullable p in
        let constant = if required && not nullable then constant p else None in
        let type_ =
          match constant with
          | Some _ -> C.T "string"
          | None -> type_of state (owner wire) field node
        in
        { wire; name = field; type_; required; nullable; constant })
      (List.sort (fun (a, _) (b, _) -> String.compare a b) properties)
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
    || (open_ && List.mem "AdditionalProperties" names)
  then refuse "%s has colliding C# property names." name;
  let stated t = C.Generic (types ^ "Stated", [ Nullable t ]) in
  let extra = generic "IReadOnlyDictionary" [ T "string"; element ] in
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
                    (if (not f.required) && f.nullable then stated f.type_
                     else if (not f.required) || f.nullable then
                       Nullable f.type_
                     else f.type_);
                  name = f.name;
                  accessors = [ Get; Init ];
                  value = None;
                };
            ])
      fields
    @
    if open_ then
      [
        C.Property
          {
            attributes =
              [ { name = "global::Xynolog.Serialization.WireRest"; args = [] } ];
            modifiers = [ Public ];
            type_ = extra;
            name = "AdditionalProperties";
            accessors = [ Get; Init ];
            value =
              Some
                (New
                   {
                     type_ = Some (generic "Dictionary" [ T "string"; element ]);
                     args = Some [];
                     init = None;
                   });
          };
      ]
    else []
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

(* The case a union's member is: what it refers to, Array, Text, the one
   string its first property that admits one admits, else its title, else
   Object. *)
and union state name keyword (members, validated) =
  let titled (s : Schema.schema) = Option.value s.title ~default:"Object" in
  let variant (s : Schema.schema) =
    match s with
    | { ref_ = Some r; _ } -> referenced state r
    | { type_ = Some [ Array ]; _ } -> "Array"
    | { type_ = Some [ String ]; _ } -> "Text"
    | { properties = Some properties; _ } -> (
        match
          List.find_map
            (fun (_, p) ->
              match p with
              | Schema.Schema p -> constant p
              | Boolean_schema _ -> None)
            properties
        with
        | Some tag -> tag
        | None -> titled s)
    | _ -> titled s
  in
  let cases =
    List.mapi
      (fun i member ->
        let v = variant (merged state name member) in
        ( identifier (Text.pascal v) ^ "Case",
          type_of state name v (member, member_of keyword i validated) ))
      members
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
              List.map
                (fun (case, t) ->
                  C.Nested
                    (Type
                       {
                         attributes = [];
                         modifiers = [ Public; Sealed ];
                         kind = Record;
                         name = case;
                         params =
                           Some [ { by = `Value; type_ = t; name = "Value" } ];
                         base = Some (T name);
                         body = None;
                       }))
                cases );
      };
  ]

type t = {
  models : (string * definition * C.decl list) list;  (** By name. *)
  schemas : (string * Schema.t) list;
      (** Every schema the models are made from, in the order each was named. *)
  member_type : string -> string -> string option;
      (** The model of its own a member of a model is made as. *)
}

(* [roots] are the schemas the models are made from, in order, each
   validated, and each what a [$ref] to where it is read from names; [made]
   are the bus's payload types beside them. *)
let make ~ids ~identifiers ~roots ~made =
  let state =
    {
      definitions = Hashtbl.create 1024;
      order = [];
      read_from = Hashtbl.create 1024;
      ids;
      identifiers;
      written = Hashtbl.create 1024;
      inlined = Hashtbl.create 256;
    }
  in
  try
    List.iter
      (fun (name, path, d) ->
        readable path (d.schema, d.validated);
        Hashtbl.replace state.read_from path name;
        define state name d)
      roots;
    List.iter (fun (name, d) -> define state name d) made;
    List.iter
      (fun name -> ignore (named state name))
      (List.sort String.compare (List.rev state.order));
    let models =
      Hashtbl.fold (fun name decls acc -> (name, decls) :: acc) state.written []
      |> List.sort (fun (a, _) (b, _) -> String.compare a b)
      |> List.map (fun (name, decls) -> (name, definition state name, decls))
    in
    Ok
      {
        models;
        schemas =
          List.rev_map
            (fun name -> (name, (definition state name).validated))
            state.order;
        member_type =
          (fun owner property ->
            Hashtbl.find_opt state.inlined
              (owner ^ "." ^ field_name owner property));
      }
  with Refused message -> Error message
