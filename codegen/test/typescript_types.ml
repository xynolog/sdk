(* What the TypeScript types writer writes for the shapes of component
   schemas, the aliases it names the types of their own in place by, and the
   kinds of id it refuses to brand. *)

open Xynolog_codegen
open Fixture

(* [root]'s type, and each alias it meets, by its name, as its type. *)
let writing ?(identifiers = []) schemas root =
  let typing =
    Typing.make (definitions schemas) ~roots:[ root ] ~identifiers ~keys:[]
  in
  let names = Typescript_types.names Typescript_syntax.schema in
  let text =
    Typescript_syntax.type_ ~depth:0
      (Typescript_types.declared ~names (typing.find root))
  in
  ( text,
    List.map
      (function
        | Typescript_syntax.Type { name; type_; _ } ->
            (name, Typescript_syntax.type_ ~depth:0 type_)
        | _ -> Alcotest.fail "an alias that is no type")
      (Typescript_types.aliases names) )

let written ?identifiers schemas root = fst (writing ?identifiers schemas root)
let one json = written [ ("S", json); ("A", {|{"type": "string"}|}) ] "S"
let equal expected actual = Alcotest.(check string) "written" expected actual

let cases =
  [
    case "a type that may be null a list holds is parenthesized" (fun () ->
        equal "(components['schemas']['A'] | null)[]"
          (one
             {|{"type": "array", "items": {"anyOf": [{"$ref": "A.json"}, {"type": "null"}]}}|}));
    case "a union in place is an alias of the name Typing gives it" (fun () ->
        match
          writing
            [
              ( "S",
                {|{"allOf": [{"$ref": "A.json"}, {"anyOf": [{"type": "string"}, {"type": "boolean"}]}]}|}
              );
              ("A", {|{"type": "string"}|});
            ]
            "S"
        with
        | text, [ (name, "string | boolean") ] ->
            equal ("components['schemas']['A'] & " ^ name) text
        | text, _ -> Alcotest.failf "%s: not one alias of the union" text);
    case "an object in place is an alias, and one value in place its literal"
      (fun () ->
        match
          writing
            [
              ( "S",
                {|{"type": "object", "required": ["o", "k"], "properties": {"o": {"type": "object", "properties": {"a": {"type": "string"}}}, "k": {"const": "x"}}}|}
              );
            ]
            "S"
        with
        | text, [ (name, alias) ] ->
            has text ("o: " ^ name ^ ";");
            has text "k: 'x';";
            has alias "a?: string;"
        | text, _ -> Alcotest.failf "%s: not one alias of the object" text);
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
