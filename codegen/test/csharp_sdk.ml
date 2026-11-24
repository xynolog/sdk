(* What the C# SDK's models are made of a schema, and each schema they
   refuse: what the SDK's own generator refused as it compiled, now refused
   as the files are written. A keyword, type or format no schema of
   Protocol's may state is refused before, as the model reads the schema
   (Schema.decode). *)

open Xynolog_codegen
module M = Csharp_sdk.Models

let case name test = Alcotest.test_case name `Quick test
let file name = "components/schemas/" ^ name ^ ".json"

let definition name text =
  let json = Yojson.Safe.from_string text in
  match Decode.run ~file:(file name) json Schema.decode with
  | Ok (schema, _) ->
      let validated = Normalize.several_types_throughout schema in
      { M.schema = Normalize.shape_only validated; validated }
  | Error error -> failwith (Decode.error_to_string error)

let roots =
  List.map (fun (name, text) -> (name, file name, definition name text))

(* The references here name schemas by path, so they need no index of [$id]s. *)
let ids = Result.get_ok (Decode.ids [])

let made ?(identifiers = []) ?(payloads = []) schemas =
  M.make ~ids ~identifiers ~roots:(roots schemas)
    ~made:(List.map (fun (name, text) -> (name, definition name text)) payloads)

let refuses ?payloads schemas expected () =
  match made ?payloads schemas with
  | Ok _ -> Alcotest.failf "expected the refusal\n  %s\nand none came" expected
  | Error message -> Alcotest.(check string) "refusal" expected message

let models schemas =
  match made schemas with
  | Ok t -> t
  | Error message -> Alcotest.failf "refused: %s" message

let names schemas () =
  List.map (fun (name, _, _) -> name) (models schemas).models

(* What Schema.decode refuses of a component. *)
let unread text () =
  match
    Decode.run ~file:(file "X") (Yojson.Safe.from_string text) Schema.decode
  with
  | Ok _ -> Alcotest.failf "read %s" text
  | Error _ -> ()

let object_ properties =
  Printf.sprintf {|{"type":"object","properties":{%s}}|} properties

let refusals =
  [
    case "a schema that is a boolean is refused"
      (refuses
         [ ("X", object_ {|"a":true|}) ]
         "components/schemas/X.json.a is not a schema object.");
    case "a reference to no schema is refused"
      (refuses
         [ ("X", {|{"$ref":"./Absent.json"}|}) ]
         "./Absent.json names no schema the models are made from");
    case "a member of no type it can be is refused"
      (refuses
         [ ("X", object_ {|"a":{"description":"Anything?"}|}) ]
         "X.A has an unsupported type shape.");
    case "an enumeration of other than strings is refused"
      (refuses
         [ ("X", {|{"type":"integer","enum":[1,2]}|}) ]
         "X: an enumeration contains a non-string.");
    case "an enumeration whose members are one C# name is refused"
      (refuses
         [ ("X", {|{"type":"string","enum":["a-b","a_b"]}|}) ]
         "X has colliding C# enumeration names.");
    case "a model that is no object, enumeration or union is refused"
      (refuses
         [ ("X", {|{"description":"Something."}|}) ]
         "X is not an object schema.");
    case "an object whose members are one C# name is refused"
      (refuses
         [ ("X", object_ {|"a-b":{"type":"string"},"a_b":{"type":"string"}|}) ]
         "X has colliding C# property names.");
    case "an open object with a member named as what it keeps is refused"
      (refuses
         [
           ( "X",
             {|{"type":"object","properties":{"additionalProperties":{"type":"string"}},"additionalProperties":true}|}
           );
         ]
         "X has colliding C# property names.");
    case "a union of two members of one case is refused"
      (refuses
         [
           ( "X",
             {|{"oneOf":[{"type":"string"},{"type":"string","maxLength":3}]}|}
           );
         ]
         "X has colliding C# union cases.");
    case "a payload named as a component is refused"
      (refuses
         ~payloads:[ ("X", {|{"type":"object","maxProperties":0}|}) ]
         [ ("X", object_ {|"a":{"type":"string"}|}) ]
         "X is named twice among the schemas the models are made from");
    case "a reference into a file no root is read from is refused"
      (refuses
         [
           ("X", object_ {|"a":{"$ref":"./Y.json#/properties/b"}|});
           ("Y", object_ {|"b":{"type":"string"}|});
         ]
         "./Y.json#/properties/b names no schema the models are made from");
    case "a reference into a file names the root read from there" (fun () ->
        match
          M.make ~ids ~identifiers:[]
            ~roots:
              [
                ( "X",
                  file "X",
                  definition "X"
                    (object_ {|"a":{"$ref":"../../client/t.json#/types/Y"}|}) );
                ( "Y",
                  "client/t.json#/types/Y",
                  definition "Y" (object_ {|"b":{"type":"string"}|}) );
              ]
            ~made:[]
        with
        | Ok t ->
            Alcotest.(check (list string))
              "models" [ "X"; "Y" ]
              (List.map (fun (name, _, _) -> name) t.models)
        | Error message -> Alcotest.failf "refused: %s" message);
    case "patternProperties is unread"
      (unread {|{"type":"object","patternProperties":{"x":{"type":"string"}}}|});
    case "a format other than the spec's is unread"
      (unread {|{"type":"string","format":"uuid"}|});
    case "OpenAPI 3.0's nullable is unread"
      (unread {|{"type":"string","nullable":true}|});
    case "additionalProperties of a number is unread"
      (unread {|{"type":"object","additionalProperties":3}|});
  ]

let readings =
  [
    case "a plain text and an identifier are no models of their own" (fun () ->
        Alcotest.(check (list string))
          "models" [ "X" ]
          (List.map
             (fun (name, _, _) -> name)
             (match
                made ~identifiers:[ "XId" ]
                  [
                    ("Text", {|{"type":"string"}|});
                    ("XId", {|{"type":"string","pattern":"^x$"}|});
                    ( "X",
                      object_
                        {|"id":{"$ref":"./XId.json"},"t":{"$ref":"./Text.json"}|}
                    );
                  ]
              with
             | Ok t -> t.models
             | Error message -> Alcotest.failf "refused: %s" message)));
    case "what a member states in place is named for its owner and place"
      (fun () ->
        Alcotest.(check (list string))
          "models"
          [ "X"; "XKind"; "XRowsItem"; "XRowsItemState" ]
          (names
             [
               ( "X",
                 object_
                   {|"kind":{"type":"string","enum":["a","b"]},"rows":{"type":"array","items":{"type":"object","properties":{"state":{"type":"string","enum":["on"]}}}}|}
               );
             ]
             ()));
    case "a model of its own takes Value until its name is no other's"
      (fun () ->
        Alcotest.(check (list string))
          "models"
          [ "X"; "XKind"; "XKindValue" ]
          (names
             [
               ("XKind", {|{"type":"string","enum":["k"]}|});
               ("X", object_ {|"kind":{"type":"string","enum":["a","b"]}|});
             ]
             ()));
    case "a member's model of its own is found by the member" (fun () ->
        let t =
          models
            [
              ("CommandError", object_ {|"code":{"type":"string","enum":["a"]}|});
            ]
        in
        Alcotest.(check (option string))
          "code" (Some "CommandErrorCode")
          (t.member_type "CommandError" "code"));
    case "a member that refers to a model is made as no model of its own"
      (fun () ->
        let t =
          models
            [
              ("Code", {|{"type":"string","enum":["a"]}|});
              ("CommandError", object_ {|"code":{"$ref":"./Code.json"}|});
            ]
        in
        Alcotest.(check (option string))
          "code" None
          (t.member_type "CommandError" "code"));
    case "what the type writers do not read of a schema is validated" (fun () ->
        let stated =
          {|{"type":"object","properties":{"a":{"type":"string","const":"c"},"b":{"type":"object","additionalProperties":{"type":"string"},"propertyNames":{"type":"string","maxLength":3},"minProperties":1,"not":{"required":["x"]}}}}|}
        in
        Alcotest.(check string)
          "validated" stated
          (Yojson.Safe.to_string
             (Schema.runtime
                (List.assoc "X" (models [ ("X", stated) ]).schemas))));
    case "a list of two types is a union of each" (fun () ->
        Alcotest.(check (list string))
          "models" [ "X"; "XA" ]
          (names [ ("X", object_ {|"a":{"type":["string","integer"]}|}) ] ()));
    case "the schemas are those given, then each made in place, in order"
      (fun () ->
        Alcotest.(check (list string))
          "schemas" [ "B"; "A"; "AKind" ]
          (List.map fst
             (models
                [
                  ("B", {|{"type":"string","enum":["b"]}|});
                  ("A", object_ {|"kind":{"type":"string","enum":["a"]}|});
                ])
               .schemas));
  ]

(* A directory of generated files refuses one no run writes. *)
let stale =
  [
    case "a file no run writes is refused" (fun () ->
        let root = Filename.temp_dir "csharp" "" in
        let directory = "Generated" in
        Sys.mkdir (Filename.concat root directory) 0o755;
        List.iter
          (fun name ->
            Out_channel.with_open_bin
              (Filename.concat root (directory ^ "/" ^ name))
              (fun oc -> output_string oc "x"))
          [ "Kept.g.cs"; "Gone.g.cs" ];
        Alcotest.(check (list string))
          "refusals"
          [
            "Generated/Gone.g.cs: /: is a generated file no run writes: delete \
             it";
          ]
          (List.map Decode.error_to_string
             (Output.stale ~root ~directory
                [ { Output.path = "Generated/Kept.g.cs"; text = "x" } ])));
  ]

let () =
  Alcotest.run "csharp_sdk"
    [ ("refusals", refusals); ("readings", readings); ("stale", stale) ]
