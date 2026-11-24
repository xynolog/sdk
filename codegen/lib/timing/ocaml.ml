(* The timing as the OCaml SDK reads it (ocaml/sdk/lib/client_timing.ml): a
   value per entry under its name in snake case, a duration or a count as an
   int and a retry budget as a record. *)

module O = Ocaml_syntax

let banner = Banner.ocaml ~from_:("protocol/specs/src/" ^ Table.file) __FILE__

let retry =
  O.type_declaration "retry"
    (Record
       (List.map
          (fun field -> (field, O.type_ "int"))
          [ "attempts"; "initial_delay_ms"; "max_delay_ms" ]))

let name (e : Table.entry) = Text.snake e.name

let files (t : Table.t) =
  [
    O.implementation ~path:"ocaml/sdk/lib/client_timing.ml" ~banner
      (O.type_item retry
      :: List.map
           (fun (e : Table.entry) ->
             O.let_ (name e)
               (match e.value with
               | Duration n | Count n -> O.int n
               | Budget b ->
                   O.record
                     [
                       ("attempts", O.int b.attempts);
                       ("initial_delay_ms", O.int b.initial_delay_ms);
                       ("max_delay_ms", O.int b.max_delay_ms);
                     ]))
           t);
    O.interface ~path:"ocaml/sdk/lib/client_timing.mli" ~banner
      (O.type_spec retry
      :: List.map
           (fun (e : Table.entry) ->
             O.val_ (name e)
               (O.type_ (match e.value with Budget _ -> "retry" | _ -> "int")))
           t);
  ]
