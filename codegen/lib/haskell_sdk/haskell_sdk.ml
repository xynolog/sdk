(* The Haskell SDK's modules that no other group's table owns: the models of
   every schema it reads or writes, with the module that exports them, the
   schemas it validates against and the round trips its tests drive; its
   HTTP routes; its transport's facts; its bus's channels and operations,
   with each operation's failure; and the launcher's control API. Each group that owns a table
   writes the Haskell SDK's module of it itself. *)

module Models = Models
module Companions = Companions
module Definitions = Definitions
module Http = Http
module Transport = Transport
module Channels = Channels
module Marker = Marker
module Constants = Constants
module Worker = Worker
module Control = Control
module H = Haskell_syntax

let ( let* ) = Result.bind

(* The member Xynolog.Discovery.Reasons names its type and constructors by,
   as a failure vocabulary's are. *)
let discovery_absent_member = "discoveryAbsent"

let path ~under name =
  "haskell/sdk/" ^ under ^ "/"
  ^ String.concat "/" (String.split_on_char '.' name)
  ^ ".hs"

let file ~under (m : H.module_) =
  { Output.path = path ~under m.name; text = H.text m }

let banner from_ = Banner.lines ~from_ __FILE__

(* The client types the SDK models, as their group states them. *)
let adapters (spec : Spec.t) =
  let* model = Client_types.Model.derive spec in
  Client_types.Haskell.adapters
    ~names:(Client_types.Haskell.adapted spec)
    ~shape:(Client_types.Model.shape model)
    ~whole:(Client_types.Haskell.whole spec)

(* The package's manifest: its template with the model modules listed, at
   the version the committed manifest states, which scripts/sdk_version.py
   writes; and the repository's licence, which the package ships. *)
let manifest ~root module_names =
  let template = Marker.read ~root "haskell/sdk/xynolog.cabal.in" in
  let committed = Marker.read ~root "haskell/sdk/xynolog.cabal" in
  let* () =
    match
      List.find_opt
        (fun m -> Marker.count m template <> 1)
        [ "@VERSION@"; "@MODEL_MODULES@" ]
    with
    | Some m -> Error ("the manifest template states " ^ m ^ " other than once")
    | None -> Ok ()
  in
  let* version =
    match
      List.filter_map
        (fun line ->
          if String.starts_with ~prefix:"version:" line then
            Some (String.trim (Marker.drop (String.length "version:") line))
          else None)
        (String.split_on_char '\n' committed)
    with
    | [ version ] -> Ok version
    | _ -> Error "xynolog.cabal must hold exactly one top-level version line"
  in
  let replace marker by text =
    match Marker.find marker text with
    | Some i ->
        String.sub text 0 i ^ by ^ Marker.drop (i + String.length marker) text
    | None -> text
  in
  Ok
    [
      {
        Output.path = "haskell/sdk/xynolog.cabal";
        text =
          template
          |> replace "@VERSION@" version
          |> replace "@MODEL_MODULES@"
               (String.concat "\n"
                  (List.map (fun m -> "    " ^ m) module_names));
      };
      {
        Output.path = "haskell/sdk/LICENSE";
        text = Marker.read ~root "LICENSE";
      };
    ]

(* A model module the models no longer make: one in the models' directory
   that [written] does not name. It is refused rather than removed, so the
   run that drops a schema names the file to delete with it. *)
let stale ~root written =
  let directory = "haskell/sdk/generated/Xynolog/Internal/Generated/Models" in
  let on_disk =
    match Sys.readdir (Filename.concat root directory) with
    | names -> Array.to_list names
    | exception Sys_error _ -> []
  in
  match
    List.find_opt
      (fun name -> not (List.mem (directory ^ "/" ^ name) written))
      (List.sort String.compare on_disk)
  with
  | Some name -> Error ("stale generated module: " ^ directory ^ "/" ^ name)
  | None -> Ok ()

let files ~root (spec : Spec.t) =
  let refused file message = [ { Decode.file; pointer = ""; message } ] in
  let within file result = Result.map_error (refused file) result in
  let* user_field = User_stamp.field spec.tables.identifiers_kinds in
  let* transport =
    within Transport.contract (Transport.derive ~root ~user_field spec)
  in
  let* http =
    within "openapi.json"
      (Http.routes ~prefix:Http.gateway_prefix ~no_content:false spec
         spec.gateway)
  in
  let* archivist =
    within "archivist/openapi.json"
      (Http.routes ~prefix:Http.archivist_prefix ~no_content:true spec
         spec.archivist)
  in
  let* bus =
    within "bus/registry.json" (Channels.derive spec.tables.bus_registry)
  in
  let* adapters = adapters spec in
  let* definitions, validated_roots =
    within "openapi.json"
      (Definitions.derive spec ~adapters
         ~carrier:(Transport.carrier_schema transport)
         ~http:(http.schemas @ archivist.schemas)
         ~envelopes:bus.envelopes)
  in
  let identifiers =
    List.map
      (fun (k : Tables.Identifiers_kinds.kinds_item) -> k.schema)
      spec.tables.identifiers_kinds.kinds
  in
  let* models =
    within "openapi.json"
      (Models.generate
         ~banner:(banner "protocol/specs/src")
         ~ids:spec.ids ~identifiers ~keys:(Typing.D.map_keys spec) definitions)
  in
  let* () =
    within "openapi.json"
      (stale ~root
         (List.map
            (fun (m : H.module_) -> path ~under:"generated" m.name)
            models.modules))
  in
  let named = List.map fst definitions in
  let definition name =
    match List.assoc_opt name definitions with
    | Some s -> Ok s
    | None -> Error ("missing schema: " ^ name)
  in
  let normalize =
    Normalize.normalize spec.Spec.ids ~find:(fun r ->
        definition (Definitions.referenced r))
  in
  let* () = within "bus/registry.json" (Channels.check bus ~models:named) in
  let* limits = within "bus/registry.json" (Channels.limits bus) in
  let* readers =
    within "bus/registry.json"
      (Channels.readers bus ~normalize ~definition ~typing:models.typing
         spec.tables.errors_codes)
  in
  let* credential =
    within Http.classifier
      (let* c = Http.credential ~root in
       let* limit = Result.bind (definition "LimitRefusal") normalize in
       let* code =
         match Option.bind limit.properties (List.assoc_opt c.field) with
         | Some p -> normalize p
         | None -> Error ("HTTP schema has no requested field: " ^ c.field)
       in
       if
         code.type_ = Some [ String ]
         && List.mem (Schema.String_literal c.refusal)
              (Option.value code.enum ~default:[])
       then Ok c
       else Error "credential refusal reader no longer matches its schema")
  in
  let* bus_event =
    within "openapi.json"
      (match Result.bind (definition "BusEventMessage") Normalize.layer with
      | Ok { properties = Some properties; _ } -> (
          match List.assoc_opt "event" properties with
          | Some (Schema { enum = Some [ String_literal event ]; _ }) ->
              Ok event
          | _ -> Error "bus event has no single name")
      | Ok _ -> Error "BusEventMessage has no properties"
      | Error e -> Error e)
  in
  let* constants = within "client/surface.json" (Constants.modules spec) in
  let* control =
    within "control/methods.json"
      (Control.module_
         ~banner:(banner "protocol/specs/src/control/methods.json")
         spec.tables.control_methods)
  in
  let tables =
    List.map
      (Companions.tables_module
         ~banner:(banner "the tables of protocol/specs/src")
         ~root)
      (Carried_tables.modules spec)
  in
  let* worker = Worker.modules ~root in
  let* manifest =
    within "haskell/sdk/xynolog.cabal.in" (manifest ~root models.module_names)
  in
  let* validated =
    (* A root is validated as Protocol states it; what the models mint
       beside the roots, as they type it. *)
    let find name =
      match
        ( List.assoc_opt name validated_roots,
          List.assoc_opt name models.definitions )
      with
      | Some s, _ | None, Some s -> Ok s
      | None, None -> Error ("unknown schema reference: " ^ name)
    in
    let merged =
      Normalize.everywhere spec.Spec.ids ~referenced:Definitions.referenced
        ~find
    in
    Spec.all
      (List.map
         (fun (name, _) ->
           match merged name with
           | Ok s -> Ok (name, s)
           | Error message ->
               Error (refused "openapi.json" (name ^ ": " ^ message)))
         models.definitions)
  in
  let* round_trip =
    within "openapi.json"
      (Companions.round_trip_module
         ~banner:(banner "protocol/specs/src")
         ~enumerations:models.enumerations ~unions:models.unions
         (List.map fst models.definitions))
  in
  let unrecognized =
    Error_codes.Haskell.code_constructor "busRequest"
      spec.tables.errors_codes.bus_request.unrecognized_failure
  in
  Ok
    (List.map (file ~under:"generated") models.modules
    @ [
        file ~under:"src"
          (Companions.types_module
             ~banner:(banner "protocol/specs/src")
             models.module_names);
        file ~under:"generated"
          (Companions.schemas_module
             ~banner:(banner "protocol/specs/src")
             validated);
        file ~under:"test" round_trip;
        file ~under:"src"
          (Http.file
             ~banner:
               (banner
                  "protocol/specs/src/openapi.json, its paths, and the \
                   reference credential classifier")
             http ~credential ~bus_event);
        file ~under:"src"
          (Http.archivist_file
             ~banner:
               (banner "protocol/specs/src/archivist/openapi.json and its paths")
             archivist);
        file ~under:"src"
          (Transport.file
             ~banner:
               (banner
                  "TRANSPORT-HTTP.md, bus/registry.json and \
                   identifiers/kinds.json")
             transport);
        file ~under:"src"
          (Channels.channels_file
             ~banner:(banner "protocol/specs/src/bus/registry.json")
             bus ~limits);
        file ~under:"test"
          (Channels.round_trip_file
             ~banner:(banner "protocol/specs/src/bus/registry.json")
             bus);
        file ~under:"generated"
          (Channels.failure_file
             ~banner:
               (banner
                  "protocol/specs/src/bus/registry.json and \
                   protocol/specs/src/errors/codes.json")
             ~unrecognized readers);
      ]
    @ List.map (file ~under:"src") (control :: tables)
    @ List.map (file ~under:"generated") constants
    @ List.map (file ~under:"generated") worker
    @ manifest
    @ Error_codes.Haskell.modules
        ~from_:"protocol/specs/src/client/discovery-absent.json"
        ~module_name:"Xynolog.Discovery.Reasons"
        ~test_name:"DiscoveryReasonRoundTrip"
        [
          {
            Error_codes.Haskell.member = discovery_absent_member;
            codes =
              List.map
                (fun (r : Tables.Client_discovery_absent.reasons_item) ->
                  r.reason)
                spec.tables.client_discovery_absent.reasons;
            statuses = None;
          };
        ])
