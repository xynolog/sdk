(* The tables of Protocol @xynolog/core carries as values, each its JSON as
   it is, typed as its own schema's member of types.ts's [tables] ([Places.schema_of]):
   the tables the services keep to (Roots.service_tables), in
   typescript/core/src/service-tables.ts with SERVICE_TABLES holding each by
   its file, and the retry rules (typescript/core/src/retry-sets.ts), whose
   sets RETRY_RULES asks. With them, each schema the Librarian sends a model
   as it is (librarian/elements/, typescript/core/src/librarian-elements.ts),
   and the Archivist's routes (typescript/core/src/archivist-http.ts). *)

module T = Typescript_syntax

let service_path = "typescript/core/src/service-tables.ts"
let retry_table = "retry/rules.json"
let retry_path = "typescript/core/src/retry-sets.ts"
let elements = "librarian/elements"
let elements_path = "typescript/core/src/librarian-elements.ts"
let archivist_path = "typescript/core/src/archivist-http.ts"

(* Every table whose schema types.ts declares in [tables] for this writer. *)
let tables spec = Roots.service_tables spec @ [ retry_table ]
let refusal file message = { Decode.file; pointer = ""; message }

(* [service-environment/variables.json] is [SERVICE_ENVIRONMENT_VARIABLES]. *)
let constant table =
  String.map
    (function
      | ('a' .. 'z' | 'A' .. 'Z' | '0' .. '9') as c -> Char.uppercase_ascii c
      | _ -> '_')
    (Filename.remove_extension table)

let table_type table =
  T.T_index (T_name "tables", T_str (Definitions.stem (Places.schema_of table)))

let banner authority = Banner.typescript_lines ~authority __FILE__

let parsed specs file =
  match Decode.parse_file ~root:specs file with
  | Ok json -> Ok json
  | Error e -> Error [ e ]

let value specs table =
  Result.map
    (fun json ->
      T.const (constant table) ~annotation:(table_type table)
        ~about:
          [
            Doc
              (Printf.sprintf "protocol/specs/src/%s, as `%s` types it." table
                 (Definitions.stem (Places.schema_of table)));
          ]
        (Json_rows json))
    (parsed specs table)

let all results =
  let found, refused =
    List.partition_map (function Ok x -> Left x | Error e -> Right e) results
  in
  if refused = [] then Ok found else Error (List.concat refused)

let import_tables = T.import ~type_only:true [ "tables" ] "./types"

let service_file specs spec =
  let service = Roots.service_tables spec in
  Result.map
    (fun values ->
      {
        Output.path = service_path;
        text =
          T.text
            {
              banner = banner [ "the services' tables of protocol/specs/src" ];
              body =
                (import_tables :: values)
                @ [
                    T.const "SERVICE_TABLES" ~as_const:true
                      ~about:
                        [
                          Doc
                            "Every table, by its file under protocol/specs/src.";
                        ]
                      (T.rows
                         (List.map
                            (fun table ->
                              T.entry (Quoted table) (Name (constant table)))
                            service));
                  ];
            };
      })
    (all (List.map (value specs) service))

let retry_file specs =
  Result.map
    (fun v ->
      {
        Output.path = retry_path;
        text =
          T.text
            {
              banner = banner [ "protocol/specs/src/" ^ retry_table ];
              body = [ import_tables; v ];
            };
      })
    (value specs retry_table)

(* [LibrarianPromptScore.json] is [LIBRARIAN_PROMPT_SCORE_SCHEMA]. *)
let element_constant file =
  String.uppercase_ascii (Text.snake (Definitions.stem file)) ^ "_SCHEMA"

let elements_file specs =
  let names =
    Sys.readdir (Filename.concat specs elements)
    |> Array.to_list
    |> List.filter (fun n -> Filename.check_suffix n ".json")
    |> List.sort compare
  in
  Result.map
    (fun consts ->
      {
        Output.path = elements_path;
        text =
          T.text
            {
              banner = banner [ "protocol/specs/src/" ^ elements ];
              body = consts;
            };
      })
    (all
       (List.map
          (fun name ->
            let file = elements ^ "/" ^ name in
            Result.map
              (fun json ->
                T.const (element_constant file) ~as_const:true
                  ~about:
                    [
                      Doc
                        (Printf.sprintf
                           "protocol/specs/src/%s: the JSON Schema of an \
                            element the Librarian asks a model for, as it is \
                            sent."
                           file);
                    ]
                  (Json_rows json))
              (parsed specs file))
          names))

(* Each operation of the Archivist's document, by its operationId: its
   method and its path, a [{name}] for each parameter. *)
let archivist_file (spec : Spec.t) =
  let operations =
    match Archivist_routes.all spec with
    | found -> Ok found
    | exception Definitions.Refused message ->
        Error [ refusal "archivist/openapi.json" message ]
  in
  Result.map
    (fun found ->
      {
        Output.path = archivist_path;
        text =
          T.text
            {
              banner =
                banner
                  [ "protocol/specs/src/archivist/openapi.json and its paths" ];
              body =
                [
                  T.const
                    ~about:
                      [
                        Doc
                          "Each operation of the Archivist, by its \
                           operationId: its method, and its path (a `{name}` \
                           for each parameter, which the caller fills).";
                      ]
                    ~as_const:true "archivistRoutes"
                    (T.rows
                       (List.map
                          (fun { Archivist_routes.method_; path; operation } ->
                            T.entry (Ident operation.operation_id)
                              (Object
                                 {
                                   layout = Inline;
                                   entries =
                                     [
                                       T.entry (Ident "method") (Str method_);
                                       T.entry (Ident "path") (Str path);
                                     ];
                                 }))
                          found));
                ];
            };
      })
    operations

let files ~root (spec : Spec.t) =
  let specs = Filename.concat root "protocol/specs/src" in
  all
    [
      service_file specs spec;
      retry_file specs;
      elements_file specs;
      archivist_file spec;
    ]
