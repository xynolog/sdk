(* The SDKs, as the Makefile's LANGUAGES names them and in its order: the
   SDKs the coverage manifests, Case_coverage and Surface_coverage, speak of. *)
type t =
  | Typescript
  | Python
  | Rust
  | Go
  | Csharp
  | Haskell
  | Kotlin
  | Ocaml
  | Swift

let all =
  [ Typescript; Python; Rust; Go; Csharp; Haskell; Kotlin; Ocaml; Swift ]

let name = function
  | Typescript -> "typescript"
  | Python -> "python"
  | Rust -> "rust"
  | Go -> "go"
  | Csharp -> "csharp"
  | Haskell -> "haskell"
  | Kotlin -> "kotlin"
  | Ocaml -> "ocaml"
  | Swift -> "swift"
