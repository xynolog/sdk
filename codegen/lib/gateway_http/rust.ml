(* The gateway's HTTP surface as the Rust SDK reads it
   (rust/sdk/src/generated/gateway_http.rs, which rust/sdk/src/gateway_http.rs
   includes): the methods the operations use; each operation as a Route
   constant named for its operationId, with its method, path and media
   types; each header as a constant; an upload's members, a variant each,
   with the name each is sent under and whether every upload sends it; and
   the client secret form, its fixed members as they are and the others the
   account's, in the schema's order. Sending a form is the SDK's own. And
   the Archivist's (rust/sdk/src/generated/archivist_http.rs, which
   rust/sdk/src/archivist_http.rs includes): the methods its operations use,
   and each operation as an ArchivistRoute constant named for its
   operationId, with its method and path. *)

module R = Rust_syntax

let path = "rust/sdk/src/generated/gateway_http.rs"
let derive names = R.List ([ "derive" ], List.map (fun n -> R.Word [ n ]) names)
let route_name operation_id = Text.upper_snake operation_id
let method_variant m = String.capitalize_ascii (String.lowercase_ascii m)

let header_constant h =
  String.uppercase_ascii (String.concat "_" (Model.words h))

let some_str = function
  | None -> R.p "None"
  | Some s -> R.Call (R.p "Some", [ R.Str s ])

let methods (m : Model.t) =
  List.sort_uniq compare
    (List.map (fun (r : Model.route) -> r.method_) m.routes)

let route (r : Model.route) =
  R.Const
    {
      doc = [ "`" ^ r.operation_id ^ "`." ];
      attrs = [];
      vis = Pub;
      name = route_name r.operation_id;
      ty = R.named "Route";
      value =
        R.Struct
          ( [ "Route" ],
            [
              ("method", R.Path [ "Method"; method_variant r.method_ ]);
              ("path", R.Str r.path);
              ("sends", some_str r.sends);
              ("answers", some_str r.answers);
            ],
            None );
    }

let header h =
  R.Const
    {
      doc = [];
      attrs = [];
      vis = Pub;
      name = header_constant h;
      ty = R.str_ty;
      value = R.Str h;
    }

let field_variant (f : Model.upload_field) = Text.pascal f.field

let upload_fields (m : Model.t) =
  let arms value =
    List.map
      (fun f -> (R.Path [ "UploadField"; field_variant f ], value f))
      m.upload_fields
  in
  [
    R.Enum
      {
        doc = [ "A member of an upload (`ResourceUpload`)." ];
        attrs = [ derive [ "Clone"; "Copy"; "Debug"; "PartialEq"; "Eq" ] ];
        vis = Pub;
        name = "UploadField";
        variants =
          List.map (fun f -> R.variant (field_variant f)) m.upload_fields;
      };
    R.Blank;
    R.Impl
      {
        generics = [];
        trait_ = None;
        for_ = R.named "UploadField";
        items =
          [
            R.I_const
              {
                doc = [ "Every member, in the schema's order." ];
                vis = Pub;
                name = "ALL";
                ty =
                  R.Array_of (R.named "UploadField", List.length m.upload_fields);
                value =
                  Some
                    (R.Array
                       (List.map
                          (fun f -> R.Path [ "UploadField"; field_variant f ])
                          m.upload_fields));
              };
            R.I_blank;
            R.I_fn
              (R.fn_
                 ~doc:[ "The name the member is sent under." ]
                 ~vis:Pub ~const:true "name" ~params:[ R.Self_value ]
                 ~ret:R.static_str
                 [
                   R.Tail (R.Match (R.p "self", arms (fun f -> R.Str f.field)));
                 ]);
            R.I_blank;
            R.I_fn
              (R.fn_
                 ~doc:[ "Whether every upload sends it." ]
                 ~vis:Pub ~const:true "required" ~params:[ R.Self_value ]
                 ~ret:(R.named "bool")
                 [
                   R.Tail
                     (R.Match (R.p "self", arms (fun f -> R.Bool f.required)));
                 ]);
          ];
      };
  ]

