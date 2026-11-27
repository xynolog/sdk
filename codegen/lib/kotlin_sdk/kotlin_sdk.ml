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

(* The schemas a generation writes, as [Typing] reads them: every root
   ([Roots]), the records Protocol states in its tables, the client types it
   generates, the schema of each table the SDK carries
   ([Service_tables]), and the sign-in store's entry, which is the store's
   own schema and no component of the API. *)
let spec_of (spec : Spec.t) : (Types.spec, string) result =
  match
    let sign_in = Definitions.sign_in spec in
    Types.spec
      [
        Typing.of_spec spec ~tables:(Service_tables.tables spec);
        Typing.make
          (Definitions.alone ~ids:spec.ids ~name:"SignIn" sign_in)
          ~roots:[ "SignIn" ] ~identifiers:[] ~value_docs:[];
      ]
  with
  | types -> Ok types
  | exception Names.Refused message -> Error message
  | exception Definitions.Refused message -> Error message

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

let generate (spec : Spec.t) =
  let* types_spec = spec_of spec in
  match Types.generate types_spec with
  | exception Names.Refused message -> Error message
  | generated ->
      let kinds =
        List.map
          (fun kind -> Types.identifiers_package ^ "." ^ kind)
          (Types.identifiers types_spec)
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
             generated.types)

(* The tables the SDK carries ([Service_tables.carried]), each object of
   them a file, each table read from its file under [root]'s
   protocol/specs/src. *)
let carried_tables ~root spec =
  let read table =
    Yojson.Safe.from_file (Filename.concat root ("protocol/specs/src/" ^ table))
  in
  List.fold_right
    (fun (c : Service_tables.carried) files ->
      let* files = files in
      let* named, decls =
        written ~from_:c.name (fun () -> Service_tables.declarations ~read c)
      in
      Ok
        (data_file
           ~banner:
             (Banner.lines ~from_:"the tables of protocol/specs/src"
                Service_tables.writer)
           ~package:c.package ~name:c.name
           ~imports:
             (List.filter
                (fun i -> Filename.remove_extension i <> c.package)
                ("xynolog.Generated" :: "xynolog.types.wireJson"
                :: List.map (fun n -> Types.types_package ^ "." ^ n) named))
           decls
        :: files))
    (Service_tables.carried spec)
    (Ok [])

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
        Control.declarations ~types:types_spec.names spec.tables.control_methods)
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
  let* carried = carried_tables ~root spec in
  let* routes = archivist_routes spec in
  let* control =
    Result.bind (types_of spec) (fun types_spec -> control types_spec spec)
  in
  let tables = [ control; routes; service_environment spec ] @ carried in
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
