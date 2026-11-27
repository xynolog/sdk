(* The timing group: a client's deadlines, retry budgets, the cadence of its
   stream and what it keeps count of (protocol/specs/src/client/timing.json),
   for the Go, Python, TypeScript, Rust, OCaml, Haskell and Kotlin SDKs; the C#
   and Swift writers read the same Table, which holds every entry to the kind
   its name says and puts each a caller may set in its record. *)

module Table = Table
module Go = Go
module Python = Python
module Typescript = Typescript
module Ocaml = Ocaml
module Rust = Rust
module Haskell = Haskell
module Kotlin = Kotlin

let files ~root:_ (spec : Spec.t) =
  Result.map
    (fun t ->
      [ Python.file t; Typescript.file t; Rust.file t; Kotlin.file t ]
      @ Go.files t @ Ocaml.files t @ Haskell.files t)
    (Table.derive spec.tables.client_timing)
