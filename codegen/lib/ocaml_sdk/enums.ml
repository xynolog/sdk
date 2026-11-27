(* Every schema Protocol roots ([Roots.all]) that is a string enum or a
   string constant, the
   client types below, why no launcher was found
   (protocol/specs/src/client/discovery-absent.json), and every record
   Protocol states in a table ([Table_records]) that is one but a union's
   tag, which is the union's constructors ([Records]), as a module of the
   OCaml SDK (ocaml/sdk/lib/enums.ml): a
   variant per member, and its name both ways. A member is a letter and then
   letters, digits and . / + -, so it names a constructor; no two name the
   same one, and no two enums name one module. *)

let source = "protocol/specs/src"

(* The client types the SDK generates that are words. *)
let client_types (spec : Spec.t) =
  List.filter
    (fun name ->
      match List.assoc_opt ("client/types/" ^ name ^ ".json") spec.schemas with
      | Some (Schema.Schema { type_ = Some [ String ]; _ }) -> true
      | _ -> false)
    (Definitions.generated_client_types spec)

type enum = { module_ : string; variants : (string * string) list }
(** Each variant: its constructor, and its member. *)

let is_member value =
  value <> ""
  && (match value.[0] with 'a' .. 'z' | 'A' .. 'Z' -> true | _ -> false)
  && String.for_all
       (function
         | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '.' | '/' | '+' | '-' -> true
         | _ -> false)
       value

let constructor value =
  String.capitalize_ascii
    (String.map
       (function '.' | '/' | '-' -> '_' | c -> c)
       (Text.replace_all ~sub:"+" ~by:"_plus" value))

let module_name name = String.capitalize_ascii (Text.snake name)

(* The members of [schema] when it is a string enum, or a string constant:
   the enum of its one value. *)
let members_of = function
  | Schema.Schema { type_ = Some [ String ]; enum = Some members; _ } ->
      Some members
  | Schema.Schema { type_ = Some [ String ]; const = Some member; _ } ->
      Some [ member ]
  | _ -> None

