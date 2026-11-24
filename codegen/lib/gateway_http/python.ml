(* The gateway's HTTP surface as the Python SDK reads it
   (python/sdk/src/xynolog/http/gateway_http.py): each operation as a
   GatewayRoute named for its operationId, with its method and path, and the
   media types it sends and answers with as constants of their own, stated
   only where it has a body; each header as a constant; a bus frame's
   members, each a constant of its name; and the client secret form, its
   fixed members as they are and the others the account's. An upload's
   members are ResourceUpload's own, in xynolog.types. *)

module P = Python_syntax

let path = "python/sdk/src/xynolog/http/gateway_http.py"
let route_name (r : Model.route) = Text.upper_snake r.operation_id

let header_name h =
  String.uppercase_ascii (String.concat "_" (String.split_on_char '-' h))

let bus_frame_name member = "BUS_FRAME_" ^ Text.upper_snake member
let final = P.Name "Final"

let constant ?about name value =
  P.assign ?about ~annotation:final ~value:(P.Str value) name

let route (r : Model.route) =
  P.assign
    ~about:[ Line ("`" ^ r.operation_id ^ "`.") ]
    ~annotation:final
    ~value:
      (P.call "GatewayRoute"
         [
           P.keyword "method" (P.Str r.method_); P.keyword "path" (P.Str r.path);
         ])
    (route_name r)

let media (r : Model.route) =
  List.filter_map Fun.id
    [
      Option.map (constant (route_name r ^ "_SENDS")) r.sends;
      Option.map (constant (route_name r ^ "_ANSWERS")) r.answers;
    ]

let client_secret_form (m : Model.t) =
  let filled =
    List.filter_map
      (function Model.Filled name -> Some name | Fixed _ -> None)
      m.client_secret_form
  in
  P.Def
    {
      name = "client_secret_form";
      params = List.map (fun name -> (name, P.Name "str")) filled;
      returns =
        P.sub "list"
          [
            P.item
              (P.sub "tuple" [ P.item (P.Name "str"); P.item (P.Name "str") ]);
          ];
      doc =
        Some
          (As_is
             "The form a service account posts with a client secret, each \
              member by its name, in the schema's order.");
      body =
        [
          P.Return
            (P.List
               (P.items ~magic:true
                  (List.map
                     (function
                       | Model.Fixed { name; value } ->
                           P.item
                             (P.tuple
                                [ P.item (P.Str name); P.item (P.Str value) ])
                       | Filled name ->
                           P.item
                             (P.tuple
                                [ P.item (P.Str name); P.item (P.Name name) ]))
                     m.client_secret_form)));
        ];
    }

let file (m : Model.t) =
  let routes = List.map route_name m.routes in
  let media_names =
    List.concat_map
      (fun (r : Model.route) ->
        List.map
          (fun suffix -> route_name r ^ suffix)
          ((if Option.is_some r.sends then [ "_SENDS" ] else [])
          @ if Option.is_some r.answers then [ "_ANSWERS" ] else []))
      m.routes
  in
  let exported =
    List.sort compare
      (("GatewayRoute" :: "client_secret_form" :: routes)
      @ media_names
      @ List.map header_name m.headers
      @ List.map bus_frame_name m.bus_frame)
  in
  {
    Output.path;
    text =
      P.text
        {
          header =
            Banner.python_lines
              ~from_:"protocol/specs/src/openapi.json and its paths" __FILE__;
          doc =
            As_is
              "The gateway's HTTP surface: its operations, the media types \
               each sends and\n\
               answers with, the headers they name, a bus frame's members, and \
               the client\n\
               secret form.\n";
          imports =
            [
              [
                P.From ("dataclasses", [ "dataclass" ]);
                P.From ("typing", [ "Final"; "final" ]);
              ];
            ];
          body =
            [
              P.assign "__all__"
                ~value:
                  (P.List
                     (P.items ~magic:true
                        (List.map (fun n -> P.item (P.Str n)) exported)));
              P.frozen_dataclass "GatewayRoute"
                "An operation of the gateway: its method, and its path, a \
                 `{name}` for each\n\
                 parameter, which the caller fills."
                [
                  P.field "method" (P.Name "str"); P.field "path" (P.Name "str");
                ];
            ]
            @ List.map route m.routes
            @ [ P.Adjacent (List.concat_map media m.routes) ]
            @ [
                P.Adjacent
                  (List.map (fun h -> constant (header_name h) h) m.headers);
                P.Adjacent
                  (List.map
                     (fun member -> constant (bus_frame_name member) member)
                     m.bus_frame);
                client_secret_form m;
              ];
        };
  }
