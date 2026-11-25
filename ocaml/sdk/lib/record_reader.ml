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

let map read value =
  List.map (fun (name, value) -> (name, read value)) (fields_of value)

let tabled of_json value =
  match of_json (Yojson.Safe.from_string (Yojson.Raw.to_string value)) with
  | Ok value -> value
  | Error _ -> assert false

let take reader name =
  reader.named <- name :: reader.named;
  List.assoc_opt name reader.fields

let required reader read name = read (Option.get (take reader name))

let optional reader read name =
  match take reader name with
  | None -> Types.Absent
  | Some `Null -> Types.Null
  | Some value -> Types.Present (read value)

(* A member that may be absent but not null: the decoder refuses its null. *)
let maybe reader read name = Option.map read (take reader name)

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

let json_map write members =
  `Assoc (List.map (fun (name, value) -> (name, write value)) members)

let json_tabled to_json value =
  Yojson.Raw.from_string (Yojson.Safe.to_string (to_json value))

let present write = function
  | Types.Absent -> None
  | Types.Null -> Some `Null
  | Types.Present value -> Some (write value)

type kind =
  | Text_kind
  | Integer_kind
  | Number_kind
  | Boolean_kind
  | List_kind
  | Object_kind
  | Null_kind
  | Any_kind

type literal =
  | Text_value of string
  | Integer_value of int
  | Boolean_value of bool

type signature = {
  kind : kind;
  required : string list;
  allowed : string list option;
  fixed : (string * literal list) list;
  values : literal list option;
}

let integral literal = Float.is_integer (float_of_string literal)

let of_kind kind (value : Yojson.Raw.t) =
  match (kind, value) with
  | Any_kind, _
  | Text_kind, `Stringlit _
  | (Integer_kind | Number_kind), `Intlit _
  | Number_kind, `Floatlit _
  | Boolean_kind, `Bool _
  | List_kind, `List _
  | Object_kind, `Assoc _
  | Null_kind, `Null ->
      true
  | Integer_kind, `Floatlit literal -> integral literal
  | _ -> false

let is literal (value : Yojson.Raw.t) =
  match (literal, value) with
  | Text_value text, `Stringlit _ -> string value = text
  | Integer_value n, (`Intlit _ | `Floatlit _) -> float value = Float.of_int n
  | Boolean_value b, `Bool v -> b = v
  | _ -> false

let admits (s : signature) value =
  of_kind s.kind value
  && (match s.values with
    | Some values -> List.exists (fun l -> is l value) values
    | None -> true)
  &&
  match value with
  | `Assoc members ->
      List.for_all (fun name -> List.mem_assoc name members) s.required
      && (match s.allowed with
        | Some allowed ->
            List.for_all (fun (name, _) -> List.mem name allowed) members
        | None -> true)
      && List.for_all
           (fun (name, values) ->
             match List.assoc_opt name members with
             | Some stated -> List.exists (fun l -> is l stated) values
             | None -> true)
           s.fixed
  | _ -> true

let member members value =
  let rec find i = function
    | [] -> assert false
    | signatures :: rest ->
        if List.exists (fun s -> admits s value) signatures then i
        else find (i + 1) rest
  in
  find 0 members

(* The members [stated], each but the absent, and then those of [extra] that
   no stated one names. *)
let write stated extra =
  `Assoc
    (List.filter_map
       (fun (name, value) -> Option.map (fun value -> (name, value)) value)
       stated
    @ List.filter (fun (name, _) -> not (List.mem_assoc name stated)) extra)
