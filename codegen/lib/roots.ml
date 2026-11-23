(* The schemas a generation is rooted on, by name: every schema of Protocol,
   each a whole file, but a table's own schema ([Places.schema_of]), a table's
   record, which is named by its title ([Table_records]), the sign-in store's
   entry ([sign_in_entry]), which each SDK's sign-in store roots of its own, the two
   that describe tables ([Places.case_table], [Places.json_schema]) and the
   client types ([client_types]), which a client roots of its own
   ([Definitions.client_roots]). A component schema is named as the
   gateway's document names it; any other by its file's stem, its reference
   the file's to itself. Protocol's schemas are one flat namespace, so
   [Definitions.bundle] refuses two of one name. *)

(* What a client hands its callers that no wire message carries: each file of
   protocol/specs/src/client/types, and the records of the registry and of the
   state units' notices. *)
let client_types = "client/types/"

(* One entry of the sign-in store [xynolog login] keeps. *)
let sign_in_entry = "sign-in-store/SignIn.json"

let all (spec : Spec.t) =
  let components = spec.gateway.components.schemas in
  let component_files =
    List.map (fun (_, r) -> fst (Decode.resolve spec.ids r)) components
  in
  let table_schemas = List.map Places.schema_of spec.table_files in
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
