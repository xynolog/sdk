(* The schemas a generation is rooted on, by name: every schema of Protocol,
   each a whole file, but the schema ([Places.schema_of]) of a case table, of
   a service table ([service_tables]) or of one of [unrooted_tables], a table's
   record, which is named by its title ([Table_records]), the sign-in store's
   entry ([sign_in_entry]), which each SDK's sign-in store roots of its own, the two
   that describe tables ([Places.case_table], [Places.json_schema]) and the
   client types ([client_types]), which a client roots of its own
   ([Definitions.client_roots]). A component schema is named as the
   gateway's document names it; any other by its file's stem, its reference
   the file's to itself. Protocol's schemas are one flat namespace, so
   [Definitions.bundle] refuses two of one name. *)

(* What a client hands its callers that no wire message carries: each file of
   protocol/specs/src/client/types, and the records of the registry. *)
let client_types = "client/types/"

(* One entry of the sign-in store [xynolog login] keeps. *)
let sign_in_entry = "sign-in-store/SignIn.json"

(* The entry's name, its file's stem. *)
let sign_in_name = Filename.remove_extension (Filename.basename sign_in_entry)

(* The tables the services keep to, which every SDK carries for them, each
   read as its own schema's model ([Places.schema_of]): every table of a
   service's area ([Places.services]) and of the services' shared
   environment, telemetry and jobs that is no case table, and the bounds of
   the bus's replies. *)
let service_tables (spec : Spec.t) =
  let areas =
    Places.services @ [ "service-environment"; "service-telemetry"; "jobs" ]
  in
  List.filter
    (fun table ->
      (match String.index_opt table '/' with
        | Some at -> List.mem (String.sub table 0 at) areas
        | None -> false)
      && not (Places.is_case_table table))
    spec.table_files
  @ [ "bus/reply-bounds.json" ]

(* The tables whose schemas [all] does not root, each with why. Every other
   table that is no case table and no service table is rooted, its schema
   named as its file is. *)
let unrooted_tables =
  [
    (* A channel's validate is an anyOf of { "type": "null" } and a $ref to a
       member, which is written in its place: a null form no writer reads. *)
    "bus/registry.json";
    (* Its content is schemas, whose records each SDK types already. *)
    "client/registry.json";
    (* Its cases, which conformance alone reads, hold a step union no writer
       knows. *)
    "client/state-units.json";
    (* A method's returns is a null form no writer reads, as the registry's
       validate is. *)
    "client/surface.json";
    (* Its schema describes the document alone, whose contents each SDK
       generates; a ClientTiming of an SDK's is the options record a caller
       hands its client. *)
    "client/timing.json";
    (* Its schema describes the document alone, whose contents each SDK
       generates; a ControlMethods of an SDK's is the catalog of methods
       generated from it. *)
    "control/methods.json";
    (* The Haskell SDK carries it, typed by its schema, in Xynolog.Tables, and
       the Kotlin SDK in xynolog.Tables. *)
    "locales/registry.json";
    (* The TypeScript, Swift and Haskell SDKs carry it, typed by its schema. *)
    "retry/rules.json";
    (* Its content is schemas, whose records each SDK types already. *)
    "session/stored.json";
  ]

let all (spec : Spec.t) =
  let components = spec.gateway.components.schemas in
  let component_files =
    List.map (fun (_, r) -> fst (Decode.resolve spec.ids r)) components
  in
  List.iter
    (fun table ->
      if not (List.mem table spec.table_files) then
        failwith (table ^ ", which all does not root, is no table of Protocol's"))
    unrooted_tables;
  let service = service_tables spec in
  let table_schemas =
    List.map Places.schema_of
      (List.filter
         (fun table ->
           Places.is_case_table table || List.mem table service
           || List.mem table unrooted_tables)
         spec.table_files)
  in
  let records =
    match Table_records.all spec with
    | Ok records -> List.map (fun (key, _, _) -> key) records
    | Error message -> failwith message
  in
  let rooted file =
    (not (String.contains file '#'))
    && (not (List.mem file component_files))
    && (not (List.mem file table_schemas))
    && (not (List.mem file records))
    && file <> Places.case_table && file <> Places.json_schema
    && file <> sign_in_entry
    && not (String.starts_with ~prefix:client_types file)
  in
  components
  @ List.filter_map
      (fun (file, _) ->
        if rooted file then
          Some
            ( Filename.remove_extension (Filename.basename file),
              { Decode.target = Filename.basename file; file; pointer = "" } )
        else None)
      spec.schemas
