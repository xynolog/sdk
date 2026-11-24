(* The C# SDK's group: its models (Models), the client types among them, and
   why no launcher was found (Types/DiscoveryAbsentReason.g.cs); each schema
   the models are made from as
   the SDK validates a value against it (WireSchemas.g.cs), the code each of
   the wire's own failure codes becomes (FailureCodes.g.cs), every failure
   vocabulary's codes (ErrorCodes.g.cs), the timing a client keeps
   (Timings.g.cs), the services' tables and the archivist's routes
   (ServiceTables.g.cs), the launcher's control API (ControlMethods.g.cs),
   and the tables
   the SDK reads as Protocol writes them, with what the sign-in store's
   contract states (ProtocolTables.g.cs). What is read as Protocol writes it
   is read from the pinned checkout, byte for byte. *)

module C = Csharp_syntax
module Models = Models

let generated = "csharp/sdk/src/Xynolog/Generated/"
let types = generated ^ "Types"
let specs = "protocol/specs/src/"
let ( let* ) = Result.bind

let file ~from_ ?(nullable = false) ~namespace path decls =
  {
    Output.path;
    text =
      C.text
        {
          header = Banner.lines ~from_ __FILE__;
          nullable;
          usings = [];
          namespace;
          decls;
        };
  }

let static_class ?(modifiers = [ C.Internal; Static ]) name members =
  C.Type
    {
      attributes = [];
      modifiers;
      kind = Class;
      name;
      params = None;
      base = None;
      body = Some (Packed, members);
    }

let constant type_ name value =
  C.Field
    {
      modifiers = [ Internal; Const ];
      type_ = T type_;
      name;
      value = Some value;
    }

(* [schema] as WireSchemas states it, each [$ref] into a table naming the
   record there by its title: WireJson finds the schema a reference names by
   the name of the file it names. *)
let titled ids records =
  Schema.cata
    ~boolean:(fun b -> Schema.Boolean_schema b)
    ~schema:(fun l ->
      Schema.Schema
        {
          l with
          ref_ =
            Option.map
              (fun (r : Decode.reference) ->
                match
                  List.find_opt
                    (fun (k, _, _) -> k = Table_records.key ids r)
                    records
                with
                | Some (_, title, _) ->
                    { Decode.target = title ^ ".json"; file = ""; pointer = "" }
                | None -> r)
              l.ref_;
        })

