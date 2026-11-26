(* The gateway's HTTP surface as the OCaml SDK reads it
   (ocaml/sdk/lib/gateway_http.ml): each operation as its method and path,
   named for its operationId in snake case; the media types each sends and
   answers with, in [Media], stated only where it has a body; each header,
   in [Header]; an upload's members, in [Upload_field], each by the name it
   is sent under and [all] in the schema's order; a bus frame's members, in
   [Bus_frame]; and the client secret form, its fixed members as they are
   and the others the account's. *)

module O = Ocaml_syntax

let path = "ocaml/sdk/lib/gateway_http.ml"
let operation_name = Text.snake
let route_name (r : Model.route) = operation_name r.operation_id
let header_name h = String.concat "_" (Model.words h)

let route (r : Model.route) =
  O.let_ (route_name r) (O.tuple [ O.string r.method_; O.string r.path ])

let media (m : Model.t) =
  O.module_ "Media"
    (List.concat_map
       (fun (r : Model.route) ->
         List.filter_map Fun.id
           [
             Option.map
               (fun media -> O.let_ (route_name r ^ "_sends") (O.string media))
               r.sends;
             Option.map
               (fun media ->
                 O.let_ (route_name r ^ "_answers") (O.string media))
               r.answers;
           ])
       m.routes)

let upload_fields (m : Model.t) =
  let name (f : Model.upload_field) = Text.snake f.field in
  O.module_ "Upload_field"
    (List.map
       (fun (f : Model.upload_field) -> O.let_ (name f) (O.string f.field))
       m.upload_fields
    @ [
        O.let_ "all"
          (O.list (List.map (fun f -> O.ident (name f)) m.upload_fields));
      ])

let client_secret_form (m : Model.t) =
  let filled =
    List.filter_map
      (function Model.Filled name -> Some name | Fixed _ -> None)
      m.client_secret_form
  in
  O.let_ "client_secret_form"
    (O.fun_labeled
       (List.map
          (fun name -> (Asttypes.Labelled name, O.Pattern.var name))
          filled)
       (O.list
          (List.map
             (function
               | Model.Fixed { name; value } ->
                   O.tuple [ O.string name; O.string value ]
               | Filled name -> O.tuple [ O.string name; O.ident name ])
             m.client_secret_form)))

let file (m : Model.t) =
  O.implementation ~path
    ~banner:
      (Banner.ocaml ~from_:"protocol/specs/src/openapi.json and its paths"
         __FILE__)
    (List.map route m.routes
    @ [
        media m;
        O.module_ "Header"
          (List.map (fun h -> O.let_ (header_name h) (O.string h)) m.headers);
        upload_fields m;
        O.module_ "Bus_frame"
          (List.map
             (fun member -> O.let_ (Text.snake member) (O.string member))
             m.bus_frame);
        client_secret_form m;
      ])

(* The Archivist's HTTP operations as the OCaml SDK states them
   (ocaml/sdk/lib/archivist_http.ml): each as its method and its path, whose
   [{name}]s the caller fills, named for its operationId in snake case. *)
let archivist (spec : Spec.t) =
  O.implementation ~path:"ocaml/sdk/lib/archivist_http.ml"
    ~banner:
      (Banner.ocaml
         ~from_:"protocol/specs/src/archivist/openapi.json and its paths"
         __FILE__)
    (List.map
       (fun { Archivist_routes.method_; path; operation } ->
         O.let_
           (operation_name operation.operation_id)
           (O.tuple [ O.string method_; O.string path ]))
       (Archivist_routes.all spec))
