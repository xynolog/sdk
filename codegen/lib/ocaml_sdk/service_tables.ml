(* The tables the services keep to ([Roots.service_tables]), which the
   applications built on the SDK read: each as a module of the OCaml SDK's
   library (ocaml/sdk/lib/<model>.ml), the types Protocol's reader derives from
   its schema ([Places.schema_of], Model) and its value as them, as the
   case-data group writes a table for the SDK's tests ([Case_data.Ocaml]). *)

module M = Xynolog_protocol_model.Model

let refusal file message = { Decode.file; pointer = ""; message }

let files ~root (spec : Spec.t) =
  let specs = Filename.concat root "protocol/specs/src" in
  match M.derive specs with
  | Error refusals ->
      Error (List.map (refusal "protocol/specs/src") refusals)
  | Ok { tables = models; harness = _ } ->
      let file path =
        match List.find_opt (fun (m : M.model) -> m.path = path) models with
        | None -> Error (refusal path "is no table Protocol's reader models")
        | Some model ->
            Result.map
              (Case_data.Ocaml.file
                 ~path:("ocaml/sdk/lib/" ^ model.model_name ^ ".ml")
                 model)
              (Result.bind
                 (Decode.parse_file ~root:specs path)
                 (Case_data.Walk.table model))
      in
      let written, refused =
        List.partition_map
          (fun path ->
            match file path with Ok f -> Left f | Error e -> Right e)
          (Roots.service_tables spec)
      in
      if refused = [] then Ok written else Error refused
