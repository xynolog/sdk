(* Each operation of the Archivist (archivist/openapi.json and its paths), in
   the document's order: its method, its path, a [{name}] for each parameter,
   which the caller fills, and the operation itself. Every writer of the
   archivist's routes reads them here. *)

type route = { method_ : string; path : string; operation : Openapi.operation }

let all (spec : Spec.t) =
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
                (fun operation -> { method_; path; operation })
                operation)
            [ ("GET", item.get); ("PUT", item.put); ("POST", item.post) ])
    spec.archivist.paths
