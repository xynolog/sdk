(* The timing as the OCaml SDK reads it (ocaml/sdk/lib/client_timing.ml): a
   value per entry under its name in snake case, a duration or a count as an
   int and a retry budget as the record of client/RetryBudget.json
   ([Records.Retry_budget]), which keeps no member beside its own. *)

module O = Ocaml_syntax

let banner = Banner.ocaml ~from_:("protocol/specs/src/" ^ Table.file) __FILE__
let budget = "Records.Retry_budget"
let name (e : Table.entry) = Text.snake e.name

let files (t : Table.t) =
  [
    O.implementation ~path:"ocaml/sdk/lib/client_timing.ml" ~banner
      (List.map
         (fun (e : Table.entry) ->
           O.let_ (name e)
             (match e.value with
             | Duration n | Count n -> O.int n
             | Budget b ->
                 O.record
                   [
                     (budget ^ ".attempts", O.int b.attempts);
                     ("initial_delay_ms", O.int b.initial_delay_ms);
                     ("max_delay_ms", O.int b.max_delay_ms);
                     ("extra", O.list []);
                   ]))
         t);
    O.interface ~path:"ocaml/sdk/lib/client_timing.mli" ~banner
      (List.map
         (fun (e : Table.entry) ->
           O.val_ (name e)
             (O.type_
                (match e.value with Budget _ -> budget ^ ".t" | _ -> "int")))
         t);
  ]
