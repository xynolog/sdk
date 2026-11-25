(* Every contract the pinned Protocol states, by kind, and whether each SDK
   declares each item: the census contracts_census.exe holds every SDK to,
   and the table CONTRACTS.md shows. A generated item is looked for in what
   its writer writes, by the name the writer gives it; a hand-written one in
   the SDK's own files, by the name its language gives it. An item counts as
   declared when a declaration names it, or, where the language types a
   value as a literal, when the literal is a member of the named type that
   holds the vocabulary; never by a string anywhere in a file. *)

module Sdk = Coverage_sdk

(* What a cell reads: the files the writers write, and the checkout's own,
   by their paths. A path no writer writes, or that the checkout lacks, is
   the census's own mistake, and fails it. *)
type texts = {
  root : string;
  generated : string -> string;
  checkout : string -> string;
}

let texts ~root (files : Output.file list) =
  let written = Hashtbl.create 4096 and read = Hashtbl.create 64 in
  List.iter
    (fun (f : Output.file) -> Hashtbl.replace written f.path f.text)
    files;
  let generated path =
    match Hashtbl.find_opt written path with
    | Some text -> text
    | None -> failwith ("contracts: no writer writes " ^ path)
  and checkout path =
    match Hashtbl.find_opt read path with
    | Some text -> text
    | None ->
        let full = Filename.concat root path in
        if not (Sys.file_exists full) then
          failwith ("contracts: the checkout has no " ^ path);
        let text = In_channel.with_open_bin full In_channel.input_all in
        Hashtbl.replace read path text;
        text
  in
  { root; generated; checkout }

type row = { item : string; declared : Sdk.t -> bool }
type kind = { kind : string; rows : row list }

let kind kind items ~item ~declared =
  {
    kind;
    rows =
      List.map
        (fun x -> { item = item x; declared = (fun s -> declared s x) })
        items;
  }

(* ---- What a declaration is ---- *)

let identifier_character = function
  | 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '_' -> true
  | _ -> false

let holds_at text i needle =
  let m = String.length needle in
  let rec from k = k = m || (text.[i + k] = needle.[k] && from (k + 1)) in
  i + m <= String.length text && from 0

let rec find text i needle =
  if needle = "" || i > String.length text then None
  else
    match String.index_from_opt text i needle.[0] with
    | None -> None
    | Some at ->
        if holds_at text at needle then Some at else find text (at + 1) needle

(* Whether [text] holds [before], then [name], then [after]; or, where
   [after] is empty, no more of an identifier. *)
let declares text (before, after) name =
  let needle = before ^ name ^ after in
  let ends at =
    let past = at + String.length needle in
    after <> ""
    || past = String.length text
    || not (identifier_character text.[past])
  in
  let rec from i =
    match find text i needle with
    | None -> false
    | Some at -> ends at || from (at + 1)
  in
  name <> "" && from 0

let any text forms name = List.exists (fun f -> declares text f name) forms
let plain = List.map (fun before -> (before, ""))

(* The part of [text] from [opening] to the first [closing] after it, both
   kept: the named type, record or module a literal or a name is a member
   of. Empty when [text] has no [opening]. *)
let block ~opening ~closing text =
  match find text 0 opening with
  | None -> ""
  | Some i -> (
      let from = i + String.length opening in
      match find text from closing with
      | None -> failwith ("contracts: nothing closes " ^ String.escaped opening)
      | Some j -> String.sub text i (j + String.length closing - i))

(* ---- Where each SDK's files are ---- *)

let directory = function
  | Sdk.Typescript -> "typescript/"
  | Python -> "python/"
  | Rust -> "rust/"
  | Go -> "go/"
  | Csharp -> "csharp/"
  | Haskell -> "haskell/"
  | Kotlin -> "kotlin/"
  | Ocaml -> "ocaml/"
  | Swift -> "swift/"

let swift_models = Swift_sdk.models_path
let kotlin_generated = "kotlin/sdk/src/generated/kotlin/xynolog/"
let csharp_generated = "csharp/sdk/src/Xynolog/Generated/"
let haskell_generated = "haskell/sdk/generated/Xynolog/Internal/Generated/"

let derived = function
  | Ok table -> table
  | Error errors ->
      failwith (String.concat "; " (List.map Decode.error_to_string errors))

(* A one-line sum type's constructors: after its [=], or a [|]. *)
let constructors = [ ("= ", ""); ("| ", "") ]

(* ---- Schemas ---- *)

(* What declares a type for a schema in each SDK's written files. C# makes a
   schema of one plain value a type of its own language (a string, a long),
   and so names every schema it validates against in WireSchemas; OCaml
   names each in Models, its value on the line after the name where the two
   are long. *)
let schema_forms = function
  | Sdk.Go -> plain [ "\ntype " ] @ [ ("\n\t", " =") ]
  | Typescript -> [ ("\n    ", ":") ]
  | Python -> plain [ "\nclass "; "\ntype " ]
  | Rust -> plain [ "pub struct "; "pub enum "; "pub type " ]
  | Swift ->
      plain
        [
          "public struct ";
          "public enum ";
          "public indirect enum ";
          "public typealias ";
        ]
  | Kotlin -> plain [ "class "; "interface "; "typealias "; "object " ]
  | Csharp -> [ ({|\"|}, {|\":{|}) ]
  | Haskell -> plain [ "\nnewtype "; "\ndata "; "\ntype " ]
  | Ocaml -> [ ({|= "|}, {|"|}); ("=\n  \"", {|"|}) ]

(* TypeScript names a record a table states as a member of [records], beside
   [components]. *)
let typescript_records t =
  block ~opening:"export interface records {" ~closing:"\n}"
    (t.generated "typescript/core/src/types.ts")

let schemas ~written t kind_name names =
  kind kind_name names ~item:Fun.id ~declared:(fun sdk name ->
      List.exists (fun text -> any text (schema_forms sdk) name) (written sdk)
      || (sdk = Typescript && declares (typescript_records t) ("\n  ", ":") name))

(* The records a table states, each by its title: its own, or, for one the
   table names by its [$id], its schema's. *)
let titles spec entries =
  List.map
    (fun entry ->
      match Table_records.stated spec entry with
      | Ok (_, Schema.Schema { title = Some title; _ }) -> title
      | Ok (key, _) -> failwith (key ^ " states a record with no title")
      | Error message -> failwith message)
    entries

(* ---- The generated kinds ---- *)

let channels t (spec : Spec.t) =
  kind "bus channels" spec.tables.bus_registry.channels ~item:Bus.Registry.name
    ~declared:(fun sdk c ->
      let n = Bus.Registry.name c in
      match sdk with
      | Go ->
          (* A request channel is its operation's, in operations_gen.go. *)
          List.exists
            (fun path ->
              declares (t.generated path) ("\n\t", "") (Bus.Go.name n))
            [ "go/bus/channels_gen.go"; "go/bus/operations_gen.go" ]
      | Typescript ->
          declares
            (block ~opening:"export type StatedEventMap" ~closing:"\n};"
               (t.generated "typescript/core/src/bus-protocol.ts"))
            ("\n  '", "':") n
      | Python ->
          declares
            (t.generated "python/sdk/src/xynolog/channels.py")
            ("\n", ": Final") (Bus.Python.constant n)
      | Rust ->
          declares
            (t.generated Bus.Rust.channels_path)
            ("pub struct ", ";") (Bus.Rust.marker n)
      | Swift ->
          declares
            (block ~opening:"public enum Channels {" ~closing:"\n}"
               (t.generated swift_models))
            ("public static let ", ":")
            (Swift_sdk.Models.member_name n)
      | Kotlin ->
          declares
            (t.generated (kotlin_generated ^ "channels/Channels.kt"))
            ("public val ", ":") (Bus.Kotlin.constant n)
      | Csharp ->
          declares
            (block ~opening:"class BusChannels" ~closing:"\n}"
               (t.generated (csharp_generated ^ "BusDescriptors.g.cs")))
            ("> ", " { get; }") (Bus.Csharp.member n)
      | Haskell ->
          declares
            (t.generated "haskell/sdk/src/Xynolog/Channels.hs")
            ("\n  ", " ::")
            (Haskell_sdk.Channels.member n)
      | Ocaml ->
          declares
            (block ~opening:"module Channels = struct" ~closing:"\nend"
               (t.generated "ocaml/sdk/lib/bus_registry.ml"))
            ("\n  let ", " =")
            (Ocaml_sdk.Bus_modules.name_of n))

(* A control method or notification, by its name and the TypeScript record
   that holds it. *)
let control what ~record names t =
  kind what names ~item:Fun.id ~declared:(fun sdk name ->
      match sdk with
      | Go ->
          declares
            (t.generated "go/control/methods_gen.go")
            ("\n\t", " =")
            (Go_types.Control.go_name name)
      | Typescript ->
          declares
            (block
               ~opening:("export const " ^ record ^ " = {")
               ~closing:"\n}"
               (t.generated "typescript/core/src/control-methods.ts"))
            ("\n  '", "':") name
      | Python ->
          declares
            (t.generated Python_types.control_path)
            ("\n", ": Final") (Bus.Python.constant name)
      | Rust ->
          declares
            (t.generated "rust/sdk/src/generated/control.rs")
            ("pub struct ", ";")
            (Rust_types.control_marker name)
      | Swift ->
          declares
            (block ~opening:"public enum Control {" ~closing:"\n}"
               (t.generated swift_models))
            ("public static let ", ":")
            (Swift_sdk.Models.member_name name)
      | Kotlin ->
          declares
            (t.generated (kotlin_generated ^ "control/ControlMethods.kt"))
            ("public val ", ":")
            (Kotlin_sdk.Control.constant name)
      | Csharp ->
          declares
            (t.generated Csharp_sdk.Control.path)
            ("> ", " { get; }")
            (Csharp_sdk.Control.property_name name)
      | Haskell ->
          declares
            (t.generated "haskell/sdk/src/Xynolog/Control.hs")
            ("\n", " ::")
            (Haskell_sdk.Control.value_name name)
      | Ocaml ->
          declares
            (t.generated "ocaml/sdk/lib/control.ml")
            ("\nlet ", " :")
            (Ocaml_sdk.Control.value_name name))

let control_methods t (spec : Spec.t) =
  control "control methods" ~record:"CONTROL_METHODS"
    (List.map
       (fun (m : Tables.Control_methods.methods_item) -> m.name)
       spec.tables.control_methods.methods)
    t

let control_notifications t (spec : Spec.t) =
  control "control notifications" ~record:"CONTROL_NOTIFICATIONS"
    (List.map
       (fun (n : Tables.Control_methods.notifications_item) -> n.name)
       spec.tables.control_methods.notifications)
    t

(* Each code within its vocabulary's type, since a code's last words can be
   another vocabulary's too. *)
let error_codes t (spec : Spec.t) =
  let module E = Error_codes.Table in
  let table = derived (E.derive spec.tables.errors_codes) in
  let codes =
    List.concat_map
      (fun (v : E.vocabulary) -> List.map (fun c -> (v, c)) v.codes)
      ((table.bus :: table.transport :: table.others) @ [ table.control ])
  in
  kind "error codes" codes
    ~item:(fun (_, (c : E.code)) -> c.code)
    ~declared:(fun sdk ((v : E.vocabulary), (c : E.code)) ->
      match sdk with
      | Go -> declares (t.generated "go/errorcodes_gen.go") ("\n\t", " ") c.go
      | Python ->
          declares
            (block
               ~opening:("\ntype " ^ v.name ^ " = Literal[")
               ~closing:"\n]"
               (t.generated "python/sdk/src/xynolog/error_codes.py"))
            ("\n    \"", "\",") c.code
      | Typescript ->
          declares
            (block
               ~opening:("export type " ^ v.name ^ " =")
               ~closing:"';"
               (t.generated "typescript/core/src/error-codes.ts"))
            ("| '", "'") c.code
      | Rust ->
          declares
            (block
               ~opening:("pub enum " ^ v.go_name ^ " {")
               ~closing:"\n}"
               (t.generated "rust/sdk/src/generated/error_codes.rs"))
            ("\n    ", ",")
            (Error_codes.Rust.variant c)
      | Swift ->
          declares
            (block
               ~opening:
                 ("public enum "
                 ^ Swift_sdk.Table_decls.error_code_enum v.member
                 ^ ":")
               ~closing:"\n}" (t.generated swift_models))
            ("case ", " = ")
            (Swift_sdk.Models.enum_case c.code)
      | Kotlin ->
          declares
            (block
               ~opening:("enum class " ^ v.go_name ^ "(")
               ~closing:"\n}"
               (t.generated (kotlin_generated ^ "errors/ErrorCodes.kt")))
            ("\n    ", "(")
            (Error_codes.Kotlin.variant c.code)
      | Csharp ->
          declares
            (block
               ~opening:("static class " ^ v.go_name ^ "\n")
               ~closing:"\n}"
               (t.generated (csharp_generated ^ "ErrorCodes.g.cs")))
            ("const string ", " =")
            (Csharp_sdk.code_constant c.code)
      | Haskell ->
          any
            (block
               ~opening:("\ndata " ^ Error_codes.Haskell.type_of v.member ^ " =")
               ~closing:"deriving"
               (t.generated "haskell/sdk/src/Xynolog/ErrorCodes.hs"))
            constructors
            (Error_codes.Haskell.code_constructor v.member c.code)
      | Ocaml ->
          declares
            (block
               ~opening:
                 ("module " ^ Error_codes.Ocaml.module_name v ^ " = struct")
               ~closing:"\nend"
               (t.generated "ocaml/sdk/lib/error_codes.ml"))
            ("\n    | ", " -> ")
            (Error_codes.Ocaml.constructor c.code))

let identifier_kinds t (spec : Spec.t) =
  kind "identifier kinds"
    (derived (Identifiers.Table.derive spec))
    ~item:(fun (k : Identifiers.Table.kind) -> k.name)
    ~declared:(fun sdk (k : Identifiers.Table.kind) ->
      let n = k.name in
      match sdk with
      | Go ->
          declares (t.generated "go/api/ids_gen.go") ("\ntype ", " struct") n
      | Typescript ->
          declares
            (t.generated "typescript/core/src/identifiers.ts")
            ("export type ", " =") n
      | Python ->
          declares
            (t.generated "python/sdk/src/xynolog/identifiers.py")
            ("\nclass ", "(") n
      | Rust ->
          declares
            (t.generated "rust/sdk/src/generated/types.rs")
            ("pub struct ", "(") n
      | Swift -> declares (t.generated swift_models) ("public struct ", ":") n
      | Kotlin ->
          declares
            (t.generated (kotlin_generated ^ "identifiers/Identifiers.kt"))
            ("value class ", "(") n
      | Csharp ->
          declares
            (t.generated (csharp_generated ^ "Identifiers/" ^ n ^ ".g.cs"))
            ("record struct ", "") n
      | Haskell ->
          declares
            (t.generated (haskell_generated ^ "Models/" ^ n ^ ".hs"))
            ("\nnewtype ", " =") n
      | Ocaml ->
          declares
            (t.generated "ocaml/sdk/lib/identifiers.ml")
            ("\nmodule ", " = struct")
            (Identifiers.Ocaml.module_name n))

let timing t (spec : Spec.t) =
  kind "timing"
    (derived (Timing.Table.derive spec.tables.client_timing))
    ~item:(fun (e : Timing.Table.entry) -> e.name)
    ~declared:(fun sdk (e : Timing.Table.entry) ->
      match sdk with
      | Go ->
          declares
            (block ~opening:"type Timing struct {" ~closing:"\n}"
               (t.generated "go/timing_gen.go"))
            ("\n\t", " ") (Timing.Go.field e)
      | Typescript ->
          any
            (t.generated "typescript/core/src/client-timing.ts")
            [ ("export const ", " ="); ("export const ", ":") ]
            (Timing.Typescript.name e)
      | Python ->
          declares
            (t.generated "python/sdk/src/xynolog/timing.py")
            ("\n", ": Final") (Timing.Python.name e)
      | Rust ->
          declares
            (t.generated "rust/sdk/src/generated/timing.rs")
            ("pub const ", ":") (Timing.Rust.name e)
      | Swift ->
          any
            (block ~opening:"public enum Timings {" ~closing:"\n}"
               (t.generated swift_models))
            [ ("public static let ", ":"); ("public static let ", " =") ]
            e.name
      | Kotlin ->
          declares
            (t.generated (kotlin_generated ^ "Timings.kt"))
            ("val ", ":")
            (Kotlin_sdk.Names.camel_constant e.name)
      | Csharp ->
          any
            (t.generated (csharp_generated ^ "Timings.g.cs"))
            [ (" ", " ="); (" ", " { get; }") ]
            (Csharp_sdk.timing_name e)
      | Haskell ->
          declares
            (t.generated "haskell/sdk/src/Xynolog/Timing.hs")
            ("\n", " ::") e.name
      | Ocaml ->
          declares
            (t.generated "ocaml/sdk/lib/client_timing.ml")
            ("\nlet ", " =") (Timing.Ocaml.name e))

(* The fixed keys a registry and its sessions keep what they keep under
   (session/stored.json): each SDK's, as the stored group writes it. OCaml's
   are the facts it keeps of the registry (Ocaml_sdk.Facts). *)
let stored_keys t (spec : Spec.t) =
  kind "stored keys" (derived (Stored.of_spec spec)).keys
    ~item:(fun (k : Stored.key) -> k.row.member)
    ~declared:(fun sdk (k : Stored.key) ->
      match sdk with
      | Go ->
          declares
            (t.generated "go/registry/stored_gen.go"
            ^ t.generated "go/stored_gen.go")
            ("const ", " =") (Stored.go_name k)
      | Typescript ->
          declares
            (t.generated "typescript/core/src/stored.ts")
            ("export const ", " =") (Stored.typescript_name k)
      | Python ->
          declares
            (t.generated "python/sdk/src/xynolog/stored.py")
            ("\n", ": Final") (Stored.python_name k)
      | Rust ->
          declares
            (t.generated "rust/sdk/src/generated/stored.rs"
            ^ t.generated "rust/http-transport/src/generated/stored.rs")
            ("pub const ", ":") (Stored.rust_name k)
      | Swift ->
          declares
            (t.generated "swift/sdk/Sources/Xynolog/Generated/StoredKeys.swift")
            ("public let ", " =") (Stored.swift_name k)
      | Kotlin ->
          declares
            (t.generated (kotlin_generated ^ "registry/StoredKeys.kt"))
            ("public const val ", ":") (Stored.kotlin_name k)
      | Csharp ->
          declares
            (t.generated (csharp_generated ^ "StoredKeys.g.cs")
            ^ t.generated (csharp_generated ^ "RedirectSignInKeys.g.cs"))
            ("public const string ", " =")
            (Stored.csharp_name k)
      | Haskell ->
          declares
            (t.generated (haskell_generated ^ "Stored.hs"))
            ("\n", " ::") (Stored.haskell_name k)
      | Ocaml ->
          declares
            (t.generated "ocaml/sdk/lib/registry_facts.ml")
            ("\nlet ", " =") (Text.snake k.row.member))

let environment t (spec : Spec.t) =
  let module E = Service_environment in
  kind "service environment variables"
    (List.map
       (fun (v : Tables.Service_environment_variables.variables_item) -> v.name)
       spec.tables.service_environment_variables.variables)
    ~item:Fun.id
    ~declared:(fun sdk n ->
      match sdk with
      | Go ->
          declares
            (t.generated "go/serviceenvironment_gen.go")
            ("\n\t", " ")
            (Go_types.Environment.constant n)
      | Typescript ->
          declares
            (block
               ~opening:("export const " ^ E.group ^ " = {")
               ~closing:"\n}"
               (t.generated "typescript/core/src/service-environment.ts"))
            ("\n  ", ":") n
      | Python ->
          declares
            (t.generated "python/sdk/src/xynolog/service_environment.py")
            ("\n", ": Final") n
      | Rust ->
          declares
            (t.generated "rust/sdk/src/generated/service_environment.rs")
            ("pub const ", ":") n
      | Swift ->
          declares
            (t.generated
               ("swift/sdk/Sources/Xynolog/Generated/" ^ E.group ^ ".swift"))
            ("public static let ", " =")
            (E.camel n)
      | Kotlin ->
          declares
            (t.generated
               (kotlin_generated ^ "services/"
              ^ Kotlin_sdk.Service_environment.name ^ ".kt"))
            ("const val ", ":") n
      | Csharp ->
          declares
            (t.generated (csharp_generated ^ E.group ^ ".g.cs"))
            ("const string ", " =") (E.pascal n)
      | Haskell ->
          declares
            (t.generated "haskell/sdk/src/Xynolog/ServiceEnvironment.hs")
            ("\n", " ::") (E.camel n)
      | Ocaml ->
          declares
            (t.generated "ocaml/sdk/lib/service_environment.ml")
            ("\nlet ", " =") (E.snake n))

(* The spans or the metrics, by the names each writer gives them. *)
let telemetry what ~rows ~go ~swift ~csharp ~constant ~haskell t (spec : Spec.t)
    =
  kind what
    (rows (derived (Telemetry.derive spec.tables.sdk_telemetry_telemetry)))
    ~item:(fun (r : Telemetry.row) -> r.name)
    ~declared:(fun sdk (r : Telemetry.row) ->
      match sdk with
      | Go ->
          declares
            (t.generated "go/telemetry_gen.go")
            ("\nvar ", " =")
            (Telemetry.go_identifier go r.name)
      | Python ->
          declares
            (t.generated "python/sdk/src/xynolog/telemetry_table.py")
            ("\n", ": Final")
            (Telemetry.python_constant r.name)
      | Ocaml ->
          declares
            (t.generated "ocaml/sdk/lib/telemetry_facts.ml")
            ("\nlet ", " =")
            (Telemetry.ocaml_name r.name)
      | Kotlin ->
          declares
            (t.generated (kotlin_generated ^ "telemetry/TelemetryTable.kt"))
            ("val ", ":")
            (Telemetry.Kotlin.constant r.name)
      | Swift ->
          declares
            (block
               ~opening:("public enum " ^ swift ^ ":")
               ~closing:"\n}" (t.generated swift_models))
            ("case ", " = ")
            (Swift_sdk.Models.enum_case r.name)
      | Typescript ->
          declares
            (t.generated "typescript/observability/src/telemetry-names.ts")
            ("export const ", " =") (constant r)
      | Csharp ->
          declares
            (block
               ~opening:("class " ^ csharp ^ "\n")
               ~closing:"\n}"
               (t.generated (csharp_generated ^ "TelemetryNames.g.cs")))
            ("const string ", " =") (Telemetry.row_pascal r)
      | Haskell ->
          declares
            (t.generated (haskell_generated ^ "TelemetryNames.hs"))
            ("\n", " ::") (haskell r)
      | Rust ->
          declares
            (t.generated "rust/telemetry/src/generated/table.rs")
            ("pub const ", ":") (constant r))

let spans =
  telemetry "telemetry spans"
    ~rows:(fun (t : Telemetry.t) -> t.spans)
    ~go:"span" ~swift:"TransportSpan" ~csharp:"TelemetrySpans"
    ~constant:Telemetry.span_constant ~haskell:Telemetry.haskell_span

let metrics =
  telemetry "telemetry metrics"
    ~rows:(fun (t : Telemetry.t) -> t.metrics)
    ~go:"metric" ~swift:"TransportMetric" ~csharp:"TelemetryMetrics"
    ~constant:Telemetry.metric_constant ~haskell:Telemetry.haskell_metric

let refresh t (spec : Spec.t) =
  let table =
    derived
      (Result.bind (Cache_refresh.context spec) (fun context ->
           Cache_refresh.Table.derive context spec.tables.client_refresh))
  in
  kind "refresh queries" table.queries
    ~item:(fun (q : Cache_refresh.Table.query) -> q.name)
    ~declared:(fun sdk (q : Cache_refresh.Table.query) ->
      let n = q.name in
      match sdk with
      | Go ->
          declares
            (t.generated "go/refresh_gen.go")
            ("\n\t", " ")
            (Cache_refresh.Go.query_const n)
      | Typescript ->
          declares
            (block ~opening:"export const CACHE_QUERIES = [" ~closing:"\n]"
               (t.generated "typescript/core/src/cache-refresh.ts"))
            ("\n  '", "',") n
      | Python ->
          declares
            (block ~opening:"\ntype CacheQuery = Literal[" ~closing:"\n]"
               (t.generated "python/sdk/src/xynolog/refresh.py"))
            ("\n    \"", "\",") n
      | Rust ->
          declares
            (block ~opening:"pub enum CacheQuery {" ~closing:"\n}"
               (t.generated "rust/sdk/src/generated/cache_refresh.rs"))
            ("\n    ", ",")
            (Cache_refresh.Rust.variant n)
      | Swift ->
          declares
            (block ~opening:"internal enum CacheQuery:" ~closing:"\n}"
               (t.generated swift_models))
            ("case ", " = ")
            (Swift_sdk.Models.enum_case n)
      | Kotlin ->
          declares
            (block ~opening:"enum class CacheQuery(" ~closing:"\n}"
               (t.generated (kotlin_generated ^ "cache/CacheRefresh.kt")))
            ("\n    ", "(")
            (Kotlin_sdk.Names.variant_of n)
      | Csharp ->
          declares
            (t.generated Cache_refresh.Csharp.path)
            ("const string ", " =")
            (Cache_refresh.Csharp.constant q)
      | Haskell ->
          any
            (block ~opening:"\ndata Query =" ~closing:"deriving"
               (t.generated (haskell_generated ^ "CacheRefresh.hs")))
            constructors
            (Cache_refresh.Haskell.identifier n)
      | Ocaml ->
          declares
            (block ~opening:"module Query = struct" ~closing:"\nend"
               (t.generated "ocaml/sdk/lib/live_facts.ml"))
            ("\n  let ", " =")
            (Cache_refresh.Ocaml.query_name n))

let discovery_absent t (spec : Spec.t) =
  kind "discovery-absent reasons"
    (List.map
       (fun (r : Tables.Client_discovery_absent.reasons_item) -> r.reason)
       spec.tables.client_discovery_absent.reasons)
    ~item:Fun.id
    ~declared:(fun sdk n ->
      match sdk with
      | Go ->
          declares
            (t.generated Go_types.path)
            ("\n\t", " ")
            (Go_types.discovery_absent_constant n)
      | Typescript ->
          declares
            (block ~opening:"\n  DiscoveryAbsentReason:" ~closing:"';"
               (t.generated "typescript/core/src/types.ts"))
            ("| '", "'") n
      | Python ->
          declares
            (block ~opening:"\ntype DiscoveryAbsentReason = Literal["
               ~closing:"]"
               (t.generated "python/sdk/src/xynolog/types.py"))
            ("\"", "\"") n
      | Rust ->
          declares
            (block ~opening:"pub enum DiscoveryAbsentReason {" ~closing:"\n}"
               (t.generated "rust/sdk/src/generated/discovery_absent.rs"))
            ("\n    ", ",") (Naming.variant n)
      | Swift ->
          declares
            (block ~opening:"public enum DiscoveryAbsentReason:" ~closing:"\n}"
               (t.generated swift_models))
            ("case ", " = ")
            (Swift_sdk.Models.enum_case n)
      | Kotlin ->
          declares
            (t.generated (kotlin_generated ^ "types/DiscoveryAbsentReason.kt"))
            ("\n    ", "(")
            (Kotlin_sdk.Names.variant_of n)
      | Csharp ->
          declares
            (t.generated
               (csharp_generated ^ "Types/DiscoveryAbsentReason.g.cs"))
            ("] ", ",")
            (Csharp_sdk.Models.enum_constant n)
      | Haskell ->
          let member = Haskell_sdk.discovery_absent_member in
          any
            (block
               ~opening:("\ndata " ^ Error_codes.Haskell.type_of member ^ " =")
               ~closing:"deriving"
               (t.generated "haskell/sdk/src/Xynolog/Discovery/Reasons.hs"))
            constructors
            (Error_codes.Haskell.code_constructor member n)
      | Ocaml ->
          any
            (block
               ~opening:
                 ("module "
                 ^ Ocaml_sdk.Enums.module_name "DiscoveryAbsentReason"
                 ^ " = struct")
               ~closing:"\n\n"
               (t.generated "ocaml/sdk/lib/enums.ml"))
            constructors
            (Ocaml_sdk.Enums.constructor n))

let testing (spec : Spec.t) =
  derived (Testing.Table.derive spec.tables.client_testing)

let kit = "swift/sdk/Sources/XynologTesting/Generated/Kit.swift"

let fault_actions t (spec : Spec.t) =
  let module T = Tables.Client_testing in
  kind "testing fault actions" (testing spec).fault_actions
    ~item:(fun (f : T.fault_actions_item) -> f.name)
    ~declared:(fun sdk (f : T.fault_actions_item) ->
      let n = f.name in
      match sdk with
      | Go ->
          declares (t.generated "go/xynologtest/kit_gen.go") ("\ntype ", "") n
      | Typescript ->
          declares
            (block ~opening:"export type FaultAction =" ~closing:"};"
               (t.generated "typescript/core/src/testing-kit.ts"))
            ("{ kind: '", "'") f.kind
      | Python ->
          declares
            (t.generated "python/sdk/src/xynolog/testing/_kit.py")
            ("\nclass ", ":") n
      | Rust ->
          declares
            (block ~opening:"pub enum FaultAction {" ~closing:"\n}"
               (t.generated "rust/sdk/src/generated/testing.rs"))
            ("\n    ", "") n
      | Swift ->
          declares (t.generated kit) ("\n  case ", "")
            (Testing.Swift.fault_case f)
      | Kotlin ->
          any
            (t.generated (kotlin_generated ^ "testing/Kit.kt"))
            [ ("public data object ", " :"); ("public data class ", "(") ]
            n
      | Csharp ->
          declares
            (t.generated (csharp_generated ^ "TestingKit.g.cs"))
            ("sealed record ", "") n
      | Haskell ->
          any
            (block ~opening:"\ndata FaultAction =" ~closing:"deriving"
               (t.generated (haskell_generated ^ "Testing.hs")))
            constructors n
      | Ocaml ->
          declares
            (block ~opening:"type fault_action =" ~closing:"\n\n"
               (t.generated "ocaml/sdk/lib/testing_facts.ml"))
            ("\n  | ", "")
            (Testing.Ocaml.fault_constructor f))

let testing_records t (spec : Spec.t) =
  let module T = Tables.Client_testing in
  kind "testing records" (testing spec).records
    ~item:(fun (r : T.records_item) -> r.name)
    ~declared:(fun sdk (r : T.records_item) ->
      let n = r.name in
      match sdk with
      | Go ->
          declares
            (t.generated "go/xynologtest/kit_gen.go")
            ("\ntype ", " struct") n
      | Typescript ->
          declares
            (t.generated "typescript/core/src/testing-kit.ts")
            ("export interface ", "") n
      | Python ->
          List.exists
            (fun path ->
              any (t.generated path) [ ("\nclass ", ":"); ("\nclass ", "(") ] n)
            [
              "python/sdk/src/xynolog/testing/_kit.py";
              "python/sdk/src/xynolog/testing/_liveness_kit.py";
            ]
      | Rust ->
          declares
            (t.generated "rust/sdk/src/generated/testing.rs")
            ("pub struct ", "") n
      | Swift -> declares (t.generated kit) ("public struct ", "") n
      | Kotlin ->
          declares
            (t.generated (kotlin_generated ^ "testing/Kit.kt"))
            ("class ", "") n
      | Csharp ->
          declares
            (t.generated (csharp_generated ^ "TestingKit.g.cs"))
            ("record ", "") n
      | Haskell ->
          declares
            (t.generated (haskell_generated ^ "Testing.hs"))
            ("\ndata ", "") n
      | Ocaml ->
          declares
            (t.checkout "ocaml/sdk/lib/testing.mli")
            ("\ntype ", " =") (Text.snake n))

let gateway_operations t (spec : Spec.t) =
  let module M = Gateway_http.Model in
  kind "gateway operations" (derived (M.derive spec)).routes
    ~item:(fun (r : M.route) -> r.operation_id)
    ~declared:(fun sdk (r : M.route) ->
      let id = r.operation_id in
      match sdk with
      | Go ->
          declares
            (t.generated "go/gatewayhttp_gen.go")
            ("\nvar ", " =")
            (Gateway_http.Go.route_name r)
      | Typescript ->
          declares
            (block ~opening:"export const gatewayRoutes = {" ~closing:"\n}"
               (t.generated "typescript/core/src/gateway-http.ts"))
            ("\n  ", ":") id
      | Python ->
          declares
            (t.generated "python/sdk/src/xynolog/http/gateway_http.py")
            ("\n", ": Final")
            (Gateway_http.Python.route_name r)
      | Rust ->
          declares
            (t.generated "rust/sdk/src/generated/gateway_http.rs")
            ("pub const ", ":")
            (Gateway_http.Rust.route_name id)
      | Swift ->
          declares
            (block ~opening:"public struct GatewayRoute: Sendable {"
               ~closing:"\n}"
               (t.generated
                  "swift/sdk/Sources/Xynolog/Generated/GatewayHTTP.swift"))
            ("public static let ", " =")
            (Gateway_http.Swift.route_name r)
      | Kotlin ->
          declares
            (t.generated (kotlin_generated ^ "http/GatewayHttp.kt"))
            ("internal val ", " =")
            (Gateway_http.Kotlin.route_name r)
      | Csharp ->
          declares
            (block ~opening:"record GatewayRoute(" ~closing:"\n}"
               (t.generated (csharp_generated ^ "GatewayHttp.g.cs")))
            ("GatewayRoute ", " =")
            (Gateway_http.Csharp.route_name r)
      | Haskell ->
          declares
            (t.generated "haskell/sdk/src/Xynolog/Http/Routes.hs")
            ("\n  ", " ::")
            (Haskell_sdk.Http.constructor
               ~prefix:Haskell_sdk.Http.gateway_prefix id)
      | Ocaml ->
          declares
            (t.generated "ocaml/sdk/lib/gateway_http.ml")
            ("\nlet ", " =")
            (Gateway_http.Ocaml.route_name r))

(* The archivist's operations, each in the archivist's own file or type,
   since the gateway's operations hold some of the same ids. *)
let archivist_operations t (spec : Spec.t) =
  kind "archivist operations"
    (List.map
       (fun (id, _, _) -> id)
       (Gateway_http.Model.archivist_operations spec))
    ~item:Fun.id
    ~declared:(fun sdk id ->
      match sdk with
      | Go ->
          declares
            (t.generated "go/archivisthttp_gen.go")
            ("\n\t", " =")
            (Go_types.Archivist_http.route_name id)
      | Typescript ->
          declares
            (block ~opening:"export const archivistRoutes = {" ~closing:"\n}"
               (t.generated "typescript/core/src/archivist-http.ts"))
            ("\n  ", ":") id
      | Python ->
          declares
            (t.generated Python_types.archivist_path)
            ("\n", ": Final")
            (Python_types.archivist_route_name id)
      | Rust ->
          declares
            (t.generated "rust/sdk/src/generated/archivist_http.rs")
            ("pub const ", ":")
            (Gateway_http.Rust.route_name id)
      | Swift ->
          declares
            (block ~opening:"public struct ArchivistRoute: Sendable {"
               ~closing:"\n}"
               (t.generated
                  "swift/sdk/Sources/Xynolog/Generated/GatewayHTTP.swift"))
            ("public static let ", " =")
            (Gateway_http.Swift.operation_name id)
      | Kotlin ->
          declares
            (block ~opening:"enum class ArchivistRoute(" ~closing:"\n}"
               (t.generated (kotlin_generated ^ "services/ArchivistRoute.kt")))
            ("\n    ", "(")
            (Kotlin_sdk.Names.variant_of id)
      | Csharp ->
          declares
            (block ~opening:"class ArchivistRoutes\n" ~closing:"\n}"
               (t.generated (csharp_generated ^ "ServiceTables.g.cs")))
            ("ServiceRoute ", " {")
            (Csharp_sdk.Services.route_name id)
      | Haskell ->
          declares
            (t.generated "haskell/sdk/src/Xynolog/Archivist/Routes.hs")
            ("\n  ", " ::")
            (Haskell_sdk.Http.constructor
               ~prefix:Haskell_sdk.Http.archivist_prefix id)
      | Ocaml ->
          declares
            (t.generated "ocaml/sdk/lib/archivist_http.ml")
            ("\nlet ", " =")
            (Gateway_http.Ocaml.operation_name id))

(* ---- The surface, which each SDK writes by hand ---- *)

let pascal = String.capitalize_ascii

(* The text of those of [paths] the checkout has: an SDK that splits some
   namespaces between modules, a public and an internal one, does not split
   every namespace. *)
let present t paths =
  String.concat ""
    (List.map
       (fun path -> "\n" ^ t.checkout path)
       (List.filter (fun p -> Sys.file_exists (Filename.concat t.root p)) paths))

(* The identifier a member line declares: the last one before the first of
   [stops], on a line that opens with [keyword] once its indent is gone. A
   call or a local on a line of its own is no member, and a call later on a
   member's line is past its first [stops]. *)
let member_declared ~keyword ~stops line =
  let line = String.trim line in
  if not (String.starts_with ~prefix:keyword line) then None
  else
    let stop =
      String.fold_left
        (fun (i, found) c ->
          ( i + 1,
            match found with None when List.mem c stops -> Some i | f -> f ))
        (0, None) line
      |> snd
      |> Option.value ~default:(String.length line)
    in
    let head = String.trim (String.sub line 0 stop) in
    let rec start i =
      if i > 0 && identifier_character head.[i - 1] then start (i - 1) else i
    in
    let from = start (String.length head) in
    Some (String.sub head from (String.length head - from))

let members ~keyword ~stops text names =
  List.exists
    (fun line ->
      match member_declared ~keyword ~stops line with
      | Some declared -> List.mem declared names
      | None -> false)
    (String.split_on_char '\n' text)

let rust_module name =
  let snake = Text.snake name in
  if List.mem snake Rust_syntax.keywords then snake ^ "_" else snake

(* A namespace's methods, as public members of the files of the SDK that hold
   them, by the name its language gives each. *)
let surface_method t sdk namespace method_ =
  match sdk with
  | Sdk.Go ->
      declares
        (t.checkout ("go/" ^ namespace ^ ".go"))
        ("Namespace) ", "(") (pascal method_)
  | Typescript ->
      any
        (block
           ~opening:("export interface " ^ pascal namespace ^ "Namespace")
           ~closing:"\n}"
           (t.checkout "typescript/sdk/src/namespaces/types.ts"))
        [
          ("\n  ", "(");
          ("\n  ", "<");
          ("get ", "$()");
          ("\n  readonly ", ":");
          ("\n  readonly ", "$:");
        ]
        method_
  | Python ->
      any
        (t.checkout
           ("python/sdk/src/xynolog/namespaces/"
           ^ Surface.Python.python namespace
           ^ ".py"))
        [ ("\n    def ", "("); ("\n    async def ", "(") ]
        (Surface.Python.python method_)
  | Rust ->
      members ~keyword:"pub " ~stops:[ '('; '<' ]
        (t.checkout
           ("rust/sdk/src/namespaces/" ^ rust_module namespace ^ ".rs"))
        [ Text.snake method_ ]
  | Swift ->
      members ~keyword:"public " ~stops:[ '('; '<'; ':'; '=' ]
        (t.checkout
           ("swift/sdk/Sources/Xynolog/Namespaces/" ^ pascal namespace
          ^ "Namespace.swift"))
        [ method_ ]
  | Kotlin ->
      members ~keyword:"public " ~stops:[ '('; '<'; ':'; '=' ]
        (t.checkout
           ("kotlin/sdk/src/main/kotlin/xynolog/namespaces/" ^ pascal namespace
          ^ "Namespace.kt"))
        [ method_ ]
  | Csharp ->
      members ~keyword:"public " ~stops:[ '('; '{'; '=' ]
        (t.checkout
           ("csharp/sdk/src/Xynolog/Namespaces/" ^ pascal namespace
          ^ "Namespace.cs"))
        [ pascal method_; pascal method_ ^ "Async" ]
  | Haskell ->
      declares
        (t.checkout ("haskell/sdk/src/Xynolog/" ^ pascal namespace ^ ".hs")
        ^ present t
            [
              "haskell/sdk/internal/Xynolog/Internal/" ^ pascal namespace
              ^ ".hs";
            ])
        ("\n", " ::") method_
  | Ocaml ->
      (* A module with an interface exports what its .mli states; one
         without, every top-level value. *)
      let base = "ocaml/sdk/lib/" ^ Text.snake namespace in
      let interface = base ^ ".mli" in
      let hand =
        if Sys.file_exists (Filename.concat t.root interface) then
          ([ ("\nval ", " :") ], present t [ interface ])
        else
          ([ ("\nlet ", " "); ("\nlet rec ", " ") ], present t [ base ^ ".ml" ])
      in
      let forms, text = hand in
      any text forms (Text.snake method_)
      || declares
           (block
              ~opening:("module " ^ pascal namespace ^ " = struct")
              ~closing:"\nend"
              (t.generated "ocaml/sdk/lib/namespace_methods.ml"))
           ("\n  let ", " ") (Text.snake method_)

let surface_methods t (spec : Spec.t) =
  let module S = Tables.Client_surface in
  kind "surface methods"
    (List.concat_map
       (fun (n : S.namespaces_item) ->
         List.map
           (fun (m : S.methods_item) -> (n.namespace, m.method_))
           n.methods)
       spec.tables.client_surface.namespaces)
    ~item:(fun (n, m) -> n ^ "." ^ m)
    ~declared:(fun sdk (n, m) -> surface_method t sdk n m)

(* Where each SDK keeps its state units, and what declares one: a unit is
   the type Protocol names for it in that SDK ([made]). *)
let state_unit_files = function
  | Sdk.Go ->
      List.map
        (fun f -> "go/state/" ^ f ^ ".go")
        [ "beckon"; "gather"; "hover"; "mark"; "match"; "search"; "yield" ]
      @ [ "go/cache.go"; "go/session.go"; "go/session_signals.go" ]
  | Typescript ->
      List.map
        (fun f -> "typescript/sdk/src/state/flows/" ^ f ^ "-state-unit.ts")
        [ "beckon"; "gather"; "mark"; "match"; "yield" ]
      @ [
          "typescript/sdk/src/state/lib/search-pipeline.ts";
          "typescript/sdk/src/session/session-signals.ts";
          "typescript/sdk/src/session/xynolog-session.ts";
          "typescript/sdk/src/cache.ts";
        ]
  | Python ->
      List.map
        (fun f -> "python/sdk/src/xynolog/state/" ^ f ^ ".py")
        [ "beckon"; "gather"; "hover"; "mark"; "match"; "search"; "yield_" ]
      @ List.map
          (fun f -> "python/sdk/src/xynolog/" ^ f ^ ".py")
          [ "cache"; "session"; "session_signals" ]
  | Rust ->
      List.map
        (fun f -> "rust/sdk/src/state/" ^ f ^ ".rs")
        [ "beckon"; "gather"; "hover"; "mark"; "match_"; "search"; "yield_" ]
      @ [
          "rust/sdk/src/cache.rs";
          "rust/sdk/src/session/signals.rs";
          "rust/sdk/src/session/xynolog_session.rs";
        ]
  | Swift ->
      List.map
        (fun f -> "swift/sdk/Sources/Xynolog/State/" ^ f ^ ".swift")
        [
          "BeckonStateUnit";
          "Cache";
          "GatherStateUnit";
          "HoverDwell";
          "MarkStateUnit";
          "MatchStateUnit";
          "SearchPipeline";
          "SessionSignals";
          "YieldStateUnit";
        ]
      @ [ "swift/sdk/Sources/Xynolog/Session/XynologSession.swift" ]
  | Kotlin ->
      List.map
        (fun f -> "kotlin/sdk/src/main/kotlin/xynolog/" ^ f ^ ".kt")
        [
          "state/BeckonStateUnit";
          "state/GatherStateUnit";
          "state/HoverDwell";
          "state/MarkStateUnit";
          "state/MatchStateUnit";
          "state/SearchPipeline";
          "state/YieldStateUnit";
          "cache/Cache";
          "session/Session";
          "session/SessionSignals";
        ]
  | Csharp ->
      List.map
        (fun f -> "csharp/sdk/src/Xynolog/" ^ f ^ ".cs")
        [
          "State/Attention";
          "State/GatherStateUnit";
          "State/MarkStateUnit";
          "State/MatchStateUnit";
          "State/SearchPipeline";
          "State/SessionSignals";
          "State/YieldStateUnit";
          "Cache";
          "Session/XynologSession";
        ]
  | Haskell ->
      List.map
        (fun f -> "haskell/sdk/src/Xynolog/State/" ^ f ^ ".hs")
        [
          "Beckon";
          "Gather";
          "HoverDwell";
          "Mark";
          "Match";
          "Search";
          "SessionSignals";
          "Yield";
        ]
      @ [
          "haskell/sdk/src/Xynolog/Session.hs";
          "haskell/sdk/internal/Xynolog/Internal/Cache.hs";
        ]
  | Ocaml -> [ "ocaml/sdk/lib/state_units.mli" ]

let state_unit_forms = function
  | Sdk.Go -> plain [ "\ntype " ]
  | Typescript -> plain [ "export interface "; "export class " ]
  | Python -> plain [ "\nclass " ]
  | Rust -> plain [ "pub struct " ]
  | Swift -> plain [ "public final class "; "public actor " ]
  | Kotlin -> plain [ "public class " ]
  | Csharp -> plain [ "public sealed class " ]
  | Haskell -> plain [ "\ndata "; "\nnewtype " ]
  | Ocaml -> [ ("\nmodule ", " =") ]

let state_units t (spec : Spec.t) =
  let module S = Tables.Client_surface in
  kind "state units" spec.tables.client_surface.state_units
    ~item:(fun (u : S.state_units_item) -> u.unit)
    ~declared:(fun sdk (u : S.state_units_item) ->
      match List.assoc_opt (Sdk.name sdk) u.made with
      | None -> false
      | Some made ->
          List.exists
            (fun path ->
              any ("\n" ^ t.checkout path) (state_unit_forms sdk) made)
            (state_unit_files sdk))

(* ---- The census ---- *)

let kinds ~written t spec =
  [
    schemas ~written t "schemas" (List.map fst (Roots.all spec));
    schemas ~written t "client registry types"
      (titles spec spec.tables.client_registry.types);
    schemas ~written t "state-unit notices"
      (titles spec spec.tables.client_state_units.notices);
    channels t spec;
    control_methods t spec;
    control_notifications t spec;
    error_codes t spec;
    identifier_kinds t spec;
    timing t spec;
    stored_keys t spec;
    environment t spec;
    spans t spec;
    metrics t spec;
    refresh t spec;
    discovery_absent t spec;
    fault_actions t spec;
    testing_records t spec;
    gateway_operations t spec;
    archivist_operations t spec;
    surface_methods t spec;
    state_units t spec;
  ]

(* A kind's count, and each SDK's items it does not declare. *)
type counted = { name : string; count : int; absent : (Sdk.t * string) list }

let count (k : kind) =
  {
    name = k.kind;
    count = List.length k.rows;
    absent =
      List.concat_map
        (fun sdk ->
          List.filter_map
            (fun r -> if r.declared sdk then None else Some (sdk, r.item))
            k.rows)
        Sdk.all;
  }

(* Every kind, counted in what [writers] write for [spec] and in the
   checkout at [root]. *)
let census ~root writers (spec : Spec.t) =
  let results = List.map (fun files -> files ~root spec) writers in
  match List.concat_map (function Ok _ -> [] | Error e -> e) results with
  | _ :: _ as errors -> Error errors
  | [] ->
      let files =
        List.concat_map (function Ok f -> f | Error _ -> []) results
      in
      let written sdk =
        List.filter_map
          (fun (f : Output.file) ->
            if String.starts_with ~prefix:(directory sdk) f.path then
              Some f.text
            else None)
          files
      in
      Ok (List.map count (kinds ~written (texts ~root files) spec))

let absences counted =
  List.concat_map
    (fun c ->
      List.map
        (fun (sdk, item) ->
          Printf.sprintf "%s declares no %s: %s" (Sdk.label sdk) c.name item)
        c.absent)
    counted

let path = "CONTRACTS.md"

let table counted =
  let row cells = "| " ^ String.concat " | " cells ^ " |" in
  let declared c sdk =
    string_of_int
      (c.count - List.length (List.filter (fun (s, _) -> s = sdk) c.absent))
  in
  String.concat "\n"
    ([
       "<!-- Generated from protocol/specs/src; do not edit. Regenerate: make \
        generate (" ^ Banner.writer __FILE__ ^ ") -->";
       "";
       "# Contracts";
       "";
       "Each kind of contract the pinned Protocol states, how many items it \
        has, and how many of them each SDK declares. `make test-codegen` fails \
        while an SDK declares fewer than all of a kind's items.";
       "";
       row ("Contract" :: "Items" :: List.map Sdk.label Sdk.all);
       row (":---" :: List.init (1 + List.length Sdk.all) (fun _ -> "---:"));
     ]
    @ List.map
        (fun c ->
          row (c.name :: string_of_int c.count :: List.map (declared c) Sdk.all))
        counted)
  ^ "\n"

(* The contracts group: CONTRACTS.md, the census of what [writers] write. *)
let files writers ~root spec =
  Result.map
    (fun counted -> [ { Output.path; text = table counted } ])
    (census ~root writers spec)
