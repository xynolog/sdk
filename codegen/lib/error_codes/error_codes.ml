(* The error-codes group: the codes a client reports a failure under
   (protocol/specs/src/errors/codes.json), the bus code each of the wire's own
   codes becomes and the transport code each HTTP status becomes, for the Go,
   Python, TypeScript, OCaml, Haskell and Kotlin SDKs. Table derives them and
   holds the table to the wire's codes (CommandError.code); Go, Python,
   Typescript, Ocaml, Haskell and Kotlin write them. *)

module Table = Table
module Go = Go
module Python = Python
module Typescript = Typescript
module Ocaml = Ocaml
module Rust = Rust
module Haskell = Haskell
module Kotlin = Kotlin

let files ~root:_ (spec : Spec.t) =
  let ( let* ) = Result.bind in
  let* t =
    Table.derive ~rpc_codes:spec.tables.control_rpc_codes
      spec.tables.errors_codes
  in
  let* ocaml = Ocaml.files t in
  let* types = Kotlin_sdk.types_of spec in
  let* kotlin =
    Kotlin_sdk.written ~from_:Table.file (fun () -> Kotlin.file ~types t)
  in
  Ok
    ([ Go.file t; Python.file t; Typescript.file t; Rust.file t; kotlin ]
    @ ocaml @ Haskell.files t)
