(* The worker's channels as the OCaml SDK holds them
   (ocaml/sdk/lib/worker_facts.ml, which Claims includes): a list of the bus
   registry's channels per constant, under its name in snake case. *)

module O = Ocaml_syntax

let path = "ocaml/sdk/lib/worker_facts.ml"

let file (constants : Table.t list) =
  O.implementation ~path
    ~banner:
      (Banner.ocaml
         ~from_:("protocol/specs/src/" ^ Table.file ^ " and bus/registry.json")
         __FILE__)
    (List.map
       (fun (c : Table.t) ->
         O.let_ (Text.snake c.member)
           (O.list
              (List.map
                 (fun n ->
                   O.construct "Bus_registry.Channel"
                     ~arg:
                       (O.ident
                          ("Bus_registry.Channels."
                          ^ Ocaml_sdk.Bus_modules.name_of n)))
                 c.channels)))
       constants)
