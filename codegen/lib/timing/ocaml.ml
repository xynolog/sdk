(* The timing as the OCaml SDK reads it (ocaml/sdk/lib/client_timing.ml): a
   value per entry under its name in snake case, a duration or a count as an
   int and a retry budget as the record of client/RetryBudget.json
   ([Records.Retry_budget]); and for each record of what a caller may set,
   its type, [client] or [transport], and the table's values of it. *)

module O = Ocaml_syntax

let banner = Banner.ocaml ~from_:("protocol/specs/src/" ^ Table.file) __FILE__
let budget = "Records.Retry_budget"
let name (e : Table.entry) = Text.snake e.name

let type_of (e : Table.entry) =
  O.type_ (match e.value with Budget _ -> budget ^ ".t" | _ -> "int")

let record_type = function
  | Table.Client -> "client"
  | Table.Transport -> "transport"

let defaults record = record_type record ^ "_defaults"

let declaration (t : Table.t) record =
  O.type_declaration (record_type record)
    (O.Record (List.map (fun e -> (name e, type_of e)) (Table.members record t)))

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
                   ]))
         t
      @ List.concat_map
          (fun record ->
            [
              O.type_item (declaration t record);
              O.let_
                ~type_:(O.type_ (record_type record))
                (defaults record)
                (O.record
                   (List.map
                      (fun e -> (name e, O.ident (name e)))
                      (Table.members record t)));
            ])
          Table.records);
    O.interface ~path:"ocaml/sdk/lib/client_timing.mli" ~banner
      (List.map (fun e -> O.val_ (name e) (type_of e)) t
      @ List.concat_map
          (fun record ->
            [
              O.type_spec (declaration t record);
              O.val_ (defaults record) (O.type_ (record_type record));
            ])
          Table.records);
  ]
