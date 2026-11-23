(* Every object component the gateway's document names, as a record of the
   OCaml SDK (ocaml/sdk/lib/records.ml), and every one that is a
   discriminated union of them as a variant. An object composed by allOf is
   what its parts merge to ([Normalize]); a string or a boolean member is
   read as one, and every other kept as its raw JSON, numbers exactly, an
   allOf among them. A union's every branch is one of the records.
   Records are read through ocaml/sdk/lib/record_reader.ml, and the module
   has no interface, so each record's type is stated once.

   And every record Protocol states in a table ([Table_records]) and every
   client type the SDK generates ([Definitions.generated_client_types]), but a
   string enum ([Enums]), as the SDK builds it and hands it its callers: an
   object as a record of its members, and a union of inline branches as a
   variant, a constructor per value of its tag carrying the branch's other
   members. A member is the table record or the enum it names, a string, a
   boolean, an integer or a number, a string component as a string and any
   other as its [Models] value, or a list of one of those; one that may be
   absent, or null, is an option. *)

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

(* A member's schema as it is read: a string or a boolean, or raw. *)
type member = Text_member | Bool_member | Raw_member
type composed = { properties : (string * member) list; required : string list }

let member_of = function
  | Schema.Schema { type_ = Some [ String ]; _ } -> Text_member
  | Schema.Schema { type_ = Some [ Boolean ]; _ } -> Bool_member
  | _ -> Raw_member

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
          properties =
            List.map
              (fun (n, m) -> (n, member_of m))
              (Option.value ~default:[] properties);
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

type record = { name : string; file : string; shape : composed }

type union = {
  name : string;
  property : string;
  variants : (string * string * string) list;
      (** Each tag, its constructor and its branch's module. *)
}

type tabled = {
  module_ : string;
  form : form;
  needs : string list;  (** The modules of the records its members name. *)
}

and form =
  | Fields of (string * Parsetree.core_type) list
  | Variants of (string * (string * Parsetree.core_type) list) list
      (** Each constructor, and the members its branch carries. *)

(* The table records but the string enums, each after the ones it names. *)
let tabled (spec : Spec.t) table =
  let refuse key at message =
    let file, pointer = Enums.place key in
    raise (Refused { Decode.file; pointer = pointer ^ at; message })
  in
  let enums = Enums.tabled spec.ids table in
  let whole = Definitions.whole spec in
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
  (* A member's type, and the module of the table record it names. *)
  let member key at ~required (name, schema) =
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
    let rec base_of schema =
      match schema with
      | Schema.Schema { ref_ = Some r; _ } -> (
          let target = Table_records.key spec.Spec.ids r in
          match (enum_of target, module_of target, component target) with
          | Some m, _, _ -> (O.type_ ("Enums." ^ m ^ ".t"), None)
          | None, Some m, _ -> (O.type_ (m ^ ".t"), Some m)
          | ( None,
              None,
              Some (_, Schema.Schema { type_ = Some [ String ]; enum = None; _ })
            ) ->
              (O.type_ "string", None)
          | None, None, Some (component, _) ->
              (O.type_ "Models.t" ~args:[ O.tags [ component ] ], None)
          | None, None, None ->
              refuse key at "names no schema the OCaml SDK has a type for")
      | Schema.Schema { type_ = Some [ String ]; enum = None; _ } ->
          (O.type_ "string", None)
      | Schema.Schema { type_ = Some [ Boolean ]; _ } -> (O.type_ "bool", None)
      | Schema.Schema { type_ = Some [ Integer ]; _ } -> (O.type_ "int", None)
      | Schema.Schema { type_ = Some [ Number ]; _ } -> (O.type_ "float", None)
      | Schema.Schema { type_ = Some [ Array ]; items = Some items; _ } ->
          let item, need = base_of items in
          (O.type_ "list" ~args:[ item ], need)
      | _ -> refuse key at "is no member the OCaml SDK has a type for"
    in
    let base, need = base_of schema in
    let type_ =
      match (List.mem name required, nullable) with
      | true, false -> base
      | true, true | false, false -> O.type_ "option" ~args:[ base ]
      | false, true -> refuse key at "may be both absent and null"
    in
    ((field_name name, type_), need)
  in
  let members key at ~required properties =
    let typed = List.map (member key at ~required) properties in
    let labels = List.map (fun ((label, _), _) -> label) typed in
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
        let fields, needs =
          members key ""
            ~required:(Option.value ~default:[] required)
            properties
        in
        { module_ = Enums.module_name title; form = Fields fields; needs }
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
                        variant_name tag
                    | _ -> None
                  in
                  match tag with
                  | Some c ->
                      let fields, needs =
                        members key at
                          ~required:(Option.value ~default:[] required)
                          (List.remove_assoc property_name properties)
                      in
                      ((c, fields), needs)
                  | None ->
                      refuse key at
                        "states no one value of its tag a constructor can name")
              | _ -> refuse key at "is no object stated in place")
            branches
        in
        let constructors = List.map (fun ((c, _), _) -> c) variants in
        if
          List.length (List.sort_uniq compare constructors)
          <> List.length constructors
        then refuse key "/oneOf" "names two variants alike";
        {
          module_ = Enums.module_name title;
          form = Variants (List.map fst variants);
          needs = List.concat_map snd variants;
        }
    | _ -> refuse key "" "is no object, no union and no string enum"
  in
  let derived = List.map derive written in
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

let derive (spec : Spec.t) table =
  try
    let components =
      List.map
        (fun (name, reference) ->
          let file, _ = Decode.resolve spec.Spec.ids reference in
          (name, file, List.assoc file spec.schemas))
        (Roots.all spec)
    in
    let records =
      List.filter_map
        (fun (name, file, schema) ->
          match object_shape spec ~file schema with
          | Some shape when shape.properties <> [] -> Some { name; file; shape }
          | _ -> None)
        components
    in
    let module_of file =
      Option.map
        (fun (r : record) -> Enums.module_name r.name)
        (List.find_opt (fun (r : record) -> r.file = file) records)
    in
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

let files (records, unions, tabled) =
  let record (r : record) =
    let fields =
      List.map
        (fun (name, m) ->
          let type_, read =
            match m with
            | Text_member -> ("string", "string")
            | Bool_member -> ("bool", "bool")
            | Raw_member -> ("Yojson.Raw.t", "raw")
          in
          let optional = not (List.mem name r.shape.required) in
          ( name,
            field_name name,
            read,
            optional,
            if optional then O.type_ "Types.presence" ~args:[ O.type_ type_ ]
            else O.type_ type_ ))
        r.shape.properties
    in
    let m = Enums.module_name r.name in
    let t =
      O.type_declaration "t"
        (Record
           (List.map (fun (_, label, _, _, t) -> (label, t)) fields
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
                    (fun (name, label, read, optional, _) ->
                      ( label,
                        O.call
                          (if optional then "optional" else "required")
                          [ O.ident "reader"; O.ident read; O.string name ] ))
                    fields
                 @ [ ("extra", O.list []) ]))
              (O.record ~with_:(O.ident "record")
                 [ ("extra", O.call "rest" [ O.ident "reader" ]) ])))
    in
    O.module_ m
      [
        O.type_item t;
        project;
        of_model r.name (O.call "project" [ model_fields ]);
      ]
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
    O.module_ m [ O.type_item t; of_model ]
  in
  let table t =
    let kind =
      match t.form with
      | Fields fields -> O.Record fields
      | Variants variants ->
          Variant
            (List.map
               (fun (c, fields) ->
                 if fields = [] then O.constructor c
                 else O.record_constructor c fields)
               variants)
    in
    O.module_ t.module_ [ O.type_item (O.type_declaration "t" kind) ]
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
