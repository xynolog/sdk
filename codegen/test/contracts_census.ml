(* contracts_census.exe SDK: every SDK declares every item of every contract
   the pinned Protocol states ([Contracts.kinds]), in what the generator's
   groups write and in the SDK's own files. A writer that leaves an item out,
   or an SDK that holds one only as a literal at a call, fails this, so no SDK
   carries less of Protocol than another. SDK is the checkout's root. *)

open Xynolog_codegen

let root = Sys.argv.(1)

let refused errors =
  List.iter (fun e -> prerr_endline (Decode.error_to_string e)) errors;
  exit 1

let spec =
  match Spec_shapes.load (Filename.concat root "protocol/specs/src") with
  | Ok spec -> spec
  | Error errors -> refused errors

let () =
  match
    Contracts.census ~root
      (List.map (fun (g : Groups.group) -> g.files) Groups.writers)
      spec
  with
  | Error errors -> refused errors
  | Ok counted ->
      let absences = Contracts.absences counted in
      List.iter prerr_endline absences;
      if absences <> [] then exit 1;
      Printf.printf "PASS every SDK declares every item of %d contracts: %s\n"
        (List.length counted)
        (String.concat ", "
           (List.map
              (fun (c : Contracts.counted) ->
                Printf.sprintf "%d %s" c.count c.name)
              counted))
