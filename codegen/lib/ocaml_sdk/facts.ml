(* The OCaml SDK's facts of tables no group of its own writes for it: a
   client assertion's lifetime and types (ocaml/sdk/lib/assertion_facts.ml);
   the registry's fixed keys, its session keys' prefix and the discovery
   document's versions (registry_facts.ml); the names a log never prints the
   value of (log_facts.ml). *)

module O = Ocaml_syntax

let discovery = "discovery/DiscoveryDocument.json"

let files (spec : Spec.t) =
  let assertion = spec.tables.session_client_assertion_cases in
  let stored = spec.tables.session_stored in
  let versions =
    match List.assoc_opt discovery spec.schemas with
    | Some (Schema.Schema { properties = Some properties; _ }) -> (
        match List.assoc_opt "version" properties with
        | Some (Schema.Schema { enum = Some members; _ }) ->
            List.fold_right
              (fun member rest ->
                match (member, rest) with
                | Schema.Int_literal n, Some rest -> Some (n :: rest)
                | _ -> None)
              members (Some [])
        | _ -> None)
    | _ -> None
  in
  match versions with
  | None ->
      Error
        [
          {
            Decode.file = discovery;
            pointer = "/properties/version/enum";
            message = "is not a list of whole versions";
          };
        ]
  | Some versions ->
      let file path ~from_ items =
        O.implementation ~path ~banner:(Banner.ocaml ~from_ __FILE__) items
      in
      Ok
        [
          file "ocaml/sdk/lib/assertion_facts.ml"
            ~from_:"session/client-assertion-cases.json"
            [
              O.let_ "lifetime_seconds" (O.int assertion.lifetime_seconds);
              O.let_ "assertion_type" (O.string assertion.assertion_type);
              O.let_ "grant_type" (O.string assertion.grant_type);
            ];
          file "ocaml/sdk/lib/registry_facts.ml"
            ~from_:("session/stored.json and " ^ discovery)
            (List.map
               (fun (k : Tables.Session_stored.keys_item) ->
                 O.let_ (Text.snake k.member) (O.string k.key))
               stored.keys
            @ [
                O.let_ "session_prefix"
                  (O.string stored.session_key_prefix.prefix);
                O.let_ "discovery_versions" (O.list (List.map O.int versions));
              ]);
          file "ocaml/sdk/lib/log_facts.ml" ~from_:"bus/log-cases.json"
            [
              O.let_ "credentials"
                (O.list (List.map O.string spec.tables.bus_log_cases.names));
            ];
        ]
