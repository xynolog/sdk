(* The surface test's calls: what [Surface.Methods] makes of each parameter a
   method takes, and what the Python writer writes of each method. *)

open Xynolog_codegen
module D = Definitions
module M = Surface.Methods
module S = Tables.Client_surface

let case name test = Alcotest.test_case name `Quick test

(* The references here name schemas by path, so they need no index of [$id]s. *)
let ids = Result.get_ok (Decode.ids [])
let file name = "components/schemas/" ^ name ^ ".json"

let decoded =
  let t = Hashtbl.create 4 in
  List.iter
    (fun (name, json) ->
      match
        Decode.run ~file:(file name)
          (Yojson.Safe.from_string json)
          Schema.decode
      with
      | Ok (s, _) -> Hashtbl.replace t (file name) s
      | Error e -> Alcotest.failf "%s" (Decode.error_to_string e))
    [
      ( "Filters",
        {|{"type":"object","properties":{"limit":{"type":"integer"},"entityType":{"type":"string"}}}|}
      );
      ( "Command",
        {|{"type":"object","required":["tag"],"properties":{"tag":{"type":"string"}}}|}
      );
    ];
  t

let named f = if Hashtbl.mem decoded f then Some (D.stem f) else None
let view = D.view ~ids ~named ~schemas:decoded ~referred:(fun _ -> false)
let schema name = view ~at:None (Hashtbl.find decoded (file name))
let definitions = { D.names = [ "Filters"; "Command" ]; schema }

let reference target : S.schema =
  Reference
    {
      ref = { Decode.target; file = "client/surface.json"; pointer = "" };
      type_arguments = None;
    }

let value ?(required = true) parameter schema : S.parameters_item =
  Value { parameter; schema = Some schema; required; absent = None }

let callback ?(required = false) parameter : S.parameters_item =
  Callback
    {
      parameter;
      calls = reference "../components/schemas/Command.json";
      returns = None;
      required;
    }

let row ?(shape = S.Promise) method_ parameters : S.methods_item =
  {
    method_;
    shape;
    via = Request { request = "a:b" };
    parameters;
    returns = None;
    cases = [];
  }

let methods rows =
  M.methods ~ids ~view:(view ~at:None) ~schema
    [ { namespace = "frame"; docs = "d"; methods = rows } ]

let taken rows =
  match methods rows with
  | [ { parameters = [ p ]; _ } ] -> p.taken
  | _ -> Alcotest.fail "not one method of one parameter"

let refused f =
  match f () with
  | exception D.Refused _ -> ()
  | _ -> Alcotest.fail "wrote what it should refuse"

let derived =
  [
    case "an object none of whose members is required is spread" (fun () ->
        match
          taken
            [
              row "list"
                [
                  value ~required:false "filters"
                    (reference "../components/schemas/Filters.json");
                ];
            ]
        with
        | M.Spread { owner = "Filters"; members } ->
            Alcotest.(check (list string))
              "its members" [ "limit"; "entityType" ] (List.map fst members)
        | _ -> Alcotest.fail "filters is not spread");
    case "an object a member of which is required is one value" (fun () ->
        match
          taken
            [
              row "add"
                [
                  value "command"
                    (reference "../components/schemas/Command.json");
                ];
            ]
        with
        | M.Value { view = D.Ref { name = "Command"; _ }; at = None } -> ()
        | _ -> Alcotest.fail "command is not the one value Command");
    case "a member of a schema is stated where it is" (fun () ->
        match
          taken
            [
              row "add"
                [
                  value "type"
                    (reference
                       "../components/schemas/Command.json#/properties/tag");
                ];
            ]
        with
        | M.Value { at = Some ("Command", "tag"); _ } -> ()
        | _ -> Alcotest.fail "type is not Command's tag");
    case "a scalar the table states is a value stated nowhere else" (fun () ->
        match
          taken
            [
              row "wait"
                [
                  value ~required:false "ms"
                    (Scalar
                       {
                         type_ = Integer;
                         minimum = Some 0;
                         format = None;
                         description = "d";
                       });
                ];
            ]
        with
        | M.Value
            { view = D.Node { type_ = Some (D.One Integer); _ }; at = None } ->
            ()
        | _ -> Alcotest.fail "ms is not an integer stated alone");
    case "a callback is no argument" (fun () ->
        match taken [ row "poll" [ callback "onStatus" ] ] with
        | M.Callback -> ()
        | _ -> Alcotest.fail "onStatus is an argument");
    case "a callback a caller must give is refused" (fun () ->
        refused (fun () ->
            methods [ row "poll" [ callback ~required:true "onStatus" ] ]));
    case "a reference into a schema at no member of it is refused" (fun () ->
        refused (fun () ->
            methods
              [
                row "add"
                  [
                    value "tag"
                      (reference
                         "../components/schemas/Command.json#/properties/tag/enum");
                  ];
              ]));
  ]

let contains ~sub text =
  let n = String.length sub and m = String.length text in
  let rec go i = i + n <= m && (String.sub text i n = sub || go (i + 1)) in
  go 0

let python rows =
  (Surface.Python.file ~kinds:[]
     (Typing.make definitions ~roots:definitions.names ~identifiers:[] ~keys:[])
     (methods rows))
    .Output.text

let has code sub =
  if not (contains ~sub code) then Alcotest.failf "no %S in:\n%s" sub code

let tag = reference "../components/schemas/Command.json#/properties/tag"
let filters = reference "../components/schemas/Filters.json"

let written =
  [
    case "each argument is given by its keyword, read as its type" (fun () ->
        let code = python [ row "addEntityType" [ value "type" tag ] ] in
        has code "STR: Final = TypeAdapter[str](str)";
        has code
          {|return client.frame.add_entity_type(type=given(args, "type", STR))|});
    case "a keyword takes an underscore after it" (fun () ->
        has
          (python [ row "copy" [ value "from" tag ] ])
          {|client.frame.copy(from_=given(args, "from", STR))|});
    case "an optional argument a case may leave out is maybe given" (fun () ->
        has
          (python [ row "files" [ value ~required:false "dirPath" tag ] ])
          {|dir_path=maybe(args, "dirPath", STR)|});
    case "a spread argument is given member by member" (fun () ->
        let code =
          python
            [
              row ~shape:Cache "resources"
                [ value ~required:false "filters" filters ];
            ]
        in
        has code {|limit=member(args, "filters", "limit", INT)|};
        has code {|entity_type=member(args, "filters", "entityType", STR)|});
    case "two arguments Python names alike are refused" (fun () ->
        refused (fun () ->
            python [ row "add" [ value "aB" tag; value "a_b" tag ] ]));
    case "a query is read fresh" (fun () ->
        has
          (python [ row ~shape:Cache "resource" [ value "type" tag ] ])
          "return fresh(client.frame.resource(");
    case "a worker's claims are read for their first" (fun () ->
        has
          (python [ row ~shape:Claims "claim" [] ])
          "return anext(client.frame.claim())");
    case "a signal returns nothing" (fun () ->
        let code = python [ row ~shape:Signal "click" [] ] in
        has code "    client.frame.click()\n    return None");
    case "a channel's events are its first payload's, in EVENTS" (fun () ->
        let code = python [ row ~shape:Events "queued" [] ] in
        has code "return first_payload(client.frame.queued())";
        has code {|("frame", "queued"): frame_queued,|});
    case "a promise is awaited as it is" (fun () ->
        has (python [ row "status" [] ]) "return client.frame.status()");
  ]

let () =
  Alcotest.run "surface"
    [ ("the methods' parameters", derived); ("python's calls", written) ]
