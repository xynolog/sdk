(* Every object component the gateway's document names, as a record of the
   OCaml SDK (ocaml/sdk/lib/records.ml), and every one that is a
   discriminated union of them as a variant. An object composed by allOf is
   what its parts merge to ([Normalize]). A member that is a string, a
   boolean, an integer, a number, a string component, a string enum
   component ([Enums]) or a list of one of those is read as its OCaml type,
   and every other kept as its raw JSON, an allOf among them. One that may
   be absent or null is an option, and one that may be both a
   [Types.presence], as is a raw one that may be absent. A union's every branch is one of the records. Each
   is read from the value a [Models] descriptor accepted, through
   ocaml/sdk/lib/record_reader.ml, and written back with the members no
   read named, the descriptor holding what is written to the schema. The
   module has no interface, so each record's type is stated once.

   And every record Protocol states in a table ([Table_records]) and every
   client type the SDK generates ([Definitions.generated_client_types]), but a
   string enum ([Enums]), as the SDK builds it and hands it its callers: an
   object as a record of its members, and a union of inline branches as a
   variant, a constructor per value of its tag carrying the branch's other
   members. A member is the table record or the enum it names, a string, a
   boolean, an integer or a number, a string component as a string and any
   other as its [Models] value, or a list of one of those; one that may be
   absent, or null, is an option. Each is read from JSON and written to it
   through ocaml/sdk/lib/table_codec.ml, a read naming the first member that
   is not of its shape. *)

module O = Ocaml_syntax

let keywords =
  "and as assert begin class constraint do done downto effect else end \
   exception external false for fun function functor if in include inherit \
   initializer land lazy let lor lsl lsr lxor match method mod module mutable \
   new nonrec object of open or private rec sig struct then to true try type \
   val virtual when while with" |> String.split_on_char ' '

let field_name name =
  let label =
    String.map
      (function ('a' .. 'z' | '0' .. '9' | '_') as c -> c | _ -> '_')
      (Text.snake name)
  in
  if List.mem label keywords || label = "extra" then label ^ "_"
  else match label.[0] with 'a' .. 'z' -> label | _ -> "field" ^ label

