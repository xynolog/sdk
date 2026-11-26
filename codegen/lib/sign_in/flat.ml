(* A flat schema: an object whose every property is a string, some of them a
   date-time and some of a least length no store checks, each described. The sign-in store's entry
   (sign-in-store/SignIn.json) is one. Anything else is refused by name
   rather than rendered as a guess. *)

type field = {
  name : string;  (** camelCase, as the wire writes it. *)
  description : string;
  is_time : bool;
  required : bool;
}

type t = {
  title : string;  (** The type's name. *)
  description : string;
  fields : field list;
  required : string list;
}

let is_word ~first name =
  name <> ""
  && first name.[0]
  && String.for_all
       (function 'A' .. 'Z' | 'a' .. 'z' -> true | _ -> false)
       name

let is_type_name = is_word ~first:(function 'A' .. 'Z' -> true | _ -> false)

let is_property_name =
  is_word ~first:(function 'a' .. 'z' -> true | _ -> false)

let stated = function Some text -> text <> "" | None -> false

let read ~file (schema : Schema.t) =
  let refusals = ref [] in
  let refuse pointer message =
    refusals := { Decode.file; pointer; message } :: !refusals
  in
  let only ~at allowed (s : Schema.schema) =
    List.iter
      (fun keyword ->
        if not (List.mem keyword allowed) then
          refuse at
            (Printf.sprintf "uses %s, which a flat schema does not" keyword))
      (Schema.keywords s)
  in
  match schema with
  | Schema.Boolean_schema _ ->
      Error
        [ { Decode.file; pointer = ""; message = "is not an object schema" } ]
  | Schema.Schema s -> (
      only ~at:"" [ "title"; "type"; "description"; "properties"; "required" ] s;
      if s.type_ <> Some [ Schema.Object ] then refuse "/type" "is not object";
      let title = Option.value s.title ~default:"" in
      if not (is_type_name title) then refuse "/title" "names no type";
      if not (stated s.description) then
        refuse "/description" "is empty or absent";
      let properties = Option.value s.properties ~default:[] in
      if properties = [] then refuse "/properties" "states none";
      let required = Option.value s.required ~default:[] in
      if required = [] then refuse "/required" "requires nothing";
      List.iteri
        (fun i name ->
          if not (List.mem_assoc name properties) then
            refuse
              (Printf.sprintf "/required/%d" i)
              (Printf.sprintf "is %s, which is not a property" name))
        required;
      let fields =
        List.map
          (fun (name, property) ->
            let at = "/properties/" ^ Decode.escape name in
            if not (is_property_name name) then
              refuse at "is not a camelCase property name";
            match property with
            | Schema.Boolean_schema _ ->
                refuse at "is not a string schema";
                { name; description = ""; is_time = false; required = false }
            | Schema.Schema p ->
                only ~at
                  [ "title"; "type"; "minLength"; "format"; "description" ]
                  p;
                if p.type_ <> Some [ Schema.String ] then
                  refuse (at ^ "/type") "is not string";
                (match p.format with
                | None | Some Schema.Date_time -> ()
                | Some _ ->
                    refuse (at ^ "/format") "is a format other than date-time");
                if not (stated p.description) then
                  refuse (at ^ "/description") "is empty or absent";
                {
                  name;
                  description = Option.value p.description ~default:"";
                  is_time = p.format = Some Schema.Date_time;
                  required = List.mem name required;
                })
          properties
      in
      match List.rev !refusals with
      | [] ->
          Ok
            {
              title;
              description = Option.value s.description ~default:"";
              fields;
              required;
            }
      | errors -> Error errors)
