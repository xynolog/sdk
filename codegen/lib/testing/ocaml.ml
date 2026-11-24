(* The testing kit's facts as the OCaml SDK reads them
   (ocaml/sdk/lib/testing_facts.ml): the faults, each drawn as likely as the
   others and a delay of the table's bounds, the delivery steps, the schedule's
   length and the slack. *)

module O = Ocaml_syntax
module T = Tables.Client_testing

let fault_constructor (fault : T.fault_actions_item) =
  String.capitalize_ascii (Text.snake fault.name)

let file (s : T.t) =
  let span (b : T.delay_ms) = b.maximum - b.minimum + 1 in
  let random_int bound =
    O.apply (O.ident "Random.State.int") [ O.ident "random"; O.int bound ]
  in
  O.implementation ~path:"ocaml/sdk/lib/testing_facts.ml"
    ~banner:(Banner.ocaml ~from_:Table.file __FILE__)
    [
      O.type_item
        (O.type_declaration "fault_action"
           (Variant
              (List.map
                 (fun (fault : T.fault_actions_item) ->
                   O.constructor (fault_constructor fault)
                     ~args:(if fault.holds = [] then [] else [ O.type_ "int" ]))
                 s.fault_actions)));
      O.type_item
        (O.type_declaration "delivery_op"
           (Variant
              (List.map
                 (fun op -> O.constructor (String.capitalize_ascii op))
                 s.delivery_ops.ops)));
      O.let_ "fault_actions"
        (O.fun_
           [ O.Pattern.var "random" ]
           (O.match_
              (random_int (List.length s.fault_actions))
              (List.mapi
                 (fun i (fault : T.fault_actions_item) ->
                   O.case (O.Pattern.int i)
                     (if fault.holds = [] then
                        O.construct (fault_constructor fault)
                      else
                        O.construct (fault_constructor fault)
                          ~arg:
                            (O.infix "+" (O.int s.delay_ms.minimum)
                               (random_int (span s.delay_ms)))))
                 s.fault_actions
              @ [ O.case O.Pattern.any O.assert_false ])));
      O.let_ "schedule_length"
        (O.tuple
           [ O.int s.schedule_length.minimum; O.int s.schedule_length.maximum ]);
      O.let_ "slack" (O.int s.slack.times);
    ]
