(* Every record and union Protocol roots, and every record and union their
   members reach, as a module of the OCaml SDK (ocaml/sdk/lib/records.ml),
   each read from its declaration in [Typing]. A record holds the members it
   names, in its schema's order, each as its OCaml type: a string, a boolean,
   an integer, a number, a string enum ([Enums], or one stated in place, a
   module of the record's own), the record or union it names, the table
   record it names, a list or a map of one of those, and its raw JSON only
   where Typing gives it no type. One that may be absent or null is an
   option, and one that may be both a [Types.presence], as is a raw one that
   may be absent. A union whose every member is a record Protocol roots and
   that a tag tells apart is a constructor per value of its tag; any other is
   a constructor per member, read as the first member whose signature admits
   the value. Each is read from the value a [Models] descriptor accepted,
   through ocaml/sdk/lib/record_reader.ml, and written back with the members
   no read named, the descriptor holding what is written to the schema. The
   module has no interface, so each record's type is stated once. Where it
   reads a member otherwise than [Typing] does, it is [Deviations].

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

module T = Typing

(* How a value is held. *)
type held =
  | Text
  | Bool
  | Int
  | Float
  | Enum of string  (** its module of [Enums] *)
  | Stated of Enums.enum
      (** an enum stated in place, its module its holder's *)
  | Record of string  (** the module of the record it is *)
  | Union of string  (** the module of the union it is *)
  | Tabled of string  (** the module of the table record it is *)
  | List_of of held
  | Map_of of held  (** each member's value, the member named as it is *)
  | Nullable of held  (** null, or the value *)
  | Raw  (** its JSON, numbers exactly: a schema that constrains nothing *)

(* A record's member: what its schema states, how its value is held, and
   whether it may be null. *)
type held_member = { member : T.member; held : held; nullable : bool }

(* A union's member: what Typing states of it, and how its value is held. *)
type held_branch = { branch : T.branch; held : held }

(* A module of records.ml: a record of [field]s, a union told apart by a
   tag, a constructor per value of it, each its branch record's module, or
   a union told apart by what each member admits. [name] is the schema
   [Models] has a descriptor of. *)
type entry = {
  module_ : string;
  name : string option;
  file : string;
  shape : shape;
}

and shape =
  | Object of held_member list
  | Tagged of { property : string; variants : (string * string * string) list }
      (** Each tag, its constructor and its branch's module. *)
  | Members of held_branch list

exception Refused of Decode.error

let refuse file pointer message =
  raise (Refused { Decode.file; pointer; message })

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

let scalar_of (s : T.scalar) =
  match s with
  | Text _ -> Text
  | Boolean -> Bool
  | Integer _ -> Int
  | Number -> Float

(* An enum stated in place, named [module_], when each of its values names a
   constructor and no two name one. *)
let stated_enum module_ values =
  let variants =
    List.filter_map
      (function
        | Schema.String_literal value when Enums.is_member value ->
            Some (Enums.constructor value, value)
        | _ -> None)
      values
  in
  let constructors = List.map fst variants in
  if
    variants <> []
    && List.length variants = List.length values
    && List.length (List.sort_uniq compare constructors)
       = List.length constructors
  then Some { Enums.module_; variants }
  else None

(* The modules a value held so names. *)
let rec modules_of = function
  | Record m | Union m -> [ m ]
  | List_of h | Map_of h | Nullable h -> modules_of h
  | Text | Bool | Int | Float | Enum _ | Stated _ | Tabled _ | Raw -> []

(* The enums a value held so states in place. *)
let rec stated_of = function
  | Stated e -> [ e ]
  | List_of h | Map_of h | Nullable h -> stated_of h
  | Text | Bool | Int | Float | Enum _ | Record _ | Union _ | Tabled _ | Raw ->
      []

let depends (e : entry) =
  match e.shape with
  | Object fields ->
      List.concat_map (fun (f : held_member) -> modules_of f.held) fields
  | Tagged { variants; _ } -> List.map (fun (_, _, m) -> m) variants
  | Members branches ->
      List.concat_map (fun (b : held_branch) -> modules_of b.held) branches

(* Each entry after the ones it names; refused if two name each other. *)
let ordered entries =
  let rec after placed = function
    | [] -> List.rev placed
    | pending ->
        let ready, waiting =
          List.partition
            (fun e ->
              List.for_all
                (fun m -> List.exists (fun p -> p.module_ = m) placed)
                (depends e))
            pending
        in
        if ready = [] then
          refuse "protocol/specs/src" ""
            ("the records "
            ^ String.concat ", " (List.map (fun e -> e.module_) waiting)
            ^ " name each other")
        else after (List.rev_append ready placed) waiting
  in
  after [] entries

(* Every component Protocol roots that is a record or a union, and every
   record and union their members reach, each a module: [tabled] the
   module of a table record by its name, [enum_of] the module of a string
   enum of [Enums] by its name. *)
let components spec (typing : T.t) ~tabled ~enum_of =
  let roots =
    List.map
      (fun (name, reference) ->
        (name, fst (Decode.resolve spec.Spec.ids reference)))
      (Roots.all spec)
  in
  let rooted name = List.mem_assoc name roots in
  let found = Hashtbl.create 512 in
  let discovered = ref [] in
  let record_form name =
    match (typing.find name).form with
    | T.Record { members = _ :: _ as members; _ } -> Some members
    | _ -> None
  in
  (* A rooted union told apart by its tag, each of whose members is a record
     of its own. *)
  let tagged name =
    match if rooted name then Some (typing.find name).form else None with
    | Some (T.Union { tag = Some { property; values }; branches })
      when List.for_all
             (fun (b : T.branch) ->
               match b.ty with
               | T.Named branch -> record_form branch <> None
               | _ -> false)
             branches ->
        Some (property, values, branches)
    | _ -> None
  in
  let rec held_of ~stated_in ~const (ty : T.ty) =
    match ty with
    | T.Scalar s -> scalar_of s
    | T.Nullable ty -> Nullable (held_of ~stated_in ~const ty)
    | T.List (Some ty) -> List_of (held_of ~stated_in ~const ty)
    | T.List None -> List_of Raw
    | T.Named name -> named ~const name
    | T.Inline i -> inline ~stated_in ~const i
    | T.Null | T.Any | T.Nothing -> Raw
  and named ~const name =
    let module_ = Enums.module_name name in
    let file = Option.value (List.assoc_opt name roots) ~default:name in
    match (tabled name, enum_of name, (typing.find name).form) with
    | Some m, _, _ -> Tabled m
    | None, Some m, _ -> Enum m
    | None, None, T.Record { members = _ :: _ as members; _ } ->
        record ~module_ ~name ~file members;
        Record module_
    | None, None, T.Union u when Deviations.text_union u -> Text
    | None, None, T.Union u ->
        union ~module_ ~name ~file u;
        Union module_
    | None, None, T.Enum { base = Some (T.Text _); _ }
      when rooted name && not const ->
        Enum module_
    | None, None, T.Enum { base = Some s; _ } -> scalar_of s
    | None, None, T.Alias ty -> held_of ~stated_in:module_ ~const ty
    | None, None, T.Identifier _ -> Text
    | None, None, T.Map { value; _ } ->
        Map_of (held_of ~stated_in:module_ ~const:false value)
    | None, None, (T.Empty _ | T.Json | T.Enum { base = None; _ }) -> Raw
    | None, None, T.Record { members = []; _ } -> Raw
  and inline ~stated_in ~const (i : T.inline) =
    let module_ = Enums.module_name i.name in
    match i.form with
    | T.Record { members = _ :: _ as members; _ } ->
        record ~module_ ~name:i.name ~file:i.place.owner members;
        Record module_
    | T.Union u when Deviations.text_union u -> Text
    | T.Union u ->
        union ~module_ ~name:i.name ~file:i.place.owner u;
        Union module_
    | T.Enum { base = Some (T.Text _); values } when not const -> (
        match stated_enum stated_in values with
        | Some e -> Stated e
        | None -> Text)
    | T.Enum { base = Some s; _ } -> scalar_of s
    | T.Map { value; _ } -> Map_of (held_of ~stated_in ~const:false value)
    (* Deviations: an object in place that names no member and says nothing
       of others holds whatever members it is given. *)
    | T.Empty _ -> Map_of Raw
    | T.Alias ty -> held_of ~stated_in ~const ty
    | T.Identifier _ -> Text
    | T.Json | T.Enum { base = None; _ } | T.Record { members = []; _ } -> Raw
  and declare module_ build =
    if not (Hashtbl.mem found module_) then (
      Hashtbl.replace found module_ None;
      let e = build () in
      Hashtbl.replace found module_ (Some e);
      discovered := e :: !discovered)
  and record ~module_ ~name ~file members =
    declare module_ (fun () ->
        let fields =
          List.map
            (fun (m : T.member) ->
              let const =
                rooted name && Deviations.ocaml_const spec ~file m.wire
              in
              let stated_in = String.capitalize_ascii (field_name m.wire) in
              let ty, nullable =
                match m.ty with T.Nullable ty -> (ty, true) | ty -> (ty, false)
              in
              { member = m; held = held_of ~stated_in ~const ty; nullable })
            members
        in
        let labels = List.map (fun f -> field_name f.member.wire) fields in
        if List.length (List.sort_uniq compare labels) <> List.length labels
        then refuse file "/properties" "has two members OCaml names alike";
        {
          module_;
          name = (if rooted name then Some name else None);
          file;
          shape = Object fields;
        })
  and union ~module_ ~name ~file (u : T.union) =
    declare module_ (fun () ->
        match tagged name with
        | Some (property, values, branches) ->
            let variants =
              List.concat
                (List.map2
                   (fun (b : T.branch) tags ->
                     let branch =
                       match b.ty with
                       | T.Named branch -> branch
                       | _ -> assert false
                     in
                     ignore (named ~const:false branch);
                     List.map
                       (fun tag ->
                         match variant_name tag with
                         | Some c -> (tag, c, Enums.module_name branch)
                         | None ->
                             refuse file
                               ("/discriminator/mapping/" ^ Decode.escape tag)
                               "names no record of the SDK's")
                       tags)
                   branches values)
            in
            let constructors = List.map (fun (_, c, _) -> c) variants in
            if
              List.length (List.sort_uniq compare constructors)
              <> List.length constructors
            then refuse file "/discriminator/mapping" "names two variants alike";
            {
              module_;
              name = Some name;
              file;
              shape = Tagged { property; variants };
            }
        | None ->
            let unpatterned (s : T.signature) = { s with pattern = None } in
            List.iteri
              (fun i (a : T.branch) ->
                List.iteri
                  (fun j (b : T.branch) ->
                    if
                      j > i
                      && List.exists
                           (fun sa ->
                             List.exists
                               (fun sb ->
                                 not
                                   (T.disjoint (unpatterned sa) (unpatterned sb)))
                               b.signature)
                           a.signature
                    then
                      refuse file ""
                        (Printf.sprintf
                           "its members %s and %s are told apart by a pattern \
                            alone, which the OCaml SDK does not read"
                           a.variant b.variant))
                  u.branches)
              u.branches;
            {
              module_;
              name = (if rooted name then Some name else None);
              file;
              shape =
                Members
                  (List.map
                     (fun (b : T.branch) ->
                       {
                         branch = b;
                         held = held_of ~stated_in:b.variant ~const:false b.ty;
                       })
                     u.branches);
            })
  in
  List.iter
    (fun (name, file) ->
      match record_form name with
      | Some members ->
          record ~module_:(Enums.module_name name) ~name ~file members
      | None -> ())
    roots;
  List.iter
    (fun (name, file) ->
      match (tagged name, (typing.find name).form) with
      | Some _, T.Union u ->
          union ~module_:(Enums.module_name name) ~name ~file u
      | _ -> ())
    roots;
  let discovered = List.rev !discovered in
  let first =
    List.filter_map
      (fun (name, _) ->
        if record_form name <> None then
          List.find_opt (fun e -> e.module_ = Enums.module_name name) discovered
        else None)
      roots
  in
  let last =
    List.filter
      (fun e -> match e.shape with Tagged _ -> true | _ -> false)
      discovered
  in
  ordered
    (first
    @ List.filter
        (fun e -> not (List.memq e first || List.memq e last))
        discovered
    @ last)

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
  | Map of base
      (** each member's value, the member named as the caller chooses *)
  | Variants of { property : string; variants : variant list }

and variant = { tag : string; constructor : string; fields : field list }

(* The table records but the string enums, each after the ones it names:
   [written] each one's key, title and name, [enum_of] the module of a
   string enum by its name, and [rooted] whether a name is one Protocol
   roots. *)
let tabled (typing : T.t) ~written ~enum_of ~rooted =
  let module_of name =
    List.find_map
      (fun (_, title) ->
        if title = name then Some (Enums.module_name title) else None)
      written
  in
  (* The records of objects stated in place as members, each its owner's
     module and its member's name. *)
  let stated = ref [] in
  (* A value's type, and the module of the table record it names; an object
     stated in place is a record of its own, [named]. *)
  let rec base_of key at ~named (ty : T.ty) =
    match ty with
    | T.Named name -> (
        match (enum_of name, module_of name) with
        | Some m, _ -> (Enum_base m, None)
        | None, Some m -> (Record_base m, Some m)
        | None, None when rooted name -> (
            match (typing.find name).form with
            | T.Alias (T.Scalar (T.Text _)) | T.Identifier _ -> (Text_base, None)
            | _ -> (Model_base name, None))
        | None, None ->
            refuse key at "names no schema the OCaml SDK has a type for")
    | T.Scalar (T.Text _) -> (Text_base, None)
    | T.Scalar T.Boolean -> (Bool_base, None)
    | T.Scalar (T.Integer _) -> (Int_base, None)
    | T.Scalar T.Number -> (Float_base, None)
    | T.List (Some item) ->
        let item, need = base_of key at ~named item in
        (List_base item, need)
    | T.Inline { form = T.Record { members = ms; _ }; _ } ->
        let fields, needs = members key at ~owner:named ms in
        stated := { module_ = named; form = Fields fields; needs } :: !stated;
        (Record_base named, Some named)
    | _ -> refuse key at "is no member the OCaml SDK has a type for"
  (* A member, and the module of the table record it names. *)
  and member key at ~owner (m : T.member) =
    let at = at ^ "/properties/" ^ Decode.escape m.wire in
    let ty, nullable =
      match m.ty with T.Nullable ty -> (ty, true) | ty -> (ty, false)
    in
    let base, need =
      base_of key at ~named:(owner ^ "_" ^ field_name m.wire) ty
    in
    if (not m.required) && nullable then
      refuse key at "may be both absent and null";
    ( {
        json = m.wire;
        label = field_name m.wire;
        base;
        required = m.required;
        nullable;
      },
      need )
  and members key at ~owner ms =
    let typed = List.map (member key at ~owner) ms in
    let labels = List.map (fun (f, _) -> f.label) typed in
    if List.length (List.sort_uniq compare labels) <> List.length labels then
      refuse key at "has two members OCaml names alike";
    (List.map fst typed, List.filter_map snd typed)
  in
  let derive (key, title) =
    let file, pointer = Enums.place key in
    let refuse at message = refuse file (pointer ^ at) message in
    let module_ = Enums.module_name title in
    match (typing.find title).form with
    | T.Record { members = ms; _ } ->
        let fields, needs = members key "" ~owner:module_ ms in
        { module_; form = Fields fields; needs }
    | T.Map { value; _ } ->
        let base, need =
          base_of key "/additionalProperties" ~named:(module_ ^ "_value") value
        in
        { module_; form = Map base; needs = Option.to_list need }
    | T.Union { tag = Some { property; _ }; branches } ->
        let variants =
          List.mapi
            (fun i (b : T.branch) ->
              let at = Printf.sprintf "/oneOf/%d" i in
              match b.ty with
              | T.Inline { form = T.Record { members = ms; _ }; _ } -> (
                  let tag =
                    List.find_map
                      (fun (m : T.member) ->
                        match m.fixed with
                        | Some (Schema.String_literal tag)
                          when m.wire = property ->
                            Option.map (fun c -> (tag, c)) (variant_name tag)
                        | _ -> None)
                      ms
                  in
                  match tag with
                  | Some (tag, constructor) ->
                      let fields, needs =
                        members key at ~owner:module_
                          (List.filter
                             (fun (m : T.member) -> m.wire <> property)
                             ms)
                      in
                      ({ tag; constructor; fields }, needs)
                  | None ->
                      refuse at
                        "states no one value of its tag a constructor can name")
              | _ -> refuse at "is no object stated in place")
            branches
        in
        let constructors = List.map (fun (v, _) -> v.constructor) variants in
        if
          List.length (List.sort_uniq compare constructors)
          <> List.length constructors
        then refuse "/oneOf" "names two variants alike";
        {
          module_;
          form = Variants { property; variants = List.map fst variants };
          needs = List.concat_map snd variants;
        }
    | _ -> refuse "" "is no object, no union and no string enum"
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

let derive (spec : Spec.t) (typing : T.t) table =
  try
    let rooted name = List.exists (fun (n, _) -> n = name) (Roots.all spec) in
    let enums = Enums.tabled spec.ids table in
    let client_enums = Enums.client_types spec in
    let enum_of name =
      match
        List.find_map
          (fun (key, m, _) ->
            if List.exists (fun (k, title, _) -> k = key && title = name) table
            then Some m
            else None)
          enums
      with
      | Some m -> Some m
      | None ->
          if List.mem name client_enums then Some (Enums.module_name name)
          else None
    in
    let is_enum name =
      match (typing.find name).form with T.Enum _ -> true | _ -> false
    in
    let written =
      List.filter_map
        (fun (key, title, _) ->
          if is_enum title then None else Some (key, title))
        table
      @ List.filter_map
          (fun name ->
            if is_enum name then None
            else Some (Roots.client_types ^ name ^ ".json", name))
          (Definitions.generated_client_types spec)
    in
    let tabled_records = tabled typing ~written ~enum_of ~rooted in
    let tabled_module name =
      List.find_map
        (fun (_, title) ->
          if title = name then Some (Enums.module_name title) else None)
        written
    in
    let entries = components spec typing ~tabled:tabled_module ~enum_of in
    let modules =
      List.map (fun (e : entry) -> e.module_) entries
      @ List.map (fun (t : tabled) -> t.module_) tabled_records
    in
    if List.length (List.sort_uniq compare modules) <> List.length modules then
      refuse "protocol/specs/src" "" "names two records one module";
    Ok (entries, tabled_records)
  with
  | Refused e -> Error [ e ]
  | Definitions.Refused message ->
      Error [ { Decode.file = "protocol/specs/src"; pointer = ""; message } ]

(* [let of_model (model : [ `Kind ] Models.t) = body]. *)
let of_model kind body =
  O.let_ "of_model"
    (O.fun_
       [
         O.Pattern.constraint_ (O.Pattern.var "model")
           (O.type_ "Models.t" ~args:[ O.tags [ kind ] ]);
       ]
       body)

let model_json = O.call "Models.json" [ O.ident "model" ]
let model_fields = O.call "fields_of" [ model_json ]

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

let rec held_type = function
  | Text -> O.type_ "string"
  | Bool -> O.type_ "bool"
  | Int -> O.type_ "int"
  | Float -> O.type_ "float"
  | Enum m -> O.type_ ("Enums." ^ m ^ ".t")
  | Stated e -> O.type_ (e.module_ ^ ".t")
  | Record m | Union m | Tabled m -> O.type_ (m ^ ".t")
  | List_of h -> O.type_ "list" ~args:[ held_type h ]
  | Map_of h ->
      O.type_ "list" ~args:[ O.type_tuple [ O.type_ "string"; held_type h ] ]
  | Nullable h -> O.type_ "option" ~args:[ held_type h ]
  | Raw -> O.type_ "Yojson.Raw.t"

let rec held_reader = function
  | Text -> O.ident "string"
  | Bool -> O.ident "bool"
  | Int -> O.ident "int"
  | Float -> O.ident "float"
  | Enum m -> O.call "enum" [ O.ident ("Enums." ^ m ^ ".of_string") ]
  | Stated e -> O.call "enum" [ O.ident (e.module_ ^ ".of_string") ]
  | Record m -> O.call "record" [ O.ident (m ^ ".project") ]
  | Union m -> O.ident (m ^ ".read")
  | Tabled m -> O.call "tabled" [ O.ident (m ^ ".of_json") ]
  | List_of h -> O.call "list" [ held_reader h ]
  | Map_of h -> O.call "map" [ held_reader h ]
  | Nullable h -> O.call "nullable" [ held_reader h ]
  | Raw -> O.ident "raw"

let rec held_writer = function
  | Text -> O.ident "json_string"
  | Bool -> O.ident "json_bool"
  | Int -> O.ident "json_int"
  | Float -> O.ident "json_float"
  | Enum m -> O.call "json_enum" [ O.ident ("Enums." ^ m ^ ".to_string") ]
  | Stated e -> O.call "json_enum" [ O.ident (e.module_ ^ ".to_string") ]
  | Record m | Union m -> O.ident (m ^ ".to_json")
  | Tabled m -> O.call "json_tabled" [ O.ident (m ^ ".to_json") ]
  | List_of h -> O.call "json_list" [ held_writer h ]
  | Map_of h -> O.call "json_map" [ held_writer h ]
  | Nullable h -> O.call "json_nullable" [ held_writer h ]
  | Raw -> O.ident "json_raw"

(* How a record's member is held: always present, an option when it may be
   absent, or a [Types.presence] when it may be absent and may be null (a
   raw one may always be null). *)
type presence = Always | Maybe | Presence

(* A record's member: how it is held, its type, its reader and its writer. *)
let record_member (f : held_member) =
  let optional = not f.member.required in
  let type_ = held_type f.held
  and read = held_reader f.held
  and write = held_writer f.held in
  match f.held with
  | Raw -> ((if optional then Presence else Always), type_, read, write)
  | _ when not optional ->
      if f.nullable then
        ( Always,
          O.type_ "option" ~args:[ type_ ],
          O.call "nullable" [ read ],
          O.call "json_nullable" [ write ] )
      else (Always, type_, read, write)
  | _ -> ((if f.nullable then Presence else Maybe), type_, read, write)

let kind_constructor (k : T.kind) =
  match k with
  | Text_kind -> "Text_kind"
  | Integer_kind -> "Integer_kind"
  | Number_kind -> "Number_kind"
  | Boolean_kind -> "Boolean_kind"
  | List_kind -> "List_kind"
  | Object_kind -> "Object_kind"
  | Null_kind -> "Null_kind"
  | Any_kind -> "Any_kind"

let literal (l : Schema.literal) =
  match l with
  | String_literal text -> O.construct "Text_value" ~arg:(O.string text)
  | Int_literal n -> O.construct "Integer_value" ~arg:(O.int n)
  | Bool_literal b -> O.construct "Boolean_value" ~arg:(O.bool b)

let option f = function None -> O.none | Some v -> O.some (f v)
let strings names = O.list (List.map O.string names)

(* What a union's member admits, as [Record_reader.signature] holds it; the
   OCaml SDK reads no pattern. *)
let signature (s : T.signature) =
  O.record
    [
      ("kind", O.construct (kind_constructor s.kind));
      ("required", strings s.required);
      ("allowed", option strings s.allowed);
      ( "fixed",
        O.list
          (List.map
             (fun (name, values) ->
               O.tuple [ O.string name; O.list (List.map literal values) ])
             s.fixed) );
      ("values", option (fun vs -> O.list (List.map literal vs)) s.values);
    ]

let entry (e : entry) =
  let rooted items = match e.name with Some name -> items name | None -> [] in
  match e.shape with
  | Object fields ->
      let fields =
        List.map
          (fun (f : held_member) ->
            let held, type_, read, write = record_member f in
            ( f.member.wire,
              field_name f.member.wire,
              read,
              write,
              held,
              match held with
              | Always -> type_
              | Maybe -> O.type_ "option" ~args:[ type_ ]
              | Presence -> O.type_ "Types.presence" ~args:[ type_ ] ))
          fields
        |> fun typed -> (typed, fields)
      in
      let typed, members = fields in
      let t =
        O.type_declaration "t"
          (Record
             (List.map (fun (_, label, _, _, _, t) -> (label, t)) typed
             @ [
                 ( "extra",
                   O.type_ "list"
                     ~args:
                       [
                         O.type_tuple
                           [ O.type_ "string"; O.type_ "Yojson.Raw.t" ];
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
                      typed
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
                       typed);
                  O.field value "extra";
                ]))
      in
      O.module_ e.module_
        (List.map Enums.impl
           (List.concat_map (fun (f : held_member) -> stated_of f.held) members)
        @ [ O.type_item t; project ]
        @ rooted (fun name ->
            [ of_model name (O.call "project" [ model_fields ]) ])
        @ [ to_json ]
        @ rooted (fun name -> [ to_model name ]))
  | Tagged { property; variants } ->
      let t =
        O.type_declaration "t"
          (Variant
             (List.map
                (fun (_, c, branch) ->
                  O.constructor c ~args:[ O.type_ (branch ^ ".t") ])
                variants))
      in
      let by_tag fields ~found ~otherwise =
        O.match_
          (O.call "List.assoc_opt" [ O.string property; fields ])
          [
            O.case
              (O.Pattern.construct "Some"
                 ~arg:
                   (O.Pattern.variant "Stringlit" ~arg:(O.Pattern.var "literal")))
              (O.match_
                 (O.call "string"
                    [ O.variant "Stringlit" ~arg:(O.ident "literal") ])
                 (List.map
                    (fun (tag, c, branch) ->
                      O.case (O.Pattern.string tag)
                        (found
                           (O.construct c
                              ~arg:(O.call (branch ^ ".project") [ fields ]))))
                    variants
                 @ [ O.case O.Pattern.any otherwise ]));
            O.case O.Pattern.any otherwise;
          ]
      in
      let read =
        O.define "read" [ "value" ]
          (O.let_in "fields"
             (O.call "fields_of" [ O.ident "value" ])
             (by_tag (O.ident "fields") ~found:Fun.id ~otherwise:O.assert_false))
      in
      let of_model =
        rooted (fun name ->
            [
              of_model name
                (O.let_in "fields" model_fields
                   (by_tag (O.ident "fields") ~found:O.some ~otherwise:O.none));
            ])
      in
      let to_json =
        O.let_ "to_json"
          (O.function_
             (List.map
                (fun (_, c, branch) ->
                  O.case
                    (O.Pattern.construct c ~arg:(O.Pattern.var "value"))
                    (O.call (branch ^ ".to_json") [ O.ident "value" ]))
                variants))
      in
      O.module_ e.module_
        ((O.type_item t :: read :: of_model)
        @ [ to_json ]
        @ rooted (fun name -> [ to_model name ]))
  | Members branches ->
      let t =
        O.type_declaration "t"
          (Variant
             (List.map
                (fun (b : held_branch) ->
                  O.constructor b.branch.variant ~args:[ held_type b.held ])
                branches))
      in
      let members =
        O.let_ "members"
          (O.list
             (List.map
                (fun (b : held_branch) ->
                  O.list (List.map signature b.branch.signature))
                branches))
      in
      let read =
        O.define "read" [ "value" ]
          (O.match_
             (O.call "member" [ O.ident "members"; O.ident "value" ])
             (List.mapi
                (fun i (b : held_branch) ->
                  O.case (O.Pattern.int i)
                    (O.construct b.branch.variant
                       ~arg:(O.apply (held_reader b.held) [ O.ident "value" ])))
                branches
             @ [ O.case O.Pattern.any O.assert_false ]))
      in
      let to_json =
        O.let_ "to_json"
          (O.function_
             (List.map
                (fun (b : held_branch) ->
                  O.case
                    (O.Pattern.construct b.branch.variant
                       ~arg:(O.Pattern.var "value"))
                    (O.apply (held_writer b.held) [ O.ident "value" ]))
                branches))
      in
      O.module_ e.module_
        (List.map Enums.impl
           (List.concat_map
              (fun (b : held_branch) -> stated_of b.held)
              branches)
        @ [ O.type_item t; members; read ]
        @ rooted (fun name -> [ of_model name (O.call "read" [ model_json ]) ])
        @ [ to_json ]
        @ rooted (fun name -> [ to_model name ]))

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
    "members";
    "tag";
    "string";
    "bool";
    "int";
    "float";
    "enum";
    "record";
    "model";
    "list";
    "map";
    "nullable";
    "required";
    "optional";
    "malformed";
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

let files (entries, tabled) =
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
      let record =
        O.record (List.map (fun f -> (f.label, O.ident f.label)) fields)
      in
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
               @ [
                   O.case O.Pattern.any
                     (O.call "malformed" [ O.string property ]);
                 ]))
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
               O.fun_
                 [ O.Pattern.var "value" ]
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
    O.module_ t.module_ [ O.type_item declaration; of_json; to_json ]
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
      ((O.open_ "Record_reader" :: List.map table tabled)
      @ List.map entry entries);
  ]
