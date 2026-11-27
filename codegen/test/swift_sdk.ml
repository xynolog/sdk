(* The schemas the Swift models generator refuses, each with why: a shape it
   has no Swift for is refused, never written as something near it; and what
   it holds a shape [Deviations] names as. *)

open Xynolog_codegen
module D = Definitions
module M = Swift_sdk.Models

let case name test = Alcotest.test_case name `Quick test

(* The references here name schemas by path, so they need no index of [$id]s. *)
let ids = Result.get_ok (Decode.ids [])

(* Why the schema [json], named [name], is refused: by the schema's decoder,
   or by the generator. *)
let refusal ?(identifiers = []) ?(name = "Fixture") json =
  match Decode.run ~file:name (Yojson.Safe.from_string json) Schema.decode with
  | Error e -> Decode.error_to_string e
  | Ok (schema, _) -> (
      match
        let definitions = D.alone ~ids ~name schema in
        let models =
          M.create
            [
              Typing.make definitions ~roots:[ name ] ~identifiers
                ~value_docs:[];
            ]
            ~schema:definitions.schema
        in
        M.generate models;
        M.declarations models
      with
      | exception D.Refused message -> message
      | _ -> Alcotest.failf "%s was generated" json)

(* The Swift the schema [json], named [Fixture], is written as. *)
let written json =
  match
    Decode.run ~file:"Fixture" (Yojson.Safe.from_string json) Schema.decode
  with
  | Error e -> Alcotest.fail (Decode.error_to_string e)
  | Ok (schema, _) ->
      let definitions = D.alone ~ids ~name:"Fixture" schema in
      let models =
        M.create
          [
            Typing.make definitions ~roots:[ "Fixture" ] ~identifiers:[]
              ~value_docs:[];
          ]
          ~schema:definitions.schema
      in
      M.generate models;
      Swift_syntax.print
        {
          banner = [];
          imports = [];
          decls =
            List.map (fun d -> (Swift_syntax.Blank, d)) (M.declarations models);
        }

let holds what json expected =
  case what (fun () ->
      let swift = written json in
      if List.length (Text.split ~sub:expected swift) < 2 then
        Alcotest.failf "%s holds no %s:\n%s" what expected swift)

let refused ?identifiers ?name what json expected =
  case what (fun () ->
      Alcotest.(check string) what expected (refusal ?identifiers ?name json))

let () =
  Alcotest.run "swift_sdk"
    [
      ( "refused",
        [
          refused "a type array" {|{"type":["string","integer"]}|}
            "a schema of several types the generator does not know";
          refused "an array without items" {|{"type":"array"}|}
            "Fixture: array without items";
          refused "an empty oneOf" {|{"oneOf":[]}|}
            "Fixture: /oneOf: expected a non-empty array";
          refused "an unknown format"
            {|{"type":"object","properties":{"x":{"type":"string","format":"secret-format"}}}|}
            {|Fixture: /properties/x/format: "secret-format" is none of date-time, uri, binary|};
          refused "two members of one Swift name"
            {|{"type":"object","properties":{"a-b":{"type":"string"},"aB":{"type":"string"}}}|}
            "Fixture: duplicate or reserved property aB";
          refused "an identifier pattern with no Swift check"
            ~identifiers:[ "FixtureId" ] ~name:"FixtureId"
            {|{"type":"string","pattern":"^(a|b)+$"}|}
            "FixtureId: unsupported identifier pattern";
        ] );
      ( "held",
        [
          holds
            "an object in place that names no member and says nothing of others"
            {|{"type":"object","required":["x"],"properties":{"x":{"type":"object"}}}|}
            "public var x: [String: JSONValue]";
          holds "an object in place that names no member and admits any"
            {|{"type":"object","required":["x"],"properties":{"x":{"type":"object","additionalProperties":true}}}|}
            "public var x: [String: JSONValue]";
          holds "bytes as Data, and other text as a String"
            {|{"type":"object","required":["file","name"],"properties":{"file":{"type":"string","format":"binary"},"name":{"type":"string"}}}|}
            "public var file: Data\n  public var name: String";
          holds "a named list as an alias of its array"
            {|{"type":"array","items":{"type":"string"}}|}
            "public typealias Fixture = [String]";
        ] );
    ]
