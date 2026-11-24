(* The service-environment group: every environment variable a Xynolog
   service reads (protocol/specs/src/service-environment/variables.json), a
   constant of its name in each SDK, with its effect, so a service or an SDK
   that reads one names it from here. Go's is go_types' (Go_types.Environment),
   and Kotlin's the Kotlin SDK's (Kotlin_sdk.Service_environment), beside the
   services' tables.
   Each SDK groups them under one name: ServiceEnvironmentVariable, as Go names its type, where its
   language groups constants in a type or an object, its module
   service_environment where a module is the group. *)

module T = Tables.Service_environment_variables

let table = "service-environment/variables.json"
let from_ = "protocol/specs/src/" ^ table
let group = "ServiceEnvironmentVariable"

let about =
  "Every environment variable a Xynolog service reads, beside its \
   configuration document, each by its name."

(* [XYNOLOG_BUS_LOG]'s words: [xynolog], [bus], [log]. *)
let words name = List.map String.lowercase_ascii (String.split_on_char '_' name)

let pascal name =
  String.concat "" (List.map String.capitalize_ascii (words name))

let camel name = String.uncapitalize_ascii (pascal name)

let typescript (t : T.t) =
  let module S = Typescript_syntax in
  {
    Output.path = "typescript/core/src/service-environment.ts";
    text =
      S.text
        {
          banner = Banner.typescript_lines ~authority:[ from_ ] __FILE__;
          body =
            [
              S.const group ~as_const:true ~about:[ Doc about ]
                (Object
                   {
                     layout = Rows;
                     entries =
                       List.map
                         (fun (v : T.variables_item) ->
                           S.entry ~about:[ Doc v.effect_ ] (Ident v.name)
                             (Str v.name))
                         t.variables;
                   });
            ];
        };
  }

let python (t : T.t) =
  let module P = Python_syntax in
  {
    Output.path = "python/sdk/src/xynolog/service_environment.py";
    text =
      P.text
        {
          header = Banner.python_lines ~from_ __FILE__;
          doc = Wrapped about;
          imports = [ [ P.From ("typing", [ "Final" ]) ] ];
          body =
            P.assign "__all__"
              ~value:
                (P.List
                   (P.items ~magic:true
                      (List.map
                         (fun (v : T.variables_item) -> P.item (P.Str v.name))
                         t.variables)))
            :: List.map
                 (fun (v : T.variables_item) ->
                   P.assign ~about:[ Prose v.effect_ ]
                     ~annotation:(P.Name "Final") ~value:(P.Str v.name) v.name)
                 t.variables;
        };
  }

let rust (t : T.t) =
  let module R = Rust_syntax in
  {
    Output.path = "rust/sdk/src/generated/service_environment.rs";
    text =
      R.text
        ~header:(Banner.lines ~from_ __FILE__)
        (List.map
           (fun (v : T.variables_item) ->
             R.Const
               {
                 doc = [ v.effect_ ];
                 attrs = [];
                 vis = Pub;
                 name = v.name;
                 ty = R.str_ty;
                 value = R.Str v.name;
               })
           t.variables);
  }

let swift (t : T.t) =
  let module S = Swift_syntax in
  let doc text = Text.wrapped ~lead:"/// " ~width:100 text in
  {
    Output.path =
      "swift/sdk/Sources/Xynolog/Generated/ServiceEnvironmentVariable.swift";
    text =
      S.print
        {
          S.banner = Banner.lines ~from_ __FILE__;
          imports = [ { S.module_ = "Foundation"; testable = false } ];
          decls =
            [
              ( S.Blank,
                {
                  S.doc = doc about;
                  modifiers = [ "public" ];
                  body =
                    S.Enum
                      {
                        name = group;
                        inherits = [];
                        layout = Lines;
                        members =
                          List.map
                            (fun (v : T.variables_item) ->
                              {
                                S.doc = doc v.effect_;
                                modifiers = [ "public"; "static" ];
                                body =
                                  S.Property
                                    {
                                      var = false;
                                      name = camel v.name;
                                      type_ = None;
                                      value = Some (S.String v.name);
                                    };
                              })
                            t.variables;
                      };
                } );
            ];
        };
  }

let csharp (t : T.t) =
  let module C = Csharp_syntax in
  {
    Output.path =
      "csharp/sdk/src/Xynolog/Generated/ServiceEnvironmentVariable.g.cs";
    text =
      C.text
        {
          header = Banner.lines ~from_ __FILE__;
          nullable = false;
          usings = [];
          namespace = "Xynolog.Services";
          decls =
            [
              C.Type
                {
                  attributes = [];
                  modifiers = [ Public; Static ];
                  kind = Class;
                  name = group;
                  params = None;
                  base = None;
                  body =
                    Some
                      ( Spaced,
                        List.map
                          (fun (v : T.variables_item) ->
                            C.Documented
                              ( v.effect_,
                                C.Field
                                  {
                                    modifiers = [ Public; Const ];
                                    type_ = C.T "string";
                                    name = pascal v.name;
                                    value = Some (C.Str v.name);
                                  } ))
                          t.variables );
                };
            ];
        };
  }

let haskell (t : T.t) =
  let module H = Haskell_syntax in
  Haskell_sdk.file ~under:"src"
    {
      H.banner = Banner.lines ~from_ __FILE__;
      extensions = [];
      name = "Xynolog.ServiceEnvironment";
      imports = [];
      body =
        List.map
          (fun (v : T.variables_item) ->
            H.value ~about:[ v.effect_ ] (camel v.name) (H.T_name "String")
              (H.Str v.name))
          t.variables;
    }

(* Each variable's name, by the Haskell constant of it, for the tests
   (test/.../ServiceEnvironmentValues.hs) to hold to the table. *)
let haskell_values (t : T.t) =
  let module H = Haskell_syntax in
  Haskell_sdk.file ~under:"test"
    {
      H.banner = Banner.lines ~from_ __FILE__;
      extensions = [];
      name = "Xynolog.Internal.Generated.ServiceEnvironmentValues";
      imports =
        [
          H.import "Data.Map.Strict" ~qualified:"Map";
          H.import "Xynolog.ServiceEnvironment";
        ];
      body =
        [
          H.value "serviceEnvironmentValues"
            (T_apply ("Map.Map", [ T_name "String"; T_name "String" ]))
            (Apply
               ( Name "Map.fromList",
                 [
                   List
                     (List.map
                        (fun (v : T.variables_item) ->
                          H.Tuple [ Str v.name; Name (camel v.name) ])
                        t.variables);
                 ] ));
        ];
    }

let ocaml (t : T.t) =
  let module O = Ocaml_syntax in
  O.implementation ~path:"ocaml/sdk/lib/service_environment.ml"
    ~banner:(Banner.ocaml ~from_ __FILE__)
    (List.map
       (fun (v : T.variables_item) ->
         O.let_ (String.concat "_" (words v.name)) (O.string v.name))
       t.variables)

let files ~root:_ (spec : Spec.t) =
  let t = spec.tables.service_environment_variables in
  match
    List.find_opt
      (fun (v : T.variables_item) ->
        not
          (List.for_all
             (fun w ->
               w <> ""
               && String.for_all
                    (function 'a' .. 'z' | '0' .. '9' -> true | _ -> false)
                    w)
             (words v.name)
          && String.equal v.name (String.uppercase_ascii v.name)))
      t.variables
  with
  | Some v ->
      Error
        [
          {
            Decode.file = table;
            pointer = "";
            message =
              v.name
              ^ " is no name of upper-case words of letters and digits joined \
                 by underscores, which each SDK's constant is named from";
          };
        ]
  | None ->
      Ok
        [
          typescript t;
          python t;
          rust t;
          swift t;
          csharp t;
          haskell t;
          haskell_values t;
          ocaml t;
        ]
