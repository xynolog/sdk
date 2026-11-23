(* The Rust SDK's protocol types (rust/sdk/src/types.rs): the body of every
   request and response the gateway declares but the ones a service only
   passes through, every channel's payload, the schemas the SDK holds beside
   them, every service's own schema ([Roots]), every kind of
   id, and the records Protocol states in its tables
   ([Table_records]), with every schema they reach; and an entry of
   the store [xynolog login] keeps (rust/sdk/src/sign_in_store.rs). *)

module Generate = Generate

(* The mark unit holds the motivation a job's parameters state. *)
let accessors = [ "MarkJobParams" ]
let regenerate from_ = Banner.lines ~from_ __FILE__

(* The SDK's types: [bundle]'s schemas it generates, and how. *)
let generation (spec : Spec.t) (bundle : Definitions.bundle) :
    Generate.generation =
  let identifiers =
    List.map
      (fun (k : Tables.Identifiers_kinds.kinds_item) -> k.schema)
      spec.tables.identifiers_kinds.kinds
  in
  {
    roots =
      List.sort_uniq String.compare
        (List.map fst (Roots.all spec)
        @ identifiers
        @ Definitions.generated_client_types spec
        @ List.map (fun (_, name, _) -> name) (Definitions.records spec));
    identifiers;
    accessors;
    elsewhere = [];
  }

(* The types the SDK's [xynolog::types] declares, by name. *)
let declared (spec : Spec.t) =
  let bundle = Definitions.bundle spec in
  Generate.declared bundle.definitions (generation spec bundle)

let types (spec : Spec.t) =
  let bundle = Definitions.bundle spec in
  {
    Output.path = "rust/sdk/src/generated/types.rs";
    text =
      Rust_syntax.text
        ~header:(regenerate "the component schemas in protocol/specs/src")
        (Generate.items bundle.definitions (generation spec bundle));
  }

let sign_in (spec : Spec.t) =
  let schema =
    match List.assoc_opt Roots.sign_in_entry spec.schemas with
    | Some s -> s
    | None -> Definitions.refuse "Protocol has no %s" Roots.sign_in_entry
  in
  {
    Output.path = "rust/sdk/src/generated/sign_in.rs";
    text =
      Rust_syntax.text
        ~header:(regenerate ("protocol/specs/src/" ^ Roots.sign_in_entry))
        (Generate.items
           (Definitions.alone ~ids:spec.ids ~name:"SignIn" schema)
           {
             roots = [ "SignIn" ];
             identifiers = [];
             accessors = [];
             elsewhere = [];
           });
  }

(* Why a client that read a launcher's discovery document found no launcher
   (rust/sdk/src/discovery.rs): an enumeration of the reasons. *)
let discovery_absent (spec : Spec.t) =
  let reasons =
    List.map
      (fun (r : Tables.Client_discovery_absent.reasons_item) ->
        Schema.String_literal r.reason)
      spec.tables.client_discovery_absent.reasons
  in
  {
    Output.path = "rust/sdk/src/generated/discovery_absent.rs";
    text =
      Rust_syntax.text
        ~header:(regenerate "protocol/specs/src/client/discovery-absent.json")
        (Generate.enumeration "DiscoveryAbsentReason"
           {
             (Definitions.node [ "type"; "enum" ]) with
             type_ = Some (One String);
             enum = Some reasons;
           }
           [ "Why no launcher was found." ]);
  }

let files ~root:_ (spec : Spec.t) =
  match [ types spec; sign_in spec; discovery_absent spec ] with
  | files -> Ok files
  | exception Definitions.Refused message ->
      Error [ { Decode.file = "openapi.json"; pointer = ""; message } ]
