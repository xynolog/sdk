(* What the Go types generator writes for the shapes of component schemas,
   and the shapes it refuses. *)

open Xynolog_codegen
module G = Go_types.Generate
open Fixture

let generated ?(identifiers = []) schemas root =
  let { G.decls; _ } = G.generate (definitions schemas) ~identifiers ~keys:[] [ root ] in
  String.concat "\n\n" (List.map Go_syntax.decl decls)

let circle =
  {|{"type": "object", "required": ["kind", "r"], "properties": {"kind": {"type": "string", "enum": ["circle"]}, "r": {"type": "number"}}}|}

let square =
  {|{"type": "object", "required": ["kind"], "properties": {"kind": {"type": "string", "enum": ["square", "box"]}}}|}

let shapes members =
  [
    ( "Shape",
      Printf.sprintf
        {|{"oneOf": [%s], "discriminator": {"propertyName": "kind"}}|}
        (String.concat ", "
           (List.map
              (fun m -> Printf.sprintf {|{"$ref": "%s.json"}|} m)
              members)) );
    ("Circle", circle);
    ("Square", square);
    ("Disc", circle);
  ]

let holder =
  [
    ( "Holder",
      {|{"type": "object", "required": ["name", "tags", "id", "when"], "properties": {"name": {"type": "string"}, "note": {"type": "string"}, "tags": {"type": "array", "items": {"type": "string"}}, "id": {"$ref": "ThingId.json"}, "when": {"type": ["string", "null"]}}}|}
    );
    ("ThingId", {|{"type": "string", "pattern": "^t-[0-9]+$"}|});
  ]

let cases =
  [
    case "a field is a pointer where its schema leaves it out or admits null"
      (fun () ->
        has
          (generated ~identifiers:[ "ThingId" ] holder "Holder")
          "type Holder struct {\n\
           \tId   ThingId  `json:\"id\"`\n\
           \tName string   `json:\"name\"`\n\
           \tNote *string  `json:\"note,omitempty\"`\n\
           \tTags []string `json:\"tags\"`\n\
           \tWhen *string  `json:\"when\"`\n\
           }");
    case "a kind of id is named, and not written" (fun () ->
        lacks
          (generated ~identifiers:[ "ThingId" ] holder "Holder")
          "type ThingId");
    case "a required list Go holds as nil is written as []" (fun () ->
        has
          (generated ~identifiers:[ "ThingId" ] holder "Holder")
          "func (v Holder) MarshalJSON() ([]byte, error) {\n\
           \ttype written Holder\n\
           \tv.Tags = listOf(v.Tags)\n\
           \treturn json.Marshal(written(v))\n\
           }");
    case "an enumeration is a named string with a constant per value" (fun () ->
        let code =
          generated
            [ ("Color", {|{"type": "string", "enum": ["red", "light-blue"]}|}) ]
            "Color"
        in
        has code "type Color string";
        has code "\tColorRed       Color = \"red\"";
        has code "\tColorLightBlue Color = \"light-blue\"";
        has code
          "func (e Color) Valid() bool {\n\
           \tswitch e {\n\
           \tcase ColorRed, ColorLightBlue:");
    case "a union embeds union, and each member has its marker" (fun () ->
        let code = generated (shapes [ "Circle"; "Square" ]) "Shape" in
        has code "type Shape struct {\n\tunion[ShapeMember]\n}";
        has code "type ShapeMember interface {\n\tmemberOfShape()\n}";
        has code "func (Circle) memberOfShape()";
        has code "func (Square) memberOfShape() {}");
    case "a member that states one value of its union's property says so"
      (fun () ->
        let code = generated (shapes [ "Circle"; "Square" ]) "Shape" in
        has code
          "func (Circle) told() (string, string) { return \"kind\", \"circle\" \
           }";
        lacks code "func (Square) told()");
    case "a union told apart by a property names the member each value names"
      (fun () ->
        let code = generated (shapes [ "Circle"; "Square" ]) "Shape" in
        has code
          "func (u Shape) Discriminator() (string, error) { return \
           u.stated(\"kind\") }";
        has code
          "\tcase \"circle\":\n\
           \t\treturn as[Circle](u.union)\n\
           \tcase \"square\", \"box\":\n\
           \t\treturn as[Square](u.union)\n");
    case "two members that state the same value are refused"
      (refused "Shape: two members state the `kind` circle" (fun () ->
           generated (shapes [ "Circle"; "Disc" ]) "Shape"));
    case "an open object keeps the members its schema does not name" (fun () ->
        let code =
          generated
            [
              ( "Bag",
                {|{"type": "object", "properties": {"a": {"type": "string"}}, "additionalProperties": true}|}
              );
            ]
            "Bag"
        in
        has code "\tAdditionalProperties map[string]any `json:\"-\"`";
        has code "return writeOpen(written(v), v.AdditionalProperties)";
        has code "return readOpen(raw, (*read)(v), &v.AdditionalProperties)");
  ]

let () = Alcotest.run "go_types" [ ("types", cases) ]
