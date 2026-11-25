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

let discovery_absent_type = "DiscoveryAbsentReason"

let discovery_absent_constant reason =
  discovery_absent_type ^ Naming.variant reason

(* Why a client that read a launcher's discovery document found no launcher
   (protocol/specs/src/client/discovery-absent.json): a constant a reason. *)
let discovery_absent (spec : Spec.t) =
  let name = discovery_absent_type in
  [
    G.Type
      {
        doc = G.prose (name ^ " is why no launcher was found.");
        name;
        def = G.Is (G.Named "string");
      };
    G.Consts
      {
        doc = [];
        spacing = Packed;
        specs =
          List.map
            (fun (r : Tables.Client_discovery_absent.reasons_item) ->
              let constant = discovery_absent_constant r.reason in
              G.spec
                ~doc:(G.prose (constant ^ ": " ^ r.docs))
                ~type_:(G.Named name) constant (G.Quoted r.reason))
            spec.tables.client_discovery_absent.reasons;
      };
  ]

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
   one: the generated types, the kinds of id and why no launcher was found. *)
let declared spec =
  let generated, identifiers = generated spec in
  generated.declared @ identifiers @ [ ("DiscoveryAbsentReason", None) ]

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
          decls = generated.decls @ discovery_absent spec;
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
