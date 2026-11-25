(* What the Go SDK's reply checks (go/internal/required) need of the table:
   the package finds a reply's shape by the name of the type package api
   declares of its schema, which is the schema's own, so each component must
   have such a type. One the Go types group writes as an alias ([type X = Y])
   is read by the type it names: its shape may state no kind but the one that
   type is, and nothing of what an object, an array or a union holds. What it
   states of the value itself (its enumeration, pattern, lengths and bounds)
   the package holds a value to where a component refers to it. *)

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
  else if String.starts_with ~prefix:"[]" named then Some Array
  else None

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

let check ~declared (shapes : (string * Shape.shape) list) =
  List.filter_map
    (fun (name, shape) ->
      let refused message =
        Some { Decode.file = Go_types.path; pointer = ""; message }
      in
      match List.assoc_opt name declared with
      | None ->
          refused
            (Printf.sprintf
               "declares no type %s, and %s is a component of openapi.json" name
               name)
      | Some None -> None
      | Some (Some named) ->
          let read_as =
            Shape.Shape
              {
                Shape.empty with
                kinds = Option.map (fun kind -> [ kind ]) (kind_of_go named);
              }
          in
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
