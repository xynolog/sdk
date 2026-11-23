(* A table's model and rows as an OCaml module of the SDK's tests: the types
   Protocol's reader derives (Model), named as its own [Tables] names them,
   and [table], every row as a value of them. A JSON value is Yojson's. Every
   named value is written with its type, so no label or constructor two
   types share is ambiguous. *)

module M = Xynolog_protocol_model.Model
module O = Ocaml_syntax
open Ast_helper

let rec type_of : M.ty -> Parsetree.core_type = function
  | String | Reference -> O.type_ "string"
  | Int -> O.type_ "int"
  | Float -> O.type_ "float"
  | Bool -> O.type_ "bool"
  | Json | Json_schema -> O.type_ "Yojson.Safe.t"
  | Constant (`String _) -> O.type_ "string"
  | Constant (`Int _) -> O.type_ "int"
  | Constant (`Float _) -> O.type_ "float"
  | Constant (`Bool _) -> O.type_ "bool"
  | Constant json ->
      invalid_arg ("a constant of no scalar: " ^ Yojson.Safe.to_string json)
  | List t -> O.type_ "list" ~args:[ type_of t ]
  | Map (k, v) -> O.type_ "list" ~args:[ O.type_tuple [ type_of k; type_of v ] ]
  | Nullable t -> O.type_ "option" ~args:[ type_of t ]
  | Named name -> O.type_ name

let field_type (f : M.field) =
  if f.required then type_of f.ty else O.type_ "option" ~args:[ type_of f.ty ]

let declaration : M.decl -> Parsetree.structure_item = function
  | Record (name, []) ->
      O.type_item
        (O.type_declaration name O.Abstract ~manifest:(O.type_ "unit"))
  | Record (name, fields) ->
      O.type_item
        (O.type_declaration name
           (O.Record
              (List.map (fun (f : M.field) -> (f.label, field_type f)) fields)))
  | Enum (name, cases) ->
      O.type_item
        (O.type_declaration name
           (O.Variant (List.map (fun (c, _) -> O.constructor c) cases)))
  | Variant (name, cases) ->
      O.type_item
        (O.type_declaration name
           (O.Variant
              (List.map
                 (fun (c : M.case) ->
                   match c.payload with
                   | Constant _ -> O.constructor c.name
                   | payload -> O.constructor c.name ~args:[ type_of payload ])
                 cases)))

let float f =
  let shortest = Printf.sprintf "%.15g" f in
  let text =
    if float_of_string shortest = f then shortest else Printf.sprintf "%.17g" f
  in
  let text =
    if String.exists (fun c -> c = '.' || c = 'e' || c = 'n' || c = 'i') text
    then text
    else text ^ "."
  in
  Exp.constant (Const.float text)

let rec json : Yojson.Safe.t -> Parsetree.expression = function
  | `Null -> O.variant "Null"
  | `Bool b -> O.variant "Bool" ~arg:(O.bool b)
  | `Int n -> O.variant "Int" ~arg:(O.int n)
  | `Intlit s -> O.variant "Intlit" ~arg:(O.string s)
  | `Float f -> O.variant "Float" ~arg:(float f)
  | `String s -> O.variant "String" ~arg:(O.string s)
  | `List items -> O.variant "List" ~arg:(O.list (List.map json items))
  | `Assoc members ->
      O.variant "Assoc"
        ~arg:
          (O.list
             (List.map (fun (k, v) -> O.tuple [ O.string k; json v ]) members))

let typed name value = Exp.constraint_ value (O.type_ name)

let rec value : Walk.value -> Parsetree.expression = function
  | String s -> O.string s
  | Int n -> O.int n
  | Float f -> float f
  | Bool b -> O.bool b
  | Json j -> json j
  | List items -> O.list (List.map value items)
  | Map pairs ->
      O.list (List.map (fun (k, v) -> O.tuple [ value k; value v ]) pairs)
  | Null -> O.none
  | Present v -> O.some (value v)
  | Record (name, []) -> typed name O.unit
  | Record (name, fields) ->
      typed name
        (O.record
           (List.map
              (fun ((f : M.field), v) ->
                ( f.label,
                  match (f.required, v) with
                  | true, Some v -> value v
                  | false, Some v -> O.some (value v)
                  | false, None -> O.none
                  | true, None -> invalid_arg (name ^ " lacks " ^ f.key) ))
              fields))
  | Enum (name, c, _) -> typed name (O.construct c)
  | Case (name, c, None) -> typed name (O.construct c.name)
  | Case (name, c, Some payload) ->
      typed name (O.construct c.name ~arg:(value payload))

