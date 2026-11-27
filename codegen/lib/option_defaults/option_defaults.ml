(* The option-defaults group: what a public option of a client is when its
   caller leaves it out, where the client decides it
   (protocol/specs/src/client/option-defaults.json), for every SDK. Table
   holds each row to its option's type; each writer writes its language's
   file of the rows its SDK takes a default of, and names each other row with
   why its SDK takes none. *)

module Table = Table
module Typescript = Typescript
module Python = Python
module Rust = Rust
module Go = Go
module Csharp = Csharp
module Haskell = Haskell
module Kotlin = Kotlin
module Ocaml = Ocaml
module Swift = Swift

let files ~root:_ (spec : Spec.t) =
  match
    let t = Table.derive spec in
    [
      Typescript.file t;
      Python.file t;
      Rust.file t;
      Csharp.file t;
      Haskell.file t;
      Kotlin.file t;
      Swift.file t;
    ]
    @ Go.files t @ Ocaml.files t
  with
  | files -> Ok files
  | exception Definitions.Refused message ->
      Error [ { Decode.file = Table.file; pointer = ""; message } ]
