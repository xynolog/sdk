(* What [Typing] proves of a union's members, and of the patterns that tell
   texts apart: two members no value of which is the other's are a union,
   and two that may be one value are refused. *)

open Xynolog_codegen
open Fixture

let union members =
  Printf.sprintf {|{"oneOf": [%s]}|} (String.concat ", " members)

let typed schemas =
  let typing =
    Typing.make (definitions schemas) ~roots:[ "U" ] ~identifiers:[] ~keys:[]
  in
  ignore (typing.find "U");
  ""

let pattern p = Printf.sprintf {|{"type": "string", "pattern": %S}|} p

let object_ required properties =
  Printf.sprintf {|{"type": "object", "required": [%s], "properties": {%s}%s}|}
    (String.concat ", " (List.map (Printf.sprintf "%S") required))
    (String.concat ", "
       (List.map (fun (k, v) -> Printf.sprintf "%S: %s" k v) properties))

let closed = {|, "additionalProperties": false|}
let check what expected actual = Alcotest.(check bool) what expected actual

let cases =
  [
    case "members of no kind in common are a union" (fun () ->
        ignore
          (typed
             [
               ("U", union [ {|{"type": "integer"}|}; {|{"type": "boolean"}|} ]);
             ]));
    case "texts whose patterns share no text are a union" (fun () ->
        ignore
          (typed
             [
               ("U", union [ {|{"$ref": "A.json"}|}; {|{"$ref": "B.json"}|} ]);
               ("A", pattern "^a-[0-9]+$");
               ("B", pattern "^b-[0-9]+$");
             ]));
    case "objects that state apart values of a member they require are a union"
      (fun () ->
        ignore
          (typed
             [
               ("U", union [ {|{"$ref": "A.json"}|}; {|{"$ref": "B.json"}|} ]);
               ("A", object_ [ "kind" ] [ ("kind", {|{"enum": ["a"]}|}) ] "");
               ("B", object_ [ "kind" ] [ ("kind", {|{"enum": ["b"]}|}) ] "");
             ]));
    case "an object that requires what a closed one admits not is apart"
      (fun () ->
        ignore
          (typed
             [
               ("U", union [ {|{"$ref": "A.json"}|}; {|{"$ref": "B.json"}|} ]);
               ("A", object_ [ "a" ] [ ("a", {|{"type": "string"}|}) ] closed);
               ("B", object_ [ "b" ] [ ("b", {|{"type": "string"}|}) ] closed);
             ]));
    case "two members that may be one value are refused"
      (refused "U: its members A and B may be one value" (fun () ->
           typed
             [
               ("U", union [ {|{"$ref": "A.json"}|}; {|{"$ref": "B.json"}|} ]);
               ("A", object_ [ "a" ] [ ("a", {|{"type": "string"}|}) ] "");
               ("B", object_ [ "b" ] [ ("b", {|{"type": "string"}|}) ] "");
             ]));
    case "texts whose patterns share a text are refused"
      (refused "U: its members A and B may be one value" (fun () ->
           typed
             [
               ("U", union [ {|{"$ref": "A.json"}|}; {|{"$ref": "B.json"}|} ]);
               ("A", pattern "^a");
               ("B", pattern "b$");
             ]));
    case "patterns anchored at both ends are read to their end" (fun () ->
        check "disjoint" true (Text_patterns.disjoint "^[a-z]+$" "^[0-9]+$");
        check "a text both admit" false (Text_patterns.disjoint "^[a-z]+$" "^x");
        check "unanchored, any text holds both" false
          (Text_patterns.disjoint "a" "b"));
    case "a value a pattern refuses is apart from it" (fun () ->
        check "refused" true (Text_patterns.refuses "^t-[0-9]+$" "t-x");
        check "admitted" false (Text_patterns.refuses "^t-[0-9]+$" "t-12");
        check "past ASCII" true (Text_patterns.refuses "^[a-z]+$" "é"));
    case "a pattern of a form it does not read proves nothing" (fun () ->
        check "lookahead" false (Text_patterns.disjoint "^(?=a)" "^b$"));
  ]

let () = Alcotest.run "typing" [ ("typing", cases) ]