let client_secret_form (m : Model.t) =
  let filled =
    List.filter_map
      (function Model.Filled name -> Some name | Fixed _ -> None)
      m.client_secret_form
  in
  let a = R.Ref (Some "'a", R.named "str") in
  R.Fn
    (R.fn_
       ~doc:
         [
           "The form a service account posts with a client secret, each member";
           "by its name, in the schema's order.";
         ]
       ~vis:Pub ~generics:[ R.Lifetime_param "'a" ]
       ~params:(List.map (fun name -> R.Param (name, a)) filled)
       ~ret:
         (R.Array_of
            (R.Tuple_of [ R.static_str; a ], List.length m.client_secret_form))
       "client_secret_form"
       [
         R.Tail
           (R.Array
              (List.map
                 (function
                   | Model.Fixed { name; value } ->
                       R.Tuple [ R.Str name; R.Str value ]
                   | Filled name -> R.Tuple [ R.Str name; R.p name ])
                 m.client_secret_form));
       ])

let file (m : Model.t) =
  {
    Output.path;
    text =
      R.text
        ~header:
          (Banner.lines ~from_:"protocol/specs/src/openapi.json and its paths"
             __FILE__)
        ([
           R.Enum
             {
               doc = [ "A method the gateway's operations use." ];
               attrs =
                 [ derive [ "Clone"; "Copy"; "Debug"; "PartialEq"; "Eq" ] ];
               vis = Pub;
               name = "Method";
               variants =
                 List.map (fun m -> R.variant (method_variant m)) (methods m);
             };
           R.Blank;
           R.Struct_def
             {
               doc =
                 [
                   "An operation of the gateway: its method, its path (a \
                    `{name}` for each";
                   "parameter, which the caller fills), and the media types it \
                    sends and";
                   "answers with, if it has a body.";
                 ];
               attrs = [ derive [ "Clone"; "Copy"; "Debug" ] ];
               vis = Pub;
               name = "Route";
               generics = [];
               body =
                 Fields
                   [
                     R.field "method" (R.named "Method");
                     R.field "path" R.static_str;
                     R.field "sends" (R.named ~args:[ R.static_str ] "Option");
                     R.field "answers" (R.named ~args:[ R.static_str ] "Option");
                   ];
             };
           R.Blank;
         ]
        @ List.concat_map (fun r -> [ route r; R.Blank ]) m.routes
        @ List.map header m.headers @ [ R.Blank ] @ upload_fields m
        @ [ R.Blank; client_secret_form m ]);
  }

let archivist (spec : Spec.t) =
  let operations = Archivist_routes.all spec in
  let route { Archivist_routes.method_; path; operation } =
    let operation_id = operation.operation_id in
    [
      R.Blank;
      R.Const
        {
          doc = [ "`" ^ operation_id ^ "`." ];
          attrs = [];
          vis = Pub;
          name = route_name operation_id;
          ty = R.named "ArchivistRoute";
          value =
            R.Struct
              ( [ "ArchivistRoute" ],
                [
                  ( "method",
                    R.Path [ "ArchivistMethod"; method_variant method_ ] );
                  ("path", R.Str path);
                ],
                None );
        };
    ]
  in
  {
    Output.path = "rust/sdk/src/generated/archivist_http.rs";
    text =
      R.text
        ~header:
          (Banner.lines
             ~from_:"protocol/specs/src/archivist/openapi.json and its paths"
             __FILE__)
        ([
           R.Enum
             {
               doc = [ "A method the Archivist's operations use." ];
               attrs =
                 [ derive [ "Clone"; "Copy"; "Debug"; "PartialEq"; "Eq" ] ];
               vis = Pub;
               name = "ArchivistMethod";
               variants =
                 List.map
                   (fun m -> R.variant (method_variant m))
                   (List.sort_uniq compare
                      (List.map
                         (fun (r : Archivist_routes.route) -> r.method_)
                         operations));
             };
           R.Blank;
           R.Struct_def
             {
               doc =
                 [
                   "An operation of the Archivist: its method and its path (a \
                    `{name}` for each";
                   "parameter, which the caller fills).";
                 ];
               attrs = [ derive [ "Clone"; "Copy"; "Debug" ] ];
               vis = Pub;
               name = "ArchivistRoute";
               generics = [];
               body =
                 Fields
                   [
                     R.field "method" (R.named "ArchivistMethod");
                     R.field "path" R.static_str;
                   ];
             };
         ]
        @ List.concat_map route operations);
  }
