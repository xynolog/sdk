(* types_census.exe SDK: every SDK declares a type for every schema Protocol
   states ([Roots.all]), in what the generator's groups write. A writer that
   leaves a schema out fails this, so no SDK carries less of Protocol than
   another. SDK is the checkout's root. *)

open Xynolog_codegen

let root = Sys.argv.(1)

let refused errors =
  List.iter (fun e -> prerr_endline (Decode.error_to_string e)) errors;
  exit 1

let spec =
  match Spec_shapes.load (Filename.concat root "protocol/specs/src") with
  | Ok spec -> spec
  | Error errors -> refused errors

let generated =
  List.concat_map
    (fun (g : Groups.group) ->
      match g.files ~root spec with
      | Ok files -> files
      | Error errors -> refused errors)
    Groups.sdk

let identifier_character = function
  | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '_' -> true
  | _ -> false

(* Whether [text] holds [before], then [name], then [after]; or, where
   [after] is empty, no more of an identifier. *)
let declares text (before, after) name =
  let needle = before ^ name ^ after in
  let length = String.length needle in
  let rec from i =
    match String.index_from_opt text i needle.[0] with
    | None -> false
    | Some at ->
        (at + length <= String.length text
        && String.sub text at length = needle
        && (after <> ""
           || at + length = String.length text
           || not (identifier_character text.[at + length])))
        || from (at + 1)
  in
  from 0

let plain = List.map (fun before -> (before, ""))

(* Each SDK: the directory its generated files are under, and what declares a
   type in them. C# makes a schema of one plain value a type of its own
   language (a string, a long), and so names every schema it validates
   against in WireSchemas; OCaml names each in Models. *)
let sdks =
  [
    ("Go", "go/", plain [ "\ntype " ] @ [ ("\n\t", " =") ]);
    ("TypeScript", "typescript/", [ ("\n    ", ":") ]);
    ("Python", "python/", plain [ "\nclass "; "\ntype " ]);
    ("Rust", "rust/", plain [ "pub struct "; "pub enum "; "pub type " ]);
    ( "Swift",
      "swift/",
      plain
        [
          "public struct ";
          "public enum ";
          "public indirect enum ";
          "public typealias ";
        ] );
    ("Kotlin", "kotlin/", plain [ "class "; "typealias "; "object " ]);
    ("C#", "csharp/", [ ({|\"|}, {|\":{|}) ]);
    ("Haskell", "haskell/", plain [ "\nnewtype "; "\ndata "; "\ntype " ]);
    ("OCaml", "ocaml/", [ ({|= "|}, {|"|}) ]);
  ]

let () =
  let names = List.map fst (Roots.all spec) in
  let refusals =
    List.concat_map
      (fun (label, under, before) ->
        let texts =
          List.filter_map
            (fun (f : Output.file) ->
              if String.starts_with ~prefix:under f.path then Some f.text
              else None)
            generated
        in
        List.filter_map
          (fun name ->
            if
              List.exists
                (fun text ->
                  List.exists (fun b -> declares text b name) before)
                texts
            then None
            else Some (Printf.sprintf "%s declares no type for %s" label name))
          names)
      sdks
  in
  List.iter prerr_endline refusals;
  if refusals <> [] then exit 1;
  Printf.printf "PASS every SDK declares a type for each of %d schemas: %s\n"
    (List.length names)
    (String.concat ", " (List.map (fun (label, _, _) -> label) sdks))
