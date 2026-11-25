(* The connection states group: the states of a client's stream and the
   moves between them (protocol/specs/src/client/connection-states.json),
   over each SDK's generated ConnectionState, for the Go, Python, Rust,
   TypeScript, Kotlin and Swift SDKs, whose transports refuse a move the
   table does not list. The Haskell SDK's group writes its moves from the
   same Table. *)

module Table = Table
module Go = Go
module Python = Python
module Rust = Rust
module Typescript = Typescript
module Kotlin = Kotlin
module Swift = Swift

let files ~root:_ (spec : Spec.t) =
  let t = Table.derive spec in
  Ok
    [
      Go.file t;
      Python.file t;
      Rust.file t;
      Typescript.file t;
      Kotlin.file t;
      Swift.file t;
    ]
