(* The OCaml SDK's modules that no other group's table owns: the string
   enums, the selector, the records of the component schemas and of
   Protocol's tables, what its
   HTTP transport says, the bus's channels and the methods that are one
   each, the facts of tables no group writes for it, the launcher's control API,
   and the tables Protocol states for its services; and
   the repository's LICENSE, which its package ships. Each group that owns a
   table writes the OCaml SDK's module of it itself. *)

module Enums = Enums
module Selector = Selector
module Records = Records
module Http_facts = Http_facts
module Facts = Facts
module Bus_modules = Bus_modules
module Service_tables = Service_tables
module Control = Control

let files ~root (spec : Spec.t) =
  let ( let* ) = Result.bind in
  let* table =
    Result.map_error
      (fun message ->
        [ { Decode.file = "protocol/specs/src"; pointer = ""; message } ])
      (Table_records.all spec)
  in
  let* enums = Enums.derive spec table in
  let* selector = Selector.derive spec in
  let* records = Records.derive spec table in
  let* codes = Error_codes.Table.derive spec.tables.errors_codes in
  let* http = Http_facts.file codes in
  let* facts = Facts.files spec in
  let* user_field = User_stamp.field spec.tables.identifiers_kinds in
  let* bus =
    Bus.Registry.derive ~ids:spec.ids
      ~component:(Bus.Registry.component spec)
      ~user_field spec.tables.bus_registry
  in
  let* shapes = Required.derive spec in
  let* bus_modules = Bus_modules.files spec bus ~shapes:shapes.shapes in
  let* service_tables = Service_tables.files ~root spec in
  let* control = Control.file spec in
  let license =
    In_channel.with_open_bin
      (Filename.concat root "LICENSE")
      In_channel.input_all
  in
  Ok
    (Enums.files enums @ Selector.files selector @ Records.files records
   @ (http :: control :: facts) @ bus_modules @ service_tables
    @ [ { Output.path = "ocaml/sdk/LICENSE"; text = license } ])
