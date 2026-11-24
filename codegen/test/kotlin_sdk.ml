(* The Kotlin types know the shapes the spec's schemas use and refuse any
   other: a schema that grows a new shape stops the run, rather than
   generating something wrong. *)

open Xynolog_codegen
module T = Kotlin_sdk.Types
module K = Kotlin_syntax

let case name test = Alcotest.test_case name `Quick test
let file name = "components/schemas/" ^ name ^ ".json"

(* The references here name schemas by path, so they need no index of [$id]s. *)
let ids = Result.get_ok (Decode.ids [])

(* Component schemas, each the JSON of its file, as a writer of types reads
   it ([Normalize.shape_only]). *)
let spec ?(identifiers = []) schemas : T.spec =
  let decoded (name, json) =
    match
      Decode.run ~file:(file name) (Yojson.Safe.from_string json) Schema.decode
    with
    | Ok (schema, _) -> (name, Normalize.shape_only schema)
    | Error error -> Alcotest.failf "%s" (Decode.error_to_string error)
  in
  {
    definitions = List.map decoded schemas;
    identifiers;
    ids;
    name_of_key = List.map (fun (name, _) -> (file name, name)) schemas;
  }

let generated ?identifiers schemas =
  let g = T.generate (spec ?identifiers schemas) in
  String.concat "\n"
    (List.map (K.decl ~depth:0)
       (g.identifier_decls @ List.concat_map snd g.types))

let refused ?identifiers schemas =
  match generated ?identifiers schemas with
  | code -> Alcotest.failf "wrote %s" code
  | exception Kotlin_sdk.Names.Refused message -> message

let contains haystack needle =
  let n = String.length needle in
  let rec from i =
    i + n <= String.length haystack
    && (String.sub haystack i n = needle || from (i + 1))
  in
  from 0

let says ~what expected said =
  if not (contains said expected) then
    Alcotest.failf "%s: %S does not say %S" what said expected

let cases =
  [
    case "a schema of a shape it does not know is refused, naming the property"
      (fun () ->
        says ~what:"refusal" "Thing.either"
          (refused
             [
               ( "Thing",
                 {|{"type":"object","properties":{"either":{"type":"array"}}}|}
               );
             ]));
    case "a const is the enumeration of its one value" (fun () ->
        says ~what:"type" {|"x"|}
          (generated
             [
               ( "Thing",
                 {|{"type":"object","properties":{"kind":{"type":"string","const":"x"}}}|}
               );
             ]));
    case "a kind of id with a pattern it cannot check is refused" (fun () ->
        says ~what:"refusal" "ThingId"
          (refused ~identifiers:[ "ThingId" ]
             [ ("ThingId", {|{"type":"string","pattern":"^(a|b)+$"}|}) ]));
    case "two properties of one Kotlin name are refused" (fun () ->
        says ~what:"refusal" "userId"
          (refused
             [
               ( "Thing",
                 {|{"type":"object","properties":{"_userId":{"type":"string"},"userId":{"type":"string"}}}|}
               );
             ]));
    case "a schema named as the SDK's own declaration is refused" (fun () ->
        says ~what:"refusal" "InvalidIdentifier"
          (refused [ ("InvalidIdentifier", {|{"type":"string"}|}) ]));
    case "a kind of id is a value class made only through its check" (fun () ->
        let code =
          generated ~identifiers:[ "ThingId" ]
            [
              ( "ThingId",
                {|{"type":"string","description":"A thing's id.","pattern":"^[A-Za-z0-9_-]{1,128}$"}|}
              );
            ]
        in
        says ~what:"code" "public value class ThingId(" code;
        says ~what:"code"
          "if (!admits(value)) throw InvalidIdentifier(\"ThingId\", PATTERN, \
           value)"
          code;
        if contains code "typealias ThingId" then
          Alcotest.failf "an alias: %s" code);
    case "a description beside a $ref is what is said of the member" (fun () ->
        let code =
          generated
            [
              ( "A",
                {|{"type":"object","properties":{"b":{"$ref":"./B.json","description":"Said beside."}}}|}
              );
              ("B", {|{"type":"string"}|});
            ]
        in
        says ~what:"code" "public val b: B? = null" code;
        says ~what:"code" "Said beside." code);
    case "a constraint beside a $ref is refused: it is an allOf" (fun () ->
        says ~what:"refusal" "has minLength beside it"
          (refused
             [
               ( "A",
                 {|{"type":"object","properties":{"b":{"$ref":"./B.json","minLength":1}}}|}
               );
               ("B", {|{"type":"string"}|});
             ]));
  ]

let () = Alcotest.run "kotlin_sdk" [ ("the types", cases) ]
