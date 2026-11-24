(* What the Haskell SDK's models come with: Xynolog.Types, which exports every
   model module; the schemas the SDK validates against at run time, each
   without what only describes it; the service tables' values; and the
   dispatcher the round-trip tests decode and encode each model's examples
   by. *)

module H = Haskell_syntax

let ( let* ) = Result.bind

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

(* Xynolog.ServiceTables: each service table's rows as its type's value, and
   every table's path with its value as JSON, which the suite holds to the
   table. *)
let service_tables_module ~banner ~root (spec : Spec.t) =
  let* body =
    List.fold_left
      (fun found table ->
        let* found = found in
        let* rows = Service_tables.rows ~root table in
        Ok
          (H.value
             (Service_tables.value_name table)
             (T_name (Service_tables.name table))
             (Apply (Name "serviceTable", [ Str table; value rows ]))
          :: found))
      (Ok [])
      (Roots.service_tables spec)
  in
  let listed =
    H.value "serviceTables"
      (T_list (T_tuple [ T_name "Text"; T_name "Value" ]))
      (List
         (List.map
            (fun table ->
              H.Tuple
                [
                  Str table;
                  Apply
                    (Name "toJSON", [ Name (Service_tables.value_name table) ]);
                ])
            (Roots.service_tables spec)))
  in
  let body = List.rev body @ [ listed ] in
  let used = H.uses body in
  Ok
    {
      H.banner;
      extensions = [ "OverloadedStrings" ];
      name = "Xynolog.ServiceTables";
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
            H.import "Xynolog.Internal.ServiceTable"
              ~items:[ Plain "serviceTable" ];
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

let round_trip_module ~banner names =
  {
    H.banner;
    extensions = [ "OverloadedStrings" ];
    name = "Xynolog.Internal.Generated.RoundTrip";
    imports =
      [
        H.import "Data.Aeson"
          ~items:[ Plain "Value"; Plain "parseJSON"; Plain "toJSON" ];
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
      ];
  }