(* [schema] without its comments, which say nothing a value is held to: a
   service table's schema says one beside a reference
   (WorkerAnswerFormats.json's [element]), where a writer reading it whole
   takes only a description. *)
let uncommented =
  Schema.cata
    ~boolean:(fun b -> Schema.Boolean_schema b)
    ~schema:(fun l -> Schema.Schema { l with comment = None })

let schema_of (spec : Spec.t) path =
  match List.assoc_opt path spec.schemas with
  | Some schema -> Ok schema
  | None ->
      Error
        [
          {
            Decode.file = path;
            pointer = "";
            message = "is not among the spec's schemas";
          };
        ]

(* The schemas the models are made from: every root ([Roots]), the gateway's
   components and the discovery document's among them, the sign-in store's
   entry, the client types it generates ([Definitions.generated_client_types]), each service table's own schema
   ([Services]), and the records Protocol states in its tables ([Table_records]);
   each with the file, or the place in a file, it is read from. *)
let roots (spec : Spec.t) =
  let* records =
    Result.map_error
      (fun message -> [ { Decode.file = specs; pointer = ""; message } ])
      (Table_records.all spec)
  in
  (* A schema is validated as a writer reads it whole ([Definitions.whole]),
     each place of several types the [anyOf] of each
     ([Normalize.several_types_throughout]): the union a model of it reads. *)
  let read name path schema =
    let validated = Normalize.several_types_throughout schema in
    (name, path, { Models.schema = Normalize.shape_only validated; validated })
  in
  let written = Definitions.whole spec in
  let whole name path =
    let* stated = schema_of spec path in
    Result.map_error
      (fun message -> [ { Decode.file = path; pointer = ""; message } ])
      (Result.map (read name path) (written stated))
  in
  let components =
    List.map
      (fun (name, reference) ->
        whole name (fst (Decode.resolve spec.Spec.ids reference)))
      (Roots.all spec)
  in
  let* roots =
    Spec.all
      (components
      @ [ whole "SignIn" Roots.sign_in_entry ]
      @ List.map
          (fun (name, path) ->
            let* stated = schema_of spec path in
            Result.map_error
              (fun message -> [ { Decode.file = path; pointer = ""; message } ])
              (Result.map (read name path) (written (uncommented stated))))
          (Services.schemas spec)
      @ List.map
          (fun name -> whole name (Roots.client_types ^ name ^ ".json"))
          (Definitions.generated_client_types spec))
  in
  Ok
    ( roots @ List.map (fun (key, name, schema) -> read name key schema) records,
      records )

let refused message =
  [ { Decode.file = "components/schemas"; pointer = ""; message } ]

let model_file (name, _, decls) =
  file ~nullable:true ~namespace:"Xynolog.Types"
    ~from_:"the schemas of protocol/specs/src the C# SDK models"
    (types ^ "/" ^ name ^ ".g.cs")
    decls

(* Why a client that read a launcher's discovery document found no launcher
   (protocol/specs/src/client/discovery-absent.json): a constant a reason,
   written as the reason's word. *)
let discovery_absent (spec : Spec.t) =
  let name = "DiscoveryAbsentReason" in
  let serialization = "global::System.Text.Json.Serialization." in
  file ~nullable:true ~namespace:"Xynolog.Types"
    ~from_:"protocol/specs/src/client/discovery-absent.json"
    (types ^ "/" ^ name ^ ".g.cs")
    [
      C.Enum
        {
          attributes =
            [
              {
                C.name = serialization ^ "JsonConverter";
                args =
                  [
                    Typeof
                      (Generic
                         (serialization ^ "JsonStringEnumConverter", [ T name ]));
                  ];
              };
            ];
          modifiers = [ Public ];
          name;
          members =
            List.map
              (fun (r : Tables.Client_discovery_absent.reasons_item) ->
                ( [
                    {
                      C.name = serialization ^ "JsonStringEnumMemberName";
                      args = [ Str r.reason ];
                    };
                  ],
                  Models.enum_constant r.reason ))
              spec.tables.client_discovery_absent.reasons;
        };
    ]

let wire_schemas ids records (models : Models.t) =
  let source =
    `Assoc
      (List.map
         (fun (name, schema) ->
           (name, Schema.runtime (titled ids records schema)))
         models.schemas)
  in
  file ~namespace:"Xynolog.Serialization"
    ~from_:"the schemas of protocol/specs/src the C# SDK models"
    (generated ^ "WireSchemas.g.cs")
    [
      static_class
        ~modifiers:[ Internal; Static; Partial ]
        "WireJson"
        [
          C.Field
            {
              modifiers = [ Private; Const ];
              type_ = T "string";
              name = "SchemaSource";
              value = Some (Str (Yojson.Safe.to_string source));
            };
        ];
    ]

(* The tables the SDK reads, by the constant it reads each as. *)
let tables =
  [
    ("Registry", "bus/registry.json");
    ("Timing", "client/timing.json");
    ("RetryRules", "retry/rules.json");
    ("Telemetry", "sdk-telemetry/telemetry.json");
    ("Log", "bus/log-cases.json");
    ("OwnerOnly", "sign-in-store/owner-only.json");
    ("OAuth", "session/oauth.json");
    ("ClientAssertion", "session/client-assertion-cases.json");
    ("Principals", "principals/cases.json");
    ("MediaTypes", "media-types/registry.json");
    ("Encodings", "text/encoding-cases.json");
    ("CacheRefresh", "client/refresh.json");
    ("Stored", "session/stored.json");
    ("Discovery", "discovery/DiscoveryDocument.json");
  ]

let protocol_tables ~root =
  let* contract = Sign_in.Contract.read ~root in
  let text path =
    In_channel.with_open_bin
      (Filename.concat root (specs ^ path))
      In_channel.input_all
  in
  Ok
    (file ~namespace:"Xynolog.Protocol"
       ~from_:
         ("protocol/specs/src: "
         ^ String.concat ", " (List.map snd tables)
         ^ " and " ^ Sign_in.Contract.file)
       (generated ^ "ProtocolTables.g.cs")
       [
         static_class "ProtocolTables"
           (List.map
              (fun (name, path) -> constant "string" name (Str (text path)))
              tables
           @ [
               constant "uint" "WindowsOffsetHigh"
                 (Uint_hex contract.offset_high);
               constant "string" "StoreFileName" (Str contract.document);
               constant "string" "StoreLockName" (Str contract.lock);
             ]);
       ])

(* A code's constant: its part after its last dot, as an enum member is
   named. *)
let code_constant code = Models.enum_constant (Error_codes.Table.segment code)

(* The code a bus request fails under, by the code its failure states, in
   the order CommandError names them; one that states none is the
   unrecognized failure. *)
let failure_codes (t : Error_codes.Table.t) (models : Models.t) =
  let* code_type =
    match models.member_type "CommandError" "code" with
    | Some name -> Ok ("global::Xynolog.Types." ^ name)
    | None -> Error (refused "CommandError.code is made as no type of its own.")
  in
  let bus (c : Error_codes.Table.code) =
    C.Name
      ("global::Xynolog.Errors." ^ t.bus.go_name ^ "." ^ code_constant c.code)
  in
  (* Derive holds every code CommandError names to the one it becomes. *)
  let arms =
    List.map
      (fun code ->
        let failure : Error_codes.Table.code = List.assoc code t.wire in
        ( C.Value (Name (code_type ^ "." ^ Models.enum_constant code)),
          bus failure ))
      Error_codes.Table.wire_codes
  in
  Ok
    (file ~namespace:"Xynolog.Protocol"
       ~from_:("protocol/specs/src/" ^ Error_codes.Table.file)
       (generated ^ "FailureCodes.g.cs")
       [
         static_class "FailureCodes"
           [
             C.Method
               {
                 modifiers = [ Internal; Static ];
                 returns = T "string";
                 name = "Of";
                 params =
                   [
                     {
                       by = `Value;
                       type_ = Nullable (T code_type);
                       name = "code";
                     };
                   ];
                 body =
                   Arrow
                     (Switch
                        ( Name "code",
                          arms
                          @ [
                              (Value Null, bus t.unrecognized);
                              ( Discard,
                                Throw
                                  (New
                                     {
                                       type_ =
                                         Some
                                           (T
                                              "global::System.ArgumentOutOfRangeException");
                                       args =
                                         Some
                                           [
                                             Arg (Nameof "code");
                                             Arg (Name "code");
                                             Arg
                                               (Str "No code of CommandError.");
                                           ];
                                       init = None;
                                     }) );
                            ] ));
               };
           ];
       ])

