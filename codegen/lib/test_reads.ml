(* The files of Protocol other than its case tables that an SDK's tests read,
   which the case-data group writes for them as it writes a case table's
   rows: a table, as values of its model; a schema, as the JSON it is, for a
   test that holds an SDK's own type to the members the schema states. *)

type read = Table of string | Schema of string

let reads : Coverage_sdk.t -> read list = function
  | Ocaml | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Swift
    ->
      []
