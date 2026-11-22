(* The case-data group: each case table's rows, as typed values of the model
   Protocol's reader derives from its schema (Model), for each SDK whose
   tests run the table (Case_coverage), and each other table or schema an
   SDK's tests read (Test_reads). A test keeps its own loop, which says
   how a row becomes a call on the SDK, and reads the rows from here, not
   from Protocol: so an SDK's tests read no file of Protocol, and a change
   to a table's shape is a compile error in each SDK that runs it. *)

module M = Xynolog_protocol_model.Model
module Walk = Walk
module Ocaml = Ocaml
module Typescript = Typescript

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

(* How this group writes an SDK's modules: the files of the module [name]
   for the SDK's tests [tests] that read it, the name those tests read it by,
   which coverage_census.exe looks for in each, and its writers of a table's
   rows and of a schema. *)
type language = {
  paths : tests:string list -> string -> string list;
  reference : string -> string;
  table : path:string -> M.model -> Walk.value -> Output.file;
  schema : path:string -> string -> Yojson.Safe.t -> Output.file;
}

(* Each package of the TypeScript SDK that [tests] are of: the directory
   under typescript/ each is in. *)
let typescript_packages tests =
  List.fold_left
    (fun found test ->
      match String.split_on_char '/' test with
      | "typescript" :: package :: _ :: _ ->
          if List.mem package found then found else found @ [ package ]
      | _ -> invalid_arg (test ^ " is no file of a TypeScript package"))
    [] tests

(* None for an SDK whose writer this group does not have yet. *)
let language : Coverage_sdk.t -> language option = function
  | Ocaml ->
      Some
        {
          paths =
            (fun ~tests:_ name -> [ "ocaml/sdk/test/cases/" ^ name ^ ".ml" ]);
          reference =
            (fun name -> "Protocol_cases." ^ String.capitalize_ascii name);
          table = Ocaml.file;
          schema = Ocaml.schema;
        }
  | Typescript ->
      (* A package's tests read no other's sources, as each package's
         rootDir is its src/: so each package whose tests read a module has
         its own. *)
      Some
        {
          paths =
            (fun ~tests name ->
              List.map
                (fun package ->
                  "typescript/" ^ package ^ "/src/__tests__/cases/" ^ name
                  ^ ".ts")
                (typescript_packages tests));
          reference = (fun name -> "cases/" ^ name);
          table = Typescript.file;
          schema = Typescript.schema;
        }
  | Python | Rust | Go | Csharp | Haskell | Kotlin | Swift -> None

(* The tests of [sdk] that read [file], under specs/src: that run it, as a
   case table, or read it, as another table or a schema. *)
let tests sdk file =
  (match List.assoc_opt file Case_coverage.tables with
    | Some coverage -> (
        match coverage sdk with
        | Case_coverage.Run_by tests -> tests
        | Absent _ | Not_yet_reached _ -> [])
    | None -> [])
  @ List.concat_map
      (fun (read, tests) -> if Test_reads.file read = file then tests else [])
      (Test_reads.reads sdk)

(* Each schema an SDK's tests read. *)
let schemas =
  List.concat_map
    (fun sdk ->
      List.filter_map
        (function Test_reads.Schema file, _ -> Some file | Table _, _ -> None)
        (Test_reads.reads sdk))
    Coverage_sdk.all
  |> List.sort_uniq compare

let refusal message =
  { Decode.file = "protocol/specs/src"; pointer = ""; message }

let files ~root (_ : Spec.t) =
  let specs = Filename.concat root "protocol/specs/src" in
  (* Each file of the module [name], of [file], with its SDK's writers. *)
  let homes file name =
    List.concat_map
      (fun sdk ->
        match (language sdk, tests sdk file) with
        | None, _ | Some _, [] -> []
        | Some language, tests ->
            List.map (fun path -> (language, path)) (language.paths ~tests name))
      Coverage_sdk.all
  in
  match M.derive specs with
  | Error refusals -> Error (List.map refusal refusals)
  | Ok { tables; harness = _ } ->
      let table (model : M.model) =
        match homes model.path model.model_name with
        | [] -> Ok []
        | homes ->
            Result.map
              (fun rows ->
                List.map (fun (l, path) -> l.table ~path model rows) homes)
              (Result.bind
                 (Decode.parse_file ~root:specs model.path)
                 (Walk.table model))
      and schema file =
        match homes file (schema_module file) with
        | [] -> Ok []
        | homes ->
            Result.map
              (fun json ->
                List.map (fun (l, path) -> l.schema ~path file json) homes)
              (Decode.parse_file ~root:specs file)
      in
      let written, refused =
        List.partition_map
          (function Ok files -> Left files | Error e -> Right e)
          (List.map table tables @ List.map schema schemas)
      in
      if refused = [] then Ok (List.concat written) else Error refused
