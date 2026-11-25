type fault = Schema_codec.fault
type t = (string * Yojson.Safe.t) list

let start fields = fields
let ( let* ) = Result.bind
let malformed = Schema_codec.malformed
let string member = function `String value -> Ok value | _ -> malformed member

let integer member = function
  | `Int value -> Ok (Z.of_int value)
  | `Intlit value -> (
      try
        let number = Z.of_string value in
        if Z.to_string number = value || value = "-0" then Ok number
        else malformed member
      with Invalid_argument _ -> malformed member)
  | _ -> malformed member

let integer_at_least minimum member json =
  let* value = integer member json in
  if Z.geq value (Z.of_int minimum) then Ok value else malformed member

let required reader read member =
  match List.assoc_opt member reader with
  | None -> Schema_codec.lacks member
  | Some value -> read member value

let optional reader read member =
  match List.assoc_opt member reader with
  | None -> Ok None
  | Some value -> Result.map Option.some (read member value)

let json_string value = `String value

let json_integer value =
  if Z.fits_int value then `Int (Z.to_int value)
  else `Intlit (Z.to_string value)

let write stated =
  `Assoc
    (List.filter_map
       (fun (name, value) -> Option.map (fun value -> (name, value)) value)
       stated)
