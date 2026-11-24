(* Which schemas a generation names, and by what: a root ([Roots]) by the
   name it is given, a table's record by its title, and a whole file of a
   directory of schemas or of client types by its own. A member of a file is
   named by none, and neither is any other file: that one is written in the
   place of each [$ref] to it, before any writer reads the schema that
   refers to it. *)

let stem file = Filename.remove_extension (Filename.basename file)

(* What a schema that states a [$ref] says of the schema it names: a
   description, or nothing. A constraint on a reference is an [allOf], so
   any other keyword beside one is refused. *)
let said_of_reference (s : _ Schema.layer) (r : Decode.reference) =
  match
    List.filter (fun k -> k <> "$ref" && k <> "description") (Schema.keywords s)
  with
  | [] -> Ok s.description
  | k :: _ ->
      Error
        (Printf.sprintf
           "$ref %s has %s beside it: only a description is said of a \
            reference, and a constraint on one is an allOf"
           r.target k)

(* The name of the schema at [key], a file or a table's record by its key
   ([Table_records.key]), when a generation names it. *)
let named (spec : Spec.t) =
  let declared =
    List.map
      (fun (name, r) -> (fst (Decode.resolve spec.Spec.ids r), name))
      (Roots.all spec)
  in
  Result.map
    (fun records ->
      let titled = List.map (fun (key, name, _) -> (key, name)) records in
      fun key ->
        match List.assoc_opt key (declared @ titled) with
        | Some name -> Some name
        | None ->
            if
              (not (String.contains key '#'))
              && (Filename.basename (Filename.dirname key) = "schemas"
                 || String.starts_with ~prefix:Roots.client_types key)
            then Some (stem key)
            else None)
    (Table_records.all spec)

exception Refused of string

let refuse fmt = Printf.ksprintf (fun message -> raise (Refused message)) fmt

(* [s] with each [$ref] to a file, or to a place within one, that [named]
   names none of written in its place, from [schemas]. What is said beside such a [$ref] is said of what
   is written there, in place of what that says of itself. A file written in
   place that reaches itself would be written in place without end. *)
let files_in_place ~ids ~schemas ~named s =
  let rec files trail = function
    | Schema.Boolean_schema _ as b -> b
    | Schema.Schema l -> (
        match l.ref_ with
        | None -> Schema.Schema (Schema.map (files trail) l)
        | Some r -> (
            let key = function
              | file, "" -> file
              | file, pointer -> file ^ "#" ^ pointer
            in
            match Decode.resolve ids r with
            | (file, pointer) as place
              when Option.is_none (named (key place))
                   && not (String.starts_with ~prefix:"/$defs/" pointer) -> (
                let at = key place in
                if List.mem at trail then
                  refuse
                    "%s reaches itself through the files written in its place"
                    at;
                let description =
                  match said_of_reference l r with
                  | Ok d -> d
                  | Error message -> refuse "%s" message
                in
                (* A place within a file is the schema there; one of its own
                   [$defs] is the writers' to name. *)
                let target =
                  Option.bind (Hashtbl.find_opt schemas file) (fun whole ->
                      if pointer = "" then Some whole
                      else Pointer.schema whole pointer)
                in
                match
                  (Option.map (files (at :: trail)) target, description)
                with
                | None, _ -> refuse "$ref %s names no schema" r.target
                | Some written, None -> written
                | Some (Schema.Schema t), Some _ ->
                    Schema.Schema { t with description }
                | Some (Schema.Boolean_schema _), Some _ ->
                    refuse
                      "$ref %s is written in its place as a schema that \
                       describes nothing, so nothing can be said of it beside \
                       it"
                      r.target)
            | _ -> Schema.Schema l))
  in
  match files [] s with s -> Ok s | exception Refused message -> Error message

(* A schema of [spec] with each [$ref] to a file no generation names
   ([named]) written in its place ([files_in_place]). *)
let in_place (spec : Spec.t) =
  let schemas = Hashtbl.of_seq (List.to_seq spec.schemas) in
  match named spec with
  | Error message -> fun _ -> Error message
  | Ok named -> files_in_place ~ids:spec.ids ~schemas ~named
