(* typing_census.exe SDK: [Typing] gives every schema Protocol states
   ([Roots.all]) a form, and reads every keyword Protocol's schemas state
   ([Typing.keywords]). A name or a keyword Protocol gains that [Typing]
   does not read fails this, before any writer of types meets it. SDK is the
   checkout's root. *)

open Xynolog_codegen

let root = Sys.argv.(1)

let refused errors =
  List.iter (fun e -> prerr_endline (Decode.error_to_string e)) errors;
  exit 1

let spec =
  match Spec_shapes.load (Filename.concat root "protocol/specs/src") with
  | Ok spec -> spec
  | Error errors -> refused errors

(* Every keyword a schema states, and every schema it holds. *)
let stated =
  Schema.cata
    ~boolean:(fun _ -> [])
    ~schema:(fun layer ->
      Schema.keywords layer @ List.concat (Schema.children layer))

let () =
  let typing =
    match Typing.of_spec spec ~tables:(Roots.service_tables spec) with
    | typing -> typing
    | exception Definitions.Refused message ->
        prerr_endline message;
        exit 1
  in
  let names = List.map fst (Roots.all spec) in
  let unformed =
    List.filter_map
      (fun name ->
        if List.mem name typing.names then None
        else Some (Printf.sprintf "Typing gives %s no form" name))
      names
  in
  let keywords =
    List.sort_uniq String.compare
      (List.concat_map (fun (_, s) -> stated s) spec.schemas)
  in
  let unread =
    List.filter_map
      (fun k ->
        if List.mem_assoc k Typing.keywords then None
        else Some (Printf.sprintf "Typing reads no keyword %s" k))
      keywords
  in
  List.iter prerr_endline (unformed @ unread);
  if unformed @ unread <> [] then exit 1;
  Printf.printf
    "PASS Typing gives each of %d schemas a form (%d with what they reach), \
     and reads each of the %d keywords Protocol states\n"
    (List.length names) (List.length typing.names) (List.length keywords)
