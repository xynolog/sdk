(* The timing as the Haskell SDK reads it: a value per entry under its name
   (haskell/sdk/src/Xynolog/Timing.hs), a duration or a count an Integer and
   a retry budget a RetryBudget, the model of client/RetryBudget.json; for
   each record of what a caller may set, its type and the table's values of
   it (generated/.../ClientTiming.hs and TransportTiming.hs); Settings, a
   field per entry, which the SDK's own modules read, made of those records
   over the table's values (generated/.../TimingSettings.hs); and each
   entry's value as JSON, by its name, for the tests
   (test/.../TimingValues.hs). *)

module H = Haskell_syntax

let banner = Banner.lines ~from_:("protocol/specs/src/" ^ Table.file) __FILE__

(* A budget's members, each with its field's name in the model. *)
let budget = [ "attempts"; "initialDelayMs"; "maxDelayMs" ]
let budget_field = H.field "RetryBudget"

let budget_value = function
  | Table.Budget { attempts; initial_delay_ms; max_delay_ms } ->
      [ attempts; initial_delay_ms; max_delay_ms ]
  | Duration _ | Count _ -> invalid_arg "Timing.Haskell: no budget"

let is_budget (e : Table.entry) =
  match e.value with Budget _ -> true | Duration _ | Count _ -> false

let type_of ~budget_type (e : Table.entry) =
  H.T_name (if is_budget e then budget_type else "Integer")

let value (e : Table.entry) =
  match e.value with
  | Duration n | Count n -> H.Int n
  | Budget _ ->
      Construct
        ( "RetryBudget",
          List.map2
            (fun m n -> (budget_field m, H.Int n))
            budget (budget_value e.value) )

let is_object ~type_ ~members ~unknown ~negative ~constructor ~fields =
  let access f = H.Apply (Name f, [ Name "value" ]) in
  H.instance "FromJSON" (T_name type_)
    [
      H.method_ "parseJSON"
        (Dollar
           ( Apply (Name "withObject", [ Str type_ ]),
             Lambda
               ( "fields",
                 Do
                   [
                     Run
                       (Apply
                          ( Name "unless",
                            [
                              Apply
                                ( Name "all",
                                  [
                                    Section
                                      ( "elem",
                                        List
                                          (List.map (fun m -> H.Str m) members)
                                      );
                                    Apply (Name "KM.keys", [ Name "fields" ]);
                                  ] );
                              Apply (Name "fail", [ Str unknown ]);
                            ] ));
                     Bind
                       ( "value",
                         Infix
                           ( Name constructor,
                             List.mapi
                               (fun i m ->
                                 ( (if i = 0 then "<$>" else "<*>"),
                                   H.Infix (Name "fields", [ (".:", Str m) ]) ))
                               members ) );
                     Run
                       (Apply
                          ( Name "unless",
                            [
                              Apply
                                ( Name "all",
                                  [
                                    Section (">=", Int 0);
                                    List (List.map access fields);
                                  ] );
                              Apply (Name "fail", [ Str negative ]);
                            ] ));
                     Run (Apply (Name "pure", [ Name "value" ]));
                   ] ) ));
    ]

let to_object ~type_ pairs =
  H.instance "ToJSON" (T_name type_)
    [
      ( "toJSON",
        {
          patterns = [ Var "value" ];
          body =
            Apply
              ( Name "object",
                [
                  List
                    (List.map
                       (fun (m, f) ->
                         H.Infix
                           (Str m, [ (".=", Apply (Name f, [ Name "value" ])) ]))
                       pairs);
                ] );
        } );
    ]

let timing (t : Table.t) =
  {
    H.banner;
    extensions = [];
    name = "Xynolog.Timing";
    imports = [ H.import "Xynolog.Types" ~items:[ All "RetryBudget" ] ];
    body =
      List.map
        (fun (e : Table.entry) ->
          H.value e.name (type_of ~budget_type:"RetryBudget" e) (value e))
        t;
  }

let field_of (e : Table.entry) = (e.name, type_of ~budget_type:"RetryBudget" e)
let protocol record = "protocol" ^ Table.record_name record

let record_module record =
  "Xynolog.Internal.Generated." ^ Table.record_name record

