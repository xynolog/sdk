(* Kotlin types from component schemas: a data class per object, an enum
   class per string enumeration, a sealed interface per [oneOf] or [anyOf],
   an alias per named string, a value class per kind of id, a property per
   schema property, optional where the schema does not require it. It knows
   the shapes the spec's schemas use and refuses any other, so a schema that
   grows a new shape stops the run rather than generating something wrong.

   It reads a schema that may be null ([Null_form]) as JSON Schema has it:
   beside one [type], [null] is a second; anything else is
   [anyOf: [{type: null}, what it is beside null]].

   A property that is required and may be null is stated, as null or a
   value; one that is optional is absent or a value; one that is optional
   and may be null is a [Stated]: absent, null or a value. A property that
   admits one value says which member of a union an object is: it is the
   type's to state, and is written whatever the encoder's defaults.

   A union is a sealed interface its named members implement, so a member is
   the union wherever the union is wanted. One whose schema names the
   property its members are told apart by, each member stating its own one
   value of it, is decoded as the member that value names. Any other is
   decoded as the first member that fits. A member that is text, a list or
   the empty object is a variant of the union's own, since nothing says which
   union a [String] was meant for.

   An object whose schema admits properties it does not name keeps them, and
   writes them back ([rest]). One whose schema admits none refuses one; any
   other ignores what it does not name, as a later gateway may add some.

   Java makes a model through its builder: [builder] takes what must be
   stated, a setter each thing that may be, and [build] makes it.

   A kind of id is a value class whose pattern is the check its constructor
   makes, and decoding goes through that constructor, so a value of the type
   has always passed its rule. *)

module K = Kotlin_syntax

let refuse = Names.refuse
let types_package = "xynolog.types"
let identifiers_package = "xynolog.identifiers"

(* The generator's own declaration, written when a schema needs it, and the
   SDK's, written by hand beside the generated ones. *)
let empty_object = "EmptyObject"
let stated = "Stated"
let invalid_identifier = "InvalidIdentifier"
let kinds_union_serializer = "KindsUnionSerializer"
let tagged_union_serializer = "TaggedUnionSerializer"
let wrapper_serializer = "WrapperSerializer"
let open_object_serializer = "OpenObjectSerializer"
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
    "kotlinx.serialization.serializer";
  ]

let after_last_dot name =
  match String.rindex_opt name '.' with
  | None -> name
  | Some i -> String.sub name (i + 1) (String.length name - i - 1)

