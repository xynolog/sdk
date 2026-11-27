(* What the Go SDK's reply checks (go/internal/required) need of the table:
   the package finds a reply's shape by the name of the type package api
   declares of its schema, which is the schema's own, so each component must
   have such a type. One the Go types group writes as an alias ([type X = Y])
   is read as the type it names is ([read_of_go]): its shape may state of what
   it holds nothing that reading does not. What it
   states of the value itself (its enumeration, pattern, lengths and bounds)
   the package holds a value to where a component refers to it. A schema
   the SDK reads by its name ([by_name]) is the package's to find by that
   name, not by a type of package api's: the sign-in store's entry, whose
   type is package xynolog's. *)

(* The kind a Go type that is no type of package api's is read as. *)
let kind_of_go named : Shape.kind option =
  let integer =
    [
      "int";
      "int8";
      "int16";
      "int32";
      "int64";
      "uint";
      "uint8";
      "uint16";
      "uint32";
      "uint64";
    ]
  in
  (* encoding/json writes and reads a []byte as text, base64's. *)
  if named = "string" || named = "[]byte" then Some String
  else if named = "bool" then Some Boolean
  else if List.mem named integer then Some Integer
  else if named = "float32" || named = "float64" then Some Number
  else if String.starts_with ~prefix:"map[" named then Some Object
  else None

(* What package required reads a value of the Go type [named] as: bytes as
   the string encoding/json writes of them, any other slice as an array of
   what it reads each item as, a type of package api that is a schema of
   [shapes] as that schema, and any other by its kind. *)
let rec read_of_go shapes named : Shape.shape =
  match named <> "[]byte" && String.starts_with ~prefix:"[]" named with
  | true ->
      let item = String.sub named 2 (String.length named - 2) in
      Shape
        {
          Shape.empty with
          kinds = Some [ Array ];
          items = Some (read_of_go shapes item);
        }
  | false when List.mem_assoc named shapes -> Ref named
  | false ->
      Shape
        {
          Shape.empty with
          kinds = Option.map (fun kind -> [ kind ]) (kind_of_go named);
        }

(* A shape without what it states of the value itself: what it holds. *)
let held : Shape.shape -> Shape.shape = function
  | Ref _ as shape -> shape
  | Shape b ->
      Shape
        {
          b with
          enum = None;
          pattern = None;
          min_length = None;
          max_length = None;
          minimum = None;
          maximum = None;
          min_items = None;
          max_items = None;
        }

let check ~declared ~by_name (shapes : (string * Shape.shape) list) =
  List.filter_map
    (fun (name, shape) ->
      if List.mem name by_name then None
      else
        let refused message =
          Some { Decode.file = Go_types.path; pointer = ""; message }
        in
        match List.assoc_opt name declared with
        | None ->
            refused
              (Printf.sprintf
                 "declares no type %s, and %s is a component of openapi.json"
                 name name)
        | Some None -> None
        | Some (Some named) ->
            let read_as = read_of_go shapes named in
            if held shape = read_as then None
            else
              refused
                (Printf.sprintf
                   "writes %s as an alias of %s, which is read as %s, and its \
                    schema requires %s of it"
                   name named
                   (Yojson.Safe.to_string (Shape.to_json ~pairs:false read_as))
                   (Yojson.Safe.to_string
                      (Shape.to_json ~pairs:false (held shape)))))
    shapes
