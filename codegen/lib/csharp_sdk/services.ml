(* The tables Protocol states for its services ([Roots.service_tables]), as
   the C# SDK carries them (Generated/ServiceTables.g.cs): each table read
   once as the type its own schema is, and each route of the archivist's HTTP
   surface. The images
   restate them by hand; a service written in C# reads them here. *)

module C = Csharp_syntax

let path = "csharp/sdk/src/Xynolog/Generated/ServiceTables.g.cs"
let specs = "protocol/specs/src/"
let ( let* ) = Result.bind

(* The type a table is read as: its schema's, named for the schema's file. *)
let type_of table =
  Filename.remove_extension (Filename.basename (Places.schema_of table))

(* Each service table's schema ([Roots.service_tables]), with the name its
   type takes, for the models. *)
let schemas spec =
  List.map
    (fun table -> (type_of table, Places.schema_of table))
    (Roots.service_tables spec)

let refusal file message = [ { Decode.file; pointer = ""; message } ]

let table ~root file =
  let source = Filename.concat root (specs ^ file) in
  let name = type_of file in
  let type_ = C.T ("global::Xynolog.Types." ^ name) in
  C.Documented
    ( "protocol/specs/src/" ^ file ^ ", as its schema " ^ name ^ " reads it.",
      C.Property
        {
          attributes = [];
          modifiers = [ Public; Static ];
          type_;
          name;
          accessors = [ Get ];
          value =
            Some
              (C.Call
                 ( Name "global::Xynolog.Services.ServiceTable.Read",
                   [ type_ ],
                   [
                     Arg
                       (Str
                          (In_channel.with_open_bin source In_channel.input_all));
                   ] ));
        } )

(* An archivist operation's property on ArchivistRoutes. *)
let route_name operation_id = Text.pascal operation_id

let route (spec : Spec.t) (path, reference) =
  let file, _ = Decode.resolve spec.ids reference in
  match List.assoc_opt file spec.path_items with
  | None ->
      Error (refusal "archivist/openapi.json" ("names no path item " ^ file))
  | Some (item : Openapi.path_item) ->
      Ok
        (List.filter_map
           (fun (method_, operation) ->
             Option.map
               (fun (o : Openapi.operation) ->
                 C.Documented
                   ( method_ ^ " " ^ path ^ ", the archivist's "
                     ^ o.operation_id ^ ".",
                     C.Property
                       {
                         attributes = [];
                         modifiers = [ Public; Static ];
                         type_ = C.T "global::Xynolog.Services.ServiceRoute";
                         name = route_name o.operation_id;
                         accessors = [ Get ];
                         value =
                           Some
                             (C.New
                                {
                                  type_ = None;
                                  args =
                                    Some
                                      [
                                        Arg
                                          (Name
                                             ("global::System.Net.Http.HttpMethod."
                                             ^ String.capitalize_ascii
                                                 (String.lowercase_ascii method_)
                                             ));
                                        Arg (Str path);
                                      ];
                                  init = None;
                                });
                       } ))
               operation)
           [ ("GET", item.get); ("PUT", item.put); ("POST", item.post) ])

let static_class name members =
  C.Type
    {
      attributes = [];
      modifiers = [ Public; Static ];
      kind = Class;
      name;
      params = None;
      base = None;
      body = Some (Packed, members);
    }

let file ~root (spec : Spec.t) =
  let tables = Roots.service_tables spec in
  let* routes = Spec.all (List.map (route spec) spec.archivist.paths) in
  Ok
    {
      Output.path;
      text =
        C.text
          {
            header =
              Banner.lines
                ~from_:
                  ("protocol/specs/src: " ^ String.concat ", " tables
                 ^ " and archivist/openapi.json")
                __FILE__;
            nullable = false;
            usings = [];
            namespace = "Xynolog.Services";
            decls =
              [
                static_class "ServiceTables" (List.map (table ~root) tables);
                static_class "ArchivistRoutes" (List.concat routes);
              ];
          };
    }
