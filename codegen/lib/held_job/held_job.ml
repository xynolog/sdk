(* The held job group: each member of a worker's handed that is its record's
   (Table), written from the record's type as each SDK's types declare it. *)

module Table = Table
module Rust = Rust
module Go = Go
module Python = Python
module Kotlin = Kotlin
module Csharp = Csharp

let files ~root:_ (spec : Spec.t) =
  let records = Table.all spec in
  match
    [
      Rust.file spec records;
      Go.file spec records;
      Python.file spec records;
      Csharp.file spec records;
    ]
    @ List.map (Kotlin.file spec) records
  with
  | files -> Ok files
  | exception Definitions.Refused message ->
      Error
        [
          {
            Decode.file = "protocol/specs/src/" ^ Table.file;
            pointer = "";
            message;
          };
        ]
