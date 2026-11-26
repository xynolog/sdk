(* The tables the services keep to, which the Kotlin SDK carries for them
   ([Roots.service_tables]), as xynolog.services.ServiceTables: each table
   read as its schema's type of xynolog.types, named as its schema's file
   is ([Places.schema_of]), by that type's serializer, from the table's
   JSON; and the Archivist's HTTP operations, as ArchivistRoute. *)

module K = Kotlin_syntax

let package = "xynolog.services"
let writer = __FILE__
let refuse = Names.refuse
let generated = K.annotation "Generated"

(* The type a table is read as: its schema's file's stem. *)
let type_of table =
  Filename.remove_extension (Filename.basename (Places.schema_of table))

(* [service-environment/variables.json] as [SERVICE_ENVIRONMENT_VARIABLES]. *)
let constant table = Names.constant_name (Filename.remove_extension table)

(* The file's name, the types of xynolog.types it names, and its declarations:
   each table, from [read], the JSON its file holds, and every one by its
   file. *)
let declarations ~(read : string -> Yojson.Safe.t) (spec : Spec.t) =
  let tables = Roots.service_tables spec in
  let constants = List.map constant tables in
  (match
     List.find_opt
       (fun c -> List.length (List.filter (( = ) c) constants) > 1)
       constants
   with
  | Some c -> refuse "two of the services' tables are both %s" c
  | None -> ());
  let table t =
    let type_ = type_of t in
    K.property
      ~about:
        (K.Doc (Printf.sprintf "protocol/specs/src/%s, read as `%s`." t type_))
      ~annotations:[ generated; K.annotation "JvmField" ]
      ~visibility:K.Public ~type_:(K.Type type_)
      ~value:
        (K.Below
           (K.call ~layout:K.Lines
              (K.Member (K.Name "wireJson", "decodeFromString"))
              [
                K.call (K.Name (type_ ^ ".serializer")) [];
                K.Str (Yojson.Safe.to_string (read t));
              ]))
      (constant t)
  in
  ( "ServiceTables",
    List.sort_uniq compare (List.map type_of tables),
    [
      K.class_
        ~about:
          (K.Doc
             "The tables the services keep to, each read as its schema's type: \
              the variables a service reads and why it refuses to start, what \
              it tells OpenTelemetry and logs, its messages, its jobs' \
              budgets, the bounds of the bus's replies, and the rest. \
              `SERVICE_TABLES` holds each by its file.")
        ~annotations:[ generated ] ~visibility:K.Public
        ~members:
          (List.map table tables
          @ [
              K.property
                ~about:
                  (K.Doc "Every table, by its file under protocol/specs/src.")
                ~annotations:[ generated; K.annotation "JvmField" ]
                ~visibility:K.Public
                ~type_:(K.Generic ("Map", [ K.Type "String"; K.Type "Any" ]))
                ~value:
                  (K.Below
                     (K.call ~layout:K.Lines (K.Name "mapOf")
                        (List.map
                           (fun t ->
                             K.Binary (K.Str t, K.To, K.Name (constant t)))
                           tables)))
                "SERVICE_TABLES";
            ])
        K.Object "ServiceTables";
    ] )

(* The Archivist's HTTP operations (protocol/specs/src/archivist/openapi.json),
   which the gateway, the librarian, the smelter and the weaver call: each
   one's method and path, a [{name}] for each of its parameters. *)
let archivist_routes (spec : Spec.t) =
  let name = "ArchivistRoute" in
  let operations = Archivist_routes.all spec in
  ( name,
    [
      K.class_
        ~about:
          (K.Doc
             "An operation of the Archivist's HTTP surface: its method, and \
              its path, a `{name}` for each parameter, which the caller fills.")
        ~annotations:[ generated ] ~visibility:K.Public
        ~constructor:
          (K.constructor
             [
               K.param
                 ~binding:(K.Bound { visibility = K.Public; mutable_ = false })
                 "method" (K.Type "String");
               K.param
                 ~binding:(K.Bound { visibility = K.Public; mutable_ = false })
                 "path" (K.Type "String");
             ])
        ~entries:
          (List.map
             (fun { Archivist_routes.method_; path; operation = o } ->
               K.entry ~about:(K.Doc o.summary)
                 ~args:[ K.Str method_; K.Str path ]
                 (Names.variant_of o.operation_id))
             operations)
        K.Enum_class name;
    ] )