(* The file and the pointer of a table record's [Table_records.key]. *)
let place key =
  match String.index_opt key '#' with
  | Some i ->
      (String.sub key 0 i, String.sub key (i + 1) (String.length key - i - 1))
  | None -> (key, "")

(* The table records a union's branch states its tag by, by key. *)
let tags ids table =
  List.concat_map
    (fun (_, _, schema) ->
      match schema with
      | Schema.Schema
          {
            discriminator = Some { property_name; _ };
            one_of = Some branches;
            _;
          } ->
          List.filter_map
            (function
              | Schema.Schema { properties = Some properties; _ } -> (
                  match List.assoc_opt property_name properties with
                  | Some
                      (Schema.Schema
                         {
                           all_of = Some [ Schema.Schema { ref_ = Some r; _ } ];
                           _;
                         }) ->
                      Some (Table_records.key ids r)
                  | _ -> None)
              | _ -> None)
            branches
      | _ -> [])
    table

let is_enum = function
  | Schema.Schema { type_ = Some [ String ]; enum = Some _; _ } -> true
  | _ -> false

(* Each table record that is a string enum but a union's tag: its key, its
   module and its members. *)
let tabled ids table =
  let tags = tags ids table in
  List.filter_map
    (fun (key, title, schema) ->
      match schema with
      | Schema.Schema { enum = Some members; _ }
        when is_enum schema && not (List.mem key tags) ->
          Some (key, module_name title, members)
      | _ -> None)
    table

let derive (spec : Spec.t) table =
  let refusals = ref [] in
  let enum ~file ~pointer module_ members =
    let refuse at message =
      refusals := { Decode.file; pointer = pointer ^ at; message } :: !refusals
    in
    let variants =
      List.concat
        (List.mapi
           (fun i (member : Schema.literal) ->
             match member with
             | String_literal value when is_member value ->
                 [ (constructor value, value) ]
             | _ ->
                 refuse
                   (Printf.sprintf "/enum/%d" i)
                   "is no member an OCaml constructor can name";
                 [])
           members)
    in
    let constructors = List.map fst variants in
    if
      variants = []
      || List.length (List.sort_uniq compare constructors)
         <> List.length constructors
    then refuse "/enum" "is empty, or two members name one constructor";
    { module_; variants }
  in
  let components =
    List.filter_map
      (fun (name, reference) ->
        let file, _ = Decode.resolve spec.ids reference in
        Option.bind (List.assoc_opt file spec.schemas) (fun schema ->
            Option.map
              (fun members -> enum ~file ~pointer:"" (module_name name) members)
              (members_of schema)))
      (List.sort (fun (a, _) (b, _) -> compare a b) (Roots.all spec))
  in
  let clients =
    List.map
      (fun name ->
        let file = "client/types/" ^ name ^ ".json" in
        match List.assoc_opt file spec.schemas with
        | Some
            (Schema.Schema { type_ = Some [ String ]; enum = Some members; _ })
          ->
            enum ~file ~pointer:"" (module_name name) members
        | _ ->
            refusals :=
              { Decode.file; pointer = ""; message = "is no string enum" }
              :: !refusals;
            { module_ = module_name name; variants = [] })
      (client_types spec)
  in
  let discovery_absent =
    enum ~file:"client/discovery-absent.json" ~pointer:"/reasons"
      "Discovery_absent_reason"
      (List.map
         (fun (r : Tables.Client_discovery_absent.reasons_item) ->
           Schema.String_literal r.reason)
         spec.tables.client_discovery_absent.reasons)
  in
  let tabled =
    List.map
      (fun (key, module_, members) ->
        let file, pointer = place key in
        enum ~file ~pointer module_ members)
      (tabled spec.ids table)
  in
  let enums = components @ clients @ (discovery_absent :: tabled) in
  let modules = List.map (fun e -> e.module_) enums in
  if List.length (List.sort_uniq compare modules) <> List.length modules then
    refusals :=
      {
        Decode.file = source;
        pointer = "";
        message = "two enums name one module";
      }
      :: !refusals;
  match List.rev !refusals with [] -> Ok enums | errors -> Error errors

module O = Ocaml_syntax

let banner =
  Banner.ocaml
    ~from_:
      "the string enums among the schemas protocol/specs/src roots, its client \
       types and its tables"
    __FILE__

let t e =
  O.type_declaration "t"
    (Variant (List.map (fun (c, _) -> O.constructor c) e.variants))

let impl e =
  O.module_ e.module_
    [
      O.type_item (t e);
      O.let_ "to_string"
        (O.function_
           (List.map
              (fun (c, member) ->
                O.case (O.Pattern.construct c) (O.string member))
              e.variants));
      O.let_ "of_string"
        (O.function_
           (List.map
              (fun (c, member) ->
                O.case (O.Pattern.string member) (O.some (O.construct c)))
              e.variants
           @ [ O.case O.Pattern.any O.none ]));
    ]

let spec e =
  O.module_spec e.module_
    [
      O.type_spec (t e);
      O.val_ "to_string" (O.arrow (O.type_ "t") (O.type_ "string"));
      O.val_ "of_string"
        (O.arrow (O.type_ "string") (O.type_ "option" ~args:[ O.type_ "t" ]));
    ]

(* Each enum's members, encoded and decoded, and an unknown value refused,
   with [rest] after. *)
let test e rest =
  let check kind name actual expected =
    O.apply (O.ident "Alcotest.check")
      [ O.ident ("Alcotest." ^ kind); O.string name; actual; expected ]
  in
  let model c = O.construct ("Model." ^ c) in
  let of_string member =
    O.apply (O.ident "Model.of_string") [ O.string member ]
  in
  O.let_module "Model"
    ("Xynolog.Enums." ^ e.module_)
    (O.sequence
       (List.concat_map
          (fun (c, member) ->
            [
              check "string" (e.module_ ^ " encode") (O.string member)
                (O.apply (O.ident "Model.to_string") [ model c ]);
              check "bool" (e.module_ ^ " decode") (O.bool true)
                (O.infix "=" (of_string member) (O.some (model c)));
            ])
          e.variants
       @ [
           check "bool"
             (e.module_ ^ " rejects unknown values")
             (O.bool true)
             (O.infix "=" (of_string "") O.none);
           rest;
         ]))

let files enums =
  [
    O.implementation ~path:"ocaml/sdk/lib/enums.ml" ~banner
      (List.map impl enums);
    O.implementation ~path:"ocaml/sdk/test/enums_cases.ml" ~banner
      [ O.let_unit (List.fold_right test enums O.unit) ];
  ]
