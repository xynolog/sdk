(* The tables the services keep to, as the Go SDK carries them
   (go/servicetables/tables_gen.go): each of [Roots.service_tables] a value of
   package api's type of its own schema, read from the table's JSON as
   protocol/specs/src holds it, and [tables] each by its file. *)

module G = Go_syntax

let path = "go/servicetables/tables_gen.go"

let text ~root (spec : Spec.t) ~table_model =
  let tables = Roots.service_tables spec in
  let json table =
    Yojson.Safe.to_string
      (Yojson.Safe.from_file
         (Filename.concat root ("protocol/specs/src/" ^ table)))
  in
  G.text
    {
      header =
        G.verbatim
          ("Code generated from the services' tables of protocol/specs/src — \
            DO NOT EDIT.\n\n\
            Regenerate: make generate (" ^ Banner.writer __FILE__ ^ ")");
      package = "servicetables";
      imports = [ [ "github.com/xynolog/sdk/go/api" ] ];
      decls =
        [
          G.Vars
            {
              doc = [];
              spacing = Spaced;
              specs =
                List.map
                  (fun table ->
                    let model = table_model table in
                    G.spec
                      ~doc:
                        (G.prose
                           (Printf.sprintf
                              "%s is protocol/specs/src/%s, read as api.%s."
                              model table model))
                      model
                      (G.Call
                         ( G.Instance
                             (G.Name "read", [ G.Named ("api." ^ model) ]),
                           [ G.Quoted (json table) ] )))
                  tables;
            };
          G.Var
            (G.spec
               ~doc:(G.prose "tables is every table, by its file.")
               "tables"
               (G.lines
                  ~of_:(G.Map (G.Named "string", G.Named "any"))
                  (List.map
                     (fun table ->
                       G.element ~key:(G.Quoted table)
                         (G.Name (table_model table)))
                     tables)));
        ];
    }

let file ~root spec ~table_model =
  { Output.path; text = text ~root spec ~table_model }