let record (t : Table.t) record =
  let type_ = Table.record_name record in
  let members = Table.members record t in
  let names = List.map (fun (e : Table.entry) -> e.name) members in
  {
    H.banner;
    extensions = [ "OverloadedStrings" ];
    name = record_module record;
    imports =
      ([
         H.import "Control.Monad" ~items:[ Plain "unless" ];
         H.import "Data.Aeson"
           ~items:
             [
               All "FromJSON";
               All "ToJSON";
               Plain "withObject";
               Plain "object";
               Op ".:";
               Op ".=";
             ];
         H.import "Data.Aeson.KeyMap" ~qualified:"KM";
         H.import "Xynolog.Timing" ~qualified:"Base";
       ]
      @
      if List.exists is_budget members then
        [ H.import "Xynolog.Types" ~items:[ Plain "RetryBudget" ] ]
      else []);
    body =
      [
        H.record
          ~about:[ Table.record_docs record ]
          ~constructor:type_ type_
          (List.map field_of members)
          ~deriving:[ "Eq"; "Show" ];
        H.value (protocol record) (T_name type_)
          (Construct (type_, List.map (fun n -> (n, H.Name ("Base." ^ n))) names));
        to_object ~type_ (List.map (fun n -> (n, n)) names);
        is_object ~type_ ~members:names ~unknown:"Unknown timing member"
          ~negative:"Negative timing member" ~constructor:type_
          ~fields:
            (List.filter_map
               (fun (e : Table.entry) ->
                 if is_budget e then None else Some e.name)
               members);
      ];
  }

let settings (t : Table.t) =
  let qualified = function
    | Table.Client -> "Client"
    | Table.Transport -> "Transport"
  in
  let argument record = String.lowercase_ascii (qualified record) in
  let from (e : Table.entry) =
    ( e.name,
      match e.record with
      | Some record ->
          H.Apply
            (Name (qualified record ^ "." ^ e.name), [ Name (argument record) ])
      | None -> H.Name ("Base." ^ e.name) )
  in
  {
    H.banner;
    extensions = [];
    name = "Xynolog.Internal.Generated.TimingSettings";
    imports =
      List.map
        (fun record ->
          H.import (record_module record) ~qualified:(qualified record))
        Table.records
      @ [
          H.import "Xynolog.Timing" ~qualified:"Base";
          H.import "Xynolog.Types" ~items:[ Plain "RetryBudget" ];
        ];
    body =
      [
        H.record ~constructor:"Settings" "Settings" (List.map field_of t)
          ~deriving:[ "Eq"; "Show" ];
        Value
          {
            about =
              [ "A caller's records, over the table's values of every other." ];
            name = "settingsOf";
            type_ =
              List.fold_right
                (fun record result ->
                  H.T_fun
                    ( T_name (qualified record ^ "." ^ Table.record_name record),
                      result ))
                Table.records (H.T_name "Settings");
            clauses =
              [
                {
                  patterns =
                    List.map
                      (fun record -> H.Var (argument record))
                      Table.records;
                  body = Construct ("Settings", List.map from t);
                };
              ];
          };
      ];
  }

let values (t : Table.t) =
  {
    H.banner;
    extensions = [ "OverloadedStrings" ];
    name = "Xynolog.Internal.Generated.TimingValues";
    imports =
      [
        H.import "Data.Aeson" ~items:[ Plain "Value"; Plain "toJSON" ];
        H.import "Data.Text" ~items:[ Plain "Text" ];
        H.import "Data.Map.Strict" ~qualified:"Map";
        H.import "Xynolog.Timing";
      ];
    body =
      [
        H.value "timingValues"
          (T_apply ("Map.Map", [ T_name "Text"; T_name "Value" ]))
          (Apply
             ( Name "Map.fromList",
               [
                 List
                   (List.map
                      (fun (e : Table.entry) ->
                        H.Tuple
                          [ Str e.name; Apply (Name "toJSON", [ Name e.name ]) ])
                      t);
               ] ));
      ];
  }

let files t =
  let file under (m : H.module_) =
    {
      Output.path =
        "haskell/sdk/" ^ under ^ "/"
        ^ String.concat "/" (String.split_on_char '.' m.name)
        ^ ".hs";
      text = H.text m;
    }
  in
  [ file "src" (timing t) ]
  @ List.map (fun r -> file "generated" (record t r)) Table.records
  @ [ file "generated" (settings t); file "test" (values t) ]
