(* A table's rows as values of its model (Protocol's [Model]): its JSON,
   which the reader has held to its schema, read again along the model's
   declarations, so each writer writes a value of the type it declares and
   reads no JSON itself. A value the model does not describe is refused, by
   its JSON Pointer. *)

module M = Xynolog_protocol_model.Model

type value =
  | String of string
  | Int of int
  | Float of float
  | Bool of bool
  | Json of Yojson.Safe.t
      (** JSON by nature, a JSON Schema, or what the model types as JSON. *)
  | List of value list
  | Map of (value * value) list
      (** Its keys (a string, or an enum's value) and values, in the file's
          order. *)
  | Null  (** A nullable value that is null. *)
  | Present of value  (** A nullable value that is not null. *)
  | Record of string * (M.field * value option) list
      (** A record by its declaration's name: each field, and its value when the
          row states it. *)
  | Enum of string * string * string
      (** An enum by its declaration's name: the constructor, and the string it
          is. *)
  | Case of string * M.case * value option
      (** A variant by its declaration's name: the case, and its payload, but a
          constant's, which the case is alone. *)

exception Refused of string * string

let refuse pointer message = raise (Refused (pointer, message))
let ( / ) pointer token = pointer ^ "/" ^ Decode.escape token

(* The declarations of [model], by name. *)
let declaration (model : M.model) name =
  match
    List.find_opt
      (function
        | M.Record (n, _) | M.Enum (n, _) | M.Variant (n, _) -> n = name)
      model.decls
  with
  | Some d -> d
  | None -> invalid_arg (model.path ^ "'s model declares no " ^ name)

(* The kind [Decode.kind] says a JSON value is, as [Model]'s [Kind] names it. *)
let kind : Yojson.Safe.t -> string = function
  | `Null -> "Null"
  | `Bool _ -> "Bool"
  | `Int _ | `Intlit _ -> "Int"
  | `Float _ -> "Number"
  | `String _ -> "String"
  | `List _ -> "Array"
  | `Assoc _ -> "Object"

let is_case json (c : M.case) =
  match (c.dispatch, json) with
  | Kind kinds, json -> List.mem (kind json) kinds
  | Object { required; stated; fixed }, `Assoc members ->
      List.for_all (fun name -> List.mem_assoc name members) required
      && List.for_all (fun (name, _) -> List.mem name stated) members
      && List.for_all
           (fun (name, v) ->
             match List.assoc_opt name members with
             | Some w -> Yojson.Safe.equal v w
             | None -> false)
           fixed
  | Object _, _ -> false

let rec walk model pointer (ty : M.ty) (json : Yojson.Safe.t) =
  match (ty, json) with
  | String, `String s | Reference, `String s -> String s
  | Int, `Int n -> Int n
  | Float, `Float f -> Float f
  | Float, `Int n -> Float (float_of_int n)
  | Bool, `Bool b -> Bool b
  | (Json | Json_schema), json -> Json json
  | Constant c, json when Yojson.Safe.equal c json -> constant pointer c
  | List t, `List items ->
      List
        (List.mapi
           (fun i item -> walk model (pointer / string_of_int i) t item)
           items)
  | Map (k, v), `Assoc members ->
      Map
        (List.map
           (fun (key, value) ->
             ( walk model (pointer / key) k (`String key),
               walk model (pointer / key) v value ))
           members)
  | Nullable _, `Null -> Null
  | Nullable t, json -> Present (walk model pointer t json)
  | Named name, json -> named model pointer name json
  | _ ->
      refuse pointer
        ("is " ^ Yojson.Safe.to_string json ^ ", which its model's type is not")

and constant pointer : Yojson.Safe.t -> value = function
  | `String s -> String s
  | `Int n -> Int n
  | `Float f -> Float f
  | `Bool b -> Bool b
  | json -> refuse pointer ("is the constant " ^ Yojson.Safe.to_string json)

and named model pointer name json =
  match (declaration model name, json) with
  | Record (_, fields), `Assoc members ->
      List.iter
        (fun (key, _) ->
          if not (List.exists (fun (f : M.field) -> f.key = key) fields) then
            refuse (pointer / key) ("is no member of " ^ name))
        members;
      Record
        ( name,
          List.map
            (fun (f : M.field) ->
              match List.assoc_opt f.key members with
              | Some v -> (f, Some (walk model (pointer / f.key) f.ty v))
              | None when f.required -> refuse pointer ("lacks " ^ f.key)
              | None -> (f, None))
            fields )
  | Enum (_, cases), `String s -> (
      match List.find_opt (fun (_, v) -> v = s) cases with
      | Some (c, v) -> Enum (name, c, v)
      | None -> refuse pointer (s ^ " is no value of " ^ name))
  | Variant (_, cases), json -> (
      match List.filter (is_case json) cases with
      | [ c ] -> (
          match c.payload with
          | Constant _ -> Case (name, c, None)
          | payload -> Case (name, c, Some (walk model pointer payload json)))
      | [] -> refuse pointer ("is no case of " ^ name)
      | _ -> refuse pointer ("is more than one case of " ^ name))
  | _ -> refuse pointer ("is no " ^ name)

(* The table's JSON [json] as a value of its model's own record, [t]; or the
   refusal, with its file and JSON Pointer. *)
let table (model : M.model) json =
  match walk model "" (Named "t") json with
  | value -> Ok value
  | exception Refused (pointer, message) ->
      Error { Decode.file = model.path; pointer; message }
