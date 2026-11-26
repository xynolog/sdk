(* What the Haskell SDK's models come with: Xynolog.Types, which exports every
   model module; the schemas the SDK validates against at run time, each
   without what only describes it; the carried tables' values; and the
   dispatcher the round-trip tests decode and encode each model's examples
   by, and what each union's members admit. *)

module H = Haskell_syntax

let rec value : Yojson.Safe.t -> H.expr = function
  | `Assoc members ->
      Apply
        ( Name "Object",
          [
            Apply
              ( Name "KM.fromList",
                [
                  List
                    (List.map
                       (fun (k, v) -> H.Tuple [ Str k; value v ])
                       (List.sort
                          (fun (a, _) (b, _) -> String.compare a b)
                          members));
                ] );
          ] )
  | `List items ->
      Apply
        ( Name "Array",
          [ Apply (Name "V.fromList", [ List (List.map value items) ]) ] )
  | `String s -> Apply (Name "String", [ Str s ])
  | `Int n ->
      Apply
        ( Name "Number",
          [ Apply (Name "read", [ Str (Models.scientific (Float.of_int n)) ]) ]
        )
  | `Float f ->
      Apply
        (Name "Number", [ Apply (Name "read", [ Str (Models.scientific f) ]) ])
  | `Bool b -> Apply (Name "Bool", [ Name (if b then "True" else "False") ])
  | `Null -> Name "Null"
  | `Intlit _ -> invalid_arg "Companions: no JSON value of this kind"

(* [schema] with each text of a vocabulary of errors/codes.json or a table
   of words ([x-xynolog-codes]) stated as an enumeration of its values,
   which the runtime form of a schema leaves out: the code types the models
   read it as hold it to no other, as the required table does. One that also
   allows null is either null or one of the values. *)
let coded (vocabularies : Error_codes.Table.vocabulary list) ~words =
  Schema.cata
    ~boolean:(fun b -> Schema.Boolean_schema b)
    ~schema:(fun (layer : Schema.schema) ->
      match layer.codes with
      | None -> Schema.Schema layer
      | Some member -> (
          match
            Word_tables.enum
              ~codes:(Error_codes.Table.enum vocabularies)
              ~words member
          with
          | None ->
              invalid_arg
                ("Companions: " ^ member
               ^ " is neither a vocabulary of errors/codes.json nor a table of \
                  words")
          | Some codes -> (
              let enum = Some codes in
              match layer.type_ with
              | Some [ Schema.String ] -> Schema.Schema { layer with enum }
              | Some [ Schema.String; Schema.Null ] ->
                  Schema.Schema
                    {
                      layer with
                      type_ = None;
                      one_of =
                        Some
                          [
                            Schema.Schema
                              { Schema.empty with type_ = Some [ Schema.Null ] };
                            Schema.Schema
                              {
                                Schema.empty with
                                type_ = Some [ Schema.String ];
                                enum;
                              };
                          ];
                    }
              | _ ->
                  invalid_arg
                    ("Companions: a code of " ^ member
                   ^ " is neither text nor text or null"))))

let schemas_module ~banner ~vocabularies ~words definitions =
  let body =
    [
      H.value "schemas" (T_name "Schemas")
        (Apply
           ( Name "Map.fromList",
             [
               List
                 (List.map
                    (fun (name, schema) ->
                      H.Tuple
                        [
                          Str name;
                          value
                            (Schema.runtime (coded vocabularies ~words schema));
                        ])
                    definitions);
             ] ));
    ]
  in
  let used = H.uses body in
  {
    H.banner;
    extensions = [ "OverloadedStrings" ];
    name = "Xynolog.Internal.Generated.Schemas";
    imports =
      [
        H.import "Data.Aeson" ~items:[ All "Value" ];
        H.import "Data.Aeson.KeyMap" ~qualified:"KM";
      ]
      @ [ H.import "Data.Map.Strict" ~qualified:"Map" ]
      @ (if List.mem "V.fromList" used.values then
           [ H.import "Data.Vector" ~qualified:"V" ]
         else [])
      @ [ H.import "Xynolog.Internal.Schema" ~items:[ Plain "Schemas" ] ];
    body;
  }

(* A module of carried tables ([Carried_tables.modules]): each table's rows as
   its type's value, and every table's path with its value as JSON, which the
   suite holds to the table. *)
let tables_module ~banner ~root (carried : Carried_tables.carried) =
  let values =
    List.map
      (fun table ->
        H.value
          (Carried_tables.value_name table)
          (T_name (Carried_tables.name table))
          (Apply
             ( Name "carriedTable",
               [ Str table; value (Carried_tables.rows ~root table) ] )))
      carried.tables
  in
  let listed =
    H.value carried.listing
      (T_list (T_tuple [ T_name "Text"; T_name "Value" ]))
      (List
         (List.map
            (fun table ->
              H.Tuple
                [
                  Str table;
                  Apply
                    (Name "toJSON", [ Name (Carried_tables.value_name table) ]);
                ])
            carried.tables))
  in
  let body = values @ [ listed ] in
  let used = H.uses body in
  {
    H.banner;
    extensions = [ "OverloadedStrings" ];
    name = carried.module_name;
    imports =
      [
        H.import "Data.Aeson" ~items:[ All "Value"; Plain "toJSON" ];
        H.import "Data.Aeson.KeyMap" ~qualified:"KM";
        H.import "Data.Text" ~items:[ Plain "Text" ];
      ]
      @ (if List.mem "V.fromList" used.values then
           [ H.import "Data.Vector" ~qualified:"V" ]
         else [])
      @ [
          H.import "Xynolog.Internal.CarriedTable"
            ~items:[ Plain "carriedTable" ];
          H.import "Xynolog.Types";
        ];
    body;
  }

let types_module ~banner module_names =
  {
    H.banner;
    extensions = [ "OverloadedStrings" ];
    name = "Xynolog.Types";
    imports = List.map (fun m -> H.import m) module_names;
    body = List.map (fun m -> H.Reexport m) module_names;
  }

(* Each value of every enumeration the models declare: its enumeration's
   name, the value, what its constructor is written as, what the value is
   read and written back as, and, of words, its constructor's word. *)
let enumeration_cases enumerations =
  let case name worded (v : Schema.literal) =
    let constructor = Models.constructor name v in
    let wire = Models.literal_value v in
    H.Tuple
      [
        Str name;
        wire;
        Apply (Name "toJSON", [ Name constructor ]);
        Apply
          ( Name "fmap",
            [
              Name "toJSON";
              Typed
                ( Apply (Name "parseEither", [ Name "parseJSON"; wire ]),
                  T_apply ("Either", [ T_name "String"; T_name name ]) );
            ] );
        (if worded then
           Apply
             ( Name "Just",
               [ Apply (Name (Models.words_of name), [ Name constructor ]) ] )
         else Name "Nothing");
      ]
  in
  H.Value
    {
      about = [];
      name = "enumerationCases";
      type_ =
        T_list
          (T_tuple
             [
               T_name "Text";
               T_name "Value";
               T_name "Value";
               T_apply ("Either", [ T_name "String"; T_name "Value" ]);
               T_apply ("Maybe", [ T_name "Text" ]);
             ]);
      clauses =
        [
          {
            patterns = [];
            body =
              List
                (List.concat_map
                   (fun (name, values) ->
                     List.map
                       (case name (Option.is_some (Models.words values)))
                       values)
                   enumerations);
          };
        ];
    }

(* A value [s] admits: its first stated value, else one of its kind, a text
   its pattern admits, and an object of its required members and of each
   fixed one at its first value. *)
let admitted ~union ~variant (s : Typing.signature) =
  match s.values with
  | Some (v :: _) -> Ok (Models.literal_value v)
  | _ -> (
      match s.kind with
      | Text_kind -> (
          match s.pattern with
          | None -> Ok (value (`String ""))
          | Some pattern -> (
              match Text_patterns.admitted pattern with
              | Some text -> Ok (value (`String text))
              | None ->
                  Error
                    (Printf.sprintf
                       "%s: no text of ASCII its member %s's pattern %s admits \
                        is spelled"
                       union variant pattern)))
      | Integer_kind -> Ok (value (`Int 0))
      | Number_kind ->
          Ok (H.Apply (Name "Number", [ Apply (Name "read", [ Str "0.5" ]) ]))
      | Boolean_kind -> Ok (value (`Bool false))
      | List_kind -> Ok (H.Apply (Name "Array", [ Name "mempty" ]))
      | Null_kind | Any_kind -> Ok (H.Name "Null")
      | Object_kind ->
          let fixed = List.map fst s.fixed in
          Ok
            (H.Apply
               ( Name "Object",
                 [
                   Apply
                     ( Name "KM.fromList",
                       [
                         List
                           (List.map
                              (fun name ->
                                H.Tuple
                                  [
                                    Str name;
                                    (match List.assoc_opt name s.fixed with
                                    | Some (v :: _) -> Models.literal_value v
                                    | _ -> Name "Null");
                                  ])
                              (s.required
                              @ List.filter
                                  (fun name -> not (List.mem name s.required))
                                  fixed));
                       ] );
                 ] )))

(* Each member of every union the models declare, by the union's name: its
   variant, and each of its signatures with a value it admits, which the
   test reads as that member. *)
let union_members unions =
  let ( let* ) = Result.bind in
  let* listed =
    Normalize.all
      (List.map
         (fun (union, members) ->
           let* members =
             Normalize.all
               (List.map
                  (fun (b : Typing.branch) ->
                    let* signed =
                      Normalize.all
                        (List.map
                           (fun s ->
                             Result.map
                               (fun v -> H.Tuple [ Models.signature s; v ])
                               (admitted ~union ~variant:b.variant s))
                           b.signature)
                    in
                    Ok (H.Tuple [ Str b.variant; List signed ]))
                  members)
           in
           Ok (H.Tuple [ Str union; List members ]))
         unions)
  in
  Ok
    (H.Value
       {
         about = [];
         name = "unionMembers";
         type_ =
           T_list
             (T_tuple
                [
                  T_name "Text";
                  T_list
                    (T_tuple
                       [
                         T_name "Text";
                         T_list (T_tuple [ T_name "Signature"; T_name "Value" ]);
                       ]);
                ]);
         clauses = [ { patterns = []; body = List listed } ];
       })

let round_trip_module ~banner ~enumerations ~unions names =
  let ( let* ) = Result.bind in
  let* members = union_members unions in
  Ok
    {
      H.banner;
      extensions = [ "OverloadedStrings" ];
      name = "Xynolog.Internal.Generated.RoundTrip";
      imports =
        [
          H.import "Data.Aeson"
            ~items:[ All "Value"; Plain "parseJSON"; Plain "toJSON" ];
          H.import "Data.Aeson.KeyMap" ~qualified:"KM";
          H.import "Data.Aeson.Types" ~items:[ Plain "parseEither" ];
          H.import "Data.Text" ~items:[ Plain "Text" ];
          H.import "Xynolog.Internal.Codec"
            ~items:[ All "Kind"; All "Signature" ];
          H.import "Xynolog.Types";
        ];
      body =
        [
          Value
            {
              about = [];
              name = "roundTrip";
              type_ =
                T_fun
                  ( T_name "Text",
                    T_fun
                      ( T_name "Value",
                        T_apply ("Either", [ T_name "String"; T_name "Value" ])
                      ) );
              clauses =
                [
                  {
                    patterns = [ Var "name"; Var "value" ];
                    body =
                      Case
                        ( Name "name",
                          List.map
                            (fun n ->
                              ( H.Literal n,
                                H.Infix
                                  ( Name "toJSON",
                                    [
                                      ( "<$>",
                                        Typed
                                          ( Apply
                                              ( Name "parseEither",
                                                [
                                                  Name "parseJSON"; Name "value";
                                                ] ),
                                            T_apply
                                              ( "Either",
                                                [ T_name "String"; T_name n ] )
                                          ) );
                                    ] ) ))
                            names
                          @ [
                              ( Otherwise,
                                Apply
                                  ( Name "Left",
                                    [
                                      Str
                                        "unknown schema in round-trip \
                                         dispatcher";
                                    ] ) );
                            ] );
                  };
                ];
            };
          enumeration_cases enumerations;
          members;
        ];
    }
