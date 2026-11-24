(* Shared cases from client/shape-cases.json: each case's value held to the
   schema it names, from the value itself, its first fault the one the case
   states, or none. The walker's modules are the library's private ones,
   copied here as test/dune copies them. *)
module T = Protocol_cases.Client_shape_cases

let held schema value =
  if not (Hashtbl.mem Schema_codec.shapes schema) then
    Alcotest.fail ("the table has no schema " ^ schema);
  Schema_codec.decode
    (Schema_shape.reference schema)
    (Yojson.Safe.to_string value)

let case (row : T.cases_item) () =
  match row with
  | Shape_accepted { schema; value; _ } -> (
      match held schema value with
      | Ok _ -> ()
      | Error (Invalid_payload fault) ->
          Alcotest.fail
            (Printf.sprintf "refused at %S, %s" fault.member
               (Enums.Frame_refusal_reason.to_string fault.reason))
      | Error (Invalid_json message) -> Alcotest.fail message)
  | Shape_refused { schema; value; member; reason = stated; _ } -> (
      match held schema value with
      | Error (Invalid_payload fault) ->
          Alcotest.(check string) "member" member fault.member;
          Alcotest.(check string)
            "reason"
            (T.frame_refusal_reason_value stated)
            (Enums.Frame_refusal_reason.to_string fault.reason)
      | Ok _ -> Alcotest.fail "the value was read"
      | Error (Invalid_json message) -> Alcotest.fail message)

let why : T.cases_item -> string = function
  | Shape_accepted { why; _ } | Shape_refused { why; _ } -> why

let () =
  if T.table.cases = [] then failwith "shape-cases.json states no case";
  Alcotest.run "shape cases"
    [
      ( "shapes",
        List.map
          (fun row -> Alcotest.test_case (why row) `Quick (case row))
          T.table.cases );
    ]
