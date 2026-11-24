(* The Archivist's HTTP surface as the Go SDK names it
   (go/archivisthttp_gen.go, from protocol/specs/src/archivist/openapi.json and
   its paths): each operation as an ArchivistRoute named for its operationId,
   with its method and its path, a {name} for each parameter, which the caller
   fills. *)

module G = Go_syntax

let path = "go/archivisthttp_gen.go"
let route_type = "ArchivistRoute"

let operations (spec : Spec.t) =
  List.concat_map
    (fun (path, reference) ->
      let file, _ = Decode.resolve spec.ids reference in
      match List.assoc_opt file spec.path_items with
      | None ->
          raise
            (Definitions.Refused
               ("archivist/openapi.json names no path item " ^ file))
      | Some (item : Openapi.path_item) ->
          List.filter_map
            (fun (method_, operation) ->
              Option.map
                (fun (o : Openapi.operation) -> (o.operation_id, method_, path))
                operation)
            [ ("GET", item.get); ("PUT", item.put); ("POST", item.post) ])
    spec.archivist.paths

let text (spec : Spec.t) =
  let route (operation_id, method_, path) =
    let name = route_type ^ Text.pascal operation_id in
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
              specs = List.map route (operations spec);
            };
        ];
    }

let file spec = { Output.path; text = text spec }
