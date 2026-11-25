type fault = Models.fault

let ( let* ) = Result.bind
let fault reason member = Error { Models.member; reason }
let malformed member = fault Enums.Frame_refusal_reason.Malformed member

let within member (fault : fault) =
  if fault.member = "" then { fault with member }
  else { fault with member = member ^ "." ^ fault.member }

let string member = function `String value -> Ok value | _ -> malformed member
let bool member = function `Bool value -> Ok value | _ -> malformed member
let int member = function `Int value -> Ok value | _ -> malformed member

let float member = function
  | `Float value -> Ok value
  | `Int value -> Ok (Float.of_int value)
  | _ -> malformed member

let enum of_string member json =
  let* text = string member json in
  match of_string text with Some value -> Ok value | None -> malformed member

let record of_json member json = Result.map_error (within member) (of_json json)

let model descriptor member json =
  match Models.decode descriptor (Yojson.Safe.to_string json) with
  | Ok value -> Ok value
  | Error (Models.Invalid_json _) -> malformed member
  | Error (Invalid_payload fault) -> Error (within member fault)

let list read member = function
  | `List values ->
      List.fold_right
        (fun value rest ->
          let* value = read member value in
          let* rest = rest in
          Ok (value :: rest))
        values (Ok [])
  | _ -> malformed member

let map read members =
  List.fold_right
    (fun (member, json) rest ->
      let* value = read member json in
      let* rest = rest in
      Ok ((member, value) :: rest))
    members (Ok [])

let assoc read member = function
  | `Assoc members -> map read members
  | _ -> malformed member

let nullable read member = function
  | `Null -> Ok None
  | json -> Result.map Option.some (read member json)

let required read member members =
  match List.assoc_opt member members with
  | None -> fault Enums.Frame_refusal_reason.Lacks member
  | Some json -> read member json

let optional read member members =
  match List.assoc_opt member members with
  | None -> Ok None
  | Some json -> Result.map Option.some (read member json)

let json_string value = `String value
let json_bool value = `Bool value
let json_int value = `Int value
let json_float value = `Float value
let json_enum to_string value = `String (to_string value)
let json_model value = Yojson.Safe.from_string (Models.encode value)
let json_list write values = `List (List.map write values)

let json_map write members =
  `Assoc (List.map (fun (member, value) -> (member, write value)) members)

let json_nullable write = function None -> `Null | Some value -> write value

let write stated =
  `Assoc
    (List.filter_map
       (fun (name, value) -> Option.map (fun value -> (name, value)) value)
       stated)
