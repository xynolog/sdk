(* How Record_reader reads and writes what Records hold. Each union's member
   is read from a value its signature admits, for every union Records
   declares (union_members.ml, which the generator writes beside Records);
   and a map, a table record and the members a record writes are read and
   written back. The reader is the library's private module, copied here as
   test/dune copies it. *)
open Record_reader

let literal = function
  | Text_value text -> `Stringlit (Yojson.Safe.to_string (`String text))
  | Integer_value n -> `Intlit (string_of_int n)
  | Boolean_value b -> `Bool b

(* A value [s] admits: its first stated value, else one of its kind, an
   object of its required members and of each fixed one at its first
   value. *)
let admitted s : Yojson.Raw.t =
  match s.values with
  | Some (value :: _) -> literal value
  | _ -> (
      match s.kind with
      | Text_kind -> `Stringlit {|""|}
      | Integer_kind -> `Intlit "0"
      | Number_kind -> `Floatlit "0.5"
      | Boolean_kind -> `Bool false
      | List_kind -> `List []
      | Null_kind | Any_kind -> `Null
      | Object_kind ->
          let fixed = List.map fst s.fixed in
          `Assoc
            (List.map
               (fun name ->
                 ( name,
                   match List.assoc_opt name s.fixed with
                   | Some (value :: _) -> literal value
                   | _ -> `Null ))
               (s.required
               @ List.filter (fun name -> not (List.mem name s.required)) fixed
               )))

let members () =
  if Union_members.unions = [] then Alcotest.fail "Records declares no union";
  List.iter
    (fun (union, members) ->
      List.iteri
        (fun index signatures ->
          List.iter
            (fun s ->
              Alcotest.(check int)
                (Printf.sprintf "%s reads its member %d" union index)
                index
                (member members (admitted s)))
            signatures)
        members)
    Union_members.unions

let integral () =
  Alcotest.(check bool)
    "an integer may be written as a whole number" true
    (admits
       {
         kind = Integer_kind;
         required = [];
         allowed = None;
         fixed = [];
         values = None;
       }
       (`Floatlit "2.0"))

let maps () =
  let value = `Assoc [ ("a", `Intlit "1"); ("b", `Intlit "2") ] in
  let read = map int value in
  Alcotest.(check (list (pair string int)))
    "a map's members"
    [ ("a", 1); ("b", 2) ]
    read;
  Alcotest.(check bool)
    "a map is written back" true
    (json_map json_int read = value)

let tabled_records () =
  let of_json = function
    | `Assoc [ ("n", `Int n) ] -> Ok n
    | _ -> Error "not a table record"
  in
  let to_json n = `Assoc [ ("n", `Int n) ] in
  let value = `Assoc [ ("n", `Intlit "3") ] in
  Alcotest.(check int) "a table record is read" 3 (tabled of_json value);
  Alcotest.(check string)
    "a table record is written" {|{"n":3}|}
    (Yojson.Raw.to_string (json_tabled to_json 3))

let writes () =
  let stated = [ ("a", Some (`Intlit "1")); ("b", None) ] in
  Alcotest.(check string)
    "the members stated" {|{"a":1}|}
    (Yojson.Raw.to_string (write stated));
  Alcotest.(check string)
    "an open record's other members" {|{"a":1,"c":2}|}
    (Yojson.Raw.to_string
       (write_open stated [ ("a", `Intlit "9"); ("c", `Intlit "2") ]))

let () =
  Alcotest.run "record reader"
    [
      ( "unions",
        [
          Alcotest.test_case "each member is read by its signature" `Quick
            members;
          Alcotest.test_case "integral numbers" `Quick integral;
        ] );
      ( "members",
        [
          Alcotest.test_case "maps" `Quick maps;
          Alcotest.test_case "table records" `Quick tabled_records;
          Alcotest.test_case "writes" `Quick writes;
        ] );
    ]
