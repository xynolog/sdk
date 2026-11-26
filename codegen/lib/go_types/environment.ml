(* Every environment variable a Xynolog service reads, as the Go SDK names
   them (go/serviceenvironment_gen.go): each row of
   protocol/specs/src/service-environment/variables.json a constant of its
   name, with its effect. *)

module G = Go_syntax
module T = Tables.Service_environment_variables

let path = "go/serviceenvironment_gen.go"

(* A variable's name as its constant's: [XYNOLOG_OIDC_CLIENT_ID] is
   [ServiceEnvironmentVariableXynologOidcClientId]. *)
let constant name =
  Service_environment.group
  ^ String.concat ""
      (List.map
         (fun word -> String.capitalize_ascii (String.lowercase_ascii word))
         (String.split_on_char '_' name))

let text (t : T.t) =
  G.text
    {
      header =
        G.verbatim
          ("Code generated from \
            protocol/specs/src/service-environment/variables.json — DO NOT \
            EDIT.\n\n\
            Regenerate: make generate (" ^ Banner.writer __FILE__ ^ ")");
      package = "xynolog";
      imports = [];
      decls =
        [
          G.Type
            {
              doc =
                G.prose
                  (Service_environment.group
                 ^ " is an environment variable a Xynolog service reads, \
                    beside its configuration document.");
              name = Service_environment.group;
              def = G.Is (G.Named "string");
            };
          G.Consts
            {
              doc = [];
              spacing = Spaced;
              specs =
                List.map
                  (fun (v : T.variables_item) ->
                    G.spec
                      ~doc:(G.prose (constant v.name ^ ": " ^ v.effect_))
                      ~type_:(G.Named Service_environment.group)
                      (constant v.name) (G.Quoted v.name))
                  t.variables;
            };
        ];
    }

let file (spec : Spec.t) =
  { Output.path; text = text spec.tables.service_environment_variables }
