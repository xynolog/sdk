(* The gateway HTTP group: what the gateway's HTTP surface states that an
   SDK's transport says (protocol/specs/src/openapi.json, its paths and
   schemas), for each SDK that does not generate its transport. Model reads
   it once; each writes its language's file. *)

module Model = Model
module Typescript = Typescript
module Rust = Rust
module Go = Go
module Python = Python
module Swift = Swift
module Kotlin = Kotlin
module Csharp = Csharp
module Ocaml = Ocaml

let files ~root:_ (spec : Spec.t) =
  Result.map
    (fun m ->
      [
        Typescript.file m;
        Rust.file m;
        Rust.archivist spec;
        Go.file m;
        Python.file m;
        Swift.file spec m;
        Kotlin.file m;
        Csharp.file m;
        Ocaml.file m;
      ])
    (Model.derive spec)
