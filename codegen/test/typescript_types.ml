(* What the TypeScript types writer writes for the shapes of component
   schemas, and the kinds of id it refuses to brand. *)

open Xynolog_codegen
open Fixture

let written ?(identifiers = []) schemas root =
  let typing =
    Typing.make (definitions schemas) ~roots:[ root ] ~identifiers ~keys:[]
  in
  Typescript_syntax.type_ ~depth:0
    (Typescript_types.declared ~named:Typescript_syntax.schema
       (typing.find root))

let one json = written [ ("S", json); ("A", {|{"type": "string"}|}) ] "S"
let equal expected actual = Alcotest.(check string) "written" expected actual

let cases =
  [
    case "a union a list holds is parenthesized" (fun () ->
        equal "(string | number)[]"
          (one
             {|{"type": "array", "items": {"oneOf": [{"type": "string"}, {"type": "number"}]}}|}));
    case "a union beside an allOf's other member is parenthesized" (fun () ->
        equal "components['schemas']['A'] & (string | boolean)"
          (one
             {|{"allOf": [{"$ref": "A.json"}, {"anyOf": [{"type": "string"}, {"type": "boolean"}]}]}|}));
    case "an allOf held to values of its part is the part and those values"
      (fun () ->
        equal "components['schemas']['A'] & 'x'"
          (one {|{"allOf": [{"$ref": "A.json"}], "enum": ["x"]}|}));
    case "a nullable reference admits null after it" (fun () ->
        equal "components['schemas']['A'] | null"
          (one {|{"anyOf": [{"$ref": "A.json"}, {"type": "null"}]}|}));
    case "an object of no properties that is not open holds no member"
      (fun () -> equal "Record<string, never>" (one {|{"type": "object"}|}));
    case "an open object holds any member beside its properties" (fun () ->
        has
          (one
             {|{"type": "object", "properties": {"a": {"type": "string"}}, "additionalProperties": true}|})
          "} & { [key: string]: unknown }");
    case "an object of a schema's members is an index signature" (fun () ->
        equal "{ [key: string]: number }"
          (one
             {|{"type": "object", "additionalProperties": {"type": "integer"}}|}));
    case "an enum of numbers or booleans is a union of their literals"
      (fun () ->
        equal "1 | 3" (one {|{"type": "integer", "enum": [1, 3]}|});
        equal "true" (one {|{"type": "boolean", "enum": [true]}|}));
    case "a property no name spells is quoted, and optional unless required"
      (fun () ->
        let text =
          one
            {|{"type": "object", "required": ["@type"], "properties": {"@type": {"type": "string"}, "@id": {"type": "string"}}}|}
        in
        has text "'@type': string;";
        has text "'@id'?: string;");
    case "a member is described by what it states, not by what it names"
      (fun () ->
        let text =
          written
            [
              ( "S",
                {|{"type": "object", "properties": {"a": {"anyOf": [{"$ref": "A.json"}, {"type": "null"}]}, "b": {"type": "string", "description": "What a b is."}}}|}
              );
              ("A", {|{"type": "string", "description": "What an A is."}|});
            ]
            "S"
        in
        lacks text "What an A is.";
        has text "What a b is.");
    case "what is said beside a reference that may be null describes the member"
      (fun () ->
        let text =
          written
            [
              ( "S",
                {|{"type": "object", "properties": {"a": {"anyOf": [{"$ref": "A.json"}, {"type": "null"}], "description": "What an a is."}}}|}
              );
              ("A", {|{"type": "string", "description": "What an A is."}|});
            ]
            "S"
        in
        lacks text "What an A is.";
        has text "What an a is.");
    case "a schema that states nothing is unknown" (fun () ->
        equal "unknown" (one "{}"));
    case "a kind of id is text of a type of its own" (fun () ->
        equal "string & { readonly __brand: 'A' }"
          (written ~identifiers:[ "A" ] [ ("A", {|{"type": "string"}|}) ] "A"));
    case "a kind of id whose schema is not text is refused" (fun () ->
        refused "N: a kind of id whose schema is not a string"
          (fun () ->
            written ~identifiers:[ "N" ] [ ("N", {|{"type": "number"}|}) ] "N")
          ());
  ]

let () = Alcotest.run "typescript_types" [ ("typescript_types", cases) ]
