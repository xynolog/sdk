(* The kotlin-sdk group: Kotlin's types of the component schemas, of the
   records Protocol states in its tables, of the client types and of why no
   launcher was found, a file each under xynolog/types,
   and the kinds of id in xynolog/identifiers, in
   kotlin/sdk/src/generated/kotlin. *)

module Names = Names
module Rule = Rule
module Types = Types
module Service_tables = Service_tables
module Control = Control
module Service_environment = Service_environment
module K = Kotlin_syntax

let ( let* ) = Result.bind
let directory = "kotlin/sdk/src/generated/kotlin"
let types_directory = directory ^ "/xynolog/types"

(* The schemas a generation writes: every root ([Roots]), the
   records Protocol states in its tables ([Table_records]), the client
   types it generates, the schema of each table the services keep to
   ([Service_tables]), and the sign-in store's entry, which is the store's own schema and no
   component of the API. *)
let spec_of (spec : Spec.t) : (Types.spec, string) result =
  let schema_of file = List.assoc_opt file spec.schemas in
  let whole = Definitions.typed spec in
  let components =
    List.map
      (fun (name, reference) ->
        (name, fst (Decode.resolve spec.Spec.ids reference)))
      (Roots.all spec)
    @ List.map
        (fun name -> (name, "client/types/" ^ name ^ ".json"))
        (Definitions.generated_client_types spec)
    @ List.map
        (fun table -> (Service_tables.type_of table, Places.schema_of table))
        (Roots.service_tables spec)
  in
  let* records = Table_records.all spec in
  let* definitions =
    List.fold_right
      (fun (name, file) rest ->
        let* rest = rest in
        match schema_of file with
        | Some schema ->
            let* schema = whole schema in
            Ok ((name, schema) :: rest)
        | None ->
            Error
              ("the component " ^ name ^ " names " ^ file
             ^ ", which the model has not read"))
      components (Ok [])
  in
  let* sign_in =
    match schema_of Roots.sign_in_entry with
    | Some s -> Ok s
    | None -> Error (Roots.sign_in_entry ^ " is not in the spec")
  in
  let definitions =
    definitions
    @ List.map (fun (_, name, s) -> (name, s)) records
    @ [ ("SignIn", sign_in) ]
  in
  match
    List.find_opt
      (fun (name, _) ->
        List.length (List.filter (fun (n, _) -> n = name) definitions) > 1)
      definitions
  with
  | Some (name, _) ->
      Error
        ("two schemas the types write are named " ^ name
       ^ ": a component, a table's record or the sign-in store's entry")
  | None ->
      Ok
        {
          Types.definitions;
          identifiers =
            List.map
              (fun (k : Tables.Identifiers_kinds.kinds_item) -> k.schema)
              spec.tables.identifiers_kinds.kinds;
          ids = spec.ids;
          name_of_key =
            List.map (fun (name, file) -> (file, name)) components
            @ List.map (fun (key, name, _) -> (key, name)) records;
        }

(* [spec_of], its refusal one of the gateway's document's. *)
let refused message =
  [ { Decode.file = "openapi.json"; pointer = ""; message } ]

let types_of spec = Result.map_error refused (spec_of spec)

(* The opt-ins a file needs, by what it names: each experimental API a
   generated file may use, beside the opt-in it requires. The compiler, every
   warning an error, refuses a file that uses one unnamed here. *)
let experimental =
  [
    ( "kotlinx.serialization.ExperimentalSerializationApi",
      [
        "EncodeDefault";
        "JsonIgnoreUnknownKeys";
        "KeepGeneratedSerializer";
        "SerialDescriptor";
      ] );
    ("kotlin.ExperimentalStdlibApi", [ "JvmExposeBoxed" ]);
  ]

let opt_in named =
  match
    List.filter_map
      (fun (opt_in, apis) ->
        if List.exists (fun api -> List.mem api named) apis then
          Some (K.arg (K.Class_literal opt_in))
        else None)
      experimental
  with
  | [] -> []
  | args -> [ K.annotation ~args "OptIn" ]

(* A file of [decls], importing those of [Types.imported] and [imports]
   they name. *)
let file ~package ~imports decls =
  let named = K.referenced decls in
  K.text
    {
      banner =
        Banner.lines ~from_:"the component schemas in protocol/specs/src"
          __FILE__;
      file_annotations = opt_in named;
      package;
      imports =
        List.filter
          (fun name -> List.mem (Types.after_last_dot name) named)
          (Types.imported @ imports);
      decls;
    }

let path package name =
  directory ^ "/"
  ^ String.map (function '.' -> '/' | c -> c) package
  ^ "/" ^ name ^ ".kt"

(* A file of data, opening with [banner]: no opt-in, and the imports and
   declarations it is given. *)
let data_file ~banner ~package ~name ~imports decls =
  {
    Output.path = path package name;
    text = K.text { banner; file_annotations = []; package; imports; decls };
  }

(* A table's file, which [writer] (its [__FILE__]) writes from Protocol's
   [from_]. *)
let table ~from_ writer =
  data_file ~banner:(Banner.lines ~from_:("protocol/specs/src/" ^ from_) writer)

(* What [write] writes, or the refusal it raises, made one of Protocol's
   [from_]. *)
let written ~from_ write =
  match write () with
  | written -> Ok written
  | exception Names.Refused message ->
      Error [ { Decode.file = from_; pointer = ""; message } ]

