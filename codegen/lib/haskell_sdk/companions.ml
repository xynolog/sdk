(* What the Haskell SDK's models come with: Xynolog.Types, which exports every
   model module; the schemas the SDK validates against at run time, each
   without what only describes it; the carried tables' values; and the
   dispatcher the round-trip tests decode and encode each model's examples
   by. *)

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

let schemas_module ~banner definitions =
  let body =
    [
      H.value "schemas" (T_name "Schemas")
        (Apply
           ( Name "Map.fromList",
             [
               List
                 (List.map
                    (fun (name, schema) ->
                      H.Tuple [ Str name; value (Schema.runtime schema) ])
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

let round_trip_module ~banner ~enumerations names =
  {
    H.banner;
    extensions = [ "OverloadedStrings" ];
    name = "Xynolog.Internal.Generated.RoundTrip";
    imports =
      [
        H.import "Data.Aeson"
          ~items:[ All "Value"; Plain "parseJSON"; Plain "toJSON" ];
        H.import "Data.Aeson.Types" ~items:[ Plain "parseEither" ];
        H.import "Data.Text" ~items:[ Plain "Text" ];
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
                      T_apply ("Either", [ T_name "String"; T_name "Value" ]) )
                );
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
                                              [ Name "parseJSON"; Name "value" ]
                                            ),
                                          T_apply
                                            ( "Either",
                                              [ T_name "String"; T_name n ] ) )
                                    );
                                  ] ) ))
                          names
                        @ [
                            ( Otherwise,
                              Apply
                                ( Name "Left",
                                  [
                                    Str
                                      "unknown schema in round-trip dispatcher";
                                  ] ) );
                          ] );
                };
              ];
          };
        enumeration_cases enumerations;
      ];
  }
