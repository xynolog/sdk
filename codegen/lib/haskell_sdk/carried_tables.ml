(* The tables the Haskell SDK carries, each typed by its own schema
   ([Places.schema_of]) as a root of the models, and its rows ([rows]) a value
   of that type, which [Companions.tables_module] writes: the services' tables
   ([Roots.service_tables]) in Xynolog.ServiceTables, and in Xynolog.Tables the
   clients' tables that no other module carries. *)

let ( let* ) = Result.bind

type carried = { module_name : string; listing : string; tables : string list }

let modules (spec : Spec.t) =
  [
    {
      module_name = "Xynolog.ServiceTables";
      listing = "serviceTables";
      tables = Roots.service_tables spec;
    };
    {
      module_name = "Xynolog.Tables";
      listing = "tables";
      tables =
        [ "control/methods.json"; "locales/registry.json"; "retry/rules.json" ];
    };
  ]

let name table =
  Filename.remove_extension (Filename.basename (Places.schema_of table))

(* A table's schema without the [$comment] each of its schemas says of itself:
   prose to its readers, not a constraint on its rows. *)
let without_prose =
  Schema.cata
    ~boolean:(fun b -> Schema.Boolean_schema b)
    ~schema:(fun s -> Schema.Schema { s with comment = None })

(* Each table's schema, by the name the models give its type. *)
let schemas (spec : Spec.t) =
  List.concat_map (fun carried -> carried.tables) (modules spec)
  |> List.fold_left
       (fun found table ->
         let* found = found in
         let file = Places.schema_of table in
         match List.assoc_opt file spec.schemas with
         | Some s -> Ok ((name table, without_prose s) :: found)
         | None -> Error ("no schema " ^ file ^ " for the table " ^ table))
       (Ok [])
  |> Result.map List.rev

let rows ~root table =
  Yojson.Safe.from_file (Filename.concat (Documents.specs ~root) table)

let value_name table = String.uncapitalize_ascii (name table)
