(* The case-data group: each case table's rows, as typed values of the model
   Protocol's reader derives from its schema (Model), for each SDK whose
   tests run the table (Case_coverage), and each other table or schema an
   SDK's tests read (Test_reads). A test keeps its own loop, which says
   how a row becomes a call on the SDK, and reads the rows from here, not
   from Protocol: so an SDK's tests read no file of Protocol, and a change
   to a table's shape is a compile error in each SDK that runs it. *)

module M = Xynolog_protocol_model.Model
module Walk = Walk

(* A schema's name as a module's: its path's words in snake case, as
   [Places.model_of] names a table's model: session/StoredSession.json is
   session_stored_session_schema. *)
let schema_module file =
  Filename.remove_extension file
  |> String.split_on_char '/'
  |> List.map (fun part ->
      Text.snake (String.map (function '-' -> '_' | c -> c) part))
  |> String.concat "_"
  |> fun name -> name ^ "_schema"

(* How this group writes an SDK's modules: the file of the module [name],
   the name its tests read it by, which coverage_census.exe looks for, and
   its writers of a table's rows and of a schema. *)
type language = {
  path : string -> string;
  reference : string -> string;
  table : path:string -> M.model -> Walk.value -> Output.file;
  schema : path:string -> string -> Yojson.Safe.t -> Output.file;
}

(* None for an SDK whose writer this group does not have yet. *)
let language : Coverage_sdk.t -> language option = function
  | Ocaml | Typescript | Python | Rust | Go | Csharp | Haskell | Kotlin | Swift
    ->
      None

(* The SDKs whose tests read [table]: run it, as a case table, or read it, as
   another table. *)
let readers table =
  List.filter
    (fun sdk ->
      (match List.assoc_opt table Case_coverage.tables with
        | Some coverage -> (
            match coverage sdk with
            | Case_coverage.Run_by _ -> true
            | Absent _ | Not_yet_reached _ -> false)
        | None -> false)
      || List.mem (Test_reads.Table table) (Test_reads.reads sdk))
    Coverage_sdk.all

(* Each schema an SDK's tests read, with the SDKs that read it. *)
let schemas =
  List.fold_left
    (fun found sdk ->
      List.fold_left
        (fun found -> function
          | Test_reads.Schema file ->
              let sdks = Option.value ~default:[] (List.assoc_opt file found) in
              (file, sdks @ [ sdk ]) :: List.remove_assoc file found
          | Table _ -> found)
        found (Test_reads.reads sdk))
    [] Coverage_sdk.all
  |> List.rev

let refusal message =
  { Decode.file = "protocol/specs/src"; pointer = ""; message }

let files ~root (_ : Spec.t) =
  let specs = Filename.concat root "protocol/specs/src" in
  match M.derive specs with
  | Error refusals -> Error (List.map refusal refusals)
  | Ok { tables; harness = _ } ->
      let written, refused =
        List.fold_left
          (fun (written, refused) (model : M.model) ->
            match readers model.path with
            | [] -> (written, refused)
            | sdks -> (
                match
                  Result.bind
                    (Decode.parse_file ~root:specs model.path)
                    (Walk.table model)
                with
                | Error e -> (written, e :: refused)
                | Ok rows ->
                    ( written
                      @ List.filter_map
                          (fun sdk ->
                            Option.map
                              (fun l ->
                                l.table ~path:(l.path model.model_name) model
                                  rows)
                              (language sdk))
                          sdks,
                      refused )))
          ([], []) tables
      in
      let written, refused =
        List.fold_left
          (fun (written, refused) (file, sdks) ->
            match Decode.parse_file ~root:specs file with
            | Error e -> (written, e :: refused)
            | Ok json ->
                ( written
                  @ List.filter_map
                      (fun sdk ->
                        Option.map
                          (fun l ->
                            l.schema
                              ~path:(l.path (schema_module file))
                              file json)
                          (language sdk))
                      sdks,
                  refused ))
          (written, refused) schemas
      in
      if refused = [] then Ok written else Error (List.rev refused)

(* Each module this group writes, of [derived]'s tables and the schemas
   SDKs' tests read: its SDK, its name, and the file under specs/src it is
   of. *)
let modules ({ tables; harness = _ } : M.t) =
  List.concat_map
    (fun (model : M.model) ->
      List.map
        (fun sdk -> (sdk, model.model_name, model.path))
        (readers model.path))
    tables
  @ List.concat_map
      (fun (file, sdks) ->
        List.map (fun sdk -> (sdk, schema_module file, file)) sdks)
      schemas
  |> List.filter (fun (sdk, _, _) -> Option.is_some (language sdk))
