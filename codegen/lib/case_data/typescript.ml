(* A table's model and rows as a TypeScript module of a package's tests: the
   types Protocol's reader derives (Model), each named in PascalCase, the
   table's own [Table], and [table], its rows as the JSON they are, which
   those types type. A record is an object type, so that a row is a [Json]
   where a test hands it on as one, and its members are its JSON's, an enum is the union
   of its strings, and a variant the union of its cases' types. A schema is
   [schema], its JSON as a constant, whose type is its own. *)

module M = Xynolog_protocol_model.Model
module T = Typescript_syntax

let type_name = function "t" -> "Table" | name -> Text.pascal name

(* A value the model types as JSON, and a JSON Schema. *)
let json = "Json"

let rec type_of : M.ty -> T.type_ = function
  | String | Reference -> T_name "string"
  | Int | Float -> T_name "number"
  | Bool -> T_name "boolean"
  | Json | Json_schema -> T_name json
  | Constant (`String s) -> T_str s
  | Constant (`Int n) -> T_int n
  | Constant (`Float _) -> T_name "number"
  | Constant (`Bool b) -> T_bool b
  | Constant other ->
      invalid_arg ("a constant of no scalar: " ^ Yojson.Safe.to_string other)
  | List t -> T_array (element t)
  | Map (String, v) -> T_index_signature (type_of v)
  | Map (Named enum, v) ->
      T_generic
        ( "Partial",
          [ T_generic ("Record", [ T_name (type_name enum); type_of v ]) ] )
  | Map _ -> invalid_arg "a map whose keys are no string and no enum"
  | Nullable t -> T_union [ type_of t; T_name "null" ]
  | Named name -> T_name (type_name name)

(* An array's element, in parentheses where it is a union. *)
and element t = match type_of t with T_union _ as u -> T_paren u | t -> t

let key name = if T.identifier name then T.Ident name else T.Quoted name

let declaration : M.decl -> T.decl = function
  | Record (name, []) ->
      T.type_alias (type_name name)
        (T_generic ("Record", [ T_name "string"; T_name "never" ]))
  | Record (name, fields) ->
      T.type_alias (type_name name)
        (T_object
           ( Rows,
             List.map
               (fun (f : M.field) ->
                 T.member ~optional:(not f.required) (key f.key) (type_of f.ty))
               fields ))
  | Enum (name, cases) ->
      T.type_alias (type_name name)
        (T_cases (List.map (fun (_, v) -> T.case (T_str v)) cases))
  | Variant (name, cases) ->
      T.type_alias (type_name name)
        (T_cases
           (List.map (fun (c : M.case) -> T.case (type_of c.payload)) cases))

(* What the JSON type is, for a module whose model types a value as JSON. *)
let json_declaration =
  T.type_alias json
    (T_union
       [
         T_name "null";
         T_name "boolean";
         T_name "number";
         T_name "string";
         T_array (T_name json);
         T_index_signature (T_name json);
       ])

let rec uses_json : M.ty -> bool = function
  | Json | Json_schema -> true
  | List t | Nullable t -> uses_json t
  | Map (k, v) -> uses_json k || uses_json v
  | String | Reference | Int | Float | Bool | Constant _ | Named _ -> false

let declares_json : M.decl -> bool = function
  | Record (_, fields) ->
      List.exists (fun (f : M.field) -> uses_json f.ty) fields
  | Enum _ -> false
  | Variant (_, cases) ->
      List.exists (fun (c : M.case) -> uses_json c.payload) cases

(* A value as the JSON it is in the table. *)
let rec to_json : Walk.value -> Yojson.Safe.t = function
  | String s -> `String s
  | Int n -> `Int n
  | Float f -> `Float f
  | Bool b -> `Bool b
  | Json j -> j
  | List items -> `List (List.map to_json items)
  | Map pairs ->
      `Assoc
        (List.map
           (fun (k, v) ->
             match k with
             | Walk.String s | Enum (_, _, s) -> (s, to_json v)
             | _ -> invalid_arg "a map whose keys are no string and no enum")
           pairs)
  | Null -> `Null
  | Present v -> to_json v
  | Record (_, fields) ->
      `Assoc
        (List.filter_map
           (fun ((f : M.field), v) ->
             Option.map (fun v -> (f.key, to_json v)) v)
           fields)
  | Enum (_, _, s) -> `String s
  | Case (_, { payload = Constant c; _ }, None) -> c
  | Case (_, _, Some payload) -> to_json payload
  | Case (name, c, None) ->
      invalid_arg (name ^ "'s case " ^ c.name ^ " lacks its payload")

let banner file =
  Banner.typescript_lines ~authority:[ "protocol/specs/src/" ^ file ] __FILE__

(* The module of [model], whose rows are [rows], at [path]. *)
let file ~path (model : M.model) rows =
  let names =
    List.map
      (function M.Record (n, _) | Enum (n, _) | Variant (n, _) -> type_name n)
      model.decls
  in
  if
    List.mem json names
    || List.length (List.sort_uniq compare names) <> List.length names
  then
    invalid_arg
      (model.path ^ "'s model declares two types of one TypeScript name");
  {
    Output.path;
    text =
      T.text
        {
          banner = banner model.path;
          body =
            (if List.exists declares_json model.decls then [ json_declaration ]
             else [])
            @ List.map declaration model.decls
            @ [
                T.const "table" ~annotation:(T_name "Table")
                  (Json_rows (to_json rows));
              ];
        };
  }

(* The schema at [file], as its JSON, [schema], at [path]. *)
let schema ~path file json_value =
  {
    Output.path;
    text =
      T.text
        {
          banner = banner file;
          body = [ T.const "schema" ~as_const:true (Json_rows json_value) ];
        };
  }
