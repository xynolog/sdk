(* The gateway's HTTP surface as the Go SDK reads it
   (go/gatewayhttp_gen.go): each operation as a GatewayRoute named for its
   operationId, with its method and path, and the media types it sends and
   answers with as constants of their own, stated only where it has a body;
   each header as a constant; where each credential the gateway takes as a
   key goes, and by what name; an upload's members, each a constant of its
   name, with whether every upload sends it, in the schema's order; a bus
   frame's members, each a constant of its name; and the client secret form,
   its fixed members as they are and the others the account's. A caller of
   the SDK, or a server of the gateway's surface, reads the routes, the
   headers and the keys; the rest is the SDK's own. *)

module G = Go_syntax

let path = "go/gatewayhttp_gen.go"
let route_name (r : Model.route) = "Route" ^ Text.pascal r.operation_id
let media_name (r : Model.route) = "route" ^ Text.pascal r.operation_id

(* A header's name as its constant's, each word as the header writes it:
   [WWW-Authenticate] is [HeaderWWWAuthenticate]. *)
let header_name h =
  "Header"
  ^ String.concat ""
      (List.map String.capitalize_ascii (String.split_on_char '-' h))

(* A form member's name as a Go parameter's: [client_id] is [clientID]. *)
let param name =
  match String.split_on_char '_' name with
  | first :: rest ->
      String.concat ""
        (first
        :: List.map
             (function "id" -> "ID" | w -> String.capitalize_ascii w)
             rest)
  | [] -> name

let upload_constant (f : Model.upload_field) =
  "uploadField" ^ Text.pascal f.field

let route (r : Model.route) =
  G.Var
    (G.spec
       ~doc:(G.prose (Printf.sprintf "%s is %s." (route_name r) r.operation_id))
       (route_name r)
       (G.inline ~of_:(G.Named "GatewayRoute")
          [
            G.keyed "Method" (G.Quoted r.method_);
            G.keyed "Path" (G.Quoted r.path);
          ]))

let media (m : Model.t) =
  List.concat_map
    (fun (r : Model.route) ->
      List.filter_map Fun.id
        [
          Option.map
            (fun media -> G.spec (media_name r ^ "Sends") (G.Quoted media))
            r.sends;
          Option.map
            (fun media -> G.spec (media_name r ^ "Answers") (G.Quoted media))
            r.answers;
        ])
    m.routes

(* A credential's key as its constant: the scheme, then where it goes, as
   [MediaTokenQuery]. *)
let api_key (scheme, (k : Model.api_key)) =
  let where, place =
    match k.in_ with
    | Path -> ("Path", "path parameter")
    | Query -> ("Query", "query parameter")
    | Header -> ("Header", "header")
  in
  let name = Text.pascal scheme ^ where in
  G.spec
    ~doc:
      (G.prose
         (Printf.sprintf "%s is the %s a %s credential is sent in." name place
            scheme))
    name (G.Quoted k.name)

let client_secret_form (m : Model.t) =
  let filled =
    List.filter_map
      (function Model.Filled name -> Some name | Fixed _ -> None)
      m.client_secret_form
  in
  let value = function
    | Model.Fixed { name; value } ->
        G.element ~key:(G.Quoted name) (G.inline [ G.item (G.Quoted value) ])
    | Filled name ->
        G.element ~key:(G.Quoted name)
          (G.inline [ G.item (G.Name (param name)) ])
  in
  G.func
    ~doc:
      (G.prose
         "clientSecretForm is the form a service account posts with a client \
          secret.")
    ~params:(List.map (fun name -> (param name, G.Named "string")) filled)
    ~results:(G.Unnamed [ G.Named "url.Values" ]) "clientSecretForm"
    (G.One_line
       (G.Return
          [
            G.inline ~of_:(G.Named "url.Values")
              (List.map value m.client_secret_form);
          ]))

let file (m : Model.t) =
  {
    Output.path;
    text =
      G.text
        {
          header =
            G.verbatim
              "Code generated from protocol/specs/src/openapi.json and its \
               paths; DO NOT EDIT.\n\n\
               Regenerate: make generate (codegen/lib/gateway_http/go.ml)";
          package = "xynolog";
          imports = [ [ "net/url" ] ];
          decls =
            [
              G.Type
                {
                  doc =
                    G.prose
                      "GatewayRoute is an operation of the gateway: its method \
                       and its path, a {name} for each parameter, which the \
                       caller fills.";
                  name = "GatewayRoute";
                  def =
                    G.Struct
                      {
                        fields =
                          [
                            {
                              doc = [];
                              names = [ "Method"; "Path" ];
                              type_ = G.Named "string";
                              tag = None;
                            };
                          ];
                        spacing = Packed;
                      };
                };
            ]
            @ List.map route m.routes
            @ [
                G.Consts
                  {
                    doc =
                      G.prose
                        "The media type each operation sends and answers with, \
                         where it has a body.";
                    specs = media m;
                    spacing = Packed;
                  };
                G.Consts
                  {
                    doc =
                      G.prose
                        "Each header the gateway's operations name, asked or \
                         answered.";
                    specs =
                      List.map
                        (fun h -> G.spec (header_name h) (G.Quoted h))
                        m.headers;
                    spacing = Packed;
                  };
                G.Consts
                  {
                    doc = [];
                    specs = List.map api_key m.api_keys;
                    spacing = Packed;
                  };
                G.Type
                  {
                    doc =
                      G.prose
                        "uploadField is a member of an upload \
                         (ResourceUpload), and whether every upload sends it.";
                    name = "uploadField";
                    def =
                      G.Struct
                        {
                          fields =
                            [
                              {
                                doc = [];
                                names = [ "name" ];
                                type_ = G.Named "string";
                                tag = None;
                              };
                              {
                                doc = [];
                                names = [ "required" ];
                                type_ = G.Named "bool";
                                tag = None;
                              };
                            ];
                          spacing = Packed;
                        };
                  };
                G.Consts
                  {
                    doc =
                      G.prose "The name each member of an upload is sent under.";
                    specs =
                      List.map
                        (fun (f : Model.upload_field) ->
                          G.spec (upload_constant f) (G.Quoted f.field))
                        m.upload_fields;
                    spacing = Packed;
                  };
                G.Var
                  (G.spec
                     ~doc:
                       (G.prose
                          "uploadFields is every member of an upload, in the \
                           schema's order.")
                     "uploadFields"
                     (G.lines ~of_:(G.Slice (G.Named "uploadField"))
                        (List.map
                           (fun (f : Model.upload_field) ->
                             G.item
                               (G.inline
                                  [
                                    G.keyed "name" (G.Name (upload_constant f));
                                    G.keyed "required"
                                      (G.Name (string_of_bool f.required));
                                  ]))
                           m.upload_fields)));
                G.Consts
                  {
                    doc =
                      G.prose
                        "The name each member of a bus frame (BusFrame) is \
                         written under.";
                    specs =
                      List.map
                        (fun name ->
                          G.spec ("busFrame" ^ Text.pascal name) (G.Quoted name))
                        m.bus_frame;
                    spacing = Packed;
                  };
                client_secret_form m;
              ];
        };
  }
