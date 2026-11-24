type t = { fields : (string * Yojson.Raw.t) list; mutable named : string list }

let start fields = { fields; named = [] }
let fields_of = function `Assoc fields -> fields | _ -> assert false

let string = function
  | `Stringlit literal -> (
      match Yojson.Safe.from_string literal with
      | `String text -> text
      | _ -> assert false)
  | _ -> assert false

let bool = function `Bool value -> value | _ -> assert false

(* An integer as the schema reads one: 1.0 is an integer. *)
let int = function
  | `Intlit literal -> int_of_string literal
  | `Floatlit literal -> Float.to_int (float_of_string literal)
  | _ -> assert false

let float = function
  | `Intlit literal | `Floatlit literal -> float_of_string literal
  | _ -> assert false

let enum of_string value = Option.get (of_string (string value))

let list read = function
  | `List values -> List.map read values
  | _ -> assert false

let nullable read = function `Null -> None | value -> Some (read value)
let record project value = project (fields_of value)
let raw value = value

let take reader name =
  reader.named <- name :: reader.named;
  List.assoc_opt name reader.fields

let required reader read name = read (Option.get (take reader name))

let optional reader read name =
  match take reader name with
  | None -> Types.Absent
  | Some `Null -> Types.Null
  | Some value -> Types.Present (read value)

(* A member that may be absent but not null: the decoder, as it reads one,
   lets a null through as absent. *)
let maybe reader read name =
  match take reader name with
  | None | Some `Null -> None
  | Some value -> Some (read value)

let rest reader =
  List.filter (fun (name, _) -> not (List.mem name reader.named)) reader.fields

let json_string text = `Stringlit (Yojson.Safe.to_string (`String text))
let json_bool value = `Bool value
let json_int value = `Intlit (string_of_int value)
let json_float value = `Floatlit (Yojson.Safe.to_string (`Float value))
let json_enum to_string value = json_string (to_string value)
let json_list write values = `List (List.map write values)
let json_nullable write = function None -> `Null | Some value -> write value
let json_raw value = value

let present write = function
  | Types.Absent -> None
  | Types.Null -> Some `Null
  | Types.Present value -> Some (write value)

(* The members [stated], each but the absent, and then those of [extra] that
   no stated one names. *)
let write stated extra =
  `Assoc
    (List.filter_map
       (fun (name, value) -> Option.map (fun value -> (name, value)) value)
       stated
    @ List.filter (fun (name, _) -> not (List.mem_assoc name stated)) extra)
