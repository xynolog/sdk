(* What the gateway's HTTP surface states that an SDK's transport says:
   each operation of openapi.json's paths, by its operationId, with its
   method, its path (a parameter left as [{name}], for the SDK to fill), the
   media type it sends and the one it answers with; every header the
   gateway's operations name, asked or answered; the members of an upload
   (ResourceUpload); the form a service account posts with a client secret
   (session/ClientSecretForm.json, as the client types model reads it); the
   members of a bus frame (BusFrame); and where each credential the gateway
   takes as a key goes, and by what name. Each SDK's writer names them in
   its language; filling a path and encoding a body stay the SDK's own. *)

let ( let* ) = Result.bind

type route = {
  operation_id : string;
  method_ : string;  (** Upper case, as it goes on the wire. *)
  path : string;
  sends : string option;  (** The request body's media type, if it has one. *)
  answers : string option;  (** The success's media type, if it has a body. *)
}

(* A member of the client secret form: one the form fixes, as the grant, or
   one the account fills, as its client id and secret. *)
type form_member =
  | Fixed of { name : string; value : string }
  | Filled of string

(* A member of an upload, and whether every upload sends it. *)
and upload_field = { field : string; required : bool }

(* A credential the gateway takes as a key: where it goes, and its name
   there. *)
and api_key = { in_ : Openapi.location; name : string }

type t = {
  routes : route list;
  headers : string list;  (** Each named once, as the document spells it. *)
  upload_fields : upload_field list;  (** In the schema's order. *)
  client_secret_form : form_member list;  (** In the schema's order. *)
  bus_frame : string list;
  api_keys : (string * api_key) list;  (** By the security scheme's name. *)
}

(* A header's name as words, lower case, for a writer to case as its
   language names a constant ([WWW-Authenticate] is [www], [authenticate]). *)
let words header =
  List.map String.lowercase_ascii (String.split_on_char '-' header)

let refusal file pointer message = { Decode.file; pointer; message }

(* [f] of each of [xs], in order, or every refusal any of them gives. *)
let each f xs =
  let found, refused =
    List.fold_left
      (fun (found, refused) x ->
        match f x with
        | Ok y -> (y :: found, refused)
        | Error e -> (found, e @ refused))
      ([], []) xs
  in
  match refused with [] -> Ok (List.rev found) | e -> Error (List.rev e)

let one_media file pointer what = function
  | None | Some [] -> Ok None
  | Some [ (media, _) ] -> Ok (Some media)
  | Some _ ->
      Error [ refusal file pointer (what ^ " states more than one media type") ]

let response (spec : Spec.t) file pointer = function
  | Openapi.Inline r -> Ok r
  | Ref reference -> (
      let target, _ = Decode.resolve spec.Spec.ids reference in
      match List.assoc_opt target spec.responses with
      | Some r -> Ok r
      | None -> Error [ refusal file pointer ("names no response " ^ target) ])

(* Each SDK fills a path's [{id}] by hand, with the resource it reads: a
   path that names any other parameter is one no SDK fills. *)
let filled_by_hand file path =
  let parameters =
    List.filter_map
      (fun segment ->
        let n = String.length segment in
        if n >= 2 && segment.[0] = '{' && segment.[n - 1] = '}' then
          Some (String.sub segment 1 (n - 2))
        else None)
      (String.split_on_char '/' path)
  in
  match List.filter (fun p -> p <> "id") parameters with
  | [] -> Ok ()
  | other :: _ ->
      Error
        [
          refusal file "/"
            (Printf.sprintf "names the path parameter {%s}; the SDKs fill {id}"
               other);
        ]

let route spec file path method_ (operation : Openapi.operation) =
  let at = "/" ^ String.lowercase_ascii method_ in
  let* () = filled_by_hand file path in
  let* sends =
    match operation.request_body with
    | None -> Ok None
    | Some body ->
        one_media file (at ^ "/requestBody") "its request" (Some body.content)
  in
  let successes =
    List.filter
      (fun (status, _) -> String.starts_with ~prefix:"2" status)
      operation.responses
  in
  let* answers =
    match successes with
    | [ (status, r) ] ->
        let pointer = at ^ "/responses/" ^ status in
        let* r = response spec file pointer r in
        one_media file pointer "its success" r.content
    | _ -> Error [ refusal file at "states other than one success" ]
  in
  Ok { operation_id = operation.operation_id; method_; path; sends; answers }

let operations (spec : Spec.t) =
  each
    (fun (path, reference) ->
      let file, _ = Decode.resolve spec.Spec.ids reference in
      match List.assoc_opt file spec.path_items with
      | None ->
          Error
            [ refusal "openapi.json" "/paths" ("names no path item " ^ file) ]
      | Some (item : Openapi.path_item) ->
          Ok
            (List.filter_map
               (fun (method_, operation) ->
                 Option.map (fun o -> (file, path, method_, o)) operation)
               [ ("GET", item.get); ("PUT", item.put); ("POST", item.post) ]))
    spec.gateway.paths
  |> Result.map List.concat

let headers spec operations =
  let* answered =
    each
      (fun (file, _, method_, (o : Openapi.operation)) ->
        each
          (fun (status, r) ->
            let pointer =
              "/" ^ String.lowercase_ascii method_ ^ "/responses/" ^ status
            in
            Result.map
              (fun (r : Openapi.response) ->
                List.map fst (Option.value r.headers ~default:[]))
              (response spec file pointer r))
          o.responses)
      operations
  in
  let asked =
    List.concat_map
      (fun (_, _, _, (o : Openapi.operation)) ->
        List.filter_map
          (fun (p : Openapi.parameter) ->
            match p.in_ with Header -> Some p.name | Path | Query -> None)
          (Option.value o.parameters ~default:[]))
      operations
  in
  Ok
    (List.sort_uniq
       (fun a b ->
         compare (String.lowercase_ascii a) (String.lowercase_ascii b))
       (asked @ List.concat (List.concat answered)))

let members (spec : Spec.t) file =
  match List.assoc_opt file spec.schemas with
  | Some (Schema.Schema { properties = Some properties; _ }) ->
      Ok (List.map fst properties)
  | _ -> Error [ refusal file "/properties" "states no members" ]

let form (forms : Client_types.Model.member list) =
  each
    (fun (m : Client_types.Model.member) ->
      match m.held with
      | Word [ value ] -> Ok (Fixed { name = m.name; value })
      | Scalar String -> Ok (Filled m.name)
      | _ ->
          Error
            [
              refusal Client_types.Model.form ("/properties/" ^ m.name)
                "is neither one word nor a string";
            ])
    forms

let derive (spec : Spec.t) =
  let* operations = operations spec in
  let* routes =
    each
      (fun (file, path, method_, operation) ->
        route spec file path method_ operation)
      operations
  in
  let* headers = headers spec operations in
  let* upload_fields =
    let file = "components/schemas/ResourceUpload.json" in
    let* names = members spec file in
    let required =
      match List.assoc_opt file spec.schemas with
      | Some (Schema.Schema { required = Some r; _ }) -> r
      | _ -> []
    in
    Ok
      (List.map
         (fun field -> { field; required = List.mem field required })
         names)
  in
  let* bus_frame = members spec "components/schemas/BusFrame.json" in
  let* client_types = Client_types.Model.derive spec in
  let* client_secret_form = form client_types.form in
  let api_keys =
    List.filter_map
      (function
        | scheme, Openapi.Api_key { in_; name; _ } ->
            Some (scheme, { in_; name })
        | _, _ -> None)
      spec.gateway.components.security_schemes
  in
  Ok { routes; headers; upload_fields; client_secret_form; bus_frame; api_keys }

(* Each operation of the Archivist (archivist/openapi.json and its paths):
   its operationId, its method and its path, a [{name}] for each parameter,
   which the caller fills. *)
let archivist_operations (spec : Spec.t) =
  List.concat_map
    (fun (path, reference) ->
      let file, _ = Decode.resolve spec.ids reference in
      match List.assoc_opt file spec.path_items with
      | None ->
          Definitions.refuse "archivist/openapi.json names no path item %s" file
      | Some (item : Openapi.path_item) ->
          List.filter_map
            (fun (method_, operation) ->
              Option.map
                (fun (o : Openapi.operation) -> (o.operation_id, method_, path))
                operation)
            [ ("GET", item.get); ("PUT", item.put); ("POST", item.post) ])
    spec.archivist.paths
