(* What the Rust types generator writes for the shapes of component schemas,
   and the shapes it refuses. *)

open Xynolog_codegen
module D = Definitions
module G = Rust_types.Generate
open Fixture

let generated ?(identifiers = []) ?(accessors = []) ?(keys = []) schemas root =
  Rust_syntax.text ~header:[]
    (G.items
       (Typing.make (definitions schemas) ~roots:[ root ] ~identifiers ~keys)
       ~accessors)

let thing pattern =
  [
    ( "ThingId",
      Printf.sprintf
        {|{"type": "string", "description": "A thing's id.", "pattern": %S}|}
        pattern );
  ]

let identifier pattern =
  generated ~identifiers:[ "ThingId" ] (thing pattern) "ThingId"

(* A file no directory of schemas holds, so written in place, that names
   itself. *)
let looped_file = "in-place/Loop.json"

let looped_schema =
  match
    Decode.run ~file:looped_file
      (Yojson.Safe.from_string
         {|{"type": "object", "properties": {"next": {"$ref": "Loop.json"}}}|})
      Schema.decode
  with
  | Ok (s, _) -> s
  | Error e -> failwith (Decode.error_to_string e)

let looped =
  let schemas = Hashtbl.create 1 in
  Hashtbl.replace schemas looped_file looped_schema;
  schemas

