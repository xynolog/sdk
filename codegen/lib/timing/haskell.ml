(* The timing as the Haskell SDK reads it: a value per entry under its name
   (haskell/sdk/src/Xynolog/Timing.hs), a duration or a count an Integer and
   a retry budget a RetryBudget, the model of client/RetryBudget.json; Settings, a field per entry, and the
   table's values as one (generated/.../TimingSettings.hs), which
   Xynolog.Timing.Settings overrides; and each entry's value as JSON, by its
   name, for the tests (test/.../TimingValues.hs). *)

module H = Haskell_syntax

let banner = Banner.lines ~from_:("protocol/specs/src/" ^ Table.file) __FILE__

(* A budget's members, each with its field's name in the model. *)
let budget = [ "attempts"; "initialDelayMs"; "maxDelayMs" ]

let budget_field member =
  Haskell_sdk.Models.lower "RetryBudget" ^ Haskell_sdk.Models.identifier member

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

let settings (t : Table.t) =
  let names = List.map (fun (e : Table.entry) -> e.name) t in
  {
    H.banner;
    extensions = [ "OverloadedStrings" ];
    name = "Xynolog.Internal.Generated.TimingSettings";
    imports =
      [
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
        H.import "Xynolog.Types" ~items:[ Plain "RetryBudget" ];
      ];
    body =
      [
        H.record "Settings"
          (List.map
             (fun (e : Table.entry) ->
               (e.name, type_of ~budget_type:"RetryBudget" e))
             t)
          ~deriving:[ "Eq"; "Show" ];
        H.value "protocolSettings" (T_name "Settings")
          (Construct
             ("Settings", List.map (fun n -> (n, H.Name ("Base." ^ n))) names));
        to_object ~type_:"Settings" (List.map (fun n -> (n, n)) names);
        is_object ~type_:"Settings" ~members:names
          ~unknown:"Unknown timing member" ~negative:"Negative timing member"
          ~constructor:"Settings"
          ~fields:
            (List.filter_map
               (fun (e : Table.entry) ->
                 if is_budget e then None else Some e.name)
               t);
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
  [
    file "src" (timing t); file "generated" (settings t); file "test" (values t);
  ]