type scalar =
  | Text
  | Bool
  | Int
  | Float
  | Enum of string  (** its module *)
  | Stated of Enums.enum  (** an enum stated in place, its module the member's *)
  | Nested of string  (** the module of the record component it names *)

type value = Scalar of scalar | List of scalar

(* A member's schema as it is read: a value, null beside it or not, or
   raw. *)
type member = Typed of { value : value; nullable : bool } | Raw_member
type 'member composed = {
  properties : (string * 'member) list;
  required : string list;
}

(* A member's scalar, an enum stated in place named [module_]. *)
let scalar_of_type ?module_ (l : Schema.t Schema.layer) =
  let stated =
    match (module_, l.enum) with
    | Some module_, Some members ->
        let values =
          List.filter_map
            (function
              | Schema.String_literal value when Enums.is_member value ->
                  Some (Enums.constructor value, value)
              | _ -> None)
            members
        in
        let constructors = List.map fst values in
        if
          values <> []
          && List.length values = List.length members
          && List.length (List.sort_uniq compare constructors)
             = List.length constructors
        then Some (Stated { Enums.module_; variants = values })
        else None
    | _ -> None
  in
  match l.type_ with
  | Some [ String ] when Option.is_some stated -> stated
  | Some [ String ] -> Some Text
  | Some [ Boolean ] -> Some Bool
  | Some [ Integer ] -> Some Int
  | Some [ Number ] -> Some Float
  | _ -> None

(* [record_of file] is the module of the record component [file] is. *)
let scalar_of ?module_ ~record_of (spec : Spec.t) (l : Schema.t Schema.layer)
    =
  match l.ref_ with
  | None -> scalar_of_type ?module_ l
  | Some r -> (
      match Decode.resolve spec.Spec.ids r with
      | file, "" -> (
          match
            (record_of file, List.assoc_opt file spec.schemas)
          with
          | Some module_, _ -> Some (Nested module_)
          | None, Some (Schema.Schema target as schema) -> (
              match Enums.component file schema with
              | Some (module_, _) -> Some (Enum module_)
              | None when target.ref_ = None -> scalar_of_type target
              | None -> None)
          | _ -> None)
      | _ -> None)

let member_of ~record_of spec name = function
  | Schema.Schema l -> (
      let module_ = String.capitalize_ascii (field_name name) in
      let typed l nullable =
        let value =
          match l with
          | { Schema.type_ = Some [ Array ]; items = Some (Schema.Schema i); _ }
            ->
              Option.map (fun s -> List s) (scalar_of ~module_ ~record_of spec i)
          | _ ->
              Option.map (fun s -> Scalar s) (scalar_of ~module_ ~record_of spec l)
        in
        match value with
        | Some value -> Typed { value; nullable }
        | None -> Raw_member
      in
      match Null_form.without_null Fun.id l with
      | Ok (Some beside) -> typed beside true
      | Ok None -> typed l false
      | Error _ -> Raw_member)
  | Schema.Boolean_schema _ -> Raw_member

exception Refused of Decode.error

(* The object a schema of [file] is, its [allOf] merged ([Normalize]), or
   none. *)
let object_shape (spec : Spec.t) ~file schema =
  let find (r : Decode.reference) =
    let target, _ = Decode.resolve spec.Spec.ids r in
    match List.assoc_opt target spec.schemas with
    | Some s -> Ok s
    | None -> Error ("$ref " ^ r.target ^ " names no schema")
  in
  match Normalize.normalize spec.Spec.ids ~find schema with
  | Error message -> raise (Refused { Decode.file; pointer = ""; message })
  | Ok { type_ = Some [ Object ]; properties; required; _ } ->
      Some
        {
          properties = Option.value ~default:[] properties;
          required = Option.value ~default:[] required;
        }
  | Ok _ -> None

(* The constructor a union's tag value names: its words in camel case,
   capitalized, or none when it has no word. *)
let variant_name tag =
  let parts =
    String.split_on_char '_'
      (String.map
         (function
           | ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9') as c -> c | _ -> '_')
         tag)
  in
  match List.filter (( <> ) "") parts with
  | [] -> None
  | first :: rest ->
      Some
        (String.capitalize_ascii
           (first ^ String.concat "" (List.map String.capitalize_ascii rest)))

type record = { name : string; file : string; shape : member composed }

type union = {
  name : string;
  property : string;
  variants : (string * string * string) list;
      (** Each tag, its constructor and its branch's module. *)
}

type base =
  | Text_base
  | Bool_base
  | Int_base
  | Float_base
  | Enum_base of string  (** its module *)
  | Record_base of string  (** its module *)
  | Model_base of string  (** its component *)
  | List_base of base

type field = {
  json : string;
  label : string;
  base : base;
  required : bool;
  nullable : bool;
}

type tabled = {
  module_ : string;
  form : form;
  needs : string list;  (** The modules of the records its members name. *)
}

and form =
  | Fields of field list
  | Map of base  (** each member's value, the member named as the caller chooses *)
  | Variants of { property : string; variants : variant list }

and variant = { tag : string; constructor : string; fields : field list }

(* The table records but the string enums, each after the ones it names. *)
let tabled (spec : Spec.t) table =
  let refuse key at message =
    let file, pointer = Enums.place key in
    raise (Refused { Decode.file; pointer = pointer ^ at; message })
  in
  let enums = Enums.tabled spec.ids table in
  let whole = Definitions.typed spec in
  let clients =
    List.filter_map
      (fun name ->
        let key = Roots.client_types ^ name ^ ".json" in
        match whole (List.assoc key spec.schemas) with
        | Ok schema when Enums.is_enum schema -> None
        | Ok schema -> Some (key, name, schema)
        | Error message -> refuse key "" message)
      (Definitions.generated_client_types spec)
  in
  let written =
    List.filter (fun (_, _, schema) -> not (Enums.is_enum schema)) table
    @ clients
  in
  let module_of key =
    List.find_map
      (fun (k, title, _) ->
        if k = key then Some (Enums.module_name title) else None)
      written
  in
  let enum_of key =
    match
      List.find_map (fun (k, m, _) -> if k = key then Some m else None) enums
    with
    | Some m -> Some m
    | None ->
        List.find_map
          (fun name ->
            if key = Roots.client_types ^ name ^ ".json" then
              Some (Enums.module_name name)
            else None)
          (Enums.client_types spec)
  in
  let component key =
    List.find_map
      (fun (name, reference) ->
        if fst (Decode.resolve spec.Spec.ids reference) = key then
          Some (name, List.assoc key spec.schemas)
        else None)
      (Roots.all spec)
  in
  (* The records of objects stated in place as members, each its owner's
     module and its member's name. *)
  let stated = ref [] in
  (* A value's type, and the module of the table record it names; an object
     stated in place is a record of its own, [named]. *)
  let rec base_of key at ~named schema =
    match schema with
      | Schema.Schema { ref_ = Some r; _ } -> (
          let target = Table_records.key spec.Spec.ids r in
          match (enum_of target, module_of target, component target) with
          | Some m, _, _ -> (Enum_base m, None)
          | None, Some m, _ -> (Record_base m, Some m)
          | ( None,
              None,
              Some (_, Schema.Schema { type_ = Some [ String ]; enum = None; _ })
            ) ->
              (Text_base, None)
          | None, None, Some (component, _) -> (Model_base component, None)
          | None, None, None ->
              refuse key at "names no schema the OCaml SDK has a type for")
      | Schema.Schema { type_ = Some [ String ]; enum = None; _ } ->
          (Text_base, None)
      | Schema.Schema { type_ = Some [ Boolean ]; _ } -> (Bool_base, None)
      | Schema.Schema { type_ = Some [ Integer ]; _ } -> (Int_base, None)
      | Schema.Schema { type_ = Some [ Number ]; _ } -> (Float_base, None)
      | Schema.Schema { type_ = Some [ Array ]; items = Some items; _ } ->
          let item, need = base_of key at ~named items in
          (List_base item, need)
      | Schema.Schema
          {
            ref_ = None;
            type_ = Some [ Object ];
            properties = Some properties;
            required;
            _;
          } ->
          let fields, needs =
            members key at ~owner:named
              ~required:(Option.value ~default:[] required)
              properties
          in
          stated := { module_ = named; form = Fields fields; needs } :: !stated;
          (Record_base named, Some named)
      | _ -> refuse key at "is no member the OCaml SDK has a type for"
  (* A member, and the module of the table record it names. *)
  and member key at ~owner ~required (name, schema) =
    let at = at ^ "/properties/" ^ Decode.escape name in
    let schema, nullable =
      match schema with
      | Schema.Schema l -> (
          match Null_form.without_null Fun.id l with
          | Ok (Some beside) -> (Schema.Schema beside, true)
          | Ok None -> (schema, false)
          | Error message -> refuse key at message)
      | Schema.Boolean_schema _ -> (schema, false)
    in
    let base, need =
      base_of key at ~named:(owner ^ "_" ^ field_name name) schema
    in
    let required = List.mem name required in
    if (not required) && nullable then refuse key at "may be both absent and null";
    ({ json = name; label = field_name name; base; required; nullable }, need)
  and members key at ~owner ~required properties =
    let typed = List.map (member key at ~owner ~required) properties in
    let labels = List.map (fun (f, _) -> f.label) typed in
    if List.length (List.sort_uniq compare labels) <> List.length labels then
      refuse key at "has two members OCaml names alike";
    (List.map fst typed, List.filter_map snd typed)
  in
  let derive (key, title, schema) =
    match schema with
    | Schema.Schema
        {
          type_ = Some [ Object ];
          properties = Some properties;
          required;
          one_of = None;
          _;
        } ->
        let module_ = Enums.module_name title in
        let fields, needs =
          members key "" ~owner:module_
            ~required:(Option.value ~default:[] required)
            properties
        in
        { module_; form = Fields fields; needs }
    | Schema.Schema
        {
          type_ = Some [ Object ];
          properties = None;
          additional_properties = Some value;
          one_of = None;
          _;
        } ->
        let module_ = Enums.module_name title in
        let base, need =
          base_of key "/additionalProperties" ~named:(module_ ^ "_value") value
        in
        { module_; form = Map base; needs = Option.to_list need }
    | Schema.Schema
        {
          discriminator = Some { property_name; mapping = None };
          one_of = Some branches;
          _;
        } ->
        let variants =
          List.mapi
            (fun i branch ->
              let at = Printf.sprintf "/oneOf/%d" i in
              match branch with
              | Schema.Schema
                  { ref_ = None; properties = Some properties; required; _ }
                -> (
                  let tag =
                    match List.assoc_opt property_name properties with
                    | Some
                        (Schema.Schema { enum = Some [ String_literal tag ]; _ })
                      ->
                        Option.map (fun c -> (tag, c)) (variant_name tag)
                    | _ -> None
                  in
                  match tag with
                  | Some (tag, constructor) ->
                      let fields, needs =
                        members key at ~owner:(Enums.module_name title)
                          ~required:(Option.value ~default:[] required)
                          (List.remove_assoc property_name properties)
                      in
                      ({ tag; constructor; fields }, needs)
                  | None ->
                      refuse key at
                        "states no one value of its tag a constructor can name")
              | _ -> refuse key at "is no object stated in place")
            branches
        in
        let constructors = List.map (fun (v, _) -> v.constructor) variants in
        if
          List.length (List.sort_uniq compare constructors)
          <> List.length constructors
        then refuse key "/oneOf" "names two variants alike";
        {
          module_ = Enums.module_name title;
          form =
            Variants
              { property = property_name; variants = List.map fst variants };
          needs = List.concat_map snd variants;
        }
    | _ -> refuse key "" "is no object, no union and no string enum"
  in
  let derived = List.map derive written in
  let derived = List.rev !stated @ derived in
  let rec after placed = function
    | [] -> List.rev placed
    | pending ->
        let ready, waiting =
          List.partition
            (fun t ->
              List.for_all
                (fun m -> List.exists (fun p -> p.module_ = m) placed)
                t.needs)
            pending
        in
        if ready = [] then
          refuse "protocol/specs/src" ""
            ("the records "
            ^ String.concat ", " (List.map (fun t -> t.module_) waiting)
            ^ " name each other")
        else after (List.rev_append ready placed) waiting
  in
  after [] derived

(* The modules a record's members name. *)
let named (r : record) =
  List.concat_map
    (function
      | _, Typed { value = Scalar (Nested m) | List (Nested m); _ } -> [ m ]
      | _ -> [])
    r.shape.properties

(* Each record with its members typed, each after the records it names. A
   member that names a record naming it back, itself or through others, is
   kept raw, so no two records name each other. *)
let ordered spec ~record_of shapes =
  let typed =
    List.map
      (fun (name, file, (shape : Schema.t composed)) ->
        {
          name;
          file;
          shape =
            {
              shape with
              properties =
                List.map
                  (fun (n, m) -> (n, member_of ~record_of spec n m))
                  shape.properties;
            };
        })
      shapes
  in
  let by_module = Hashtbl.create 1024 in
  List.iter
    (fun (r : record) -> Hashtbl.replace by_module (Enums.module_name r.name) r)
    typed;
  let names m = named (Hashtbl.find by_module m) in
  let reaches from target =
    let seen = Hashtbl.create 64 in
    let rec go m =
      m = target
      || (not (Hashtbl.mem seen m))
         && (Hashtbl.replace seen m ();
             List.exists go (names m))
    in
    List.exists go (names from)
  in
  let acyclic =
    List.map
      (fun (r : record) ->
        let m = Enums.module_name r.name in
        {
          r with
          shape =
            {
              r.shape with
              properties =
                List.map
                  (function
                    | ( n,
                        Typed { value = Scalar (Nested t) | List (Nested t); _ }
                      )
                      when t = m || reaches t m ->
                        (n, Raw_member)
                    | member -> member)
                  r.shape.properties;
            };
        })
      typed
  in
  let rec after placed = function
    | [] -> List.rev placed
    | pending ->
        let ready, waiting =
          List.partition
            (fun r ->
              List.for_all
                (fun m ->
                  List.exists
                    (fun (p : record) -> Enums.module_name p.name = m)
                    placed)
                (named r))
            pending
        in
        if ready = [] then
          raise
            (Refused
               {
                 Decode.file = "protocol/specs/src";
                 pointer = "";
                 message = "the component records name each other";
               })
        else after (List.rev_append ready placed) waiting
  in
  after [] acyclic

let derive (spec : Spec.t) table =
  try
    let components =
      List.map
        (fun (name, reference) ->
          let file, _ = Decode.resolve spec.Spec.ids reference in
          (name, file, List.assoc file spec.schemas))
        (Roots.all spec)
    in
    let shapes =
      List.filter_map
        (fun (name, file, schema) ->
          match object_shape spec ~file schema with
          | Some shape when shape.properties <> [] -> Some (name, file, shape)
          | _ -> None)
        components
    in
    let module_of file =
      List.find_map
        (fun (name, f, _) ->
          if f = file then Some (Enums.module_name name) else None)
        shapes
    in
    let records = ordered spec ~record_of:module_of shapes in
    let refuse file pointer message =
      raise (Refused { Decode.file; pointer; message })
    in
    let unions =
      List.filter_map
        (fun (name, file, schema) ->
          match schema with
          | Schema.Schema
              {
                discriminator = Some { property_name; mapping };
                one_of = Some branches;
                _;
              } ->
              List.iter
                (function
                  | Schema.Schema { ref_ = Some r; _ }
                    when Option.is_some
                           (module_of (fst (Decode.resolve spec.Spec.ids r))) ->
                      ()
                  | _ ->
                      refuse file "/oneOf"
                        "has a branch that is no record of the SDK's")
                branches;
              let variants =
                List.map
                  (fun (tag, target) ->
                    let branch, _ =
                      Decode.resolve spec.Spec.ids
                        { Decode.target; file; pointer = "/discriminator" }
                    in
                    match (module_of branch, variant_name tag) with
                    | Some m, Some c -> (tag, c, m)
                    | _ ->
                        refuse file
                          ("/discriminator/mapping/" ^ Decode.escape tag)
                          "names no record of the SDK's")
                  (Option.value ~default:[] mapping)
              in
              let constructors = List.map (fun (_, c, _) -> c) variants in
              if
                List.length (List.sort_uniq compare constructors)
                <> List.length constructors
              then
                refuse file "/discriminator/mapping" "names two variants alike";
              Some { name; property = property_name; variants }
          | _ -> None)
        components
    in
    List.iter
      (fun (r : record) ->
        let labels = List.map (fun (n, _) -> field_name n) r.shape.properties in
        if List.length (List.sort_uniq compare labels) <> List.length labels
        then refuse r.file "/properties" "has two members OCaml names alike")
      records;
    let tabled = tabled spec table in
    let modules =
      List.map (fun (r : record) -> Enums.module_name r.name) records
      @ List.map (fun (u : union) -> Enums.module_name u.name) unions
      @ List.map (fun t -> t.module_) tabled
    in
    if List.length (List.sort_uniq compare modules) <> List.length modules then
      refuse "protocol/specs/src" "" "names two records one module";
    Ok (records, unions, tabled)
  with Refused e -> Error [ e ]

(* [let of_model (model : [ `Kind ] Models.t) = body]. *)
let of_model kind body =
  O.let_ "of_model"
    (O.fun_
       [
         O.Pattern.constraint_ (O.Pattern.var "model")
           (O.type_ "Models.t" ~args:[ O.tags [ kind ] ]);
       ]
       body)

let model_fields =
  O.call "fields_of" [ O.call "Models.json" [ O.ident "model" ] ]

(* The [Models] descriptor of the schema named [name]. *)
let descriptor name = O.ident ("Models." ^ Text.snake name)

(* [let to_model value = Models.decode descriptor (encoded value)]. *)
let to_model name =
  O.define "to_model" [ "value" ]
    (O.call "Models.decode"
       [
         descriptor name;
         O.call "Yojson.Raw.to_string" [ O.call "to_json" [ O.ident "value" ] ];
       ])

let scalar_type = function
  | Text -> O.type_ "string"
  | Bool -> O.type_ "bool"
  | Int -> O.type_ "int"
  | Float -> O.type_ "float"
  | Enum m -> O.type_ ("Enums." ^ m ^ ".t")
  | Stated e -> O.type_ (e.module_ ^ ".t")
  | Nested m -> O.type_ (m ^ ".t")

let scalar_reader = function
  | Text -> O.ident "string"
  | Bool -> O.ident "bool"
  | Int -> O.ident "int"
  | Float -> O.ident "float"
  | Enum m -> O.call "enum" [ O.ident ("Enums." ^ m ^ ".of_string") ]
  | Stated e -> O.call "enum" [ O.ident (e.module_ ^ ".of_string") ]
  | Nested m -> O.call "record" [ O.ident (m ^ ".project") ]

let scalar_writer = function
  | Text -> O.ident "json_string"
  | Bool -> O.ident "json_bool"
  | Int -> O.ident "json_int"
  | Float -> O.ident "json_float"
  | Enum m -> O.call "json_enum" [ O.ident ("Enums." ^ m ^ ".to_string") ]
  | Stated e -> O.call "json_enum" [ O.ident (e.module_ ^ ".to_string") ]
  | Nested m -> O.ident (m ^ ".to_json")

(* The enums [member] states in place. *)
let stated = function
  | Typed { value = Scalar (Stated e) | List (Stated e); _ } -> [ e ]
  | _ -> []

(* How a component's member is held: always present, an option when it may
   be absent, or a [Types.presence] when it may be absent and may be null
   (a raw one may always be null). *)
type presence = Always | Maybe | Presence

(* A component's member: how it is held, its type, its reader and its
   writer. *)
let component_member ~optional member =
  match member with
  | Raw_member ->
      ( (if optional then Presence else Always),
        O.type_ "Yojson.Raw.t",
        O.ident "raw",
        O.ident "json_raw" )
  | Typed { value; nullable } ->
      let type_, read, write =
        match value with
        | Scalar s -> (scalar_type s, scalar_reader s, scalar_writer s)
        | List s ->
            ( O.type_ "list" ~args:[ scalar_type s ],
              O.call "list" [ scalar_reader s ],
              O.call "json_list" [ scalar_writer s ] )
      in
      if not optional then
        if nullable then
          ( Always,
            O.type_ "option" ~args:[ type_ ],
            O.call "nullable" [ read ],
            O.call "json_nullable" [ write ] )
        else (Always, type_, read, write)
      else ((if nullable then Presence else Maybe), type_, read, write)

let rec base_type = function
  | Text_base -> O.type_ "string"
  | Bool_base -> O.type_ "bool"
  | Int_base -> O.type_ "int"
  | Float_base -> O.type_ "float"
  | Enum_base m -> O.type_ ("Enums." ^ m ^ ".t")
  | Record_base m -> O.type_ (m ^ ".t")
  | Model_base c -> O.type_ "Models.t" ~args:[ O.tags [ c ] ]
  | List_base b -> O.type_ "list" ~args:[ base_type b ]

let rec base_reader = function
  | Text_base -> O.ident "string"
  | Bool_base -> O.ident "bool"
  | Int_base -> O.ident "int"
  | Float_base -> O.ident "float"
  | Enum_base m -> O.call "enum" [ O.ident ("Enums." ^ m ^ ".of_string") ]
  | Record_base m -> O.call "record" [ O.ident (m ^ ".of_json") ]
  | Model_base c -> O.call "model" [ descriptor c ]
  | List_base b -> O.call "list" [ base_reader b ]

let rec base_writer = function
  | Text_base -> O.ident "json_string"
  | Bool_base -> O.ident "json_bool"
  | Int_base -> O.ident "json_int"
  | Float_base -> O.ident "json_float"
  | Enum_base m -> O.call "json_enum" [ O.ident ("Enums." ^ m ^ ".to_string") ]
  | Record_base m -> O.ident (m ^ ".to_json")
  | Model_base _ -> O.ident "json_model"
  | List_base b -> O.call "json_list" [ base_writer b ]

let field_type f =
  if f.required && not f.nullable then base_type f.base
  else O.type_ "option" ~args:[ base_type f.base ]

(* The names a table record's reader binds or calls, which no member's label
   may shadow. *)
let codec_names =
  [
    "members"; "tag"; "string"; "bool"; "int"; "float"; "enum"; "record";
    "model"; "list"; "map"; "nullable"; "required"; "optional"; "malformed";
    "write";
  ]

(* [let* label = read member members in body] for each of [fields], and
   then [body]. *)
let read_fields module_ fields body =
  List.fold_right
    (fun f body ->
      if List.mem f.label codec_names then
        invalid_arg
          (module_ ^ "'s member " ^ f.json ^ " is named as its reader's own "
         ^ f.label);
      let read = base_reader f.base in
      let read =
        if f.required then
          O.call "required"
            [
              (if f.nullable then O.call "nullable" [ read ] else read);
              O.string f.json;
              O.ident "members";
            ]
        else O.call "optional" [ read; O.string f.json; O.ident "members" ]
      in
      O.let_star (O.Pattern.var f.label) read body)
    fields body

(* Each of [fields] of [value] as [write] states it. *)
let written_fields value fields =
  List.map
    (fun f ->
      let member = O.field value f.label in
      let write = base_writer f.base in
      O.tuple
        [
          O.string f.json;
          (if f.required && not f.nullable then
             O.some (O.apply write [ member ])
           else if f.required then
             O.some (O.call "json_nullable" [ write; member ])
           else O.call "Option.map" [ write; member ]);
        ])
    fields

let files (records, unions, tabled) =
  let record (r : record) =
    let fields =
      List.map
        (fun (name, m) ->
          let optional = not (List.mem name r.shape.required) in
          let held, type_, read, write = component_member ~optional m in
          ( name,
            field_name name,
            read,
            write,
            held,
            match held with
            | Always -> type_
            | Maybe -> O.type_ "option" ~args:[ type_ ]
            | Presence -> O.type_ "Types.presence" ~args:[ type_ ] ))
        r.shape.properties
    in
    let m = Enums.module_name r.name in
    let t =
      O.type_declaration "t"
        (Record
           (List.map (fun (_, label, _, _, _, t) -> (label, t)) fields
           @ [
               ( "extra",
                 O.type_ "list"
                   ~args:
                     [
                       O.type_tuple [ O.type_ "string"; O.type_ "Yojson.Raw.t" ];
                     ] );
             ]))
    in
    (* A record's fields are evaluated in no stated order, so the members no
       read named are taken once the record is built. *)
    let project =
      O.define "project" [ "fields" ]
        (O.let_in "reader"
           (O.call "start" [ O.ident "fields" ])
           (O.let_in "record"
              (O.record
                 (List.map
                    (fun (name, label, read, _, held, _) ->
                      ( label,
                        O.call
                          (match held with
                          | Always -> "required"
                          | Maybe -> "maybe"
                          | Presence -> "optional")
                          [ O.ident "reader"; read; O.string name ] ))
                    fields
                 @ [ ("extra", O.list []) ]))
              (O.record ~with_:(O.ident "record")
                 [ ("extra", O.call "rest" [ O.ident "reader" ]) ])))
    in
    let value = O.ident "value" in
    let to_json =
      O.let_ "to_json"
        (O.fun_
           [ O.Pattern.constraint_ (O.Pattern.var "value") (O.type_ "t") ]
           (O.call "write"
              [
                O.list
                  (List.map
                     (fun (name, label, _, write, held, _) ->
                       let member = O.field value label in
                       O.tuple
                         [
                           O.string name;
                           (match held with
                           | Always -> O.some (O.apply write [ member ])
                           | Maybe -> O.call "Option.map" [ write; member ]
                           | Presence -> O.call "present" [ write; member ]);
                         ])
                     fields);
                O.field value "extra";
              ]))
    in
    O.module_ m
      (List.map Enums.impl
         (List.concat_map (fun (_, member) -> stated member) r.shape.properties)
      @ [
        O.type_item t;
        project;
        of_model r.name (O.call "project" [ model_fields ]);
        to_json;
        to_model r.name;
      ])
  in
  let union u =
    let m = Enums.module_name u.name in
    let t =
      O.type_declaration "t"
        (Variant
           (List.map
              (fun (_, c, branch) ->
                O.constructor c ~args:[ O.type_ (branch ^ ".t") ])
              u.variants))
    in
    let literal = O.variant "Stringlit" ~arg:(O.ident "literal") in
    let of_model =
      of_model u.name
        (O.let_in "fields" model_fields
           (O.match_
              (O.call "List.assoc_opt"
                 [ O.string u.property; O.ident "fields" ])
              [
                O.case
                  (O.Pattern.construct "Some"
                     ~arg:
                       (O.Pattern.variant "Stringlit"
                          ~arg:(O.Pattern.var "literal")))
                  (O.match_
                     (O.call "string" [ literal ])
                     (List.map
                        (fun (tag, c, branch) ->
                          O.case (O.Pattern.string tag)
                            (O.some
                               (O.construct c
                                  ~arg:
                                    (O.call (branch ^ ".project")
                                       [ O.ident "fields" ]))))
                        u.variants
                     @ [ O.case O.Pattern.any O.none ]));
                O.case O.Pattern.any O.none;
              ]))
    in
    let to_json =
      O.let_ "to_json"
        (O.function_
           (List.map
              (fun (_, c, branch) ->
                O.case
                  (O.Pattern.construct c ~arg:(O.Pattern.var "value"))
                  (O.call (branch ^ ".to_json") [ O.ident "value" ]))
              u.variants))
    in
    O.module_ m [ O.type_item t; of_model; to_json; to_model u.name ]
  in
  let table t =
    let declaration =
      match t.form with
      | Fields fields ->
          O.type_declaration "t"
            (O.Record (List.map (fun f -> (f.label, field_type f)) fields))
      | Map base ->
          O.type_declaration "t" O.Abstract
            ~manifest:
              (O.type_ "list"
                 ~args:[ O.type_tuple [ O.type_ "string"; base_type base ] ])
      | Variants { variants; _ } ->
          O.type_declaration "t"
            (Variant
               (List.map
                  (fun v ->
                    if v.fields = [] then O.constructor v.constructor
                    else
                      O.record_constructor v.constructor
                        (List.map (fun f -> (f.label, field_type f)) v.fields))
                  variants))
    in
    let built constructor fields =
      let record = O.record (List.map (fun f -> (f.label, O.ident f.label)) fields) in
      O.construct "Ok"
        ~arg:
          (match constructor with
          | None -> record
          | Some c when fields = [] -> O.construct c
          | Some c -> O.construct c ~arg:record)
    in
    let read =
      match t.form with
      | Fields fields -> read_fields t.module_ fields (built None fields)
      | Map base -> O.call "map" [ base_reader base; O.ident "members" ]
      | Variants { property; variants } ->
          O.let_star (O.Pattern.var "tag")
            (O.call "required"
               [ O.ident "string"; O.string property; O.ident "members" ])
            (O.match_ (O.ident "tag")
               (List.map
                  (fun v ->
                    O.case (O.Pattern.string v.tag)
                      (read_fields t.module_ v.fields
                         (built (Some v.constructor) v.fields)))
                  variants
               @ [ O.case O.Pattern.any (O.call "malformed" [ O.string property ]) ]))
    in
    let json = O.type_ "Yojson.Safe.t" in
    let of_json =
      O.let_ "of_json"
        ~type_:
          (O.arrow json
             (O.type_ "result" ~args:[ O.type_ "t"; O.type_ "Models.fault" ]))
        (O.open_in "Table_codec"
           (O.function_
              [
                O.case
                  (O.Pattern.variant "Assoc" ~arg:(O.Pattern.var "members"))
                  read;
                O.case O.Pattern.any (O.call "malformed" [ O.string "" ]);
              ]))
    in
    let value = O.ident "value" in
    let to_json =
      O.let_ "to_json"
        ~type_:(O.arrow (O.type_ "t") json)
        (O.open_in "Table_codec"
           (match t.form with
           | Fields fields ->
               O.fun_ [ O.Pattern.var "value" ]
                 (O.call "write" [ O.list (written_fields value fields) ])
           | Map base -> O.call "json_map" [ base_writer base ]
           | Variants { property; variants } ->
               O.function_
                 (List.map
                    (fun v ->
                      let tag =
                        O.tuple
                          [
                            O.string property;
                            O.some (O.call "json_string" [ O.string v.tag ]);
                          ]
                      in
                      if v.fields = [] then
                        O.case
                          (O.Pattern.construct v.constructor)
                          (O.call "write" [ O.list [ tag ] ])
                      else
                        O.case
                          (O.Pattern.construct v.constructor
                             ~arg:(O.Pattern.var "value"))
                          (O.call "write"
                             [ O.list (tag :: written_fields value v.fields) ]))
                    variants)))
    in
    O.module_ t.module_
      [ O.type_item declaration; of_json; to_json ]
  in
  let entries =
    List.map record records @ List.map union unions @ List.map table tabled
  in
  let banner =
    Banner.ocaml
      ~from_:
        "OpenAPI object components and discriminator mappings, and the records \
         of Protocol's tables"
      __FILE__
  in
  [
    O.implementation ~path:"ocaml/sdk/lib/records.ml" ~banner
      (O.open_ "Record_reader" :: entries);
  ]
