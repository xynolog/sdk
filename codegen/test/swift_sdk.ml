(* The schemas the Swift models generator refuses, each with why: a shape it
   has no Swift for is refused, never written as something near it. *)

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
        let models =
          M.create (D.alone ~ids ~name schema) ~identifiers ~keys:[]
        in
        M.generate models;
        M.declarations models
      with
      | exception D.Refused message -> message
      | _ -> Alcotest.failf "%s was generated" json)

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
          refused "not" {|{"type":"object","not":{}}|}
            {|unsupported schema keywords: ["not"]|};
          refused "const" {|{"type":"string","const":"x"}|}
            {|unsupported schema keywords: ["const"]|};
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
    ]
