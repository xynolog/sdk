(* The Archivist's HTTP surface as the Go SDK names it
   (go/archivisthttp_gen.go, from protocol/specs/src/archivist/openapi.json and
   its paths): each operation as an ArchivistRoute named for its operationId,
   with its method and its path, a {name} for each parameter, which the caller
   fills. *)

module G = Go_syntax

let path = "go/archivisthttp_gen.go"
let route_type = "ArchivistRoute"
let route_name operation_id = route_type ^ Text.pascal operation_id

let text (spec : Spec.t) =
  let route { Archivist_routes.method_; path; operation } =
    let operation_id = operation.operation_id in
    let name = route_name operation_id in
    G.spec
      ~doc:(G.prose (Printf.sprintf "%s is %s." name operation_id))
      name
      (G.inline ~of_:(G.Named route_type)
         [ G.keyed "Method" (G.Quoted method_); G.keyed "Path" (G.Quoted path) ])
  in
  G.text
    {
      header =
        G.verbatim
          ("Code generated from protocol/specs/src/archivist/openapi.json and \
            its paths — DO NOT EDIT.\n\n\
            Regenerate: make generate (" ^ Banner.writer __FILE__ ^ ")");
      package = "xynolog";
      imports = [];
      decls =
        [
          G.Type
            {
              doc =
                G.prose
                  (route_type
                 ^ " is an operation of the Archivist: its method and its \
                    path, a {name} for each parameter, which the caller fills."
                  );
              name = route_type;
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
          G.Vars
            {
              doc = [];
              spacing = Spaced;
              specs = List.map route (Archivist_routes.all spec);
            };
        ];
    }

let file spec = { Output.path; text = text spec }
