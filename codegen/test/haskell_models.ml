(* What the Haskell models writer states bytes as: a named schema of them is
   a newtype of a ByteString, read and written as their base64, since aeson
   has no JSON of bytes; bytes stated in place have no such name, and are
   refused. *)

open Xynolog_codegen
module M = Haskell_sdk.Models

let case name test = Alcotest.test_case name `Quick test
let ids = Result.get_ok (Decode.ids [])

let schema json =
  match
    Decode.run ~file:"Fixture" (Yojson.Safe.from_string json) Schema.decode
  with
  | Ok (schema, _) -> schema
  | Error e -> Alcotest.fail (Decode.error_to_string e)

let generated definitions =
  M.generate ~banner:[] ~ids ~identifiers:[]
    (List.map (fun (name, json) -> (name, schema json)) definitions)

let written definitions =
  match generated definitions with
  | Ok models ->
      String.concat "\n" (List.map Haskell_syntax.text models.M.modules)
  | Error message -> Alcotest.fail message

let contains text part =
  let n = String.length part in
  let rec at i =
    i + n <= String.length text && (String.sub text i n = part || at (i + 1))
  in
  at 0

let holds what definitions parts =
  case what (fun () ->
      let haskell = written definitions in
      List.iter
        (fun part ->
          if not (contains haskell part) then
            Alcotest.failf "no %S in:\n%s" part haskell)
        parts)

let refused what definitions expected =
  case what (fun () ->
      match generated definitions with
      | Ok _ -> Alcotest.fail "was generated"
      | Error message ->
          if not (contains message expected) then
            Alcotest.failf "refused with %S" message)

let bytes = {|{"type":"string","format":"binary"}|}

let () =
  Alcotest.run "haskell models"
    [
      ( "bytes",
        [
          holds "a named schema of bytes is a ByteString, as base64"
            [ ("Bytes", bytes) ]
            [
              "newtype Bytes = Bytes {bytesValue :: ByteString}";
              "Bytes <$> base64Bytes value";
              "toJSON (Bytes value) = base64Value value";
              "import Data.ByteString (ByteString)";
            ];
          holds "a record holds bytes by their schema's name"
            [
              ("Bytes", bytes);
              ( "Upload",
                {|{"type":"object","required":["file"],"properties":{"file":{"$ref":"Bytes.json"}}}|}
              );
            ]
            [ "uploadFile :: Bytes" ];
          refused "bytes stated in place"
            [
              ( "Upload",
                {|{"type":"object","required":["file"],"properties":{"file":{"type":"string","format":"binary"}}}|}
              );
            ]
            "bytes stated in place";
        ] );
    ]