(* Each failure vocabulary of errors/codes.json, a class of its codes as
   constants, named as Go names its type; the transport's also says which
   code an HTTP status becomes. *)
let error_codes (t : Error_codes.Table.t) =
  let codes (v : Error_codes.Table.vocabulary) =
    List.map
      (fun (c : Error_codes.Table.code) ->
        C.Documented
          ( c.docs,
            C.Field
              {
                modifiers = [ Public; Const ];
                type_ = T "string";
                name = code_constant c.code;
                value = Some (Str c.code);
              } ))
      v.codes
  in
  let returns (c : Error_codes.Table.code) =
    C.Return (Name (code_constant c.code))
  in
  let status op n = C.Binary (C.Name "status", op, C.Int n) in
  let transport_of =
    C.Method
      {
        modifiers = [ Internal; Static ];
        returns = T "string";
        name = "Of";
        params = [ { by = `Value; type_ = T "int"; name = "status" } ];
        body =
          Block
            (List.map
               (fun (n, c) -> C.If (status C.Eq n, [ returns c ]))
               t.exact
            @ (match t.from with
              | Some (n, c) -> [ C.If (status C.Ge n, [ returns c ]) ]
              | None -> [])
            @ [ returns t.unclassified ]);
      }
  in
  let vocabulary ?(more = []) (v : Error_codes.Table.vocabulary) =
    static_class ~modifiers:[ C.Public; C.Static ] v.go_name (codes v @ more)
  in
  file ~namespace:"Xynolog.Errors"
    ~from_:("protocol/specs/src/" ^ Error_codes.Table.file)
    (generated ^ "ErrorCodes.g.cs")
    ([ vocabulary t.bus; vocabulary ~more:[ transport_of ] t.transport ]
    @ List.map (fun v -> vocabulary v) t.others
    @ [ vocabulary t.control ])

(* The timing a client keeps (client/timing.json), a constant an entry,
   named as the entry is; a budget is a RetryPolicy. *)
let timings (entries : Timing.Table.t) =
  let member (e : Timing.Table.entry) =
    let name = String.capitalize_ascii e.name in
    match e.value with
    | Timing.Table.Duration n | Timing.Table.Count n ->
        constant "int" name (C.Int n)
    | Timing.Table.Budget { attempts; initial_delay_ms; max_delay_ms } ->
        C.Property
          {
            attributes = [];
            modifiers = [ Internal; Static ];
            type_ = T "global::Xynolog.Http.RetryPolicy";
            name;
            accessors = [ Get ];
            value =
              Some
                (New
                   {
                     type_ = None;
                     args =
                       Some
                         [
                           Arg (Int attempts);
                           Arg (Int initial_delay_ms);
                           Arg (Int max_delay_ms);
                         ];
                     init = None;
                   });
          }
  in
  file ~namespace:"Xynolog.Protocol"
    ~from_:("protocol/specs/src/" ^ Timing.Table.file)
    (generated ^ "Timings.g.cs")
    [ static_class "Timings" (List.map member entries) ]

let files ~root (spec : Spec.t) =
  let* kinds = Identifiers.Table.derive spec in
  let* roots, records = roots spec in
  let* made =
    Spec.all
      (Bus.Csharp.payloads spec.tables.bus_registry
      |> List.map (Result.map_error (fun e -> [ e ])))
  in
  let* models =
    Result.map_error refused
      (Models.make ~ids:spec.ids
         ~identifiers:
           (List.map (fun (k : Identifiers.Table.kind) -> k.name) kinds)
         ~keys:(Definitions.map_keys spec)
         ~roots
         ~made:
           (List.map
              (fun (name, _, schema) ->
                let validated = Normalize.several_types_throughout schema in
                ( name,
                  { Models.schema = Normalize.shape_only validated; validated }
                ))
              made))
  in
  let* codes = Error_codes.Table.derive spec.tables.errors_codes in
  let* failures = failure_codes codes models in
  let* timing = Timing.Table.derive spec.tables.client_timing in
  let* tables = protocol_tables ~root in
  let* services = Services.file ~root spec in
  let* control = Control.file models spec in
  let written = List.map model_file models.models @ [ discovery_absent spec ] in
  match Output.stale ~root ~directory:types written with
  | [] ->
      Ok
        (written
        @ [
            wire_schemas spec.ids records models;
            failures;
            error_codes codes;
            timings timing;
            tables;
            services;
            control;
          ])
  | stale -> Error stale
