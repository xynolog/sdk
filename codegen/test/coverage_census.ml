(* coverage_census.exe SDK: Case_coverage names every case table of the pinned
   Protocol and no other, and the SDKs the Makefile's LANGUAGES names, in its
   order; and for each table and SDK, either tests this checkout has under the
   SDK's directory that each read the table, or a reason. A test reads a
   table by the module the case-data group writes its rows to, where the
   group has a writer for the SDK, else by the table's path; and every
   module the group writes is read by a file of its SDK other than itself. A
   case table is a table of the model whose file name ends in cases.json
   (specs/README.md, "Case tables"). Surface_coverage names only items the pinned Protocol's
   client surface has, each once, with each SDK that lacks it once and a
   reason; that an SDK has an item it names nowhere is its own surface test's
   to hold. The readers annotations/reader-cases.json names are the readers of
   the surface's annotations module that no SDK lacks. SDK is the checkout's
   root. *)

open Xynolog_codegen

let root = Sys.argv.(1)
let read path = In_channel.with_open_bin path In_channel.input_all

(* Whether [text] names [part]: has it, followed by no character of a name,
   so a module's name does not name a longer one it begins. *)
let names text part =
  let n = String.length text and m = String.length part in
  let ends i =
    i + m = n
    ||
    match text.[i + m] with
    | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' -> false
    | _ -> true
  in
  let rec from i =
    i + m <= n && ((String.sub text i m = part && ends i) || from (i + 1))
  in
  from 0

let duplicates names =
  List.sort compare names
  |> List.fold_left
       (fun (previous, found) name ->
         ( Some name,
           if previous = Some name && not (List.mem name found) then
             name :: found
           else found ))
       (None, [])
  |> snd |> List.rev

let prefix = "LANGUAGES := "

let languages =
  read (Filename.concat root "Makefile")
  |> String.split_on_char '\n'
  |> List.find_map (fun line ->
      if String.starts_with ~prefix line then
        Some
          (String.sub line (String.length prefix)
             (String.length line - String.length prefix)
          |> String.split_on_char ' '
          |> List.filter (( <> ) ""))
      else None)

let spec =
  match Spec_shapes.load (Filename.concat root "protocol/specs/src") with
  | Error errors ->
      List.iter (fun e -> prerr_endline (Decode.error_to_string e)) errors;
      exit 1
  | Ok spec -> spec

module M = Xynolog_protocol_model.Model

let derived =
  match M.derive (Filename.concat root "protocol/specs/src") with
  | Error refusals ->
      List.iter prerr_endline refusals;
      exit 1
  | Ok derived -> derived

(* What a test of [sdk] that reads [table] names: the module the case-data
   group writes the table's rows to, else, for an SDK it has no writer for,
   the table's path; or, for a table the model does not derive, a refusal. *)
let reads_by sdk table =
  match Case_data.language sdk with
  | None -> Ok table
  | Some language -> (
      match
        List.find_opt (fun (m : M.model) -> m.path = table) derived.tables
      with
      | Some model -> Ok (language.reference model.model_name)
      | None -> Error "Protocol's reader derives no model of it")

let case_tables =
  List.filter
    (fun file -> String.ends_with ~suffix:"cases.json" file)
    spec.table_files

let named = List.map fst Case_coverage.tables

let sdk_refusals =
  let names = List.map Coverage_sdk.name Coverage_sdk.all in
  match languages with
  | None -> [ "the Makefile states no LANGUAGES" ]
  | Some languages when languages <> names ->
      [
        Printf.sprintf
          "Coverage_sdk.all names %s, and the Makefile's LANGUAGES %s"
          (String.concat " " names)
          (String.concat " " languages);
      ]
  | Some _ -> []

let table_refusals =
  List.map
    (Printf.sprintf "%s: Case_coverage names it more than once")
    (duplicates named)
  @ List.filter_map
      (fun table ->
        if List.mem table named then None
        else
          Some
            (Printf.sprintf
               "%s: a case table of the pinned Protocol that Case_coverage \
                does not name"
               table))
      case_tables
  @ List.filter_map
      (fun table ->
        if List.mem table case_tables then None
        else
          Some
            (Printf.sprintf
               "%s: Case_coverage names it, and the pinned Protocol has no \
                such case table"
               table))
      named

(* [where]'s refusals of [tests], each a test of [sdk] that reads what it
   names, [named]: a file under the SDK's directory, in the checkout, that
   names it. *)
let test_refusals where sdk tests named =
  List.map
    (Printf.sprintf "%s: names %s more than once" where)
    (duplicates tests)
  @ List.concat_map
      (fun test ->
        let path = Filename.concat root test in
        if not (String.starts_with ~prefix:(Coverage_sdk.name sdk ^ "/") test)
        then
          [
            Printf.sprintf "%s: %s is not under %s/" where test
              (Coverage_sdk.name sdk);
          ]
        else if not (Sys.file_exists path && not (Sys.is_directory path)) then
          [ Printf.sprintf "%s: %s is not in the checkout" where test ]
        else
          match named with
          | Error why -> [ Printf.sprintf "%s: %s" where why ]
          | Ok name when not (names (read path) name) ->
              [ Printf.sprintf "%s: %s does not name %s" where test name ]
          | Ok _ -> [])
      tests

let coverage_refusals table sdk =
  let where = Printf.sprintf "%s, %s" table (Coverage_sdk.name sdk) in
  match (List.assoc table Case_coverage.tables) sdk with
  | Case_coverage.Absent why | Case_coverage.Not_yet_reached why ->
      if String.trim why = "" then [ where ^ ": states no reason" ] else []
  | Case_coverage.Run_by [] -> [ where ^ ": names no test" ]
  | Case_coverage.Run_by tests ->
      test_refusals where sdk tests (reads_by sdk table)

(* What a test of [sdk] that reads the schema [file] names: the module the
   case-data group writes it to, else its path. *)
let schema_read_by sdk file =
  match Case_data.language sdk with
  | None -> file
  | Some language -> language.reference (Case_data.schema_module file)

let test_reads_refusals =
  List.concat_map
    (fun sdk ->
      List.concat_map
        (fun (read, tests) ->
          let where =
            Printf.sprintf "%s, %s" (Test_reads.file read)
              (Coverage_sdk.name sdk)
          in
          match (read, tests) with
          | _, [] -> [ where ^ ": Test_reads names no test" ]
          | Test_reads.Table table, tests ->
              test_refusals where sdk tests (reads_by sdk table)
          | Schema file, tests ->
              test_refusals where sdk tests (Ok (schema_read_by sdk file)))
        (Test_reads.reads sdk))
    Coverage_sdk.all

(* Each directory the case-data group writes to holds what it writes and
   no other module: one it no longer writes is no test's. *)
let stale_refusals =
  let written = Case_data.paths derived in
  List.sort_uniq compare (List.map Filename.dirname written)
  |> List.concat_map (fun dir ->
      Sys.readdir (Filename.concat root dir)
      |> Array.to_list |> List.sort compare
      |> List.filter_map (fun name ->
          let path = Filename.concat dir name in
          if name = "dune" || List.mem path written then None
          else
            Some
              (Printf.sprintf
                 "%s: the case-data group writes no such module, so no test \
                  reads it"
                 path)))

module Surface = Tables.Client_surface

let module_member_name : Surface.modules_item_members_item -> string = function
  | Reader m -> m.member
  | Function m -> m.member
  | Type m -> m.member
  | Constant m -> m.member

(* Every item of the pinned Protocol's surface that Surface_coverage can name. *)
let surface_items =
  let surface = spec.tables.client_surface in
  List.concat_map
    (fun (m : Surface.modules_item) ->
      Surface_coverage.Module m.module_
      :: List.map
           (fun member ->
             Surface_coverage.Module_member
               (m.module_, module_member_name member))
           m.members)
    surface.modules
  @ List.concat_map
      (fun (w : Surface.worker_item) ->
        List.map
          (fun (member : Surface.members_item) ->
            Surface_coverage.Worker_member (w.handed, member.member))
          w.members)
      surface.worker
  @ List.concat_map
      (fun (u : Surface.state_units_item) ->
        List.map
          (fun (member : Surface.item_members_item) ->
            Surface_coverage.State_unit_member (u.unit, member.member))
          u.members)
      surface.state_units
  @ List.map
      (fun (member : Surface.wire_members_item) ->
        Surface_coverage.Wire_member member.member)
      surface.wire.members

let item_name = function
  | Surface_coverage.Module m -> "module " ^ m
  | Module_member (m, member) -> Printf.sprintf "module %s's %s" m member
  | Worker_member (handed, member) ->
      Printf.sprintf "the worker's %s's %s" handed member
  | State_unit_member (unit, member) ->
      Printf.sprintf "state unit %s's %s" unit member
  | Wire_member member -> "wire's " ^ member

let lacked = List.map fst Surface_coverage.lacking

let surface_refusals =
  List.map
    (fun item ->
      Printf.sprintf "%s: Surface_coverage names it more than once"
        (item_name item))
    (duplicates lacked)
  @ List.concat_map
      (fun (item, lacks) ->
        let where = item_name item in
        (if List.mem item surface_items then []
         else
           [ where ^ ": Surface_coverage names it, and the surface has none" ])
        @ (if lacks = [] then [ where ^ ": names no SDK" ] else [])
        @ List.map
            (fun sdk ->
              Printf.sprintf "%s: names %s more than once" where
                (Coverage_sdk.name sdk))
            (duplicates (List.map fst lacks))
        @ List.filter_map
            (fun (sdk, lack) ->
              match lack with
              | Surface_coverage.Absent why | Not_yet_reached why ->
                  if String.trim why = "" then
                    Some
                      (Printf.sprintf "%s, %s: states no reason" where
                         (Coverage_sdk.name sdk))
                  else None)
            lacks)
      Surface_coverage.lacking

(* The annotations module's readers, and its is-functions, which read too. *)
let reader_refusals =
  let every_sdk =
    List.find
      (fun (m : Surface.modules_item) -> m.module_ = "annotations")
      spec.tables.client_surface.modules
    |> fun m ->
    List.filter_map
      (fun (member : Surface.modules_item_members_item) ->
        let name = module_member_name member in
        let reads =
          match member with
          | Reader _ -> true
          | Function _ ->
              String.length name > 2
              && String.sub name 0 2 = "is"
              && Char.uppercase_ascii name.[2] = name.[2]
          | Type _ | Constant _ -> false
        in
        if
          reads
          && not
               (List.mem_assoc
                  (Surface_coverage.Module_member ("annotations", name))
                  Surface_coverage.lacking)
        then Some name
        else None)
      m.members
  in
  let table = spec.tables.annotations_reader_cases.readers in
  if List.sort compare table = List.sort compare every_sdk then []
  else
    [
      Printf.sprintf
        "annotations/reader-cases.json's readers are %s, and the readers of \
         the surface's annotations module that no SDK lacks %s"
        (String.concat " " table)
        (String.concat " " every_sdk);
    ]

let refusals =
  sdk_refusals @ table_refusals
  @ List.concat_map
      (fun table -> List.concat_map (coverage_refusals table) Coverage_sdk.all)
      (List.sort_uniq compare named)
  @ test_reads_refusals @ stale_refusals @ surface_refusals @ reader_refusals

let () =
  List.iter prerr_endline refusals;
  if refusals <> [] then exit 1;
  Printf.printf
    "PASS every case table is run by a named test or absent with a reason, in \
     each SDK, every other file of Protocol a test reads is named with its \
     tests, and every surface item an SDK lacks is one Protocol has, with a \
     reason: %d case tables, %d SDKs, %d surface items lacked\n"
    (List.length case_tables)
    (List.length Coverage_sdk.all)
    (List.length Surface_coverage.lacking)
