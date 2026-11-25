(* The Haskell SDK's facts of tables no group of its own writes for it: the
   templates a principal's DID is made from (principals/cases.json), the
   names a bus log never prints the value of (bus/log-cases.json), a client
   assertion's types and lifetime (session/client-assertion-cases.json), and
   the fields of the options a session factory takes, as client/surface.json
   lists them, each of the type Haskell holds it as. *)

module H = Haskell_syntax

let module_ ~from_ name
    ?(imports = [ H.import "Data.Text" ~items:[ Plain "Text" ] ]) body =
  {
    H.banner = Banner.lines ~from_ __FILE__;
    extensions = [ "OverloadedStrings" ];
    name = "Xynolog.Internal.Generated." ^ name;
    imports;
    body;
  }

let text name value = H.value name (T_name "Text") (Str value)

(* Each field of a session factory's options, and the type Haskell holds it
   as: a knowledge base, a storage, and the signals unit. *)
let factory_types =
  [
    ("kb", "KnowledgeBase");
    ("storage", "Storage.SessionStorage");
    ("signals", "Signals.SessionSignals");
  ]

let factory_fields (surface : Tables.Client_surface.t) =
  let listed =
    List.concat_map
      (fun (m : Tables.Client_surface.modules_item) ->
        if m.module_ <> "registry" then []
        else
          List.filter_map
            (function
              | Tables.Client_surface.Type
                  { member = "SessionFactoryOptions"; fields; _ } ->
                  Some fields
              | Reader _ | Function _ | Type _ | Constant _ -> None)
            m.members)
      surface.modules
  in
  match listed with
  | [ Some fields ]
    when List.sort String.compare fields
         = List.sort String.compare (List.map fst factory_types)
         && List.length fields = List.length factory_types ->
      Ok (List.map (fun f -> (f, List.assoc f factory_types)) fields)
  | [ Some _ ] ->
      Error
        "SessionFactoryOptions' fields in surface.json are not those Haskell \
         types"
  | [ None ] -> Error "SessionFactoryOptions states no fields in surface.json"
  | _ ->
      Error
        "surface.json's registry module does not list SessionFactoryOptions \
         once"

let occurrences ~of_ text =
  let n = String.length of_ in
  let rec count i found =
    if i > String.length text - n then found
    else if String.sub text i n = of_ then count (i + n) (found + 1)
    else count (i + 1) found
  in
  count 0 0

let modules (spec : Spec.t) =
  let principals = spec.tables.principals_cases in
  let assertion = spec.tables.session_client_assertion_cases in
  let templates =
    [ ("person", principals.person); ("agent", principals.agent) ]
  in
  match
    List.find_opt
      (fun (_, value) ->
        occurrences ~of_:"{domain}" value <> 1
        || occurrences ~of_:"{subject}" value <> 1)
      templates
  with
  | Some (name, _) ->
      Error
        ("principal template " ^ name
       ^ " has not one {domain} and one {subject}")
  | None ->
      Result.map
        (fun fields ->
          [
            module_ ~from_:"principals/cases.json" "Principals"
              (List.map (fun (name, value) -> text name value) templates);
            module_ ~from_:"bus/log-cases.json" "BusLog"
              [
                H.value "withheldNames" (T_list (T_name "Text"))
                  (List
                     (List.map
                        (fun n -> H.Str n)
                        spec.tables.bus_log_cases.names));
              ];
            module_ ~from_:"session/client-assertion-cases.json"
              "ClientAssertion"
              [
                text "grantType" assertion.grant_type;
                text "assertionType" assertion.assertion_type;
                H.value "lifetimeSeconds" (T_name "Integer")
                  (Int assertion.lifetime_seconds);
              ];
            module_ ~from_:"client/surface.json" "SessionFactoryOptions"
              ~imports:
                [
                  H.import "Xynolog.Types" ~items:[ Plain "KnowledgeBase" ];
                  H.import "Xynolog.SessionStorage" ~qualified:"Storage";
                  H.import "Xynolog.State.SessionSignals" ~qualified:"Signals";
                ]
              [
                H.record ~constructor:"SessionFactoryOptions"
                  "SessionFactoryOptions"
                  (List.map
                     (fun (field, type_) ->
                       ( Models.field "SessionFactoryOptions" field,
                         H.T_name type_ ))
                     fields);
              ];
          ])
        (factory_fields spec.tables.client_surface)