let cases =
  [
    case "a type written for a component schema names it, and an alias does not"
      (fun () ->
        let code =
          generated
            [
              ( "Holder",
                {|{"type": "object", "properties": {"name": {"$ref": "Name.json"}, "inner": {"type": "object", "properties": {}}}}|}
              );
              ("Name", {|{"type": "string"}|});
            ]
            "Holder"
        in
        has code "schema!(Holder);";
        Alcotest.(check int) "one" 1 (count code "schema!("));
    case
      "a kind of id is a type of its own that decodes through its constructor"
      (fun () ->
        let code = identifier "^[A-Za-z0-9_-]{1,128}$" in
        lacks code "pub type ThingId";
        has code
          "/// A thing's id.\n\
           #[derive(\n\
          \    Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, \
           serde::Deserialize, serde::Serialize,\n\
           )]\n\
           #[serde(try_from = \"String\", into = \"String\")]\n\
           pub struct ThingId(String);";
        has code
          "pub fn new(value: impl Into<String>) -> Result<ThingId, \
           InvalidIdentifier>";
        has code "impl std::ops::Deref for ThingId {\n    type Target = str;");
    case
      "a kind of id's pattern is written as the rule its constructor holds a \
       value to" (fun () ->
        has
          (identifier "^[A-Za-z0-9_-]{1,128}$")
          "    const RULE: Rule = Rule {\n\
          \        prefix: \"\",\n\
          \        admitted: Admitted::Of(&[('A', 'Z'), ('a', 'z'), ('0', \
           '9'), ('_', '_'), ('-', '-')]),\n\
          \        least: 1,\n\
          \        most: Some(128),\n\
          \    };";
        has (identifier "^did:\\S+$")
          "        prefix: \"did:\",\n\
          \        admitted: Admitted::NotWhitespace,\n\
          \        least: 1,\n\
          \        most: None,";
        has
          (identifier "^[A-Za-z0-9_-]{1,128}$")
          "pub const PATTERN: &'static str = \"^[A-Za-z0-9_-]{1,128}$\";");
    case "a kind of id whose pattern cannot be written as a rule is refused"
      (refused "ThingId: a pattern the generator cannot write as a rule"
         (fun () -> identifier "^e-[^:]+:[^:]+:.+$"));
    case "a kind of id with no pattern is refused"
      (refused "ThingId: a kind of id states no pattern" (fun () ->
           generated ~identifiers:[ "ThingId" ]
             [ ("ThingId", {|{"type": "string"}|}) ]
             "ThingId"));
    case "a property that refers to a kind of id is of its type" (fun () ->
        let code =
          generated ~identifiers:[ "ThingId" ]
            [
              ("ThingId", {|{"type": "string", "pattern": "^[a-z]+$"}|});
              ( "Holder",
                {|{"type": "object", "required": ["thing", "maybe"], "properties": {
                    "thing": {"$ref": "ThingId.json"},
                    "others": {"type": "array", "items": {"$ref": "ThingId.json"}},
                    "maybe": {"anyOf": [{"$ref": "ThingId.json"}, {"type": "null"}]}}}|}
              );
            ]
            "Holder"
        in
        has code "    pub thing: ThingId,";
        has code "    pub others: Option<Vec<ThingId>>,";
        has code "    pub maybe: Option<ThingId>,");
    case "a map named by its keys' schema is keyed by that type" (fun () ->
        let code =
          generated ~identifiers:[ "ThingId" ]
            ~keys:[ ("Where", "ThingId") ]
            [
              ("ThingId", {|{"type": "string", "pattern": "^[a-z]+$"}|});
              ( "Where",
                {|{"type": "object", "additionalProperties": {"type": "integer"}}|}
              );
            ]
            "Where"
        in
        has code "pub type Where = std::collections::BTreeMap<ThingId, i64>;");
    case "a union names each member by what it is" (fun () ->
        has
          (generated
             [
               ("Target", {|{"type": "integer"}|});
               ( "Holder",
                 {|{"type": "object", "required": ["target"], "properties": {"target": {"oneOf": [
                     {"type": "string"},
                     {"$ref": "Target.json"},
                     {"type": "array", "items": {"$ref": "Target.json"}},
                     {"type": "object", "additionalProperties": true}]}}}|}
               );
             ]
             "Holder")
          "pub enum HolderTarget {\n\
          \    Text(String),\n\
          \    Target(Target),\n\
          \    List(Vec<Target>),\n\
          \    Object(serde_json::Map<String, serde_json::Value>),\n\
           }");
    case "an inline member is named by its discriminant" (fun () ->
        has
          (generated
             [
               ( "Focus",
                 {|{"oneOf": [
                     {"type": "object", "required": ["kind"], "properties": {"kind": {"type": "string", "enum": ["annotation"]}}},
                     {"type": "object", "required": ["kind"], "properties": {"kind": {"type": "string", "enum": ["resource"]}}}]}|}
               );
             ]
             "Focus")
          "pub enum Focus {\n\
          \    Annotation(FocusAnnotation),\n\
          \    Resource(FocusResource),\n\
           }");
    case
      "an enum spells a + in its variant, and says each value as the wire \
       spells it" (fun () ->
        let code =
          generated
            [
              ( "Media",
                {|{"type": "string", "enum": ["text/x-c", "text/x-c++", "image/svg+xml"]}|}
              );
            ]
            "Media"
        in
        has code "#[serde(rename = \"text/x-c++\")]\n    TextXCPlusPlus,";
        has code "#[serde(rename = \"image/svg+xml\")]\n    ImageSvgPlusXml,";
        has code
          "    /// The value as the wire spells it.\n\
          \    pub const fn as_str(&self) -> &'static str {\n\
          \        match self {\n\
          \            Media::TextXC => \"text/x-c\",\n\
          \            Media::TextXCPlusPlus => \"text/x-c++\",");
    case "two enum values one variant would name are refused"
      (refused "two enum values would both be the variant TextPlain" (fun () ->
           generated
             [
               ( "Media",
                 {|{"type": "string", "enum": ["text/plain", "text-plain"]}|} );
             ]
             "Media"));
    case "two members nothing tells apart are refused"
      (refused "two union members would both be the variant Text" (fun () ->
           generated
             [
               ( "Twice",
                 {|{"oneOf": [{"type": "string"}, {"type": "string", "description": "another"}, {"type": "array", "items": {"type": "string"}}]}|}
               );
             ]
             "Twice"));
    case "a named string is an alias" (fun () ->
        has
          (generated
             [
               ( "MediaType",
                 {|{"type": "string", "description": "A MIME type."}|} );
             ]
             "MediaType")
          "/// A MIME type.\npub type MediaType = String;");
    case "a nullable reference is the referenced type and not a copy of it"
      (fun () ->
        let code =
          generated
            [
              ( "Resource",
                {|{"type": "object", "properties": {"name": {"type": "string"}}}|}
              );
              ( "Answer",
                {|{"type": "object", "required": ["resource"], "properties": {"resource":
                    {"anyOf": [{"$ref": "Resource.json"}, {"type": "null"}], "description": "The resource, if any."}}}|}
              );
            ]
            "Answer"
        in
        has code "pub resource: Option<Resource>,";
        lacks code "AnswerResource");
    case "a type written in place takes a name no schema has" (fun () ->
        let code =
          generated
            [
              ( "NoteBody",
                {|{"type": "object", "properties": {"value": {"type": "string"}}}|}
              );
              ( "Note",
                {|{"type": "object", "properties": {"body": {"oneOf": [
                    {"$ref": "NoteBody.json"}, {"type": "array", "items": {"$ref": "NoteBody.json"}}]}}}|}
              );
            ]
            "Note"
        in
        has code
          "pub enum NoteBodyValue {\n\
          \    NoteBody(NoteBody),\n\
          \    List(Vec<NoteBody>),\n\
           }";
        has code "pub body: Option<NoteBodyValue>,");
    case
      "a struct with required and optional properties is made from the \
       required ones" (fun () ->
        has
          (generated
             [
               ( "Ask",
                 {|{"type": "object", "required": ["title", "cursor"], "additionalProperties": true, "properties": {
                     "title": {"type": "string"}, "note": {"type": "string"},
                     "cursor": {"type": ["string", "null"]}, "page": {"type": ["string", "null"]}}}|}
               );
             ]
             "Ask")
          "impl Ask {\n\
          \    /// The `Ask` that states these and nothing else.\n\
          \    pub fn new(title: impl Into<String>, cursor: Option<String>) -> \
           Self {\n\
          \        Self {\n\
          \            title: title.into(),\n\
          \            note: None,\n\
          \            cursor,\n\
          \            page: None,\n\
          \            rest: serde_json::Map::new(),\n\
          \        }\n\
          \    }\n\
           }\n");
    case "a struct that is all required or all optional has no constructor"
      (fun () ->
        let code =
          generated
            [
              ( "Whole",
                {|{"type": "object", "required": ["title"], "properties": {"title": {"type": "string"}}}|}
              );
            ]
            "Whole"
          ^ generated
              [
                ( "Options",
                  {|{"type": "object", "properties": {"note": {"type": "string"}}}|}
                );
              ]
              "Options"
        in
        has code "pub struct Whole {";
        has code "pub struct Options {";
        lacks code "pub fn new(");
    case
      "a property that admits one value is stated by the constructor and not \
       asked for" (fun () ->
        let code =
          generated
            [
              ( "Tagging",
                {|{"type": "object", "required": ["motivation", "schemaId"], "additionalProperties": false, "properties": {
                    "motivation": {"type": "string", "enum": ["tagging"]}, "schemaId": {"type": "string"}, "language": {"type": "string"}}}|}
              );
            ]
            "Tagging"
        in
        has code
          "    pub fn new(schema_id: impl Into<String>) -> Self {\n\
          \        Self {\n\
          \            motivation: TaggingMotivation::Tagging,\n\
          \            schema_id: schema_id.into(),\n\
          \            language: None,\n\
          \        }\n\
          \    }\n";
        lacks code "impl Default for Tagging");
    case
      "a struct whose one required property admits one value is made from \
       nothing" (fun () ->
        has
          (generated
             [
               ( "Yielding",
                 {|{"type": "object", "required": ["jobType"], "additionalProperties": false, "properties": {"jobType": {"enum": ["yield"], "type": "string"}}}|}
               );
             ]
             "Yielding")
          "impl Default for Yielding {\n\
          \    fn default() -> Self {\n\
          \        Self::new()\n\
          \    }\n\
           }\n\n\
           impl Yielding {\n\
          \    /// The `Yielding` that states what it must and nothing else.\n\
          \    pub fn new() -> Self {\n\
          \        Self {\n\
          \            job_type: YieldingJobType::Yield,\n\
          \        }\n\
          \    }\n\
           }\n");
    case "a value stated as a const is the enumeration of its one value"
      (fun () ->
        has
          (generated
             [
               ( "Yielding",
                 {|{"type": "object", "required": ["jobType"], "additionalProperties": false, "properties": {"jobType": {"const": "yield", "type": "string"}}}|}
               );
             ]
             "Yielding")
          {|"yield"|});
    case "a value of one integer or boolean is a type of that value alone"
      (fun () ->
        let code =
          generated
            [
              ( "Entry",
                {|{"type": "object", "required": ["v", "declined", "stamp"], "additionalProperties": false, "properties": {
                    "v": {"type": "integer", "const": 3}, "declined": {"type": "boolean", "const": true}, "stamp": {"type": "string"}}}|}
              );
            ]
            "Entry"
        in
        has code
          "#[derive(Debug, Clone, Copy, Default, PartialEq, Eq, PartialOrd, \
           Ord, Hash)]\n\
           pub struct EntryV;\n\n\
           constant!(EntryV, i64, 3);\n";
        has code "constant!(EntryDeclined, bool, true);\n";
        has code "    pub v: EntryV,\n";
        has code
          "    pub fn new(stamp: impl Into<String>) -> Self {\n\
          \        Self {\n\
          \            v: EntryV,\n\
          \            declined: EntryDeclined,\n\
          \            stamp: stamp.into(),\n\
          \        }\n\
          \    }\n";
        lacks code "pub const V");
    case "an enumeration of several integers is refused"
      (refused
         "EntryV: only an enumeration of strings, or one integer or boolean, \
          is generated" (fun () ->
           generated
             [
               ( "Entry",
                 {|{"type": "object", "required": ["v"], "properties": {"v": {"type": "integer", "enum": [1, 2]}}}|}
               );
             ]
             "Entry"));
    case
      "a member that is a schema of its own is its union wherever the union is \
       wanted" (fun () ->
        let code =
          generated
            [
              ("Named", {|{"type": "string"}|});
              ( "Target",
                {|{"type": "object", "properties": {"source": {"type": "string"}}, "required": ["source"]}|}
              );
              ( "Holder",
                {|{"oneOf": [{"$ref": "Target.json"}, {"$ref": "Named.json"}, {"type": "array", "items": {"$ref": "Target.json"}}]}|}
              );
            ]
            "Holder"
        in
        has code "member!(Holder::Target(Target));";
        Alcotest.(check int) "one" 1 (count code "member!("));
    case
      "a union is decoded by what each member admits, and one told apart by a \
       property says which value it states" (fun () ->
        let code =
          generated ~accessors:[ "Mark" ]
            [
              ( "Motivation",
                {|{"type": "string", "enum": ["highlighting", "tagging"]}|} );
              ( "MarkHighlight",
                {|{"type": "object", "required": ["motivation"], "properties": {"motivation": {"type": "string", "enum": ["highlighting"]}}}|}
              );
              ( "MarkTag",
                {|{"type": "object", "required": ["motivation"], "properties": {"motivation": {"type": "string", "enum": ["tagging"]}}}|}
              );
              ( "Mark",
                {|{"oneOf": [{"$ref": "MarkHighlight.json"}, {"$ref": "MarkTag.json"}], "discriminator": {"propertyName": "motivation"}}|}
              );
            ]
            "Mark"
        in
        has code
          "#[derive(Debug, Clone, PartialEq, Eq, Hash, serde::Serialize)]\n\
           #[serde(untagged)]\n\
           pub enum Mark {";
        has code "    pub const MEMBERS: &'static [&'static [Signature]] = &[";
        has code {|("motivation", &[Literal::Text("tagging")])|};
        has code "union!(Mark, MarkHighlight, MarkTag);\n";
        lacks code "serde::Deserialize<'de> for Mark";
        has code
          "    pub(crate) const fn motivation(&self) -> Motivation {\n\
          \        match self {\n\
          \            Mark::MarkHighlight(_) => Motivation::Highlighting,\n\
          \            Mark::MarkTag(_) => Motivation::Tagging,\n\
          \        }\n\
          \    }");
    case "a union whose members only a pattern tells apart is refused"
      (refused
         "U: its members A and B are told apart only by a pattern, which the \
          Rust SDK does not read" (fun () ->
           generated
             [
               ("A", {|{"type": "string", "pattern": "^a$"}|});
               ("B", {|{"type": "string", "pattern": "^b$"}|});
               ( "U",
                 {|{"oneOf": [{"$ref": "A.json"}, {"$ref": "B.json"}, {"type": "integer"}]}|}
               );
             ]
             "U"));
    case
      "a member whose value is none of the enumeration its property names is \
       refused"
      (refused
         "a member states the `motivation` `linking`, which is no Motivation"
         (fun () ->
           generated ~accessors:[ "Mark" ]
             [
               ("Motivation", {|{"type": "string", "enum": ["highlighting"]}|});
               ( "MarkLink",
                 {|{"type": "object", "required": ["motivation"], "properties": {"motivation": {"type": "string", "enum": ["linking"]}}}|}
               );
               ( "Mark",
                 {|{"oneOf": [{"$ref": "MarkLink.json"}], "discriminator": {"propertyName": "motivation"}}|}
               );
             ]
             "Mark"));
    case "a property named by a keyword is a raw field" (fun () ->
        let code =
          generated
            [
              ( "Typed",
                {|{"type": "object", "required": ["type"], "properties": {"type": {"type": "string"}, "@id": {"type": "string"}}}|}
              );
            ]
            "Typed"
        in
        has code "    pub r#type: String,";
        has code
          "    #[serde(rename = \"@id\")]\n\
          \    #[serde(default, skip_serializing_if = \"Option::is_none\")]\n\
          \    pub id: Option<String>,");
    case "a constructor of more than seven says so to the linter" (fun () ->
        let properties =
          String.concat ", "
            (List.map
               (fun p -> Printf.sprintf {|"%s": {"type": "string"}|} p)
               [ "a"; "b"; "c"; "d"; "e"; "f"; "g"; "h"; "z" ])
        in
        has
          (generated
             [
               ( "Many",
                 Printf.sprintf
                   {|{"type": "object", "required": ["a", "b", "c", "d", "e", "f", "g", "h"], "properties": {%s}}|}
                   properties );
             ]
             "Many")
          "    #[allow(clippy::too_many_arguments)]\n\
          \    pub fn new(\n\
          \        a: impl Into<String>,");
    case "a schema named as the SDK's own is refused"
      (refused "InvalidIdentifier is a schema's name, and the SDK's own"
         (fun () ->
           generated
             [ ("InvalidIdentifier", {|{"type": "string"}|}) ]
             "InvalidIdentifier"));
    case "a file written in place that reaches itself is refused"
      (refused "reaches itself" (fun () ->
           ignore
             (D.view ~ids
                ~named:(fun _ -> None)
                ~schemas:looped
                ~referred:(fun _ -> false)
                ~at:None looped_schema);
           ""));
    case "a file written in place that reaches itself has no references"
      (refused "reaches itself" (fun () ->
           String.concat " "
             (D.references ~ids
                ~named:(fun _ -> None)
                ~schemas:looped looped_schema)));
  ]

let () = Alcotest.run "rust_types" [ ("types", cases) ]
