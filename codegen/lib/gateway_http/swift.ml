(* The gateway's HTTP surface as the Swift SDK reads it
   (swift/sdk/Sources/Xynolog/Generated/GatewayHTTP.swift): each operation
   as a GatewayRoute named for its operationId, with its method and path;
   the media types each sends and answers with, stated only where it has a
   body; each header; an upload's members, by the name each is sent under;
   and the client secret form, its fixed members as they are and the others
   the account's. *)

module S = Swift_syntax

let path = "swift/sdk/Sources/Xynolog/Generated/GatewayHTTP.swift"
let decl ?(doc = []) modifiers body = { S.doc; modifiers; body }
let docs text = Text.wrapped ~lead:"/// " ~width:100 text
let member_docs text = Text.wrapped ~lead:"  /// " ~width:100 text
let uncapitalized = String.uncapitalize_ascii
let route_name (r : Model.route) = uncapitalized (Text.pascal r.operation_id)

let header_name h =
  uncapitalized
    (String.concat "" (List.map String.capitalize_ascii (Model.words h)))

let constant ?(doc = []) name value =
  decl ~doc [ "public"; "static" ]
    (S.Property { var = false; name; type_ = None; value = Some value })

let route ~type_ ~operation_id ~method_ ~path =
  constant
    ~doc:(member_docs ("`" ^ operation_id ^ "`."))
    (uncapitalized (Text.pascal operation_id))
    (S.Call
       ( S.Name type_,
         [
           { label = Some "method"; value = S.String method_ };
           { label = Some "path"; value = S.String path };
         ] ))

let route_table ~name ~of_ routes =
  decl
    ~doc:
      (docs
         ("An operation of " ^ of_
        ^ ": its method, and its path, a `{name}` for each parameter, which \
           the caller fills."))
    [ "public" ]
    (S.Struct
       {
         name;
         generics = [];
         inherits = [ S.Named "Sendable" ];
         layout = S.Lines;
         members =
           [
             decl [ "public" ]
               (S.Property
                  {
                    var = false;
                    name = "method";
                    type_ = Some (S.Named "String");
                    value = None;
                  });
             decl [ "public" ]
               (S.Property
                  {
                    var = false;
                    name = "path";
                    type_ = Some (S.Named "String");
                    value = None;
                  });
           ]
           @ List.map
               (fun (operation_id, method_, path) ->
                 route ~type_:name ~operation_id ~method_ ~path)
               routes;
       })

let routes (m : Model.t) =
  route_table ~name:"GatewayRoute" ~of_:"the gateway"
    (List.map
       (fun (r : Model.route) -> (r.operation_id, r.method_, r.path))
       m.routes)

(* The archivist's operations (archivist/openapi.json), by their
   operationIds, each path's parameters left for the caller to fill. *)
let archivist_routes (spec : Spec.t) =
  route_table ~name:"ArchivistRoute" ~of_:"the archivist"
    (List.concat_map
       (fun (path, reference) ->
         let file, _ = Decode.resolve spec.ids reference in
         match List.assoc_opt file spec.path_items with
         | None ->
             Definitions.refuse "archivist/openapi.json names no path item %s"
               file
         | Some (item : Openapi.path_item) ->
             List.filter_map
               (fun (method_, operation) ->
                 Option.map
                   (fun (o : Openapi.operation) ->
                     (o.operation_id, method_, path))
                   operation)
               [ ("GET", item.get); ("PUT", item.put); ("POST", item.post) ])
       spec.archivist.paths)

let namespace ~doc name members =
  decl ~doc:(docs doc) [ "public" ]
    (S.Enum { name; inherits = []; layout = S.Lines; members })

let media (m : Model.t) =
  namespace
    ~doc:
      "The media type each operation sends and answers with, where it has a \
       body."
    "GatewayMedia"
    (List.concat_map
       (fun (r : Model.route) ->
         List.filter_map Fun.id
           [
             Option.map
               (fun media -> constant (route_name r ^ "Sends") (S.String media))
               r.sends;
             Option.map
               (fun media ->
                 constant (route_name r ^ "Answers") (S.String media))
               r.answers;
           ])
       m.routes)

let headers (m : Model.t) =
  namespace ~doc:"Each header the gateway's operations name, asked or answered."
    "GatewayHeader"
    (List.map (fun h -> constant (header_name h) (S.String h)) m.headers)

let upload_fields (m : Model.t) =
  decl
    ~doc:
      (docs
         "A member of an upload (`ResourceUpload`), by the name it is sent \
          under.")
    [ "public" ]
    (S.Enum
       {
         name = "UploadField";
         inherits =
           [ S.Named "String"; S.Named "Sendable"; S.Named "CaseIterable" ];
         layout = S.Lines;
         members =
           List.map
             (fun (f : Model.upload_field) ->
               let name = Swift_sdk.Models.enum_case f.field in
               decl []
                 (S.Case
                    {
                      name;
                      value =
                        (if name = f.field then S.Bare
                         else S.Raw (S.String f.field));
                    }))
             m.upload_fields;
       })

(* A form member's name as a Swift parameter's: [client_id] is [clientId]. *)
let param name = uncapitalized (Text.pascal name)

let client_secret_form (m : Model.t) =
  let filled =
    List.filter_map
      (function Model.Filled name -> Some name | Fixed _ -> None)
      m.client_secret_form
  in
  decl
    ~doc:
      (docs
         "The form a service account posts with a client secret, each member \
          by its name, in the schema's order.")
    [ "public" ]
    (S.Func
       {
         name = "clientSecretForm";
         generics = [];
         params =
           List.map
             (fun name ->
               {
                 S.label = None;
                 name = param name;
                 type_ = S.Named "String";
                 default = None;
               })
             filled;
         throws = false;
         result =
           Some (S.Array_of (S.Tuple_of [ S.Named "String"; S.Named "String" ]));
         body =
           {
             layout = S.Lines;
             stmts =
               [
                 S.Return
                   (Some
                      (S.Array
                         ( S.Inline,
                           List.map
                             (function
                               | Model.Fixed { name; value } ->
                                   S.Tuple [ S.String name; S.String value ]
                               | Filled name ->
                                   S.Tuple
                                     [ S.String name; S.Name (param name) ])
                             m.client_secret_form )));
               ];
           };
       })

let file (spec : Spec.t) (m : Model.t) =
  {
    Output.path;
    text =
      S.print
        {
          S.banner =
            Banner.lines ~from_:"protocol/specs/src/openapi.json and its paths"
              __FILE__;
          imports = [ { S.module_ = "Foundation"; testable = false } ];
          decls =
            List.map
              (fun d -> (S.Blank, d))
              [
                routes m;
                archivist_routes spec;
                media m;
                headers m;
                upload_fields m;
                client_secret_form m;
              ];
        };
  }
