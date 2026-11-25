open Xynolog_codegen

let case name test = Alcotest.test_case name `Quick test

let command_error =
  ( "CommandError",
    {|{"type":"object","properties":{"code":{"type":"string","enum":["a-code"]}}}|}
  )

let component (name, text) =
  let file = "components/schemas/" ^ name ^ ".json" in
  match Decode.run ~file (Yojson.Safe.from_string text) Schema.decode with
  | Ok (schema, _) -> (name, file, schema)
  | Error error -> failwith (Decode.error_to_string error)

(* The references here name schemas by path, so they need no index of [$id]s. *)
let ids = Result.get_ok (Decode.ids [])

let derived components =
  Required.Shape.derive ~ids ~unrecognized:"Unrecognized"
    (List.map component (command_error :: components))

let compact text = Yojson.Safe.to_string (Yojson.Safe.from_string text)

let shape_text ?(pairs = false) shape =
  Yojson.Safe.to_string (Required.Shape.to_json ~pairs shape)

(* The shape the derivation gives [name], among [components], as JSON. *)
let derives ?pairs components name expected () =
  match derived components with
  | Error errors ->
      Alcotest.failf "refused:\n  %s"
        (String.concat "\n  " (List.map Decode.error_to_string errors))
  | Ok derivation ->
      Alcotest.(check string)
        name (compact expected)
        (shape_text ?pairs (List.assoc name derivation.shapes))

let refuses components expected () =
  match derived components with
  | Ok _ -> Alcotest.failf "expected the refusal\n  %s\nand none came" expected
  | Error errors ->
      let found = List.map Decode.error_to_string errors in
      if not (List.mem expected found) then
        Alcotest.failf "expected the refusal\n  %s\nfound\n  %s" expected
          (String.concat "\n  " found)

let s = "components/schemas/S.json"
let string_component = ("Str", {|{"type":"string"}|})

let kinds =
  [
    case "a type is a kind"
      (derives [ ("S", {|{"type":"string"}|}) ] "S" {|{"kinds":["string"]}|});
    case "a number allows an integer"
      (derives
         [ ("S", {|{"type":["integer","number"]}|}) ]
         "S" {|{"kinds":["number"]}|});
    case "kinds in the table's order"
      (derives
         [ ("S", {|{"type":["boolean","array","string"]}|}) ]
         "S" {|{"kinds":["array","string","boolean"]}|});
    case "a schema that states nothing allows anything"
      (derives [ ("S", {|{"description":"anything"}|}) ] "S" {|{}|});
    case "an enum's values are its kinds"
      (derives
         [ ("S", {|{"enum":["a",1,true]}|}) ]
         "S" {|{"kinds":["string","integer","boolean"],"enum":["a",1,true]}|});
    case "properties make an object"
      (derives
         [ ("S", {|{"required":["a"]}|}) ]
         "S" {|{"kinds":["object"],"required":["a"]}|});
    case "items make an array"
      (derives
         [ ("S", {|{"items":{"type":"string"}}|}) ]
         "S" {|{"kinds":["array"],"items":{"kinds":["string"]}}|});
    case "allOf allows what each part allows"
      (derives
         [
           ("S", {|{"allOf":[{"type":["string","integer"]},{"type":"number"}]}|});
         ]
         "S"
         {|{"kinds":["integer"],"allOf":[{"kinds":["string","integer"]},{"kinds":["number"]}]}|});
    case "oneOf allows what any variant allows"
      (derives
         [ ("S", {|{"oneOf":[{"type":"string"},{"type":"boolean"}]}|}) ]
         "S"
         {|{"kinds":["string","boolean"],"oneOf":[{"kinds":["string"]},{"kinds":["boolean"]}]}|});
  ]

(* The pointers of the members of [text] that the spec's reading refuses as
   optional and nullable. *)
let optional_nullable text expected () =
  let _, file, schema = component ("S", text) in
  Alcotest.(check (list string))
    "refused" expected
    (List.map
       (fun (error : Decode.error) -> error.pointer)
       (Spec_shapes.optional_nullable file schema))

let nullable =
  [
    case "null beside a type allows null"
      (derives
         [ ("S", {|{"type":["string","null"]}|}) ]
         "S" {|{"kinds":["string","null"]}|});
    case "an anyOf of a reference and null is a union with null"
      (derives
         [
           string_component;
           ("S", {|{"anyOf":[{"$ref":"./Str.json"},{"type":"null"}]}|});
         ]
         "S"
         {|{"kinds":["string","null"],"oneOf":[{"kinds":["null"]},{"ref":"Str"}]}|});
    case "a oneOf whose last member is null is a union with null"
      (derives
         [
           ( "S",
             {|{"oneOf":[{"type":"string"},{"type":"boolean"},{"type":"null"}]}|}
           );
         ]
         "S"
         {|{"kinds":["string","boolean","null"],"oneOf":[{"kinds":["null"]},{"kinds":["string","boolean"],"oneOf":[{"kinds":["string"]},{"kinds":["boolean"]}]}]}|});
    case "an anyOf that holds null beside no reference is refused"
      (refuses
         [ ("S", {|{"anyOf":[{"type":"string"},{"type":"null"}]}|}) ]
         (s
        ^ ": /: an anyOf that holds null is of one $ref and { \"type\": \
           \"null\" }"));
    case "an enum beside a type that allows null is refused"
      (refuses
         [ ("S", {|{"type":["string","null"],"enum":["a"]}|}) ]
         (s
        ^ ": /: states an enum beside a type that allows null, and an enum \
           states no null"));
    case "a member that is optional and may be null is refused, wherever it is"
      (optional_nullable
         {|{"type":"object","properties":{
             "a":{"type":["string","null"]},
             "b":{"type":"object","properties":{"c":{"oneOf":[{"type":"string"},{"type":"integer"},{"type":"null"}]}}},
             "d":{"type":"array","items":{"type":"object","properties":{"e":{"type":["integer","null"]}}}}}}|}
         [
           "/properties/a";
           "/properties/b/properties/c";
           "/properties/d/items/properties/e";
         ]);
    case "a member that is required, or that may not be null, is read"
      (optional_nullable
         {|{"type":"object","required":["a"],"properties":{"a":{"type":["string","null"]},"b":{"type":"string"}}}|}
         []);
  ]

let values =
  [
    case "a pattern's sets, escapes and quantifiers"
      (derives
         [
           ( "S",
             {|{"type":"string","pattern":"^[c-ea]\\d{2,}[^b]?x*\\.{1,3}y+$"}|}
           );
         ]
         "S"
         {|{"kinds":["string"],"pattern":[
             {"of":[[97,97],[99,101]],"min":1,"max":1},
             {"of":[[48,57]],"min":2},
             {"of":[[0,97],[99,1114111]],"min":0,"max":1},
             {"of":[[120,120]],"min":0},
             {"of":[[46,46]],"min":1,"max":3},
             {"of":[[121,121]],"min":1}]}|});
    case "dot and the white space escape"
      (derives
         [ ("S", {|{"type":"string","pattern":"^.\\s$"}|}) ]
         "S"
         {|{"kinds":["string"],"pattern":[
             {"of":[[0,9],[11,12],[14,8231],[8234,1114111]],"min":1,"max":1},
             {"of":[[9,13],[32,32],[160,160],[5760,5760],[8192,8202],[8232,8233],[8239,8239],[8287,8287],[12288,12288],[65279,65279]],"min":1,"max":1}]}|});
    case "a group's alternatives are a group of series"
      (derives
         [ ("S", {|{"type":"string","pattern":"^(a|bc)+$"}|}) ]
         "S"
         {|{"kinds":["string"],"pattern":[
             {"either":[
               [{"of":[[97,97]],"min":1,"max":1}],
               [{"of":[[98,98]],"min":1,"max":1},{"of":[[99,99]],"min":1,"max":1}]],
              "min":1}]}|});
    case "an end the pattern does not anchor takes any code points"
      (derives
         [ ("S", {|{"type":"string","pattern":"ab"}|}) ]
         "S"
         {|{"kinds":["string"],"pattern":[
             {"of":[[0,1114111]],"min":0},
             {"of":[[97,97]],"min":1,"max":1},
             {"of":[[98,98]],"min":1,"max":1},
             {"of":[[0,1114111]],"min":0}]}|});
    case "a backward range is refused"
      (refuses
         [ ("S", {|{"type":"string","pattern":"^[z-a]$"}|}) ]
         (s
        ^ ": /pattern: is ^[z-a]$, which is not a pattern the table can spell \
           out"));
    case "bounds and counts"
      (derives
         [
           ( "S",
             {|{"type":"object","properties":{
                 "n":{"type":"integer","minimum":1,"maximum":100},
                 "f":{"type":"number","minimum":0.5},
                 "t":{"type":"string","minLength":1,"maxLength":5},
                 "l":{"type":"array","minItems":1,"maxItems":3}}}|}
           );
         ]
         "S"
         {|{"kinds":["object"],"members":{
             "f":{"kinds":["number"],"minimum":0.5},
             "l":{"kinds":["array"],"minItems":1,"maxItems":3},
             "n":{"kinds":["integer"],"minimum":1,"maximum":100},
             "t":{"kinds":["string"],"minLength":1,"maxLength":5}}}|});
    case "a negative count is refused"
      (refuses
         [ ("S", {|{"type":"string","minLength":-1}|}) ]
         (s ^ ": /minLength: is -1, which is no count"));
  ]

let objects =
  [
    case "members by their code points, and only those that can be wrong"
      (derives
         [
           ( "S",
             {|{"type":"object","required":["b","a"],"properties":{
                 "é":{"type":"string"},"b":{"type":"string"},
                 "a":{"description":"anything"},"B":{"type":"boolean"}}}|}
           );
         ]
         "S"
         {|{"kinds":["object"],"required":["b","a"],"members":{
             "B":{"kinds":["boolean"]},"b":{"kinds":["string"]},
             "é":{"kinds":["string"]}}}|});
    case "the sets of members an object does not carry all of"
      (derives
         [
           ( "S",
             {|{"type":"object","properties":{"a":{},"b":{},"c":{}},
                "not":{"anyOf":[{"required":["a","b"]},{"required":["c"]}]}}|}
           );
         ]
         "S" {|{"kinds":["object"],"notAll":[["a","b"],["c"]]}|});
    case "a not of other than required members is refused"
      (refuses
         [ ("S", {|{"type":"object","not":{"type":"string"}}|}) ]
         (s
        ^ ": /not: is a not of what is no list of required members, which the \
           table does not know how to state"));
    case "the fewest members, and what each member's name is"
      (derives
         [
           ( "S",
             {|{"type":"object","minProperties":1,"propertyNames":{"type":"string","pattern":"^[a-z]+$"},"additionalProperties":{"type":"string"}}|}
           );
         ]
         "S"
         {|{"kinds":["object"],"values":{"kinds":["string"]},"minMembers":1,
            "names":{"kinds":["string"],"pattern":[{"of":[[97,122]],"min":1}]}}|});
    case "members as pairs, for a reader whose objects keep no order"
      (derives ~pairs:true
         [
           ( "S",
             {|{"type":"object","properties":{"b":{"type":"string"},"a":{"type":"string"}}}|}
           );
         ]
         "S"
         {|{"kinds":["object"],"members":[["a",{"kinds":["string"]}],["b",{"kinds":["string"]}]]}|});
    case "closed to what it names"
      (derives
         [
           ( "S",
             {|{"type":"object","additionalProperties":false,"properties":{"b":{},"a":{}}}|}
           );
         ]
         "S" {|{"kinds":["object"],"closed":["a","b"]}|});
    case "closed to every member"
      (derives
         [ ("S", {|{"type":"object","maxProperties":0}|}) ]
         "S" {|{"kinds":["object"],"closed":[]}|});
    case "a maxProperties above zero is refused"
      (refuses
         [ ("S", {|{"type":"object","maxProperties":1}|}) ]
         (s
        ^ ": /maxProperties: is 1 beside 0 properties, and the table states \
           only an object that carries none"));
    case "a map's values"
      (derives
         [
           ("S", {|{"type":"object","additionalProperties":{"type":"integer"}}|});
         ]
         "S" {|{"kinds":["object"],"values":{"kinds":["integer"]}}|});
    case "a closed part of an allOf is refused"
      (refuses
         [
           ("Closed", {|{"type":"object","additionalProperties":false}|});
           ( "S",
             {|{"allOf":[{"$ref":"./Closed.json"},{"type":"object","required":["a"]}]}|}
           );
         ]
         (s
        ^ ": /allOf: has a closed part, which would refuse the other parts' \
           members"));
    case "a description beside a reference is that reference"
      (derives
         [
           string_component; ("S", {|{"$ref":"./Str.json","description":"d"}|});
         ]
         "S" {|{"ref":"Str"}|});
  ]

let unions =
  [
    case "a discriminator's mapping by the variants' places"
      (derives
         [
           ("A", {|{"type":"object","required":["kind"]}|});
           ("B", {|{"type":"object","required":["kind"]}|});
           ( "S",
             {|{"oneOf":[{"$ref":"./A.json"},{"$ref":"./B.json"}],
                "discriminator":{"propertyName":"kind","mapping":{"b":"./B.json","a":"./A.json"}}}|}
           );
         ]
         "S"
         {|{"kinds":["object"],"oneOf":[{"ref":"A"},{"ref":"B"}],
            "discriminator":{"property":"kind","mapping":{"b":1,"a":0}}}|});
    case "a mapping to no variant is refused"
      (refuses
         [
           ("A", {|{"type":"object","required":["kind"]}|});
           ("B", {|{"type":"object","required":["kind"]}|});
           ( "S",
             {|{"oneOf":[{"$ref":"./A.json"}],
                "discriminator":{"propertyName":"kind","mapping":{"b":"./B.json"}}}|}
           );
         ]
         (s
        ^ ": /discriminator/mapping/b: maps \"b\" to ./B.json, which is none \
           of its variants"));
    case "a discriminator with no mapping maps the value each variant fixes"
      (derives
         [
           ( "S",
             {|{"oneOf":[
                 {"type":"object","properties":{"kind":{"enum":["a"]}},"required":["kind"]},
                 {"type":"object","properties":{"kind":{"const":"b"}},"required":["kind"]}],
                "discriminator":{"propertyName":"kind"}}|}
           );
         ]
         "S"
         {|{"kinds":["object"],"oneOf":[
             {"kinds":["object"],"required":["kind"],"members":{"kind":{"kinds":["string"],"enum":["a"]}}},
             {"kinds":["object"],"required":["kind"],"members":{"kind":{"kinds":["string"],"enum":["b"]}}}],
            "discriminator":{"property":"kind","mapping":{"a":0,"b":1}}}|});
    case
      "a discriminator with no mapping maps the value a variant's allOf fixes"
      (derives
         [
           ( "S",
             {|{"oneOf":[
                 {"allOf":[{"type":"object","properties":{"kind":{"enum":["a"]}},"required":["kind"]}]},
                 {"allOf":[{"type":"object","properties":{"kind":{"enum":["b"]}},"required":["kind"]}]}],
                "discriminator":{"propertyName":"kind"}}|}
           );
         ]
         "S"
         {|{"kinds":["object"],"oneOf":[
             {"kinds":["object"],"allOf":[{"kinds":["object"],"required":["kind"],"members":{"kind":{"kinds":["string"],"enum":["a"]}}}]},
             {"kinds":["object"],"allOf":[{"kinds":["object"],"required":["kind"],"members":{"kind":{"kinds":["string"],"enum":["b"]}}}]}],
            "discriminator":{"property":"kind","mapping":{"a":0,"b":1}}}|});
    case "a discriminator with no mapping over a referred variant is refused"
      (refuses
         [
           ("A", {|{"type":"object","required":["kind"]}|});
           ( "S",
             {|{"oneOf":[{"$ref":"./A.json"}],"discriminator":{"propertyName":"kind"}}|}
           );
         ]
         (s
        ^ ": /discriminator: states no mapping, and variant 0 is no object \
           stated in place"));
    case
      "a discriminator with no mapping over a variant that fixes no value is \
       refused"
      (refuses
         [
           ( "S",
             {|{"oneOf":[{"type":"object","properties":{"kind":{"type":"string"}}}],
                "discriminator":{"propertyName":"kind"}}|}
           );
         ]
         (s
        ^ ": /discriminator: states no mapping, and variant 0 fixes no one kind"
         ));
    case
      "a discriminator with no mapping over a variant that fixes two values is \
       refused"
      (refuses
         [
           ( "S",
             {|{"oneOf":[{"type":"object","properties":{"kind":{"enum":["a"]}},
                 "allOf":[{"type":"object","properties":{"kind":{"enum":["b"]}}}]}],
                "discriminator":{"propertyName":"kind"}}|}
           );
         ]
         (s
        ^ ": /discriminator: states no mapping, and variant 0 fixes no one kind"
         ));
    case "a discriminator beside no union is refused"
      (refuses
         [
           ( "S",
             {|{"type":"object","discriminator":{"propertyName":"kind","mapping":{}}}|}
           );
         ]
         (s ^ ": /discriminator: is beside no oneOf or anyOf"));
    case "unevaluatedProperties unread as one object is refused"
      (refuses
         [
           ( "S",
             {|{"allOf":[{"type":"object","properties":{"a":{"type":"string"}}}],
                "unevaluatedProperties":false}|}
           );
         ]
         (s
        ^ ": /: states unevaluatedProperties, which the table reads only as \
           the one object it closes (Normalize.closed_within)"));
    case "oneOf beside anyOf is refused"
      (refuses
         [
           ("S", {|{"oneOf":[{"type":"string"}],"anyOf":[{"type":"string"}]}|});
         ]
         (s ^ ": /: states both oneOf and anyOf"));
    case "a component's union none of whose variants can be wrong is left out"
      (derives
         [ ("S", {|{"type":"object","anyOf":[{},{"description":"x"}]}|}) ]
         "S" {|{"kinds":["object"]}|});
    case "a member's union none of whose variants can be wrong is left out"
      (derives
         [
           ( "S",
             {|{"type":"object","properties":{"u":{"anyOf":[{},{"description":"x"}]}}}|}
           );
         ]
         "S" {|{"kinds":["object"]}|});
  ]

let references =
  [
    case "a component that can be wrong is referred to"
      (derives
         [
           string_component;
           ("S", {|{"type":"object","properties":{"a":{"$ref":"./Str.json"}}}|});
         ]
         "S" {|{"kinds":["object"],"members":{"a":{"ref":"Str"}}}|});
    case "components that refer only to each other can be wrong in no way"
      (derives
         [
           ("A", {|{"allOf":[{"$ref":"./B.json"},{"description":"x"}]}|});
           ("B", {|{"anyOf":[{"$ref":"./A.json"},{}]}|});
           ("S", {|{"type":"object","properties":{"a":{"$ref":"./A.json"}}}|});
         ]
         "S" {|{"kinds":["object"]}|});
    case "a reference to no component is refused"
      (refuses
         [ ("S", {|{"$ref":"./Missing.json"}|}) ]
         (s
        ^ ": /$ref: names ./Missing.json, which is no component of openapi.json"
         ));
    case "a reference into a component is the schema there"
      (derives
         [
           ( "O",
             {|{"type":"object","properties":{"a":{"type":"string","minLength":1}}}|}
           );
           ("S", {|{"$ref":"./O.json#/properties/a"}|});
         ]
         "S" {|{"kinds":["string"],"minLength":1}|});
    case "a schema that allows nothing is refused"
      (refuses
         [ ("S", {|{"type":"array","items":false}|}) ]
         (s
        ^ ": /items: allows no value, which the table does not know how to \
           state"));
  ]

let command_errors =
  [
    case "CommandError's codes are recognized, and no enum"
      (derives [] "CommandError"
         {|{"kinds":["object"],"members":{"code":{"kinds":["string"],"recognized":["a-code"]}}}|});
    case "a CommandError that requires its code is refused" (fun () ->
        match
          Required.Shape.derive ~ids ~unrecognized:"Unrecognized"
            [
              component
                ( "CommandError",
                  {|{"type":"object","required":["code"],"properties":{"code":{"type":"string","enum":["a"]}}}|}
                );
            ]
        with
        | Ok _ -> Alcotest.fail "accepted"
        | Error errors ->
            Alcotest.(check (list string))
              "refusals"
              [
                "components/schemas/CommandError.json: /required: requires \
                 code, and codes.json reads a code its enum does not name as \
                 Unrecognized, as one that states none";
              ]
              (List.map Decode.error_to_string errors));
    case "a CommandError whose code names no list is refused" (fun () ->
        match
          Required.Shape.derive ~ids ~unrecognized:"Unrecognized"
            [
              component
                ( "CommandError",
                  {|{"type":"object","properties":{"code":{"type":"string"}}}|}
                );
            ]
        with
        | Ok _ -> Alcotest.fail "accepted"
        | Error errors ->
            Alcotest.(check (list string))
              "refusals"
              [
                "components/schemas/CommandError.json: /properties/code: is \
                 one of no enum, and codes.json reads a code the enum does not \
                 name as Unrecognized";
              ]
              (List.map Decode.error_to_string errors));
  ]

let json shape =
  Yojson.Safe.to_string (Required.Shape.to_json ~pairs:false shape)

let string_shape =
  Required.Shape.Shape { Required.Shape.empty with kinds = Some [ String ] }

let go =
  let declared =
    [
      ("A", None);
      ("B", Some "string");
      ("C", Some "map[string]int");
      ("D", Some "[]byte");
    ]
  in
  let check shapes =
    List.map Decode.error_to_string (Required.Go.check ~declared shapes)
  in
  [
    case "an alias read as the kind its schema states" (fun () ->
        Alcotest.(check (list string))
          "refusals" []
          (check
             [
               ("A", Required.Shape.Ref "B");
               ( "B",
                 Required.Shape.Shape
                   {
                     Required.Shape.empty with
                     kinds = Some [ String ];
                     enum = Some [ String_literal "x" ];
                   } );
               ( "C",
                 Required.Shape.Shape
                   { Required.Shape.empty with kinds = Some [ Object ] } );
             ]));
    case "an alias of bytes read as the string encoding/json writes" (fun () ->
        Alcotest.(check (list string))
          "refusals" []
          (check [ ("D", string_shape) ]));
    case "an alias whose schema holds more is refused" (fun () ->
        Alcotest.(check (list string))
          "refusals"
          [
            "go/api/types_gen.go: /: writes C as an alias of map[string]int, \
             which is read as {\"kinds\":[\"object\"]}, and its schema \
             requires {\"kinds\":[\"object\"],\"closed\":[]} of it";
          ]
          (check
             [
               ( "C",
                 Required.Shape.Shape
                   {
                     Required.Shape.empty with
                     kinds = Some [ Object ];
                     closed = Some [];
                   } );
             ]));
    case "a component with no type is refused" (fun () ->
        Alcotest.(check (list string))
          "refusals"
          [
            "go/api/types_gen.go: /: declares no type E, and E is a component \
             of openapi.json";
          ]
          (check [ ("E", string_shape) ]));
  ]

let writers =
  [
    case "the JSON table, a schema to a line" (fun () ->
        Alcotest.(check string)
          "text"
          ("{\n  \"$comment\": "
          ^ Yojson.Safe.to_string (`String Required.Table.comment)
          ^ ",\n\
            \  \"schemas\": {\n\
            \    \"A\": {},\n\
            \    \"B\": {\"kinds\":[\"string\"]}\n\
            \  }\n\
             }\n")
          (Required.Table.text
             [
               ("A", Required.Shape.Shape Required.Shape.empty);
               ("B", string_shape);
             ]));
    case "an envelope holds only its response" (fun () ->
        let docs : Tables.Bus_registry.docs = { lead = []; trailing = "" } in
        Alcotest.(check (list (result string string)))
          "shapes"
          [
            Ok
              {|{"kinds":["object"],"required":["response"],"members":{"response":{"ref":"A"}},"closed":["response"]}|};
            Ok {|{"kinds":["object"],"closed":[]}|};
            Ok {|{"ref":"StoredEventResponse"}|};
            Error
              {|bus/registry.json: /channels: "c" carries Missing, which is no component|};
          ]
          (List.map
             (fun channel ->
               Result.map_error Decode.error_to_string
                 (Result.map json
                    (Required.Event.channel
                       ~known:(fun name -> name <> "Missing")
                       channel)))
             [
               Tables.Bus_registry.Envelope
                 {
                   channel = "c";
                   shape = "envelope";
                   schema = "A";
                   validate = None;
                   docs;
                   schema_docs = docs;
                 };
               Void
                 {
                   channel = "c";
                   shape = "void";
                   validate = None;
                   docs;
                   schema_docs = docs;
                 };
               Stored_event
                 {
                   channel = "c";
                   shape = "storedEvent";
                   event = "e";
                   payload = "P";
                   enriched = None;
                   system = None;
                   validate = None;
                   docs;
                   schema_docs = docs;
                 };
               Schema
                 {
                   channel = "c";
                   shape = "schema";
                   schema = "Missing";
                   validate = None;
                   docs;
                   schema_docs = docs;
                 };
             ]));
  ]

let () =
  Alcotest.run "required"
    [
      ("kinds", kinds);
      ("nullable", nullable);
      ("values", values);
      ("objects", objects);
      ("unions", unions);
      ("references", references);
      ("CommandError", command_errors);
      ("Go", go);
      ("writers", writers);
    ]
