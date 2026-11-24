(* The tables the services read ([Roots.service_tables]), as the Haskell SDK
   carries them: each typed by its own schema ([Places.schema_of]) as a root
   of the models, and its rows ([rows]) a value of that type, which
   [Companions.service_tables_module] writes. A table's [$comment] is its
   prose, as is each [$comment] its schema says, which the type and the value
   leave out. *)

let ( let* ) = Result.bind
let prose = "$comment"

let name table =
  Filename.remove_extension (Filename.basename (Places.schema_of table))

(* A table's schema without its prose: its rows' [$comment] member, and each
   [$comment] it says of itself. *)
let without_prose schema =
  match
    Schema.cata
      ~boolean:(fun b -> Schema.Boolean_schema b)
      ~schema:(fun s -> Schema.Schema { s with comment = None })
      schema
  with
  | Schema.Schema s ->
      Schema.Schema
        {
          s with
          properties =
            Option.map (List.filter (fun (k, _) -> k <> prose)) s.properties;
          required = Option.map (List.filter (( <> ) prose)) s.required;
        }
  | other -> other

(* Each table's schema, by the name the models give its type. *)
let schemas (spec : Spec.t) =
  List.map
    (fun table ->
      let file = Places.schema_of table in
      match List.assoc_opt file spec.schemas with
      | Some s -> Ok (name table, without_prose s)
      | None -> Error ("no schema " ^ file ^ " for the table " ^ table))
    (Roots.service_tables spec)
  |> List.fold_left
       (fun found s ->
         let* found = found in
         let* s = s in
         Ok (s :: found))
       (Ok [])
  |> Result.map List.rev

let rows ~root table =
  match
    Yojson.Safe.from_file (Filename.concat (Documents.specs ~root) table)
  with
  | `Assoc members -> Ok (`Assoc (List.remove_assoc prose members))
  | _ -> Error (table ^ " is no object")

let value_name table = String.uncapitalize_ascii (name table)
