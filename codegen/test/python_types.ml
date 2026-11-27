(* What the Python types writer writes for the shapes of component schemas,
   the order it writes them in, and the names it refuses. *)

open Xynolog_codegen
open Fixture

(* The module for [schemas] beside a kind of id, K. *)
let written schemas =
  let schemas = ("K", {|{"type": "string"}|}) :: schemas in
  Python_types.module_
    (Typing.make (definitions schemas) ~roots:(List.map fst schemas)
       ~identifiers:[ "K" ] ~value_docs:[])

let one json = written [ ("S", json) ]

let before code first second =
  let at sub =
    let n = String.length sub in
    let rec go i =
      if i + n > String.length code then Alcotest.failf "no %S in:\n%s" sub code
      else if String.sub code i n = sub then i
      else go (i + 1)
    in
    go 0
  in
  if at first > at second then
    Alcotest.failf "%S after %S in:\n%s" first second code

let cases =
  [
    case "a map named by its keys' schema is keyed by that type" (fun () ->
        let code =
          written
            [
              ( "Where",
                {|{"type": "object", "propertyNames": {"$ref": "./K.json"}, "additionalProperties": {"type": "integer"}}|}
              );
            ]
        in
        has code "type Where = dict[K, int]");
    case "an object is a frozen model, its optional members None unless given"
      (fun () ->
        let code =
          one
            {|{"type": "object", "required": ["a"], "properties": {"a": {"type": "string"}, "b": {"type": "integer"}}}|}
        in
        has code
          "class S(WireModel, frozen=True):\n\
          \    a: str\n\
          \    b: int | None = None\n");
    case "a description beside a reference is what is said of the member"
      (fun () ->
        let code =
          written
            [
              ("T", {|{"type": "object", "properties": {}}|});
              ( "S",
                {|{"type": "object", "required": ["t"], "properties": {"t": {"$ref": "./T.json", "description": "The t."}}}|}
              );
            ]
        in
        has code {|t: Annotated[T, Field(description="The t.")]|});
    case "a constraint beside a reference is refused: it is an allOf"
      (refused "has enum beside it" (fun () ->
           written
             [
               ("T", {|{"type": "string"}|});
               ( "S",
                 {|{"type": "object", "properties": {"t": {"$ref": "./T.json", "enum": ["x"]}}}|}
               );
             ]));
    case "a member no Python name spells is held under its alias" (fun () ->
        let code =
          one
            {|{"type": "object", "required": ["entityTypes", "yield", "schema"], "properties": {"entityTypes": {"type": "string"}, "yield": {"type": "string"}, "schema": {"type": "string"}}}|}
        in
        has code {|entity_types: Annotated[str, Field(alias="entityTypes")]|};
        has code {|yield_: Annotated[str, Field(alias="yield")]|};
        has code {|schema_: Annotated[str, Field(alias="schema")]|});
    case "a closed object forbids other members, an open one allows them"
      (fun () ->
        has
          (one
             {|{"type": "object", "properties": {"a": {"type": "string"}}, "additionalProperties": false}|})
          {|class S(WireModel, frozen=True, extra="forbid"):|};
        has
          (one
             {|{"type": "object", "properties": {"a": {"type": "string"}}, "additionalProperties": true}|})
          {|class S(WireModel, frozen=True, extra="allow"):|});
    case "an object that holds nothing is a model of no members" (fun () ->
        has
          (one {|{"type": "object", "maxProperties": 0}|})
          "class S(WireModel, frozen=True, extra=\"forbid\"):\n    pass\n");
    case "an object of a schema's members is a dict of it" (fun () ->
        has
          (one
             {|{"type": "object", "additionalProperties": {"type": "integer"}}|})
          "type S = dict[str, int]");
    case "a nullable member admits None, and is not optional for it" (fun () ->
        has
          (one
             {|{"type": "object", "required": ["a"], "properties": {"a": {"type": ["string", "null"]}}}|})
          "    a: str | None\n");
    case "a string enum is the union of its literals" (fun () ->
        has
          (one {|{"type": "string", "enum": ["x", "y"]}|})
          {|type S = Literal["x", "y"]|});
    case "a discriminated union names its discriminator" (fun () ->
        let code =
          written
            [
              ( "U",
                {|{"oneOf": [{"$ref": "A.json"}, {"$ref": "B.json"}], "discriminator": {"propertyName": "kind"}}|}
              );
              ( "A",
                {|{"type": "object", "required": ["kind"], "properties": {"kind": {"type": "string", "enum": ["a"]}}}|}
              );
              ( "B",
                {|{"type": "object", "required": ["kind"], "properties": {"kind": {"type": "string", "enum": ["b"]}}}|}
              );
            ]
        in
        has code {|type U = Annotated[A | B, Field(discriminator="kind")]|};
        has code {|    kind: Literal["a"]|});
    case "a member of an enum it names, narrowed beside it, is the narrowed one"
      (fun () ->
        let code =
          written
            [
              ( "U",
                {|{"oneOf": [{"type": "object", "required": ["kind"], "properties": {"kind": {"allOf": [{"$ref": "K2.json"}], "enum": ["a"]}}}, {"type": "object", "required": ["kind"], "properties": {"kind": {"allOf": [{"$ref": "K2.json"}], "enum": ["b"]}}}], "discriminator": {"propertyName": "kind"}}|}
              );
              ("K2", {|{"type": "string", "enum": ["a", "b"]}|});
            ]
        in
        has code {|    kind: Literal["a"]|};
        has code {|    kind: Literal["b"]|};
        lacks code "    kind: K2");
    case "an allOf of a model and members of its own extends the model"
      (fun () ->
        let code =
          written
            [
              ( "S",
                {|{"allOf": [{"$ref": "A.json"}, {"type": "object", "properties": {"b": {"type": "string"}}}]}|}
              );
              ( "A",
                {|{"type": "object", "properties": {"a": {"type": "string"}}}|}
              );
            ]
        in
        has code "class S(A, frozen=True):\n    b: str | None = None\n");
    case "a member that restates its base's as an enum is the enum's literals"
      (fun () ->
        let code =
          written
            [
              ( "S",
                {|{"allOf": [{"$ref": "A.json"}, {"type": "object", "required": ["code"], "properties": {"code": {"type": "string", "enum": ["x", "y"]}}}]}|}
              );
              ( "A",
                {|{"type": "object", "properties": {"code": {"type": "string"}}}|}
              );
            ]
        in
        has code {|    code: SCode|};
        has code {|Literal["x", "y"]|};
        lacks code "class SCode(");
    case "a member is described by what it states, not by what it names"
      (fun () ->
        let code =
          written
            [
              ( "S",
                {|{"type": "object", "required": ["a"], "properties": {"a": {"anyOf": [{"$ref": "A.json"}, {"type": "null"}]}}}|}
              );
              ("A", {|{"type": "string", "description": "What an A is."}|});
            ]
        in
        has code "    a: A | None\n";
        has code {|type A = Annotated[str, Field(description="What an A is.")]|};
        Alcotest.(check int)
          "A's description, once" 1
          (count code "What an A is."));
    case "a declaration follows every one it names" (fun () ->
        let code =
          written
            [
              ( "S",
                {|{"allOf": [{"$ref": "A.json"}, {"type": "object", "properties": {"b": {"$ref": "B.json"}}}]}|}
              );
              ( "A",
                {|{"type": "object", "properties": {"a": {"type": "string"}}}|}
              );
              ("B", {|{"type": "string", "enum": ["x", "y"]}|});
            ]
        in
        before code "class A(" "class S(";
        before code "type B =" "class S(");
    case "a kind of id is xynolog.identifiers', not declared here" (fun () ->
        let code =
          one
            {|{"type": "object", "required": ["k"], "properties": {"k": {"$ref": "K.json"}}}|}
        in
        has code "from xynolog.identifiers import K\n";
        has code "    k: K\n";
        lacks code "class K(";
        lacks code "type K =");
    case "two members of one Python name are refused" (fun () ->
        refused "would both be the Python field a_b"
          (fun () ->
            one
              {|{"type": "object", "properties": {"aB": {"type": "string"}, "a_b": {"type": "string"}}}|})
          ());
  ]

let () = Alcotest.run "python_types" [ ("python_types", cases) ]
