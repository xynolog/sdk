(* The swift-sdk group: the Swift SDK's models of every component schema, the
   records Protocol states in its tables ([Table_records]), the client types it
   generates and the sign-in store's entry, with the tables as typed values and
   why no launcher was found
   (swift/sdk/Sources/Xynolog/Generated/Models.swift), and its test bridge
   (swift/sdk/Tests/XynologTests/Generated/TestBridge.swift). Models declares
   the schemas, Table_decls the tables, Test_bridge the bridge. *)

module Models = Models
module Spec_values = Spec_values
module Table_decls = Table_decls
module Test_bridge = Test_bridge
module S = Swift_syntax
module D = Definitions

let models_path = "swift/sdk/Sources/Xynolog/Generated/Models.swift"
let tables_path = "swift/sdk/Sources/Xynolog/Generated/ServiceTables.swift"
let bridge_path = "swift/sdk/Tests/XynologTests/Generated/TestBridge.swift"
let banner = Banner.lines ~from_:"protocol/specs/src" __FILE__

(* Why a client that read a launcher's discovery document found no launcher
   (protocol/specs/src/client/discovery-absent.json): a case a reason, its
   raw value the reason's word. *)
let discovery_absent (spec : Spec.t) =
  {
    S.doc =
      [
        "Why a client that read a launcher's discovery document found no \
         launcher.";
      ];
    modifiers = [ "public" ];
    body =
      S.Enum
        {
          name = "DiscoveryAbsentReason";
          inherits =
            [
              S.Named "String";
              S.Named "Codable";
              S.Named "Sendable";
              S.Named "CaseIterable";
            ];
          layout = S.Lines;
          members =
            List.map
              (fun (r : Tables.Client_discovery_absent.reasons_item) ->
                {
                  S.doc = Text.wrapped ~lead:"  /// " ~width:100 r.docs;
                  modifiers = [];
                  body =
                    S.Case
                      {
                        name = Models.enum_case r.reason;
                        value = S.Raw (S.String r.reason);
                      };
                })
              spec.tables.client_discovery_absent.reasons;
        };
  }

let import module_ = { S.module_; testable = false }

(* A service table's model: its own schema's ([Places.schema_of]), named as
   that file is. *)
let table_model table = D.stem (Places.schema_of table)

(* The tables Swift reads as their schemas' models: the services'
   ([Roots.service_tables]), and the retry rules, which its transport retries
   by. *)
let read_tables (spec : Spec.t) =
  Roots.service_tables spec @ [ "retry/rules.json" ]

(* Each table [read_tables] names, a public constant of its schema's model,
   read from the table's text once; and the services' tables by their
   files. *)
let service_tables ~root (spec : Spec.t) =
  let tables = read_tables spec in
  let constant table = Models.member_name (Filename.remove_extension table) in
  let read table =
    Yojson.Safe.to_string
      (Yojson.Safe.from_file
         (Filename.concat root ("protocol/specs/src/" ^ table)))
  in
  List.map
    (fun table ->
      {
        S.doc =
          [
            Printf.sprintf "protocol/specs/src/%s, read as `%s`." table
              (table_model table);
          ];
        modifiers = [ "public" ];
        body =
          S.Property
            {
              var = false;
              name = constant table;
              type_ = Some (S.Named (table_model table));
              value =
                Some
                  (S.Call
                     ( S.Name "readTable",
                       [
                         { label = Some "file"; value = S.String table };
                         { label = None; value = S.String (read table) };
                       ] ));
            };
      })
    tables
  @ [
      {
        S.doc = [ "Every table of the services, by its file." ];
        modifiers = [ "public" ];
        body =
          S.Property
            {
              var = false;
              name = "serviceTables";
              type_ =
                Some
                  (S.Dictionary_of
                     ( S.Named "String",
                       S.Any
                         (S.Composition
                            [ S.Named "Encodable"; S.Named "Sendable" ]) ));
              value =
                Some
                  (S.Dictionary
                     ( S.Lines,
                       List.map
                         (fun table ->
                           (S.String table, S.Name (constant table)))
                         (Roots.service_tables spec) ));
            };
      };
    ]

(* The two files, as Swift. *)
let swift_files ~root (spec : Spec.t) =
  let ( let* ) = Result.bind in
  let* derivation = Required.derive spec in
  let* timing = Timing.Table.derive spec.tables.client_timing in
  let* codes = Error_codes.Table.derive spec.tables.errors_codes in
  let* user_field = User_stamp.field spec.tables.identifiers_kinds in
  match
    let bundle = D.bundle spec in
    let sign_in =
      match List.assoc_opt Roots.sign_in_entry spec.schemas with
      | Some s -> bundle.view s
      | None -> D.refuse "Protocol has no %s" Roots.sign_in_entry
    in
    let records = List.map (fun (_, name, _) -> name) (D.records spec) in
    let table_models =
      List.map
        (fun table ->
          let file = Places.schema_of table and name = table_model table in
          if List.mem name bundle.definitions.names then
            D.refuse "%s, the schema of %s, is named as a schema already is"
              file table;
          match List.assoc_opt file spec.schemas with
          | Some s -> (name, bundle.view (Normalize.shape_only s))
          | None -> D.refuse "%s has no schema %s" table file)
        (read_tables spec)
    in
    let definitions =
      {
        D.names =
          List.sort String.compare
            (("SignIn" :: records)
            @ Definitions.generated_client_types spec
            @ List.map fst table_models @ bundle.definitions.names);
        schema =
          (fun n ->
            if n = "SignIn" then sign_in
            else
              match List.assoc_opt n table_models with
              | Some s -> s
              | None -> bundle.definitions.schema n);
      }
    in
    let identifiers =
      List.sort String.compare
        (List.map
           (fun (k : Tables.Identifiers_kinds.kinds_item) -> k.schema)
           spec.tables.identifiers_kinds.kinds)
    in
    let models = Models.create definitions ~identifiers in
    let tables =
      Table_decls.declarations models ~spec ~view:bundle.view
        ~shapes:derivation.shapes ~timing ~codes ~user_field
    in
    Models.generate models;
    let models_file =
      {
        S.banner;
        imports = [ import "Foundation" ];
        decls =
          List.map
            (fun d -> (S.Blank, d))
            (Models.declarations models @ [ discovery_absent spec ])
          @ List.mapi
              (fun i d -> ((if i = 0 then S.Blank else S.Line), d))
              tables;
      }
    in
    let bridge =
      {
        S.banner;
        imports =
          [
            import "Foundation";
            import "Testing";
            { module_ = "Xynolog"; testable = true };
          ];
        decls = Test_bridge.decls ~names:definitions.names ~identifiers;
      }
    in
    let tables_file =
      {
        S.banner =
          Banner.lines ~from_:"the services' tables of protocol/specs/src"
            __FILE__;
        imports = [ import "Foundation" ];
        decls = List.map (fun d -> (S.Blank, d)) (service_tables ~root spec);
      }
    in
    [
      (models_path, models_file);
      (tables_path, tables_file);
      (bridge_path, bridge);
    ]
  with
  | files -> Ok files
  | exception D.Refused message ->
      Error [ { Decode.file = "openapi.json"; pointer = ""; message } ]

let files ~root spec =
  Result.map
    (List.map (fun (path, file) -> { Output.path; text = S.print file }))
    (swift_files ~root spec)
