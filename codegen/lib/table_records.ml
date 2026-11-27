(* The records Protocol states inside a table rather than in files of their
   own, or that a table names by their [$id], and how a [$ref] names one. *)

let ( let* ) = Result.bind

(* Where a [$ref] points: the file it names, and the place in it when it names
   one. A record stated inside a table is named by both. *)
let key ids (r : Decode.reference) =
  match Decode.resolve ids r with
  | file, "" -> file
  | file, pointer -> file ^ "#" ^ pointer

(* A record at [key] in a table: one the table names by its [$id] is its
   schema's, keyed by its file. *)
let stated (spec : Spec.t) (key, (s : Schema.t)) =
  match s with
  | Schema.Schema ({ ref_ = Some r; _ } as l)
    when Schema.keywords l = [ "$ref" ] -> (
      match Decode.resolve spec.ids r with
      | file, "" -> (
          match List.assoc_opt file spec.schemas with
          | Some schema -> Ok (file, schema)
          | None -> Error (key ^ " names " ^ file ^ ", which is no schema"))
      | file, pointer ->
          Error (key ^ " names " ^ file ^ "#" ^ pointer ^ ", within a schema"))
  | s -> Ok (key, s)

(* Each record, by the file and pointer a [$ref] names it by, and named by its
   title: the types a registry of knowledge bases hands its caller, why a
   session ended, the stored session, a
   sign-in pending its redirect, and where each stream was. The stored
   cache document is none: its entry is a tuple ([prefixItems]), which no
   writer of types reads, and each SDK's reader of it is held to it
   ([Stored]). *)
let all (spec : Spec.t) : ((string * string * Schema.t) list, string) result =
  let t = spec.tables in
  let within file member =
    List.map (fun (name, s) ->
        (file ^ "#/" ^ member ^ "/" ^ Decode.escape name, s))
  in
  let titled found entry =
    Result.bind found (fun found ->
        let* key, s = stated spec entry in
        match s with
        | Schema.Schema { title = Some title; _ } ->
            Ok ((key, title, s) :: found)
        | _ -> Error (key ^ " states a record with no title"))
  in
  Result.map List.rev
  @@ List.fold_left titled (Ok [])
       (within "client/registry.json" "types" t.client_registry.types
       @ [
           ("session/cases.json#/told", t.session_cases.told);
           ( "session/stored.json#/storedSession",
             t.session_stored.stored_session );
           ( "session/stored.json#/pendingAuthorization",
             t.session_stored.pending_authorization );
           ("session/stored.json#/lastEventIds", t.session_stored.last_event_ids);
         ])
