(* The Haskell SDK's HTTP routes: one constructor of HttpRoute for each of the
   gateway's operations, typed by what it is asked and answers, with its
   method, path, status, media types, whether it needs a credential and the
   headers it requires; the schemas of what an operation states in place,
   which the models name after it; and the bus's event name. The Archivist's operations are ArchivistRoute's constructors, each
   named Archivist and its operation, of the same facts, and an operation
   that answers with no content answers (). *)

module H = Haskell_syntax

let ( let* ) = Result.bind

type route = {
  name : string;
  constructor : string;
  method_ : string;
  path : string;
  input : string;
  output : string;
  input_media : string option;
  output_media : string option;  (** None when the success has no content. *)
  status : string;
  authenticated : bool;
  headers : (string * string) list;  (** Each header, and its schema's name. *)
}

type t = {
  routes : route list;
  schemas : (string * Schema.t) list;
      (** What the routes state in place, by the names the models give them. *)
}

let refused message = Error message

(* [f] of each of [xs], in order, or the first refusal. *)
let each f xs =
  Result.map List.rev
    (List.fold_left
       (fun found x ->
         let* found = found in
         let* y = f x in
         Ok (y :: found))
       (Ok []) xs)

let one what = function [ x ] -> Ok x | _ -> Error ("HTTP " ^ what)

let base_name (r : Decode.reference) =
  Filename.remove_extension (Filename.basename r.target)

(* What names an operation's route: its operationId, capitalized, after the
   document's prefix, which is none for the gateway's. *)
let route_name operation_id = String.capitalize_ascii operation_id
let constructor ~prefix operation_id = prefix ^ route_name operation_id
let gateway_prefix = ""
let archivist_prefix = "Archivist"

let routes ~prefix ~no_content (spec : Spec.t) (document : Openapi.document) =
  let* rows =
    each
      (fun (path, (reference : Decode.reference)) ->
        let file, _ = Decode.resolve spec.Spec.ids reference in
        let* item =
          match List.assoc_opt file spec.path_items with
          | Some item -> Ok item
          | None -> refused ("no path item " ^ file)
        in
        let operations =
          List.filter_map
            (fun (m, o) -> Option.map (fun o -> (m, o)) o)
            [
              ("get", item.Openapi.get); ("post", item.post); ("put", item.put);
            ]
        in
        each
          (fun (method_, (operation : Openapi.operation)) ->
            let name = route_name operation.operation_id in
            let constructor = constructor ~prefix operation.operation_id in
            let* status, response =
              one "operation needs one success status"
                (List.filter
                   (fun (status, _) -> String.starts_with ~prefix:"2" status)
                   operation.responses)
            in
            let* response =
              match response with
              | Openapi.Inline r -> Ok r
              | Ref _ -> refused "success has no content"
            in
            let* media, output, extra =
              match response.content with
              | Some content -> (
                  let* media, answer =
                    one "success needs one content type" content
                  in
                  match answer.schema with
                  | Schema { ref_ = Some r; _ } ->
                      Ok (Some media, base_name r, [])
                  | Schema { format = Some Binary; _ } ->
                      Ok (Some media, "ByteString", [])
                  | schema ->
                      Ok
                        ( Some media,
                          constructor ^ "Response",
                          [ (constructor ^ "Response", schema) ] ))
              | None when no_content -> Ok (None, "()", [])
              | None -> refused "HTTP success has no content"
            in
            let authenticated =
              operation.security <> [] && not (List.mem [] operation.security)
            in
            let* input, input_media, request_extra =
              match operation.request_body with
              | None -> Ok ("()", None, [])
              | Some body -> (
                  let* () =
                    if body.required then Ok ()
                    else
                      refused
                        "optional HTTP bodies need an explicit encoding rule"
                  in
                  let* media, described =
                    one "body needs one content type" body.content
                  in
                  match described.schema with
                  | Schema ({ ref_ = Some r; _ } as s) ->
                      if
                        List.for_all
                          (fun k ->
                            List.mem k [ "$ref"; "description"; "$comment" ])
                          (Schema.keywords s)
                      then Ok (base_name r, Some media, [])
                      else
                        refused "constrained HTTP body reference needs a model"
                  | schema ->
                      Ok
                        ( constructor ^ "Request",
                          Some media,
                          [ (constructor ^ "Request", schema) ] ))
            in
            let headers =
              List.concat
                (List.mapi
                   (fun i (p : Openapi.parameter) ->
                     if p.in_ = Header && p.required then
                       [
                         ( p.name,
                           constructor ^ "Header" ^ string_of_int i,
                           p.schema );
                       ]
                     else [])
                   (Option.value operation.parameters ~default:[]))
            in
            Ok
              ( {
                  name;
                  constructor;
                  method_ = String.uppercase_ascii method_;
                  path;
                  input;
                  output;
                  input_media;
                  output_media = media;
                  status;
                  authenticated;
                  headers = List.map (fun (h, n, _) -> (h, n)) headers;
                },
                extra @ request_extra
                @ List.map (fun (_, n, s) -> (n, s)) headers ))
          operations)
      (List.sort
         (fun (a, _) (b, _) -> String.compare a b)
         document.Openapi.paths)
  in
  let rows = List.concat rows in
  let names = List.map (fun (r, _) -> r.constructor) rows in
  if List.length (List.sort_uniq String.compare names) <> List.length names then
    refused "HTTP constructor collision"
  else Ok { routes = List.map fst rows; schemas = List.concat_map snd rows }

(* What a route table is declared as: its GADT, and the functions that give
   each route's facts, named [lower] and the fact. *)
type table = { gadt : string; lower : string }

let gateway = { gadt = "HttpRoute"; lower = "route" }
let archivist = { gadt = "ArchivistRoute"; lower = "archivistRoute" }

let dispatch table fact result routes value =
  H.Value
    {
      about = [];
      name = table.lower ^ fact;
      type_ =
        T_fun
          (H.T_apply (table.gadt, [ T_name "request"; T_name "answer" ]), result);
      clauses =
        List.map
          (fun r ->
            { H.patterns = [ Constructor (r.constructor, []) ]; body = value r })
          routes;
    }

(* A route's type: a model, ByteString, or () for a route that takes no body
   or answers no content. *)
let text = function "()" -> H.T_tuple [] | value -> H.T_name value

let maybe_bytes = function
  | None -> H.Name "Nothing"
  | Some m -> Apply (Name "Just", [ Str m ])

(* Each route's declarations but its answer's media type, which a table
   states as it holds it. *)
let declarations table routes =
  [
    H.Gadt
      {
        about = [];
        name = table.gadt;
        params = [ ("request", None); ("answer", None) ];
        constructors =
          List.map
            (fun r ->
              ( r.constructor,
                H.T_apply (table.gadt, [ text r.input; text r.output ]) ))
            routes;
      };
    dispatch table "Name" (text "Text") routes (fun r -> Str r.name);
    dispatch table "Method" (text "ByteString") routes (fun r -> Str r.method_);
    dispatch table "Path" (text "Text") routes (fun r -> Str r.path);
    dispatch table "Status" (text "Int") routes (fun r ->
        Int (int_of_string r.status));
  ]

let headed table routes =
  [
    dispatch table "RequestMediaType"
      (H.T_apply ("Maybe", [ text "ByteString" ]))
      routes
      (fun r -> maybe_bytes r.input_media);
    dispatch table "Authenticated" (text "Bool") routes (fun r ->
        Name (if r.authenticated then "True" else "False"));
    dispatch table "RequiredHeaders"
      (H.T_list (T_tuple [ text "ByteString"; text "Text" ]))
      routes
      (fun r ->
        List (List.map (fun (h, n) -> H.Tuple [ Str h; Str n ]) r.headers));
  ]

let routes_module ~banner ~name body routes =
  let used = H.uses body in
  let types =
    List.sort_uniq String.compare
      (List.concat_map (fun r -> [ r.input; r.output ]) routes)
  in
  let models =
    List.exists
      (fun t -> List.mem t used.types && t <> "ByteString" && t <> "()")
      types
  in
  {
    H.banner;
    extensions = [ "GADTs"; "OverloadedStrings" ];
    name;
    imports =
      ((if List.mem "Key" used.types then
          [ H.import "Data.Aeson.Key" ~items:[ Plain "Key" ] ]
        else [])
      @ [
          H.import "Data.ByteString" ~items:[ Plain "ByteString" ];
          H.import "Data.Text" ~items:[ Plain "Text" ];
        ]
      @ if models then [ H.import "Xynolog.Types" ] else []);
    body;
  }

(* The gateway's routes, each answering content: [routes ~no_content:false]
   refuses one that does not. *)
let file ~banner t ~bus_event =
  let routes = t.routes in
  let content r =
    match r.output_media with
    | Some media -> H.Str media
    | None -> invalid_arg (r.constructor ^ " answers no content")
  in
  routes_module ~banner ~name:"Xynolog.Http.Routes"
    (declarations gateway routes
    @ [ dispatch gateway "MediaType" (text "ByteString") routes content ]
    @ headed gateway routes
    @ [ H.value "busEventName" (text "Text") (Str bus_event) ])
    routes

let archivist_file ~banner t =
  let routes = t.routes in
  routes_module ~banner ~name:"Xynolog.Archivist.Routes"
    (declarations archivist routes
    @ [
        dispatch archivist "MediaType"
          (H.T_apply ("Maybe", [ text "ByteString" ]))
          routes
          (fun r -> maybe_bytes r.output_media);
      ]
    @ headed archivist routes)
    routes
