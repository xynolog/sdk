(* How a [$ref] names its schema: a whole file, a table's record, or a member
   inside a file, written in place. *)

open Xynolog_codegen

let case name test = Alcotest.test_case name `Quick test

let schema file text =
  match Decode.run ~file (Yojson.Safe.from_string text) Schema.decode with
  | Ok (s, _) -> s
  | Error error -> Alcotest.fail (Decode.error_to_string error)

let request = "components/schemas/Request.json"

let schemas =
  let t = Hashtbl.create 4 in
  Hashtbl.replace t request
    (schema request
       {|{"type":"object","properties":{
           "limit":{"type":"integer","minimum":1},
           "a/b":{"type":"boolean"},
           "names":{"type":"array","items":{"type":"string"}},
           "either":{"oneOf":[{"type":"string"},{"type":"number"}]}}}|});
  Hashtbl.replace t "components/schemas/Loop.json"
    (schema "components/schemas/Loop.json"
       {|{"type":"object","properties":{"self":{"$ref":"#/properties/self"}}}|});
  Hashtbl.replace t "client/registry.json#/properties/types/0"
    (schema "client/registry.json" {|{"title":"Entry","type":"object"}|});
  t

let from_client target =
  { Decode.target; file = "client/types/Options.json"; pointer = "" }

let type_of = function
  | Some (Schema.Schema { type_ = Some [ t ]; _ }) -> Some t
  | _ -> None

let type_name =
  Alcotest.testable
    (fun f t ->
      Format.pp_print_string f
        (match t with
        | Schema.String -> "string"
        | Integer -> "integer"
        | Number -> "number"
        | Boolean -> "boolean"
        | Array -> "array"
        | Object -> "object"
        | Null -> "null"))
    ( = )

(* The references here name schemas by path, so they need no index of [$id]s. *)
let ids = Result.get_ok (Decode.ids [])

let at target =
  type_of (Definitions.schema_at ~ids ~schemas (from_client target))

let refused target =
  match Definitions.schema_at ~ids ~schemas (from_client target) with
  | exception Definitions.Refused _ -> ()
  | _ -> Alcotest.failf "%s names a schema" target

let cases =
  [
    case "a member is the schema the pointer names in its file" (fun () ->
        Alcotest.(check (option type_name))
          "limit" (Some Integer)
          (at "../../components/schemas/Request.json#/properties/limit"));
    case "an escaped member name is unescaped" (fun () ->
        Alcotest.(check (option type_name))
          "a/b" (Some Boolean)
          (at "../../components/schemas/Request.json#/properties/a~1b"));
    case "a pointer walks through items and a branch" (fun () ->
        Alcotest.(check (option type_name))
          "names' items" (Some String)
          (at "../../components/schemas/Request.json#/properties/names/items");
        Alcotest.(check (option type_name))
          "either's second" (Some Number)
          (at "../../components/schemas/Request.json#/properties/either/oneOf/1"));
    case "a whole file is its schema" (fun () ->
        Alcotest.(check (option type_name))
          "Request" (Some Object)
          (at "../../components/schemas/Request.json"));
    case "a pointer at no member is refused" (fun () ->
        refused "../../components/schemas/Request.json#/properties/offset");
    case "a pointer past the schema is refused" (fun () ->
        refused "../../components/schemas/Request.json#/properties/limit/items");
    case "a pointer into a file there is none of is refused" (fun () ->
        refused "../../components/schemas/Missing.json#/properties/limit");
    case "a table's record is named by its title, not walked" (fun () ->
        let named key =
          if key = "client/registry.json#/properties/types/0" then Some "Entry"
          else None
        in
        match
          Definitions.referent ~ids ~named ~schemas
            (from_client "../registry.json#/properties/types/0")
        with
        | Some (Definitions.Named "Entry") -> ()
        | _ -> Alcotest.fail "the record is not named Entry");
    case "a member no table names is written in place" (fun () ->
        match
          Definitions.referent ~ids
            ~named:(fun _ -> None)
            ~schemas
            (from_client
               "../../components/schemas/Request.json#/properties/limit")
        with
        | Some (Definitions.In_place (key, s)) ->
            Alcotest.(check string)
              "its key" "components/schemas/Request.json#/properties/limit" key;
            Alcotest.(check (option type_name))
              "its schema" (Some Integer) (type_of (Some s))
        | _ -> Alcotest.fail "the member is not written in place");
  ]

let did = "KbDid.json"

let in_place_schemas =
  let t = Hashtbl.create 4 in
  Hashtbl.replace t did
    (schema did
       {|{"type":"string","pattern":"^did:web:\\S+$","description":"A DID."}|});
  Hashtbl.replace t "Loop.json"
    (schema "Loop.json" {|{"type":"array","items":{"$ref":"Loop.json"}}|});
  t

let named key = if key = request then Some "Request" else None

let written text =
  Schema_names.files_in_place ~ids ~schemas:in_place_schemas ~named ~places:true
    (schema "Health.json" text)

let property name = function
  | Ok (Schema.Schema { properties = Some properties; _ }) ->
      List.assoc name properties
  | Ok _ -> Alcotest.fail "no properties"
  | Error message -> Alcotest.fail message

let description = function
  | Schema.Schema { description; _ } -> description
  | Schema.Boolean_schema _ -> None

let in_place_cases =
  [
    case "a file nothing names is written in place, described as said beside"
      (fun () ->
        let kb =
          property "kb"
            (written
               {|{"type":"object","properties":{"kb":{"$ref":"KbDid.json","description":"Its DID."}}}|})
        in
        Alcotest.(check (option type_name))
          "type" (Some Schema.String) (type_of (Some kb));
        Alcotest.(check (option string))
          "description" (Some "Its DID.") (description kb));
    case "a file written in place keeps its own description when none is said"
      (fun () ->
        Alcotest.(check (option string))
          "description" (Some "A DID.")
          (description
             (property "kb"
                (written
                   {|{"type":"object","properties":{"kb":{"$ref":"KbDid.json"}}}|}))));
    case "a file a generation names stays a reference" (fun () ->
        match
          property "r"
            (written
               {|{"type":"object","properties":{"r":{"$ref":"components/schemas/Request.json"}}}|})
        with
        | Schema.Schema { ref_ = Some _; _ } -> ()
        | _ -> Alcotest.fail "written in place");
    case "a constraint beside a reference is refused" (fun () ->
        match
          written
            {|{"type":"object","properties":{"kb":{"$ref":"KbDid.json","minLength":1}}}|}
        with
        | Error _ -> ()
        | Ok _ -> Alcotest.fail "accepted");
    case "a file that reaches itself is refused" (fun () ->
        match written {|{"$ref":"Loop.json"}|} with
        | Error _ -> ()
        | Ok _ -> Alcotest.fail "accepted");
  ]

(* A schema of the client's [properties], each [$ref] read from Options.json,
   with each member of another schema written in its place, [recorded] naming
   records a table states. *)
let in_place ?(recorded = []) properties =
  let s =
    schema "client/types/Options.json"
      (Printf.sprintf {|{"type":"object","properties":{%s}}|} properties)
  in
  Definitions.members_in_place ~ids ~schemas ~recorded s

let member_of = function
  | Schema.Schema { properties = Some ps; _ } -> List.assoc_opt "m" ps
  | Schema.Boolean_schema _ | Schema.Schema _ -> None

let still_a_reference = function
  | Some (Schema.Schema { ref_ = Some _; _ }) -> ()
  | _ -> Alcotest.fail "the reference was written in its place"

let limit =
  {|"m":{"$ref":"../../components/schemas/Request.json#/properties/limit"}|}

let whole =
  [
    case "a member of another schema is written in its place" (fun () ->
        match member_of (in_place limit) with
        | Some
            (Schema.Schema { type_ = Some [ Integer ]; minimum = Some 1.; _ })
          ->
            ()
        | _ -> Alcotest.fail "m is not the integer limit is");
    case "a whole file stays a reference" (fun () ->
        still_a_reference
          (member_of
             (in_place {|"m":{"$ref":"../../components/schemas/Request.json"}|})));
    case "a reference to what the file defines stays a reference" (fun () ->
        still_a_reference
          (member_of
             (in_place
                {|"m":{"$ref":"../../components/schemas/Request.json#/$defs/Members"}|})));
    case "a record a table states stays a reference" (fun () ->
        still_a_reference
          (member_of
             (in_place
                ~recorded:
                  [ "components/schemas/Request.json#/properties/limit" ]
                limit)));
    case "a description beside a member written in place is what is said of it"
      (fun () ->
        match
          member_of
            (in_place
               {|"m":{"$ref":"../../components/schemas/Request.json#/properties/limit","description":"d"}|})
        with
        | Some
            (Schema.Schema
               { type_ = Some [ Integer ]; description = Some "d"; _ }) ->
            ()
        | _ -> Alcotest.fail "m is not the limit, described as d");
    case "a member that reaches itself in its place is refused" (fun () ->
        match
          in_place
            {|"m":{"$ref":"../../components/schemas/Loop.json#/properties/self"}|}
        with
        | exception Definitions.Refused _ -> ()
        | _ -> Alcotest.fail "the member was written in place without end");
  ]

let () =
  Alcotest.run "definitions"
    [
      ("a $ref's schema", cases);
      ("files written in place", in_place_cases);
      ("members written in place", whole);
    ]
