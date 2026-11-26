(* The Go SDK's protocol types (go/api/types_gen.go): a type for every
   component schema of the gateway's document, every record Protocol states
   in its tables ([Table_records]) and the client types it generates, with every
   schema they reach, but the kinds of id, which go/api/ids_gen.go declares;
   and why no launcher was found. Beside them, the launcher's control API
   typed by those types ([Control], go/control/methods_gen.go), the retry
   rules ([Retry], go/retry_gen.go), the environment variables a service
   reads ([Environment], go/serviceenvironment_gen.go), the tables the
   services keep to ([Service_tables], go/servicetables/tables_gen.go) and the
   Archivist's routes ([Archivist_http], go/archivisthttp_gen.go). *)

module Generate = Generate
module Control = Control
module Environment = Environment
module Archivist_http = Archivist_http
module G = Go_syntax

let path = "go/api/types_gen.go"

(* Each table the services keep to ([Roots.service_tables]) is typed by its
   own schema ([Places.schema_of]), named as that schema's file is, and is a
   value of that type in package servicetables ([Service_tables]). *)
let table_model table = Definitions.stem (Places.schema_of table)

let generated (spec : Spec.t) =
  ( Generate.generate (Typing.of_spec spec ~tables:(Roots.service_tables spec)),
    List.map
      (fun (k : Tables.Identifiers_kinds.kinds_item) -> (k.schema, None))
      spec.tables.identifiers_kinds.kinds )

(* The fields of the struct package api declares of [name]. *)
let fields spec name =
  let generated, _ = generated spec in
  match
    List.find_map
      (function
        | G.Type { name = n; def = Struct { fields; _ }; _ } when n = name ->
            Some fields
        | _ -> None)
      generated.decls
  with
  | Some fields -> fields
  | None -> Definitions.refuse "%s: package api declares no struct of it" name

(* Every type package api declares, and what it is an alias of, if it is
   one: the generated types and the kinds of id. *)
let declared spec =
  let generated, identifiers = generated spec in
  generated.declared @ identifiers

let file spec =
  let generated, _ = generated spec in
  {
    Output.path;
    text =
      Go_syntax.text
        {
          header =
            Go_syntax.verbatim
              ("Code generated from the component schemas of \
                protocol/specs/src/openapi.json, the client types of \
                protocol/specs/src/client/types and \
                protocol/specs/src/client/discovery-absent.json — DO NOT \
                EDIT.\n\n\
                Regenerate: make generate (" ^ Banner.writer __FILE__ ^ ")");
          package = "api";
          imports = (match generated.imports with [] -> [] | used -> [ used ]);
          decls = generated.decls;
        };
  }

let files ~root (spec : Spec.t) =
  match
    let declared = List.map fst (declared spec) in
    [
      file spec;
      Control.file spec ~declared;
      Retry.file spec;
      Environment.file spec;
      Service_tables.file ~root spec ~table_model;
      Archivist_http.file spec;
    ]
  with
  | files -> Ok files
  | exception Definitions.Refused message ->
      Error [ { Decode.file = "openapi.json"; pointer = ""; message } ]
