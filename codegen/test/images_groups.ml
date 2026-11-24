(* images_groups.exe ROOT: images' groups write their files from the Protocol
   sdk pins. ROOT is the sdk checkout; images' own drift gate holds the files
   to what images commits. *)

open Xynolog_codegen

let fail fmt =
  Printf.ksprintf
    (fun m ->
      prerr_endline m;
      exit 1)
    fmt

let () =
  let sdk =
    match Sys.argv with
    | [| _; root |] ->
        if Filename.is_relative root then Filename.concat (Sys.getcwd ()) root
        else root
    | _ -> fail "usage: images_groups.exe ROOT"
  in
  let spec =
    match Spec_shapes.load (Filename.concat sdk "protocol/specs/src") with
    | Ok spec -> spec
    | Error errors ->
        fail "%s" (String.concat "\n" (List.map Decode.error_to_string errors))
  in
  List.iter
    (fun (g : Groups.group) ->
      match g.files ~root:sdk spec with
      | Ok [] -> fail "images' %s group writes no file" g.name
      | Ok _ -> ()
      | Error errors ->
          fail "images' %s group refused sdk's Protocol:\n%s" g.name
            (String.concat "\n" (List.map Decode.error_to_string errors)))
    (Groups.of_target Images)
