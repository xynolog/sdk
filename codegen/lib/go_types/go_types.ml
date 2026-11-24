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
module G = Go_syntax

(* Why a client that read a launcher's discovery document found no launcher
   (protocol/specs/src/client/discovery-absent.json): a constant a reason. *)
let discovery_absent (spec : Spec.t) =
  let name = "DiscoveryAbsentReason" in
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
              let constant = name ^ Naming.variant r.reason in
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

(* Every schema a generation is rooted on, the service tables' included. *)
let definitions (spec : Spec.t) (bundle : Definitions.bundle) =
  let named name =
    match bundle.definitions.schema name with
    | _ -> true
    | exception Definitions.Refused _ -> false
  in
  let tables =
    List.map
      (fun table ->
        let file = Places.schema_of table and name = table_model table in
        if named name then
          raise
            (Definitions.Refused
               (Printf.sprintf
                  "%s, the schema of %s, is named as a schema already is" file
                  table));
        match List.assoc_opt file spec.schemas with
        | Some s -> (name, bundle.view (Normalize.shape_only s))
        | None ->
            raise
              (Definitions.Refused
                 (Printf.sprintf "%s has no schema %s" table file)))
      (Roots.service_tables spec)
  in
  ( {
      Definitions.names = bundle.definitions.names @ List.map fst tables;
      schema =
        (fun name ->
          match List.assoc_opt name tables with
          | Some s -> s
          | None -> bundle.definitions.schema name);
    },
    List.map fst tables )

(* The type each named map's keys are, where its schema's [propertyNames] is
   a whole schema of its own: LastEventIds is keyed by ResourceId. *)
let keys (spec : Spec.t) =
  let key_of = function
    | Schema.Schema
        { property_names = Some (Schema.Schema { ref_ = Some r; _ }); _ } -> (
        match Decode.resolve spec.ids r with
        | file, "" -> Some (Definitions.stem file)
        | _ -> None)
    | _ -> None
  in
  List.filter_map
    (fun (name, r) ->
      let file, _ = Decode.resolve spec.ids r in
      Option.map (fun s -> (name, s)) (List.assoc_opt file spec.schemas))
    (Roots.all spec)
  @ List.map (fun (_, name, s) -> (name, s)) (Definitions.records spec)
  |> List.filter_map (fun (name, s) ->
      Option.map (fun key -> (name, key)) (key_of s))

let generated (spec : Spec.t) =
  let bundle = Definitions.bundle spec in
  let definitions, tables = definitions spec bundle in
  let identifiers =
    List.map
      (fun (k : Tables.Identifiers_kinds.kinds_item) -> k.schema)
      spec.tables.identifiers_kinds.kinds
  in
  let roots =
    List.filter (fun n -> not (List.mem n identifiers)) bundle.definitions.names
    @ List.map (fun (_, name, _) -> name) (Definitions.records spec)
    @ Definitions.generated_client_types spec
    @ tables
  in
  ( Generate.generate definitions ~identifiers ~keys:(keys spec) roots,
    List.map (fun name -> (name, None)) identifiers )

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