(* A file in [directory] that no run writes: refused rather than removed, so
   the run that drops a schema or a table names the file to delete with
   it. *)
let stale ~root ~directory written =
  let on_disk =
    match Sys.readdir (Filename.concat root directory) with
    | names -> List.sort String.compare (Array.to_list names)
    | exception Sys_error _ -> []
  in
  match
    List.find_opt
      (fun name -> not (List.mem (directory ^ "/" ^ name) written))
      on_disk
  with
  | Some name ->
      Error ("a generated file nothing writes: " ^ directory ^ "/" ^ name)
  | None -> Ok ()

(* Why a client that read a launcher's discovery document found no launcher
   (protocol/specs/src/client/discovery-absent.json): an entry a reason, its
   value the reason's word. *)
let discovery_absent (spec : Spec.t) =
  let name = "DiscoveryAbsentReason" in
  {
    Output.path = path Types.types_package name;
    text =
      file ~package:Types.types_package ~imports:[]
        [
          K.class_
            ~about:
              (K.Doc
                 "Why a client that read a launcher's discovery document found \
                  no launcher.")
            ~visibility:K.Public
            ~constructor:
              (K.constructor
                 [
                   K.param ~about:(K.Doc "The reason as every SDK spells it.")
                     ~binding:
                       (K.Bound { visibility = K.Public; mutable_ = false })
                     "value" (K.Type "String");
                 ])
            ~entries:
              (List.map
                 (fun (r : Tables.Client_discovery_absent.reasons_item) ->
                   K.entry ~about:(K.Doc r.docs) ~args:[ K.Str r.reason ]
                     (Names.variant_of r.reason))
                 spec.tables.client_discovery_absent.reasons)
            K.Enum_class name;
        ];
  }

let generate (spec : Spec.t) =
  let* types_spec = spec_of spec in
  match Types.generate types_spec with
  | exception Names.Refused message -> Error message
  | generated ->
      let kinds =
        List.map
          (fun kind -> Types.identifiers_package ^ "." ^ kind)
          types_spec.identifiers
      in
      Ok
        ({
           Output.path = path Types.identifiers_package "Identifiers";
           text =
             file ~package:Types.identifiers_package ~imports:[]
               generated.identifier_decls;
         }
         :: List.map
              (fun (name, decls) ->
                {
                  Output.path = path Types.types_package name;
                  text = file ~package:Types.types_package ~imports:kinds decls;
                })
              generated.types
        @ [ discovery_absent spec ])

(* The tables the services keep to ([Service_tables]), each read from its
   file under [root]'s protocol/specs/src. *)
let service_tables ~root spec =
  let from_ = "the services' tables" in
  let read table =
    Yojson.Safe.from_file (Filename.concat root ("protocol/specs/src/" ^ table))
  in
  let* name, named, decls =
    written ~from_ (fun () -> Service_tables.declarations ~read spec)
  in
  Ok
    (data_file
       ~banner:
         (Banner.lines ~from_:"the services' tables of protocol/specs/src"
            Service_tables.writer)
       ~package:Service_tables.package ~name
       ~imports:
         ("xynolog.Generated" :: "xynolog.types.wireJson"
         :: List.map (fun n -> Types.types_package ^ "." ^ n) named)
       decls)

(* The Archivist's routes ([Service_tables.archivist_routes]), a file of the
   services' package. *)
let archivist_routes spec =
  let from_ = "archivist/openapi.json" in
  let* name, decls =
    written ~from_ (fun () -> Service_tables.archivist_routes spec)
  in
  Ok
    (table ~from_ Service_tables.writer ~package:Service_tables.package ~name
       ~imports:[ "xynolog.Generated" ] decls)

(* The control API's methods and notifications ([Control]), naming the
   types [types_spec] writes. *)
let control (types_spec : Types.spec) (spec : Spec.t) =
  let from_ = "control/methods.json" in
  let* name, named, decls =
    written ~from_ (fun () ->
        Control.declarations
          ~types:(List.map fst types_spec.definitions)
          spec.tables.control_methods)
  in
  Ok
    (table ~from_ Control.writer ~package:Control.package ~name
       ~imports:
         ("xynolog.Generated"
         :: List.map (fun n -> Types.types_package ^ "." ^ n) named)
       decls)

(* The environment variables the services read ([Service_environment]), in
   the package of the services' tables. *)
let service_environment (spec : Spec.t) =
  table ~from_:Service_environment.from_ Service_environment.writer
    ~package:Service_tables.package ~name:Service_environment.name
    ~imports:[ "xynolog.Generated" ]
    (Service_environment.declarations spec.tables.service_environment_variables)

let files ~root (spec : Spec.t) =
  let* tables = service_tables ~root spec in
  let* routes = archivist_routes spec in
  let* control =
    Result.bind (types_of spec) (fun types_spec -> control types_spec spec)
  in
  let tables = [ control; routes; tables; service_environment spec ] in
  Result.map_error refused
    (let* files = generate spec in
     let files = files @ tables in
     let written = List.map (fun (f : Output.file) -> f.path) files in
     let* () = stale ~root ~directory:types_directory written in
     let* () =
       stale ~root
         ~directory:(Filename.dirname (path Service_tables.package "_"))
         written
     in
     Ok files)
