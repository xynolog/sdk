(* What the tests of a writer of types share: component schemas built from
   JSON, and checks of the code written for them. *)

open Xynolog_codegen
module D = Definitions

let case name test = Alcotest.test_case name `Quick test

(* The references here name schemas by path, so they need no index of [$id]s. *)
let ids = Result.get_ok (Decode.ids [])

(* Schemas by name, each read from its place, a [$ref] naming another by
   its place, each as a writer of types reads it ([Normalize.shape_only], as
   [Definitions.bundle] gives it). *)
let definitions_at schemas =
  let decoded = Hashtbl.create 8 in
  List.iter
    (fun (_, place, json) ->
      match
        Decode.run ~file:place (Yojson.Safe.from_string json) Schema.decode
      with
      | Ok (s, _) -> Hashtbl.replace decoded place (Normalize.shape_only s)
      | Error e -> Alcotest.failf "%s" (Decode.error_to_string e))
    schemas;
  let named place =
    List.find_map
      (fun (name, p, _) -> if p = place then Some name else None)
      schemas
  in
  let views =
    List.map
      (fun (name, place, _) ->
        (name, D.view ~ids ~named ~schemas:decoded (Hashtbl.find decoded place)))
      schemas
  in
  {
    D.names = List.map (fun (name, _, _) -> name) schemas;
    schema = (fun n -> List.assoc n views);
  }

(* Schemas by name, each a file of a directory of schemas. *)
let definitions schemas =
  definitions_at
    (List.map
       (fun (name, json) ->
         (name, "components/schemas/" ^ name ^ ".json", json))
       schemas)

let contains ~sub text =
  let n = String.length sub and m = String.length text in
  let rec go i = i + n <= m && (String.sub text i n = sub || go (i + 1)) in
  go 0

let has code sub =
  if not (contains ~sub code) then Alcotest.failf "no %S in:\n%s" sub code

let lacks code sub =
  if contains ~sub code then Alcotest.failf "%S in:\n%s" sub code

let count code sub =
  let n = String.length sub in
  let rec go i acc =
    if i + n > String.length code then acc
    else if String.sub code i n = sub then go (i + n) (acc + 1)
    else go (i + 1) acc
  in
  go 0 0

let refused expected text () =
  match text () with
  | code -> Alcotest.failf "wrote:\n%s" code
  | exception D.Refused message ->
      if not (contains ~sub:expected message) then
        Alcotest.failf "refused for %S" message
