(* Kotlin types from Protocol's schemas as [Typing] reads them: a data class
   per object, an enum class per string enumeration, a sealed interface per
   union, an alias per named string, a value class per kind of id, a
   property per member, optional where the schema does not require it. It
   spells what [Typing] decides, and refuses a form Kotlin has no spelling
   for, so a schema that grows a new shape stops the run rather than
   generating something wrong.

   A property that is required and may be null is stated, as null or a
   value; and one that is optional is absent or a value. A property that
   admits one value says which member of a union an object is: it is the
   type's to state, and is written whatever the encoder's defaults.

   A union is a sealed interface its named members implement, so a member is
   the union wherever the union is wanted. Its serializer states what each
   member admits ([Typing]'s signatures), and a value is decoded as the one
   member that admits it, or refused as the one that names it says, or as
   none of them (SignatureUnionSerializer). A member that is text, a list or
   the empty object is a variant of the union's own, since nothing says
   which union a [String] was meant for.

   An object whose schema admits members it does not name keeps them, and
   writes them back ([rest]). One whose schema admits none refuses one; any
   other ignores what it does not name, as a later gateway may add some.

   Java makes a model through its builder: [builder] takes what must be
   stated, a setter each thing that may be, and [build] makes it.

   A kind of id is a value class whose pattern is the check its constructor
   makes, and decoding goes through that constructor, so a value of the type
   has always passed its rule. *)

module K = Kotlin_syntax
module T = Typing

let refuse = Names.refuse
let types_package = "xynolog.types"
let identifiers_package = "xynolog.identifiers"

(* The generator's own declaration, written when a schema needs it, and the
   SDK's, written by hand beside the generated ones. *)
let empty_object = "EmptyObject"
let invalid_identifier = "InvalidIdentifier"
let signature_union_serializer = "SignatureUnionSerializer"
let wrapper_serializer = "WrapperSerializer"
let open_object_serializer = "OpenObjectSerializer"
let constant_serializer = "ConstantSerializer"
let rest = "rest"

(* The names a generated file imports: no schema may be named as one. *)
let imported =
  [
    "kotlinx.serialization.EncodeDefault";
    "kotlinx.serialization.KSerializer";
    "kotlinx.serialization.KeepGeneratedSerializer";
    "kotlinx.serialization.SerialName";
    "kotlinx.serialization.Serializable";
    "kotlinx.serialization.SerializationException";
    "kotlinx.serialization.Transient";
    "kotlinx.serialization.descriptors.PrimitiveKind";
    "kotlinx.serialization.descriptors.PrimitiveSerialDescriptor";
    "kotlinx.serialization.descriptors.SerialDescriptor";
    "kotlinx.serialization.encoding.Decoder";
    "kotlinx.serialization.encoding.Encoder";
    "kotlinx.serialization.json.JsonElement";
    "kotlinx.serialization.json.JsonIgnoreUnknownKeys";
    "kotlinx.serialization.json.JsonObject";
    "kotlinx.serialization.json.JsonPrimitive";
    "kotlinx.serialization.serializer";
  ]

let after_last_dot name =
  match String.rindex_opt name '.' with
  | None -> name
  | Some i -> String.sub name (i + 1) (String.length name - i - 1)

(* What a generation reads: the schemas it writes, each [Typing]'s
   declaration of one of [typings], in the order of their names. *)
type spec = { names : string list; find : string -> T.declaration }

let spec typings =
  let names =
    List.sort String.compare
      (List.concat_map (fun (t : T.t) -> t.names) typings)
  in
  List.iteri
    (fun i name ->
      if i > 0 && List.nth names (i - 1) = name then
        refuse
          "two schemas the types write are named %s: a component, a table's \
           record or the sign-in store's entry"
          name)
    names;
  {
    names;
    find =
      (fun name ->
        match
          List.find_opt (fun (t : T.t) -> List.mem name t.names) typings
        with
        | Some t -> t.find name
        | None -> refuse "the spec declares no schema %s" name);
  }

(* The kinds of id among them. *)
let identifiers spec =
  List.filter
    (fun name ->
      match (spec.find name).form with T.Identifier _ -> true | _ -> false)
    spec.names

let is_identifier spec name =
  List.mem name spec.names
  && match (spec.find name).form with T.Identifier _ -> true | _ -> false

type form = Stated_nullable | Single of Schema.literal | Required | Optional

(* One property of an object, as its class and its builder have it. *)
type property = {
  wire : string;
  name : string;
  type_ : K.type_;
  about : K.doc option;
  boxed : bool;
  form : form;
}

(* A declaration of [xynolog.types]: [Pending] while what it reaches is
   written, then the declarations of its file, given the unions it is a
   member of. *)
type written =
  | Pending
  | Alias of K.decl
  | Declared of (string list -> K.decl list)

type state = {
  spec : spec;
  written : (string, written) Hashtbl.t;
  identifiers_written : (string, K.decl) Hashtbl.t;
  unions_of : (string, string list) Hashtbl.t;
}

let state spec =
  {
    spec;
    written = Hashtbl.create 512;
    identifiers_written = Hashtbl.create 8;
    unions_of = Hashtbl.create 512;
  }

let t name = K.Type name
let list_of item = K.Generic ("kotlin.collections.List", [ item ])
let name_of = function K.Type name -> Some name | _ -> None

(* A description as a doc: on one line when it is one. *)
let doc = function
  | Some text when String.trim text <> "" ->
      let text = String.trim text in
      Some
        (if String.contains text '\n' then (K.Block text : K.doc)
         else K.Doc text)
  | _ -> None

let public_val = K.Bound { visibility = K.Public; mutable_ = false }
let serializable = K.annotation "Serializable"

let serializable_with target =
  K.annotation
    ~args:[ K.arg ~label:"with" (K.Class_literal target) ]
    "Serializable"

(* What renames a declaration named [name] to [wire] on the wire: nothing
   where the two are one. *)
let serial_name ~name wire =
  if wire = name then []
  else [ K.annotation ~args:[ K.arg (K.Str wire) ] "SerialName" ]

let supers unions = List.map (fun u -> K.super (t u)) unions
let serializer_of type_ = K.call (K.Name (type_ ^ ".serializer")) []

let empty_json_object =
  K.call (K.Name "JsonObject") [ K.call (K.Name "emptyMap") [] ]

(* The type a schema of the generation names: written once, here. *)
let rec named st name =
  let d = st.spec.find name in
  (match d.form with
  | T.Identifier { pattern } ->
      if not (Hashtbl.mem st.identifiers_written name) then
        Hashtbl.replace st.identifiers_written name
          (identifier name pattern d.node_description)
  | form ->
      if not (Hashtbl.mem st.written name) then (
        Hashtbl.replace st.written name Pending;
        Hashtbl.replace st.written name
          (declaration st name form (doc d.node_description))));
  name

(* A type of its own written in place, declared by the name [Typing] gives
   it. *)
and inline st (i : T.inline) =
  if not (Hashtbl.mem st.written i.name) then (
    Hashtbl.replace st.written i.name Pending;
    Hashtbl.replace st.written i.name
      (declaration st i.name i.form (doc i.node_description)));
  t i.name

(* The Kotlin type of a value of [ty], not null. *)
and type_of st what (ty : T.ty) =
  match ty with
  | T.Named name -> t (named st name)
  | T.Any -> t "JsonElement"
  | T.Nullable inner -> type_of st what inner
  | T.Scalar (T.Text _) -> t "String"
  | T.Scalar (T.Code vocabulary) ->
      t ("xynolog.errors." ^ snd (Code_names.named vocabulary))
  | T.Scalar (T.Word table) -> t (Word_tables.type_name table)
  | T.Scalar T.Boolean -> t "Boolean"
  | T.Scalar T.Number -> t "Double"
  | T.Scalar (T.Integer _) -> t "Long"
  | T.List (Some items) -> list_of (type_of st what items)
  | T.List None -> refuse "%s: a list that states no items" what
  | T.Inline i -> in_place st what i
  | T.Null | T.Nothing ->
      refuse "%s: a schema shape the generator does not know" what

and in_place st what (i : T.inline) =
  match (i.form, i.composition) with
  | _, Some _ | T.Record _, None -> inline st i
  | T.Union u, None ->
      if Deviations.text_union u then t "String" else inline st i
  | T.Enum { base = Some (T.Text _); _ }, None -> inline st i
  | T.Enum { base = Some (T.Integer _ | T.Boolean); _ }, None -> inline st i
  | T.Enum { base = Some T.Number; _ }, None -> t "Double"
  | (T.Empty _ as form), None when T.holds_none form -> the_empty_object st
  | T.Empty _, None -> t "JsonObject"
  | T.Map { key; value }, None -> map_of st what key value
  | ( ( T.Enum { base = None | Some (T.Code _ | T.Word _); _ }
      | T.Alias _ | T.Identifier _ | T.Json ),
      None ) ->
      refuse "%s: a schema shape the generator does not know" what

(* A map, keyed by the schema [key] names (text, when it names none), of
   what [value] admits. *)
and map_of st what key value =
  K.Generic
    ( "kotlin.collections.Map",
      [
        (match key with Some key -> t (named st key) | None -> t "String");
        type_of st what value;
      ] )

and the_empty_object st =
  if not (Hashtbl.mem st.written empty_object) then
    Hashtbl.replace st.written empty_object
      (Declared
         (fun unions ->
           [
             K.class_ ~about:(K.Block "An object with no properties.")
               ~annotations:[ serializable ] ~visibility:K.Public
               ~supers:(supers unions) K.Data_object empty_object;
           ]));
  t empty_object

(* The declaration of [name], of [form]. *)
and declaration st name (form : T.form) about : written =
  let alias type_ =
    Alias (K.Typealias { about; visibility = K.Public; name; type_ })
  in
  match form with
  | T.Union u -> union_declaration st name u about
  | T.Enum { base = Some (T.Text _); values } ->
      enum_declaration name values about
  | T.Enum
      { values = [ ((Schema.Int_literal _ | Schema.Bool_literal _) as v) ]; _ }
    ->
      constant_declaration name v about
  | T.Enum _ ->
      refuse "%s: only string enumerations and constants are generated" name
  | T.Alias (T.Scalar (T.Text _)) -> alias (t "String")
  | T.Alias (T.Scalar (T.Integer _)) -> alias (t "Long")
  | T.Alias (T.Scalar T.Number) -> alias (t "Double")
  | T.Alias (T.Scalar T.Boolean) -> alias (t "Boolean")
  | T.Map { key; value } -> alias (map_of st name key value)
  | T.Empty { rest = T.Open; _ } -> alias (t "JsonObject")
  | T.Empty { rest; _ } ->
      (* An object with nothing to state is one value: the same [{}] every time. *)
      Declared
        (fun unions ->
          [
            K.class_ ?about
              ~annotations:
                (serializable
                ::
                (if rest = T.Closed then []
                 else [ K.annotation "JsonIgnoreUnknownKeys" ]))
              ~visibility:K.Public ~supers:(supers unions) K.Data_object name;
          ])
  | T.Record { members; rest } -> object_declaration st name members rest about
  | T.Alias _ | T.Identifier _ | T.Json ->
      refuse "%s: a schema shape the generator does not know" name

and enum_declaration name values about =
  let entries =
    List.fold_left
      (fun entries value ->
        let text =
          match value with
          | Schema.String_literal s -> s
          | _ -> refuse "%s: an enum value is not a string" name
        in
        let variant = Names.variant_of text in
        if List.exists (fun (e : K.entry) -> e.entry = variant) entries then
          refuse "%s: two enum values would both be the constant %s" name
            variant;
        entries
        @ [
            K.entry
              ~annotations:(serial_name ~name:variant text)
              ~args:[ K.Str text ] variant;
          ])
      [] values
  in
  Declared
    (fun unions ->
      [
        K.class_ ?about ~annotations:[ serializable ] ~visibility:K.Public
          ~constructor:
            (K.constructor
               [
                 K.param ~about:(K.Doc "The value as the wire spells it.")
                   ~binding:public_val "value" (t "String");
               ])
          ~supers:(supers unions) ~entries K.Enum_class name;
      ])

and property st owner (m : T.member) =
  let name = Names.property_name m.wire in
  let type_ = type_of st (owner ^ "." ^ m.wire) m.ty in
  let nullable = match m.ty with T.Nullable _ -> true | _ -> false in
  let boxed =
    match name_of type_ with Some k -> is_identifier st.spec k | None -> false
  in
  let form =
    match (m.required, nullable, m.fixed) with
    | true, true, _ -> Stated_nullable
    | true, false, Some only -> Single only
    | true, false, _ -> Required
    | false, _, _ -> Optional
  in
  { wire = m.wire; name; type_; about = doc m.node_description; boxed; form }

and object_declaration st name (members : T.member list) (rest_ : T.rest) about
    : written =
  let open_ =
    match rest_ with
    | T.Open -> true
    | T.Closed | T.Unstated -> false
    | T.Of _ ->
        refuse
          "%s: properties beside additionalProperties, which the generator \
           does not know"
          name
  in
  let closed = rest_ = T.Closed in
  let props = List.map (property st name) members in
  List.iteri
    (fun i p ->
      if
        List.exists
          (fun q -> q.name = p.name)
          (List.filteri (fun j _ -> j < i) props)
      then refuse "%s: two properties are named %s in Kotlin" name p.name;
      if open_ && p.name = rest then
        refuse
          "%s: a property is named %s, which is where an open object keeps \
           what it does not name"
          name rest;
      if p.name = "build" then
        refuse "%s: a property is named build, which is its builder's last call"
          name)
    props;
  Declared
    (fun unions ->
      let rest_param =
        K.param
          ~about:(K.Doc "Every property the schema does not name, as it came.")
          ~annotations:[ K.annotation "Transient" ]
          ~binding:public_val ~default:empty_json_object rest (t "JsonObject")
      in
      [
        K.class_ ?about
          ~annotations:
            ((if open_ then
                [
                  serializable_with (name ^ ".Serializer");
                  K.annotation "KeepGeneratedSerializer";
                ]
              else [ serializable ])
            @
            if closed || open_ then []
            else [ K.annotation "JsonIgnoreUnknownKeys" ])
          ~visibility:K.Public
          ~constructor:
            (K.constructor
               (List.map declared props @ if open_ then [ rest_param ] else []))
          ~supers:(supers unions)
          ~members:
            (builder name props open_
            @ if open_ then open_serializer name else [])
          K.Data_class name;
      ])

(* As the data class declares it. *)
and declared p =
  let annotations =
    serial_name ~name:p.name p.wire
    @ (match p.form with
      | Single _ -> [ K.annotation "EncodeDefault" ]
      | _ -> [])
    @ if p.boxed then [ K.annotation ~target:"get" "JvmExposeBoxed" ] else []
  in
  let type_, default =
    match p.form with
    | Stated_nullable -> (K.Nullable p.type_, None)
    | Single only -> (
        match (name_of p.type_, only) with
        | Some type_name, Schema.String_literal only ->
            (p.type_, Some (K.Name (type_name ^ "." ^ Names.variant_of only)))
        | Some type_name, (Schema.Int_literal _ | Schema.Bool_literal _) ->
            (p.type_, Some (K.Name type_name))
        | None, _ ->
            refuse "%s: a property of one value that is not an enumeration"
              p.wire)
    | Required -> (p.type_, None)
    | Optional -> (K.Nullable p.type_, Some K.Null)
  in
  K.param ?about:p.about ~annotations ~binding:public_val ?default p.name type_

(* The type a builder takes it as. *)
and taken p =
  match p.form with
  | Stated_nullable | Optional -> K.Nullable p.type_
  | Single _ | Required -> p.type_

(* What Java makes one with: the builder, and the companion's [builder]. *)
(* [members] a line apart where none is annotated: each annotated one
   stands apart, as the printer packs only bare members. *)
and packed members =
  let run = function [] -> [] | run -> [ K.Packed (List.rev run) ] in
  let rec go acc = function
    | [] -> run acc
    | (K.Function { annotations = _ :: _; _ } as m) :: rest ->
        run acc @ (m :: go [] rest)
    | m :: rest -> go (m :: acc) rest
  in
  go [] members

and builder name props open_ =
  let given =
    List.filter
      (fun p ->
        match p.form with Required | Stated_nullable -> true | _ -> false)
      props
  in
  let set =
    List.filter
      (fun p -> match p.form with Optional -> true | _ -> false)
      props
  in
  let field p =
    K.property ~visibility:K.Private ~mutable_:true ~type_:(taken p)
      ~value:(K.Same_line K.Null) p.name
  in
  let fields =
    List.map field set
    @
    if open_ then
      [
        K.property ~visibility:K.Private ~mutable_:true ~type_:(t "JsonObject")
          ~value:(K.Same_line empty_json_object) rest;
      ]
    else []
  in
  let setter ~annotations field type_ value =
    K.function_ ~annotations ~visibility:K.Public
      ~params:[ (field, type_) ]
      ~returns:(t "Builder") field
      (K.Same_line
         (K.call
            ~lambda:
              (K.Lambda ([], K.Assigning (K.Member (K.This, field), value)))
            (K.Name "apply") []))
  in
  let setters =
    List.map
      (fun p ->
        setter
          ~annotations:
            (if p.boxed then [ K.annotation "JvmExposeBoxed" ] else [])
          p.name (taken p) (K.Name p.name))
      set
    @
    if open_ then [ setter ~annotations:[] rest (t "JsonObject") (K.Name rest) ]
    else []
  in
  let arguments =
    List.filter_map
      (fun p ->
        match p.form with Single _ -> None | _ -> Some (p.name, K.Name p.name))
      props
    @ if open_ then [ (rest, K.Name rest) ] else []
  in
  let build =
    K.function_ ~visibility:K.Public ~returns:(t name) "build"
      (K.Same_line (K.named_call (K.Name name) arguments))
  in
  [
    K.class_
      ~about:
        (K.Doc
           (Printf.sprintf
              "How Java makes a `%s`: `builder` takes what it must state, a \
               setter each thing it may, and `build` makes it."
              name))
      ~visibility:K.Public
      ~constructor:
        (K.constructor ~visibility:K.Internal
           (List.map
              (fun p ->
                K.param
                  ~binding:
                    (K.Bound { visibility = K.Private; mutable_ = false })
                  p.name (taken p))
              given))
      ~members:
        ((match fields with [] -> [] | fields -> [ K.Packed fields ])
        @ packed setters @ [ build ])
      K.Class "Builder";
    K.class_ ~visibility:K.Public
      ~members:
        [
          K.function_
            ~about:
              (K.Doc
                 (Printf.sprintf
                    "A builder of a `%s` that states these, and what its \
                     setters add."
                    name))
            ~annotations:
              (K.annotation "JvmStatic"
              ::
              (if List.exists (fun p -> p.boxed) given then
                 [ K.annotation "JvmExposeBoxed" ]
               else []))
            ~visibility:K.Public
            ~params:(List.map (fun p -> (p.name, taken p)) given)
            ~returns:(t "Builder") "builder"
            (K.Same_line
               (K.call (K.Name "Builder")
                  (List.map (fun p -> K.Name p.name) given)));
        ]
      K.Companion_object "Companion";
  ]

(* An open object's serializer: what the schema names, read and written by
   the serializer the plugin generates, and the rest kept as it came. *)
(* A schema of one integer or boolean: an object, read and written as that
   value. *)
and constant_declaration name (value : Schema.literal) about : written =
  let literal : K.expr =
    match value with
    | Schema.Int_literal i -> Int i
    | Schema.Bool_literal b -> Bool b
    | Schema.String_literal _ ->
        refuse "%s: a constant of text is an enumeration" name
  in
  Declared
    (fun unions ->
      [
        K.class_ ?about
          ~annotations:[ serializable_with (name ^ ".Serializer") ]
          ~visibility:K.Public ~supers:(supers unions)
          ~members:
            [
              K.class_ ~visibility:K.Internal
                ~supers:
                  [
                    K.super
                      ~args:
                        [
                          K.arg (K.Name name);
                          K.arg (K.call (K.Name "JsonPrimitive") [ literal ]);
                        ]
                      (K.Generic (constant_serializer, [ t name ]));
                  ]
                K.Object "Serializer";
            ]
          K.Data_object name;
      ])

and open_serializer name =
  [
    K.class_ ~visibility:K.Internal
      ~supers:
        [
          K.super ~layout:K.Lines
            ~args:
              [
                K.arg (K.call (K.Name (name ^ ".generatedSerializer")) []);
                K.arg (K.Reference (name, rest));
                K.arg
                  (K.Lambda
                     ( [ "named"; rest ],
                       K.named_call (K.Name "named.copy")
                         [ (rest, K.Name rest) ] ));
              ]
            (K.Generic (open_object_serializer, [ t name ]));
        ]
      K.Object "Serializer";
  ]

(* A kind of id: text no code can make but through its constructor, which
   holds it to the schema's pattern. *)
and identifier name pattern description =
  let pattern =
    match pattern with
    | Some p -> p
    | None -> refuse "%s: a kind of id states no pattern" name
  in
  let rule = Rule.of_pattern name pattern in
  K.class_ ?about:(doc description)
    ~annotations:
      [
        serializable_with (name ^ ".Serializer");
        K.annotation "JvmExposeBoxed";
        K.annotation "JvmInline";
      ]
    ~visibility:K.Public
    ~constructor:
      (K.constructor
         [
           K.param ~about:(K.Doc "The id as text.") ~binding:public_val "value"
             (t "String");
         ])
    ~members:
      [
        K.Init
          [
            K.If_then
              ( K.Not (K.call (K.Name "admits") [ K.Name "value" ]),
                K.Do
                  (K.Throw
                     (K.call (K.Name invalid_identifier)
                        [ K.Str name; K.Name "PATTERN"; K.Name "value" ])) );
          ];
        K.function_ ~override:true ~returns:(t "String") "toString"
          (K.Same_line (K.Name "value"));
        K.class_
          ~about:
            (K.Doc
               "The id as a JSON string; text its rule refuses fails as a \
                decoder's failures do.")
          ~visibility:K.Internal
          ~supers:[ K.super (K.Generic ("KSerializer", [ t name ])) ]
          ~members:
            [
              K.property ~override:true ~type_:(t "SerialDescriptor")
                ~value:
                  (K.Same_line
                     (K.call (K.Name "PrimitiveSerialDescriptor")
                        [
                          K.Str (identifiers_package ^ "." ^ name);
                          K.Name "PrimitiveKind.STRING";
                        ]))
                "descriptor";
              K.function_ ~override:true
                ~params:[ ("encoder", t "Encoder"); ("value", t name) ]
                "serialize"
                (K.Block
                   [
                     K.Do
                       (K.call (K.Name "encoder.encodeString")
                          [ K.Name "value.value" ]);
                   ]);
              K.function_ ~override:true
                ~params:[ ("decoder", t "Decoder") ]
                ~returns:(t name) "deserialize"
                (K.Below
                   (K.Try
                      {
                        body =
                          K.call (K.Name name)
                            [
                              K.call
                                (K.Member
                                   ( K.call (K.Name "decoder.decodeInline")
                                       [ K.Name "descriptor" ],
                                     "decodeString" ))
                                [];
                            ];
                        caught = ("refused", t invalid_identifier);
                        handler =
                          K.Throw
                            (K.call (K.Name "SerializationException")
                               [ K.Name "refused.message"; K.Name "refused" ]);
                      }));
            ]
          K.Object "Serializer";
        K.class_ ~visibility:K.Public
          ~members:
            [
              K.property
                ~about:
                  (K.Doc "The rule a value is held to, as the spec writes it.")
                ~visibility:K.Public ~const:true ~type_:(t "String")
                ~value:(K.Same_line (K.Str pattern)) "PATTERN";
              K.function_
                ~about:
                  (K.Doc
                     (Printf.sprintf
                        "`value` as a `%s`, or null when it is not one." name))
                ~annotations:
                  [ K.annotation "JvmStatic"; K.annotation "JvmExposeBoxed" ]
                ~visibility:K.Public
                ~params:[ ("value", t "String") ]
                ~returns:(K.Nullable (t name))
                "parse"
                (K.Same_line
                   (K.If
                      ( K.call (K.Name "admits") [ K.Name "value" ],
                        K.call (K.Name name) [ K.Name "value" ],
                        K.Null )));
              K.function_ ~visibility:K.Private
                ~params:[ ("value", t "String") ]
                ~returns:(t "Boolean") "admits" (Rule.check rule);
            ]
          K.Companion_object "Companion";
      ]
    K.Value_class name

(* Whether a type is a declaration of its own that a union's members can be:
   not an alias, nor a type of Kotlin's or the JSON library's. One still being
   written is. *)
and implementable st type_ =
  match name_of type_ with
  | Some name when name <> empty_object -> (
      match Hashtbl.find_opt st.written name with
      | Some (Pending | Declared _) -> true
      | Some (Alias _) | None -> false)
  | _ -> false

and union_declaration st name (u : T.union) about : written =
  (match T.apart_by_pattern_only u with
  | Some (a, b) ->
      refuse
        "%s: its members %s and %s are told apart only by a pattern, which the \
         Kotlin SDK does not read"
        name a b
  | None -> ());
  (* Each member's type, in the union's order, and the variants of its own. *)
  let read = ref [] and variants = ref [] in
  let variant v decl =
    let type_ = name ^ "." ^ v in
    if List.mem type_ !read then
      refuse "%s: two union members would both be the variant %s" name v;
    variants := !variants @ [ decl ];
    read := !read @ [ type_ ]
  in
  let member type_ =
    let unions =
      Option.value ~default:[] (Hashtbl.find_opt st.unions_of type_)
    in
    if not (List.mem name unions) then
      Hashtbl.replace st.unions_of type_ (unions @ [ name ]);
    read := !read @ [ type_ ]
  in
  List.iter
    (fun (b : T.branch) ->
      match b.ty with
      | T.Named target when is_identifier st.spec target ->
          variant b.variant
            (wrapped name (named st target)
               (t (identifiers_package ^ "." ^ target)))
      | T.Named target when not (T.admits_only_text b) ->
          let type_ = named st target in
          if implementable st (t type_) then member type_
          else
            variant b.variant
              (wrapped name b.variant (t (types_package ^ "." ^ type_)))
      | T.Inline { form = T.Empty _ as form; composition = None; _ }
        when T.holds_none form ->
          variant b.variant
            (K.class_ ~about:(K.Doc "The empty object.")
               ~annotations:[ serializable ] ~visibility:K.Public
               ~supers:[ K.super (t name) ]
               K.Data_object b.variant)
      | _ when T.admits_only_text b ->
          variant b.variant (wrapped name b.variant (t "String"))
      | T.Scalar (T.Integer _) ->
          variant b.variant (wrapped name b.variant (t "Long"))
      | T.Scalar T.Number ->
          variant b.variant (wrapped name b.variant (t "Double"))
      | T.Scalar T.Boolean ->
          (* Within the member, a bare [Boolean] is the member itself. *)
          variant b.variant (wrapped name b.variant (t "kotlin.Boolean"))
      | T.List _ ->
          variant b.variant (wrapped name b.variant (type_of st name b.ty))
      | T.Inline _ -> (
          let type_ = type_of st name b.ty in
          match name_of type_ with
          | Some key when implementable st type_ -> member key
          | _ -> variant b.variant (wrapped name b.variant type_))
      | _ -> refuse "%s: a union member the generator does not know" name)
    u.branches;
  let read = !read and variants = !variants in
  let serializer = name ^ "Serializer" in
  let list = function
    | [] -> K.call (K.Name "emptyList") []
    | items -> K.call (K.Name "listOf") items
  in
  let stated = function Some e -> e | None -> K.Null in
  let literal (l : Schema.literal) =
    match l with
    | Schema.String_literal s -> K.call (K.Name "Literal.Text") [ K.Str s ]
    | Schema.Int_literal n -> K.call (K.Name "Literal.Integer") [ K.Int n ]
    | Schema.Bool_literal b -> K.call (K.Name "Literal.Boolean") [ K.Bool b ]
  in
  let words ws = list (List.map (fun w -> K.Str w) ws) in
  let signature (s : T.signature) =
    let kind =
      match s.kind with
      | T.Text_kind -> "TEXT"
      | T.Integer_kind -> "INTEGER"
      | T.Number_kind -> "NUMBER"
      | T.Boolean_kind -> "BOOLEAN"
      | T.List_kind -> "LIST"
      | T.Object_kind -> "OBJECT"
      | T.Null_kind -> "NULL"
      | T.Any_kind -> "ANY"
    in
    K.named_call ~layout:K.Lines (K.Name "Signature")
      [
        ("kind", K.Name ("Kind." ^ kind));
        ("required", words s.required);
        ("allowed", stated (Option.map words s.allowed));
        ( "fixed",
          list
            (List.map
               (fun (p, vs) ->
                 K.Binary (K.Str p, K.To, list (List.map literal vs)))
               s.fixed) );
        ( "values",
          stated (Option.map (fun vs -> list (List.map literal vs)) s.values) );
      ]
  in
  let chooser =
    K.super ~layout:K.Lines
      ~args:
        [
          K.arg (K.Class_literal name);
          K.arg ~label:"members"
            (K.call ~layout:K.Lines (K.Name "listOf")
               (List.map
                  (fun (b : T.branch) ->
                    K.call ~layout:K.Lines (K.Name "listOf")
                      (List.map signature b.signature))
                  u.branches));
          K.arg ~label:"variants"
            (K.Lambda
               ( [],
                 K.call ~layout:K.Lines (K.Name "listOf")
                   (List.map serializer_of read) ));
        ]
      (K.Generic (signature_union_serializer, [ t name ]))
  in
  Declared
    (fun unions ->
      [
        K.class_ ?about
          ~annotations:[ serializable_with serializer ]
          ~visibility:K.Public ~supers:(supers unions) ~members:variants
          K.Sealed_interface name;
        K.class_ ~visibility:K.Internal ~supers:[ chooser ] K.Object serializer;
      ])

(* A variant of a union that holds a value of [type_], written as the value
   itself. [type_] is qualified where the variant is named as it is, which
   would shadow it. *)
and wrapped union variant type_ =
  K.class_
    ~about:
      (K.Doc
         (Printf.sprintf "A member that is a `%s`, as the value itself."
            (after_last_dot (K.type_ type_))))
    ~annotations:[ serializable_with (variant ^ ".Serializer") ]
    ~visibility:K.Public
    ~constructor:
      (K.constructor ~layout:K.Inline
         [ K.param ~binding:public_val "value" type_ ])
    ~supers:[ K.super (t union) ]
    ~members:
      [
        K.class_ ~visibility:K.Internal
          ~supers:
            [
              K.super
                ~args:
                  [
                    K.arg (K.Class_literal variant);
                    K.arg
                      (K.call (K.Name "kotlinx.serialization.serializer") []);
                    K.arg
                      (K.Lambda ([], K.call (K.Name variant) [ K.Name "it" ]));
                    K.arg (K.Reference (variant, "value"));
                  ]
                (K.Generic (wrapper_serializer, [ t variant; type_ ]));
            ]
          K.Object "Serializer";
      ]
    K.Data_class variant

let sorted table =
  List.sort
    (fun (a, _) (b, _) -> compare a b)
    (List.of_seq (Hashtbl.to_seq table))

(* What one generation writes: each declaration of the types' package, by
   name, as the declarations of its file, and the kinds of id. *)
type generated = {
  types : (string * K.decl list) list;
  identifier_decls : K.decl list;
}

let generate spec =
  List.iter
    (fun name ->
      if List.exists (fun i -> after_last_dot i = name) imported then
        refuse "%s is a schema's name, and a name the generated code imports"
          name;
      if
        List.mem name
          [
            empty_object;
            invalid_identifier;
            signature_union_serializer;
            "Signature";
            "Kind";
            "Literal";
            "Found";
            wrapper_serializer;
            open_object_serializer;
            constant_serializer;
          ]
      then refuse "%s is a schema's name, and one the SDK declares by hand" name)
    spec.names;
  let st = state spec in
  List.iter (fun name -> ignore (named st name)) spec.names;
  let types =
    List.map
      (fun (name, written) ->
        let unions =
          List.sort compare
            (Option.value ~default:[] (Hashtbl.find_opt st.unions_of name))
        in
        match written with
        | Declared decls -> (name, decls unions)
        | Alias _ when unions <> [] ->
            refuse "%s: an alias that a union counts a member" name
        | Alias decl -> (name, [ decl ])
        | Pending -> refuse "%s: a declaration never finished" name)
      (sorted st.written)
  in
  { types; identifier_decls = List.map snd (sorted st.identifiers_written) }

(* The properties of the data class declared of [name], each by its Kotlin
   name, with the type it is read as, what it is, and whether Java reads it
   boxed. *)
let properties spec name =
  let st = state spec in
  match (spec.find name).form with
  | T.Record { members; _ } ->
      List.map
        (fun m ->
          let p = property st name m in
          (p.name, taken p, p.about, p.boxed))
        members
  | _ -> refuse "%s: no data class is declared of it" name

(* The Kotlin type of the value a table's [$ref] names, named in full: a
   schema's type, or the type of one member of a schema's own. Named in
   full, since a schema's type may share its name with one Kotlin imports
   by default, as Annotation does. *)
let value_type_of spec ~component ~member =
  let st = state spec in
  let type_ =
    match member with
    | None -> t (named st component)
    | Some member -> (
        match (spec.find component).form with
        | T.Record { members; _ } -> (
            match
              List.find_opt (fun (m : T.member) -> m.wire = member) members
            with
            | Some m -> type_of st (component ^ "." ^ member) m.ty
            | None -> refuse "%s has no member %s" component member)
        | _ -> refuse "%s has no member %s" component member)
  in
  match type_ with
  | K.Type name when is_identifier spec name ->
      t (identifiers_package ^ "." ^ name)
  | K.Type name when List.mem name spec.names -> t (types_package ^ "." ^ name)
  | other -> other

(* What a file that names [type_] imports for it: the generated types and
   the JSON library's it names unqualified. *)
let rec imports_of spec = function
  | K.Type name when String.contains name '.' -> []
  | K.Type ("String" | "Boolean" | "Double" | "Long") -> []
  | K.Type (("JsonElement" | "JsonObject") as name) ->
      [ "kotlinx.serialization.json." ^ name ]
  | K.Type name when is_identifier spec name ->
      [ identifiers_package ^ "." ^ name ]
  | K.Type name -> [ types_package ^ "." ^ name ]
  | K.Generic (name, args) ->
      imports_of spec (K.Type name) @ List.concat_map (imports_of spec) args
  | K.Nullable t -> imports_of spec t
  | K.Star -> []
  | K.Function_type (params, result) ->
      List.concat_map (imports_of spec) (result :: params)
