(* The URL path a browser fetches a launcher's discovery document at, which is
   its path under the state home too: client/surface.json's discovery
   constant discoveryUrlPath, as each SDK's discovery module holds it. *)

let from_ = "protocol/specs/src/client/surface.json"

let about =
  "Where a launcher's discovery document is: its path under the state home, \
   and the URL path a browser fetches it at."

(* The constant's value, as the surface states it. *)
let value (spec : Spec.t) =
  match
    List.concat_map
      (fun (m : Tables.Client_surface.modules_item) ->
        if m.module_ <> "discovery" then []
        else
          List.filter_map
            (function
              | Tables.Client_surface.Constant
                  { member = "discoveryUrlPath"; value; _ } ->
                  Some value
              | Reader _ | Function _ | Type _ | Constant _ -> None)
            m.members)
      spec.tables.client_surface.modules
  with
  | [ Some (`String path) ] -> Ok path
  | _ ->
      Error
        [
          {
            Decode.file = "client/surface.json";
            pointer = "/modules";
            message =
              "states discovery's discoveryUrlPath not once, or not as a \
               string value";
          };
        ]

let go path =
  let module G = Go_syntax in
  {
    Output.path = "go/discovery/urlpath_gen.go";
    text =
      G.text
        {
          header =
            G.verbatim
              ("Code generated from " ^ from_
             ^ " — DO NOT EDIT.\n\nRegenerate: make generate ("
             ^ Banner.writer __FILE__ ^ ")");
          package = "discovery";
          imports = [];
          decls =
            [
              G.Const
                (G.spec
                   ~doc:
                     (G.prose
                        ("DiscoveryURLPath is "
                        ^ String.uncapitalize_ascii about))
                   "DiscoveryURLPath" (G.Quoted path));
            ];
        };
  }

let python path =
  let module P = Python_syntax in
  {
    Output.path = "python/sdk/src/xynolog/_discovery_url_path.py";
    text =
      P.text
        {
          header = Banner.python_lines ~from_ __FILE__;
          doc = As_is "Where a launcher's discovery document is.";
          imports = [ [ P.From ("typing", [ "Final" ]) ] ];
          body =
            [
              P.assign "__all__"
                ~value:
                  (P.List (P.items [ P.item (P.Str "DISCOVERY_URL_PATH") ]));
              P.assign ~about:[ Prose about ] ~annotation:(P.Name "Final")
                ~value:(P.Str path) "DISCOVERY_URL_PATH";
            ];
        };
  }

let typescript path =
  let module T = Typescript_syntax in
  {
    Output.path = "typescript/core/src/discovery.ts";
    text =
      T.text
        {
          banner = Banner.typescript_lines ~authority:[ from_ ] __FILE__;
          body =
            [ T.const "DISCOVERY_URL_PATH" ~about:[ Doc about ] (T.Str path) ];
        };
  }

let rust path =
  let module R = Rust_syntax in
  {
    Output.path = "rust/sdk/src/generated/discovery_url_path.rs";
    text =
      R.text
        ~header:(Banner.lines ~from_ __FILE__)
        [
          R.Const
            {
              doc = [ about ];
              attrs = [];
              vis = Pub;
              name = "DISCOVERY_URL_PATH";
              ty = R.str_ty;
              value = R.Str path;
            };
        ];
  }

let kotlin path =
  let module K = Kotlin_syntax in
  Kotlin_sdk.table ~from_:"client/surface.json" __FILE__
    ~package:"xynolog.discovery" ~name:"DiscoveryUrlPath" ~imports:[]
    [
      K.property ~about:(K.Block about) ~visibility:K.Public ~const:true
        ~type_:(K.Type "String") ~value:(K.Same_line (K.Str path))
        "DISCOVERY_URL_PATH";
    ]

let swift path =
  let module S = Swift_syntax in
  {
    Output.path = "swift/sdk/Sources/Xynolog/Generated/DiscoveryUrlPath.swift";
    text =
      S.print
        {
          S.banner = Banner.lines ~from_ __FILE__;
          imports = [ { S.module_ = "Foundation"; testable = false } ];
          decls =
            [
              ( S.Blank,
                {
                  S.doc = Text.wrapped ~lead:"/// " ~width:100 about;
                  modifiers = [ "public" ];
                  body =
                    S.Property
                      {
                        var = false;
                        name = "discoveryUrlPath";
                        type_ = None;
                        value = Some (S.String path);
                      };
                } );
            ];
        };
  }

let csharp path =
  let module C = Csharp_syntax in
  {
    Output.path = "csharp/sdk/src/Xynolog/Generated/DiscoveryUrlPath.g.cs";
    text =
      C.text
        {
          header = Banner.lines ~from_ __FILE__;
          nullable = false;
          usings = [];
          namespace = "Xynolog.Discovery";
          decls =
            [
              C.Type
                {
                  attributes = [];
                  modifiers = [ Public; Static; Partial ];
                  kind = Class;
                  name = "LauncherDiscovery";
                  params = None;
                  base = None;
                  body =
                    Some
                      ( Spaced,
                        [
                          C.Documented
                            ( about,
                              C.Field
                                {
                                  modifiers = [ Public; Const ];
                                  type_ = T "string";
                                  name = "DiscoveryUrlPath";
                                  value = Some (Str path);
                                } );
                        ] );
                };
            ];
        };
  }

let ocaml path =
  let module O = Ocaml_syntax in
  O.implementation ~path:"ocaml/sdk/lib/discovery_url_path.ml"
    ~banner:(Banner.ocaml ~from_:"client/surface.json" __FILE__)
    [ O.let_ "discovery_url_path" (O.string path) ]

let haskell path =
  let module H = Haskell_syntax in
  H.file ~under:"generated"
    {
      H.banner = Banner.lines ~from_ __FILE__;
      extensions = [ "OverloadedStrings" ];
      name = "Xynolog.Internal.Generated.DiscoveryUrlPath";
      imports = [ H.import "Data.Text" ~items:[ Plain "Text" ] ];
      body =
        [
          H.value ~about:[ about ] "discoveryUrlPath" (H.T_name "Text")
            (H.Str path);
        ];
    }

let files ~root:_ (spec : Spec.t) =
  Result.map
    (fun path ->
      [
        go path;
        python path;
        typescript path;
        rust path;
        kotlin path;
        swift path;
        csharp path;
        ocaml path;
        haskell path;
      ])
    (value spec)