(* A schema as it says null. [Wrapped] is [anyOf: [{type: null}, s]];
   [Typed_null] is [s] with [null] beside its one type. A [$ref] is the
   schema it names, and nothing said beside it is read: the bundle the SDKs
   read writes a component's reference alone. *)
type null_form = Not_null | Typed_null | Wrapped

type node =
  | Bool_node of bool
  | Null_type  (** [{type: null}], a [Wrapped] node's first member. *)
  | Ref of { reference : Decode.reference; description : string option }
  | Node of { s : Schema.schema; null_form : null_form }

let node : Schema.t -> node = function
  | Boolean_schema b -> Bool_node b
  | Schema ({ ref_ = Some reference; _ } as s) -> (
      match Schema_names.said_of_reference s reference with
      | Ok description -> Ref { reference; description }
      | Error message -> Names.refuse "%s" message)
  | Schema s -> (
      match Null_form.without_null Fun.id s with
      | Error message -> Names.refuse "%s" message
      | Ok None -> Node { s; null_form = Not_null }
      | Ok (Some beside) -> (
          match beside.type_ with
          | Some [ _ ] -> Node { s = beside; null_form = Typed_null }
          | _ -> Node { s = beside; null_form = Wrapped }))

(* The keywords a node states beside its [type] and its [anyOf]. *)
let keywords = function
  | Node { s; null_form = Not_null | Typed_null } -> Some s
  | Bool_node _ | Null_type | Ref _ | Node { null_form = Wrapped; _ } -> None

let field f n = Option.bind (keywords n) f

(* Its [type], when that is one name. *)
let type_name = function
  | Node { s = { type_ = Some [ t ]; _ }; null_form = Not_null } -> Some t
  | _ -> None

let enum = field (fun s -> s.enum)

let description = function
  | Ref { description; _ } -> description
  | n -> field (fun s -> s.description) n

let properties = field (fun (s : Schema.schema) -> s.properties)

let required n =
  Option.value ~default:[] (field (fun (s : Schema.schema) -> s.required) n)

let additional = field (fun (s : Schema.schema) -> s.additional_properties)
let max_properties = field (fun (s : Schema.schema) -> s.max_properties)
let all_of = field (fun (s : Schema.schema) -> s.all_of)
let items = field (fun (s : Schema.schema) -> s.items)
let discriminator = field (fun (s : Schema.schema) -> s.discriminator)
let is_closed n = additional n = Some (Boolean_schema false)

let union n =
  match n with
  | Node { s; null_form = Wrapped } ->
      Some [ Null_type; node (Schema.Schema s) ]
  | _ ->
      field
        (fun (s : Schema.schema) ->
          match s.one_of with Some m -> Some m | None -> s.any_of)
        n
      |> Option.map (List.map node)

let is_empty = function
  | Node { s; null_form = Not_null } -> Schema.keywords s = []
  | _ -> false

let property_node n key =
  Option.bind (properties n) (List.assoc_opt key) |> Option.map node

(* The one string a schema admits, when it admits exactly one. *)
let only_value n =
  match enum n with Some [ Schema.String_literal v ] -> Some v | _ -> None

(* The single value an object's discriminating property takes: the first of
   its properties that admits exactly one string. *)
let discriminant n =
  List.find_map
    (fun (_, p) -> only_value (node p))
    (Option.value ~default:[] (properties n))

(* A schema that also admits null, as the schema without it. *)
let without_null what n =
  match (union n, n) with
  | Some members, _ -> (
      match List.filter (function Null_type -> false | _ -> true) members with
      | others when List.length others = List.length members -> None
      | [ one ] -> Some one
      | _ ->
          refuse
            "%s: a union of several members and null, which draft 7 does not \
             make of a schema"
            what)
  | None, Node { s; null_form = Typed_null } ->
      Some (Node { s; null_form = Not_null })
  | None, _ -> None

(* What a generation reads: the schemas it writes, by name, the kinds of id
   among them, and the name of each schema a [$ref] names, by where it points
   ([Table_records.key]). *)
type spec = {
  definitions : (string * Schema.t) list;
  identifiers : string list;
  ids : Decode.ids;  (** Each schema's [$id]: what a reference names. *)
  name_of_key : (string * string) list;
}

let component spec (r : Decode.reference) =
  match List.assoc_opt (Table_records.key spec.ids r) spec.name_of_key with
  | Some name -> name
  | None -> refuse "$ref %s names no schema the types write" r.target

let reference spec = function
  | Ref { reference; _ } -> Some (component spec reference)
  | Bool_node _ | Null_type | Node _ -> None

let schema spec name =
  match List.assoc_opt name spec.definitions with
  | Some s -> node s
  | None -> refuse "the spec declares no schema %s" name

(* What [what]'s node [n] means: one that states an [allOf], what its parts
   merge to. Whether it admits null is the node's own: its merge is made from
   what it states beside its null. *)
let meant spec what = function
  | Node { s = { all_of = Some _; _ } as s; null_form } -> (
      match
        Normalize.normalize spec.ids
          ~find:(fun r ->
            match List.assoc_opt (component spec r) spec.definitions with
            | Some s -> Ok s
            | None -> Error ("the spec declares no schema " ^ r.target))
          (Schema.Schema s)
      with
      | Ok s -> Node { s; null_form }
      | Error message -> refuse "%s: %s" what message)
  | n -> n

type form =
  | Stated_nullable
  | Single of string
  | Required
  | Three_states
  | Optional

(* One property of an object, as its class and its builder have it. *)
type property = {
  wire : string;
  name : string;
  type_ : K.type_;
  about : K.doc option;
  boxed : bool;
  form : form;
}

(* An object's members: the properties it states, those it requires, and
   what it admits beside them. *)
type object_ = {
  stated_properties : (string * Schema.t) list;
  required_names : string list;
  beside : Schema.t option;
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
  inlined : (string, node) Hashtbl.t;
      (** The schema each type written in place was written from. *)
  identifiers_written : (string, K.decl) Hashtbl.t;
  unions_of : (string, string list) Hashtbl.t;
}

let state spec =
  {
    spec;
    written = Hashtbl.create 512;
    inlined = Hashtbl.create 256;
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

(* Whether a schema is text, following [$ref]s and unions of text. A kind of
   id is text. *)
let rec is_string st n =
  match reference st.spec n with
  | Some name -> is_string st (schema st.spec name)
  | None -> (
      match union n with
      | Some members -> List.for_all (is_string st) members
      | None -> type_name n = Some Schema.String && enum n = None)

(* The type a component schema names: written once, here. *)
let rec named st name =
  if List.mem name st.spec.identifiers then (
    if not (Hashtbl.mem st.identifiers_written name) then
      Hashtbl.replace st.identifiers_written name
        (identifier name (schema st.spec name)))
  else if not (Hashtbl.mem st.written name) then (
    Hashtbl.replace st.written name Pending;
    Hashtbl.replace st.written name (declaration st name (schema st.spec name)));
  name

(* The name of the type of [owner]'s property [property], when its schema is
   written in place: the two names together, and [Value] after them for as
   long as a schema already has that name. *)
and inline_name st owner property =
  let rec free name =
    if List.mem_assoc name st.spec.definitions then free (name ^ "Value")
    else name
  in
  free (owner ^ Names.pascal property)

and inline st name n =
  (match Hashtbl.find_opt st.inlined name with
  | Some written when written = n -> ()
  | Some _ -> refuse "two different schemas written in place as %s" name
  | None when Hashtbl.mem st.written name ->
      refuse "a schema written in place as %s, which another type is" name
  | None ->
      Hashtbl.replace st.inlined name n;
      Hashtbl.replace st.written name Pending;
      Hashtbl.replace st.written name (declaration st name n));
  t name

(* The Kotlin type of a value [owner]'s property [property] holds, not null. *)
and type_of st owner property n =
  let what = owner ^ "." ^ property in
  (match n with
  | Node _ | Ref _ -> ()
  | Bool_node _ | Null_type -> refuse "%s: a schema that is no object" what);
  match reference st.spec n with
  | Some name -> t (named st name)
  | None when is_empty n -> t "JsonElement"
  | None -> (
      match without_null what n with
      | Some n -> type_of st owner property n
      | None -> (
          match all_of n with
          | Some _ -> inline st (inline_name st owner property) n
          | None -> (
              match union n with
              | Some members ->
                  if List.for_all (is_string st) members then t "String"
                  else inline st (inline_name st owner property) n
              | None -> (
                  match type_name n with
                  | Some String ->
                      if enum n <> None then
                        inline st (inline_name st owner property) n
                      else t "String"
                  | Some Boolean -> t "Boolean"
                  | Some Number -> t "Double"
                  | Some Integer -> t "Long"
                  | Some Array ->
                      list_of
                        (type_of st owner (property ^ "Item")
                           (node_of_items what n))
                  | Some Object -> (
                      match (properties n, additional n) with
                      | Some (_ :: _), _ ->
                          inline st (inline_name st owner property) n
                      | _, Some (Boolean_schema false) -> the_empty_object st
                      | _ when max_properties n = Some 0 -> the_empty_object st
                      | _, (None | Some (Boolean_schema true)) -> t "JsonObject"
                      | _, Some beside ->
                          K.Generic
                            ( "kotlin.collections.Map",
                              [
                                t "String";
                                type_of st owner (property ^ "Value")
                                  (node beside);
                              ] ))
                  | Some Null | None ->
                      refuse "%s: a schema shape the generator does not know"
                        what))))

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

and node_of_items what n =
  match items n with
  | Some items -> node items
  | None -> refuse "%s: a list that states no items" what

and declaration st name raw : written =
  match (all_of raw, keywords raw) with
  | Some _, Some s ->
      plain_declaration st name
        ~owner:
          (Inherited.of_schemas
             ~find:(fun n -> List.assoc n st.spec.definitions)
             ~referenced:(component st.spec) name (Schema.Schema s))
        (meant st.spec name raw)
  | _ -> plain_declaration st name ~owner:(fun _ -> name) raw

(* The declaration of [name], whose schema [raw] states no [allOf], each of
   its properties named for the schema [owner] says states it. *)
and plain_declaration st name ~owner raw : written =
  let about = doc (description raw) in
  match union raw with
  | Some members ->
      let told_apart =
        Option.bind (discriminator raw) (fun (d : Schema.discriminator) ->
            Option.map
              (fun tags -> (d.property_name, tags))
              (tags st d.property_name members))
      in
      union_declaration st name members told_apart about
  | None -> (
      match enum raw with
      | Some values ->
          if type_name raw <> Some String then
            refuse "%s: only string enumerations are generated" name;
          enum_declaration name values about
      | None ->
          let alias held =
            Alias
              (K.Typealias
                 { about; visibility = K.Public; name; type_ = t held })
          in
          if is_string st raw then alias "String"
          else if type_name raw = Some Integer then alias "Long"
          else if type_name raw = Some Number then alias "Double"
          else if type_name raw = Some Boolean then alias "Boolean"
          else if type_name raw <> Some Object then
            refuse "%s: a schema shape the generator does not know" name
          else
            object_declaration st name ~owner
              {
                stated_properties = Option.value ~default:[] (properties raw);
                required_names = required raw;
                beside = additional raw;
              }
              about)

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

and property st owner wire n required =
  let name = Names.property_name wire in
  let type_ = type_of st owner wire n in
  let meant = meant st.spec (owner ^ "." ^ wire) n in
  let nullable = without_null (owner ^ "." ^ wire) meant <> None in
  let about = doc (description meant) in
  let boxed =
    match name_of type_ with
    | Some k -> List.mem k st.spec.identifiers
    | None -> false
  in
  let form =
    match (required, nullable, only_value meant) with
    | true, true, _ -> Stated_nullable
    | true, false, Some only -> Single only
    | true, false, None -> Required
    | false, true, _ -> Three_states
    | false, false, _ -> Optional
  in
  { wire; name; type_; about; boxed; form }

and object_declaration st name ~owner
    { stated_properties; required_names; beside } about : written =
  let open_ =
    match beside with
    | Some (Boolean_schema true) -> true
    | None | Some (Boolean_schema false) -> false
    | Some _ ->
        refuse
          "%s: properties beside additionalProperties, which the generator \
           does not know"
          name
  in
  let closed = beside = Some (Boolean_schema false) in
  match stated_properties with
  | [] when open_ ->
      Alias
        (K.Typealias
           { about; visibility = K.Public; name; type_ = t "JsonObject" })
  | [] ->
      (* An object with nothing to state is one value: the same [{}] every time. *)
      Declared
        (fun unions ->
          [
            K.class_ ?about
              ~annotations:
                (serializable
                ::
                (if closed then [] else [ K.annotation "JsonIgnoreUnknownKeys" ])
                )
              ~visibility:K.Public ~supers:(supers unions) K.Data_object name;
          ])
  | _ ->
      let props =
        List.map
          (fun (wire, s) ->
            property st (owner wire) wire (node s)
              (List.mem wire required_names))
          stated_properties
      in
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
            refuse
              "%s: a property is named build, which is its builder's last call"
              name)
        props;
      Declared
        (fun unions ->
          let rest_param =
            K.param
              ~about:
                (K.Doc "Every property the schema does not name, as it came.")
              ~annotations:[ K.annotation "Transient" ]
              ~binding:public_val ~default:empty_json_object rest
              (t "JsonObject")
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
                   (List.map declared props
                   @ if open_ then [ rest_param ] else []))
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
        match name_of p.type_ with
        | Some type_name ->
            (p.type_, Some (K.Name (type_name ^ "." ^ Names.variant_of only)))
        | None ->
            refuse "%s: a property of one value that is not an enumeration"
              p.wire)
    | Required -> (p.type_, None)
    | Three_states ->
        (K.Generic (stated, [ p.type_ ]), Some (K.Name (stated ^ ".Absent")))
    | Optional -> (K.Nullable p.type_, Some K.Null)
  in
  K.param ?about:p.about ~annotations ~binding:public_val ?default p.name type_

(* The type a builder takes it as. *)
and taken p =
  match p.form with
  | Stated_nullable | Three_states | Optional -> K.Nullable p.type_
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
      (fun p ->
        match p.form with Optional | Three_states -> true | _ -> false)
      props
  in
  let field p =
    match p.form with
    | Three_states ->
        K.property ~visibility:K.Private ~mutable_:true
          ~type_:(K.Generic (stated, [ p.type_ ]))
          ~value:(K.Same_line (K.Name (stated ^ ".Absent")))
          p.name
    | _ ->
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
        let value =
          match p.form with
          | Three_states ->
              K.If
                ( K.Binary (K.Name p.name, K.Eq, K.Null),
                  K.Name (stated ^ ".Null"),
                  K.call (K.Name (stated ^ ".Value")) [ K.Name p.name ] )
          | _ -> K.Name p.name
        in
        setter
          ~annotations:
            (if p.boxed then [ K.annotation "JvmExposeBoxed" ] else [])
          p.name (taken p) value)
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
and identifier name n =
  if type_name n <> Some String then
    refuse "%s: a kind of id that is not a string" name;
  let pattern =
    match field (fun (s : Schema.schema) -> s.pattern) n with
    | Some p -> p
    | None -> refuse "%s: a kind of id states no pattern" name
  in
  let rule = Rule.of_pattern name pattern in
  K.class_
    ?about:(doc (description n))
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

(* The value of [property] each member of a union states, when every member
   is an object that must state it, each admits one value, and no two admit
   the same. *)
and tags st property members =
  List.fold_left
    (fun found raw ->
      Option.bind found (fun found ->
          let member =
            meant st.spec property
              (match reference st.spec raw with
              | Some r -> schema st.spec r
              | None -> raw)
          in
          match Option.bind (property_node member property) only_value with
          | Some tag
            when List.mem property (required member) && not (List.mem tag found)
            ->
              Some (found @ [ tag ])
          | _ -> None))
    (Some []) members

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

and union_declaration st name members told_apart about : written =
  (* Each member: the declaration it is, and the kinds of JSON it is read from. *)
  let read = ref [] and variants = ref [] in
  let variant v decl reads =
    let type_ = name ^ "." ^ v in
    if List.mem_assoc type_ !read then
      refuse "%s: two union members would both be the variant %s" name v;
    variants := !variants @ [ decl ];
    read := !read @ [ (type_, reads) ]
  in
  let member type_ reads =
    let unions =
      Option.value ~default:[] (Hashtbl.find_opt st.unions_of type_)
    in
    if not (List.mem name unions) then
      Hashtbl.replace st.unions_of type_ (unions @ [ name ]);
    read := !read @ [ (type_, reads) ]
  in
  List.iter
    (fun m ->
      let is_empty_member =
        type_name m = Some Object
        && properties m = None
        && (max_properties m = Some 0 || is_closed m)
      in
      match reference st.spec m with
      | Some target when not (is_string st m) ->
          let type_ = named st target in
          let target_schema = schema st.spec target in
          let reads =
            if enum target_schema <> None then [ `Text ]
            else if union target_schema <> None then
              [ `Text; `Scalar; `List; `Object ]
            else [ `Object ]
          in
          if implementable st (t type_) then member type_ reads
          else
            variant type_
              (wrapped name type_ (t (types_package ^ "." ^ type_)))
              reads
      | Some target when List.mem target st.spec.identifiers ->
          let v = named st target in
          variant v
            (wrapped name target (t (identifiers_package ^ "." ^ target)))
            [ `Text ]
      | _ when is_empty_member ->
          variant "Empty"
            (K.class_ ~about:(K.Doc "The empty object.")
               ~annotations:[ serializable ] ~visibility:K.Public
               ~supers:[ K.super (t name) ]
               K.Data_object "Empty")
            [ `Object ]
      | _ when is_string st m ->
          variant "Text" (wrapped name "Text" (t "String")) [ `Text ]
      | _ when type_name m = Some Integer ->
          variant "Integer" (wrapped name "Integer" (t "Long")) [ `Scalar ]
      | _ when type_name m = Some Number ->
          variant "Number" (wrapped name "Number" (t "Double")) [ `Scalar ]
      | _ when type_name m = Some Boolean ->
          variant "Boolean" (wrapped name "Boolean" (t "Boolean")) [ `Scalar ]
      | _ when type_name m = Some Array ->
          variant "List"
            (wrapped name "List"
               (list_of (type_of st name "Item" (node_of_items name m))))
            [ `List ]
      | _ when type_name m = Some Object -> (
          (* An inline member is named by the one value its discriminant
             takes, else by its title. *)
          let type_ =
            type_of st name
              (match
                 (discriminant m, field (fun (s : Schema.schema) -> s.title) m)
               with
              | Some d, _ -> Names.pascal d
              | None, Some title -> Names.pascal title
              | None, None -> "Object")
              m
          in
          match name_of type_ with
          | Some key when implementable st type_ -> member key [ `Object ]
          | _ -> variant "Object" (wrapped name "Object" type_) [ `Object ])
      | _ -> refuse "%s: a union member the generator does not know" name)
    members;
  let read = !read and variants = !variants in
  let lazily e = K.Lambda ([], e) in
  let serializer = name ^ "Serializer" in
  let chooser =
    match told_apart with
    | Some (property, tags) ->
        K.super ~layout:K.Lines
          ~args:
            [
              K.arg (K.Class_literal name);
              K.arg (K.Str property);
              K.arg ~label:"members"
                (lazily
                   (K.call (K.Name "mapOf")
                      (List.map2
                         (fun tag (type_, _) ->
                           K.Binary (K.Str tag, K.To, serializer_of type_))
                         tags read)));
            ]
          (K.Generic (tagged_union_serializer, [ t name ]))
    | None ->
        let fits kind =
          let members =
            List.filter_map
              (fun (type_, reads) ->
                if List.mem kind reads then Some (serializer_of type_) else None)
              read
          in
          lazily
            (match members with
            | [] -> K.call (K.Name "emptyList") []
            | _ -> K.call (K.Name "listOf") members)
        in
        K.super ~layout:K.Lines
          ~args:
            [
              K.arg (K.Class_literal name);
              K.arg ~label:"strings" (fits `Text);
              K.arg ~label:"scalars" (fits `Scalar);
              K.arg ~label:"arrays" (fits `List);
              K.arg ~label:"objects" (fits `Object);
            ]
          (K.Generic (kinds_union_serializer, [ t name ]))
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
    (fun (name, _) ->
      if List.exists (fun i -> after_last_dot i = name) imported then
        refuse "%s is a schema's name, and a name the generated code imports"
          name;
      if
        List.mem name
          [
            empty_object;
            stated;
            invalid_identifier;
            kinds_union_serializer;
            tagged_union_serializer;
            wrapper_serializer;
            open_object_serializer;
          ]
      then refuse "%s is a schema's name, and one the SDK declares by hand" name)
    spec.definitions;
  let st = state spec in
  List.iter
    (fun name -> ignore (named st name))
    (List.sort compare (List.map fst spec.definitions));
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

(* The Kotlin type of the value a table's [$ref] names, named in full: a
   component schema's type, or the type of one member of a component's own
   properties. Named in full, since a schema's type may share its name with
   one Kotlin imports by default, as Annotation does. *)
let value_type_of spec ~component ~member =
  let st = state spec in
  let type_ =
    match member with
    | None -> t (named st component)
    | Some member -> (
        match property_node (schema spec component) member with
        | Some property -> type_of st component member property
        | None -> refuse "%s has no member %s" component member)
  in
  match type_ with
  | K.Type name when List.mem name spec.identifiers ->
      t (identifiers_package ^ "." ^ name)
  | K.Type name when List.mem_assoc name spec.definitions ->
      t (types_package ^ "." ^ name)
  | other -> other

(* What a file that names [type_] imports for it: the generated types and
   the JSON library's it names unqualified. *)
let rec imports_of spec = function
  | K.Type name when String.contains name '.' -> []
  | K.Type ("String" | "Boolean" | "Double" | "Long") -> []
  | K.Type (("JsonElement" | "JsonObject") as name) ->
      [ "kotlinx.serialization.json." ^ name ]
  | K.Type name when List.mem name spec.identifiers ->
      [ identifiers_package ^ "." ^ name ]
  | K.Type name -> [ types_package ^ "." ^ name ]
  | K.Generic (name, args) ->
      imports_of spec (K.Type name) @ List.concat_map (imports_of spec) args
  | K.Nullable t -> imports_of spec t
  | K.Star -> []
  | K.Function_type (params, result) ->
      List.concat_map (imports_of spec) (result :: params)
