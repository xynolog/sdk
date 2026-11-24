(* Every generation group, by the repository whose files it writes (its
   target) and the name that repository's make generate and make
   check-generated run it under. A group writes its files from the model,
   and refuses a spec that breaks a rule its files rely on. [root] is the
   target's checkout, whose protocol/specs/src the model reads, for a group
   that reads or holds its files to what is there. *)

type group = {
  name : string;
  files : root:string -> Spec.t -> (Output.file list, Decode.error list) result;
}

let sdk =
  [
    { name = "bus"; files = Bus.files };
    { name = "required"; files = Required.files };
    { name = "unicode-case"; files = Unicode_case.files };
    { name = "encodings"; files = Encodings.files };
    { name = "error-codes"; files = Error_codes.files };
    { name = "timing"; files = Timing.files };
    { name = "cache-refresh"; files = Cache_refresh.files };
    { name = "identifiers"; files = Identifiers.files };
    { name = "oauth-clients"; files = Oauth_clients.files };
    { name = "telemetry"; files = Telemetry.files };
    { name = "sign-in"; files = Sign_in.files };
    { name = "media-types"; files = Media_types.files };
    { name = "stored"; files = Stored.files };
    { name = "locales"; files = Locales.files };
    { name = "job-storage"; files = Job_storage.files };
    { name = "limits"; files = Limits.files };
    { name = "client-types"; files = Client_types.files };
    { name = "surface"; files = Surface.Calls.files };
    { name = "testing"; files = Testing.files };
    { name = "gateway-http"; files = Gateway_http.files };
    { name = "ocaml-sdk"; files = Ocaml_sdk.files };
    { name = "rust-types"; files = Rust_types.files };
    { name = "go-types"; files = Go_types.files };
    { name = "typescript-types"; files = Typescript_types.files };
    { name = "python-types"; files = Python_types.files };
    { name = "swift-sdk"; files = Swift_sdk.files };
    { name = "haskell-sdk"; files = Haskell_sdk.files };
    { name = "kotlin-sdk"; files = Kotlin_sdk.files };
    { name = "csharp-sdk"; files = Csharp_sdk.files };
    { name = "case-data"; files = Case_data.files };
  ]

let cli =
  [
    { name = "control"; files = Cli.Control.files };
    { name = "stack"; files = Cli.Stack.files };
    { name = "mcp-tools"; files = Cli.Mcp_tools.files };
  ]

let images =
  [
    { name = "bundles"; files = Images.Bundles.files };
    { name = "archivist-waits"; files = Images.Archivist_waits.files };
  ]

type target = Sdk | Cli | Images

let targets = [ ("sdk", Sdk); ("cli", Cli); ("images", Images) ]
let of_target = function Sdk -> sdk | Cli -> cli | Images -> images
