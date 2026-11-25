(* The testing kit's facts as the Haskell SDK reads them
   (haskell/sdk/generated/Xynolog/Internal/Generated/Testing.hs): the faults,
   each drawn as likely as the others and a delay of the table's bounds, the
   schedule's length, the slack, the delivery steps and the kit's records.
   Haskell's liveness spec holds the retry clock it runs under besides, and
   its faulty transport is the kit's own record, of Haskell's controls. *)

module H = Haskell_syntax
module T = Tables.Client_testing

let io_unit = H.T_apply ("IO", [ T_tuple [] ])

(* Each record member's Haskell type, by the record. *)
let member_types =
  [
    ( "RequestLogEntry",
      [
        ("channel", H.T_name "Text");
        ("action", T_name "FaultAction");
        ("correlationId", T_apply ("Maybe", [ T_name "Text" ]));
        ("retryKey", T_name "Text");
        ("payload", T_name "Object");
      ] );
    ( "LivenessScenario",
      [ ("outputs", H.T_list io_unit); ("settlements", T_list io_unit) ] );
    ( "LivenessSpec",
      [
        ( "setup",
          H.T_fun
            ( T_name "FaultyTransport",
              T_fun (T_fun (T_name "LivenessScenario", io_unit), io_unit) ) );
        ("timeoutMs", T_name "Integer");
        ("retryBudget", T_name "Integer");
        ("cases", T_name "Int");
        ("schedules", T_apply ("Gen", [ T_list (T_name "FaultAction") ]));
        ("makeResponse", T_name "Respond");
      ] );
  ]

let fields (record : T.records_item) typed =
  List.map
    (fun (member, t) ->
      (String.uncapitalize_ascii record.name ^ String.capitalize_ascii member, t))
    typed

let text (s : T.t) records =
  let constructor (fault : T.fault_actions_item) =
    H.constructor fault.name
      ~fields:(List.map (fun _ -> H.T_name "Integer") fault.holds)
  in
  let draw (fault : T.fault_actions_item) =
    match fault.holds with
    | [] -> H.Apply (Name "pure", [ Name fault.name ])
    | _ ->
        Infix
          ( Name fault.name,
            [
              ( "<$>",
                Apply
                  ( Name "chooseInteger",
                    [ Tuple [ Int s.delay_ms.minimum; Int s.delay_ms.maximum ] ]
                  ) );
            ] )
  in
  let kit_record name =
    let r, typed = Table.record name records in
    H.record ~about:[ r.docs ] ~constructor:r.name r.name (fields r typed)
  in
  let spec, spec_typed = Table.record "LivenessSpec" records in
  {
    Output.path = "haskell/sdk/generated/Xynolog/Internal/Generated/Testing.hs";
    text =
      H.text
        {
          banner = Banner.lines ~from_:Table.from_ __FILE__;
          extensions = [ "OverloadedStrings" ];
          name = "Xynolog.Internal.Generated.Testing";
          imports =
            [
              H.import "Data.Aeson" ~items:[ Plain "Object"; Plain "Value" ];
              H.import "Data.Text" ~items:[ Plain "Text" ];
              H.import "Xynolog.Retry" ~items:[ Plain "RetryOptions" ];
              H.import "Xynolog.Transport"
                ~items:[ Plain "Transport"; Plain "Carried" ];
              H.import "Test.QuickCheck"
                ~items:[ Plain "Gen"; Plain "oneof"; Plain "chooseInteger" ];
            ];
          body =
            [
              H.data "FaultAction" ~deriving:[ "Eq"; "Show" ]
                (List.map constructor s.fault_actions);
              Value
                {
                  about = [];
                  name = "faultKind";
                  type_ = T_fun (T_name "FaultAction", T_name "Text");
                  clauses =
                    List.map
                      (fun (fault : T.fault_actions_item) ->
                        {
                          H.patterns =
                            [
                              Constructor
                                ( fault.name,
                                  List.map (fun _ -> H.Otherwise) fault.holds );
                            ];
                          body = Str fault.kind;
                        })
                      s.fault_actions;
                };
              H.data "DeliveryOp" ~about:[ s.delivery_ops.docs ]
                ~deriving:[ "Eq"; "Ord"; "Show"; "Enum"; "Bounded" ]
                (List.map
                   (fun op -> H.constructor (String.capitalize_ascii op))
                   s.delivery_ops.ops);
              Value
                {
                  about = [];
                  name = "deliveryOpName";
                  type_ = T_fun (T_name "DeliveryOp", T_name "Text");
                  clauses =
                    List.map
                      (fun op ->
                        {
                          H.patterns =
                            [ Constructor (String.capitalize_ascii op, []) ];
                          body = Str op;
                        })
                      s.delivery_ops.ops;
                };
              H.value "faultActions"
                (T_apply ("Gen", [ T_name "FaultAction" ]))
                (Apply (Name "oneof", [ List (List.map draw s.fault_actions) ]));
              H.value "scheduleLength" ~about:[ s.schedule_length.docs ]
                (T_tuple [ T_name "Int"; T_name "Int" ])
                (Tuple
                   [
                     Int s.schedule_length.minimum;
                     Int s.schedule_length.maximum;
                   ]);
              H.value "slack" ~about:[ s.slack.docs ] (T_name "Integer")
                (Int s.slack.times);
              H.alias "Respond"
                (T_fun
                   ( T_name "Text",
                     T_fun
                       ( T_name "Object",
                         T_apply
                           ("IO", [ T_apply ("Maybe", [ T_name "Value" ]) ]) )
                   ));
              kit_record "RequestLogEntry";
              H.record ~constructor:"FaultyTransport" "FaultyTransport"
                ~about:
                  [
                    "The transport owner fills this with its real carrier and \
                     its native controls.";
                  ]
                [
                  ("carrier", T_name "Transport");
                  ( "queueReply",
                    T_fun
                      ( T_name "Text",
                        T_fun
                          ( T_list (T_apply ("Maybe", [ T_name "Value" ])),
                            io_unit ) ) );
                  ( "refuseWhen",
                    T_fun
                      ( T_fun
                          ( T_name "Text",
                            T_fun
                              ( T_name "Object",
                                T_apply
                                  ( "IO",
                                    [ T_apply ("Maybe", [ T_name "Object" ]) ]
                                  ) ) ),
                        io_unit ) );
                  ( "requestLog",
                    T_apply ("IO", [ T_list (T_name "RequestLogEntry") ]) );
                  ("deliver", T_fun (T_name "Carried", io_unit));
                ];
              kit_record "LivenessScenario";
              H.record ~about:[ spec.docs ] ~constructor:spec.name spec.name
                (fields spec spec_typed
                @ [ ("livenessClock", T_name "RetryOptions") ]);
            ];
        };
  }

let file table =
  Result.map (text table) (Table.typed ~language:"Haskell" member_types table)