(* A value as the JSON it is written as in the table, for a call on the SDK
   that takes JSON: [<name>_json] of each declaration, and [<name>_value],
   the string an enum's constructor is. *)
let json_name name = name ^ "_json"
let var = O.ident

let rec to_json : M.ty -> Parsetree.expression = function
  | String | Reference ->
      O.fun_ [ O.Pattern.var "s" ] (O.variant "String" ~arg:(var "s"))
  | Int -> O.fun_ [ O.Pattern.var "n" ] (O.variant "Int" ~arg:(var "n"))
  | Float -> O.fun_ [ O.Pattern.var "f" ] (O.variant "Float" ~arg:(var "f"))
  | Bool -> O.fun_ [ O.Pattern.var "b" ] (O.variant "Bool" ~arg:(var "b"))
  | Json | Json_schema -> var "Fun.id"
  | Constant c -> to_json (constant_type c)
  | List t ->
      O.fun_
        [ O.Pattern.var "l" ]
        (O.variant "List" ~arg:(O.call "List.map" [ to_json t; var "l" ]))
  | Map (k, v) ->
      O.fun_
        [ O.Pattern.var "l" ]
        (O.variant "Assoc"
           ~arg:
             (O.call "List.map"
                [
                  O.fun_
                    [ O.Pattern.tuple [ O.Pattern.var "k"; O.Pattern.var "v" ] ]
                    (O.tuple [ key k; O.apply (to_json v) [ var "v" ] ]);
                  var "l";
                ]))
  | Nullable t ->
      O.function_
        [
          (* Option's own, which a table's constructor named None or Some
             does not hide. *)
          O.case (O.Pattern.construct "Option.None") (O.variant "Null");
          O.case
            (O.Pattern.construct "Option.Some" ~arg:(O.Pattern.var "v"))
            (O.apply (to_json t) [ var "v" ]);
        ]
  | Named name -> var (json_name name)

and constant_type : Yojson.Safe.t -> M.ty = function
  | `String _ -> String
  | `Int _ -> Int
  | `Float _ -> Float
  | `Bool _ -> Bool
  | json ->
      invalid_arg ("a constant of no scalar: " ^ Yojson.Safe.to_string json)

(* A map's key [k], as the member's name it is. *)
and key : M.ty -> Parsetree.expression = function
  | String -> var "k"
  | Named enum -> O.call (enum ^ "_value") [ var "k" ]
  | _ -> invalid_arg "a map whose keys are no string and no enum"

let serializer : M.decl -> Parsetree.structure_item list = function
  | Record (name, []) ->
      [
        O.let_ (json_name name)
          (O.fun_
             [ O.Pattern.constraint_ O.Pattern.unit (O.type_ name) ]
             (O.variant "Assoc" ~arg:(O.list [])));
      ]
  | Record (name, fields) ->
      let member (f : M.field) =
        let at = O.field (var "r") f.label in
        if f.required then
          O.construct "Option.Some"
            ~arg:(O.tuple [ O.string f.key; O.apply (to_json f.ty) [ at ] ])
        else
          O.call "Option.map"
            [
              O.fun_
                [ O.Pattern.var "v" ]
                (O.tuple [ O.string f.key; O.apply (to_json f.ty) [ var "v" ] ]);
              at;
            ]
      in
      [
        O.let_ (json_name name)
          (O.fun_
             [ O.Pattern.constraint_ (O.Pattern.var "r") (O.type_ name) ]
             (O.variant "Assoc"
                ~arg:
                  (O.call "List.filter_map"
                     [ var "Fun.id"; O.list (List.map member fields) ])));
      ]
  | Enum (name, cases) ->
      [
        O.let_ (name ^ "_value")
          (O.function_
             (List.map
                (fun (c, v) ->
                  O.case
                    (O.Pattern.constraint_ (O.Pattern.construct c)
                       (O.type_ name))
                    (O.string v))
                cases));
        O.let_ (json_name name)
          (O.fun_
             [ O.Pattern.var "v" ]
             (O.variant "String" ~arg:(O.call (name ^ "_value") [ var "v" ])));
      ]
  | Variant (name, cases) ->
      [
        O.let_ (json_name name)
          (O.function_
             (List.map
                (fun (c : M.case) ->
                  match c.payload with
                  | Constant k ->
                      O.case
                        (O.Pattern.constraint_
                           (O.Pattern.construct c.name)
                           (O.type_ name))
                        (json k)
                  | payload ->
                      O.case
                        (O.Pattern.constraint_
                           (O.Pattern.construct c.name ~arg:(O.Pattern.var "v"))
                           (O.type_ name))
                        (O.apply (to_json payload) [ var "v" ]))
                cases));
      ]

(* The module of [model], whose rows are [rows], at [path]. *)
let file ~path (model : M.model) rows =
  O.implementation ~path
    ~banner:(Banner.ocaml ~from_:("protocol/specs/src/" ^ model.path) __FILE__)
    (List.concat_map (fun d -> declaration d :: serializer d) model.decls
    @ [ O.let_ "table" ~type_:(O.type_ "t") (value rows) ])

(* The schema at [file], as its JSON, [schema], at [path]. *)
let schema ~path file json_value =
  O.implementation ~path
    ~banner:(Banner.ocaml ~from_:("protocol/specs/src/" ^ file) __FILE__)
    [ O.let_ "schema" ~type_:(O.type_ "Yojson.Safe.t") (json json_value) ]
