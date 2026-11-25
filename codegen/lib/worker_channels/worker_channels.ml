(* The worker channels group: each constant of client/surface.json that is
   the channels a stream names, resolved against bus/registry.json once
   (Table), for the Go, Python, Rust, TypeScript, Kotlin, Swift, C# and OCaml
   SDKs. The Haskell SDK's group writes its module of them from the same
   Table. *)

module Table = Table
module Go = Go
module Python = Python
module Rust = Rust
module Typescript = Typescript
module Kotlin = Kotlin
module Swift = Swift
module Csharp = Csharp
module Ocaml = Ocaml

let files ~root:_ (spec : Spec.t) =
  let constants = Table.all spec in
  Ok
    [
      Go.file constants;
      Python.file constants;
      Rust.file constants;
      Typescript.file constants;
      Kotlin.file constants;
      Swift.file constants;
      Csharp.file constants;
      Ocaml.file constants;
    ]
