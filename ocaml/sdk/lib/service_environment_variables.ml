(* Generated from protocol/specs/src/service-environment/variables.json. Do not edit.
   Regenerate: make generate (codegen/lib/case_data/ocaml.ml) *)

type service_telemetry_telemetry_services_item =
  | Archivist
  | Dispatcher
  | Gateway
  | Librarian
  | Smelter
  | Weaver
  | Worker

let service_telemetry_telemetry_services_item_value = function
  | (Archivist : service_telemetry_telemetry_services_item) -> "archivist"
  | (Dispatcher : service_telemetry_telemetry_services_item) -> "dispatcher"
  | (Gateway : service_telemetry_telemetry_services_item) -> "gateway"
  | (Librarian : service_telemetry_telemetry_services_item) -> "librarian"
  | (Smelter : service_telemetry_telemetry_services_item) -> "smelter"
  | (Weaver : service_telemetry_telemetry_services_item) -> "weaver"
  | (Worker : service_telemetry_telemetry_services_item) -> "worker"

let service_telemetry_telemetry_services_item_json v =
  `String (service_telemetry_telemetry_services_item_value v)

type read_by = Service | Opentelemetry

let read_by_value = function
  | (Service : read_by) -> "service"
  | (Opentelemetry : read_by) -> "opentelemetry"

let read_by_json v = `String (read_by_value v)

type provided_by = Launcher | Image | Operator

let provided_by_value = function
  | (Launcher : provided_by) -> "launcher"
  | (Image : provided_by) -> "image"
  | (Operator : provided_by) -> "operator"

let provided_by_json v = `String (provided_by_value v)

type variables_item = {
  name : string;
  services : service_telemetry_telemetry_services_item list;
  read_by : read_by;
  provided_by : provided_by;
  required : bool;
  effect_ : string;
}

let variables_item_json (r : variables_item) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("name", (fun s -> `String s) r.name);
         Option.Some
           ( "services",
             (fun l ->
               `List (List.map service_telemetry_telemetry_services_item_json l))
               r.services );
         Option.Some ("readBy", read_by_json r.read_by);
         Option.Some ("providedBy", provided_by_json r.provided_by);
         Option.Some ("required", (fun b -> `Bool b) r.required);
         Option.Some ("effect", (fun s -> `String s) r.effect_);
       ])

type t = { comment : string; variables : variables_item list }

let t_json (r : t) =
  `Assoc
    (List.filter_map Fun.id
       [
         Option.Some ("$comment", (fun s -> `String s) r.comment);
         Option.Some
           ( "variables",
             (fun l -> `List (List.map variables_item_json l)) r.variables );
       ])

let table : t =
  ({
     comment =
       "Every environment variable a Xynolog service reads, beside its \
        configuration document (GatewayConfig, DispatcherConfig, \
        ArchivistConfig, LibrarianConfig, WeaverConfig, SmelterConfig, \
        WorkerConfig) and the variables that document names (the gateway's \
        signal.userEnv and signal.passwordEnv, the dispatcher's queue.userEnv \
        and queue.passwordEnv, the Librarian's, the Weaver's and the Smelter's \
        secrets for their stores and providers, and the keys a worker's \
        engines name by apiKeyEnv). A service, in any language, reads the rows \
        that list it and no variable the table does not list for it \
        \226\128\148 beyond the standard OTEL_* variables an OpenTelemetry SDK \
        reads on its own, and the options variable of the allocator it links \
        (jemalloc's _RJEM_MALLOC_CONF, which it reads before any of its code \
        runs), which the table neither promises nor refuses. `services` names \
        the services that read each. `readBy` says what reads it: `service`, \
        the service's own code, Xynolog's SDK and libraries among it \
        \226\128\148 which, for a service written in Rust, the images \
        repository's `scripts/check-service-environment.mjs`, which its CI \
        runs, scans in both directions, over its crate and every workspace and \
        SDK crate it links: a read not listed for that service fails it, and \
        so does a row nothing in it reads; `opentelemetry`, the OpenTelemetry \
        SDK. `providedBy` says what sets each where the launcher runs the \
        service: `launcher`, `image` (the image or its supervisor sets it; \
        checked there), or `operator` (nothing sets it; an operator may). A \
        service's conformance suite sets only the rows that list it, and \
        exercises each by name; one gateway case also sets a variable a \
        runtime would read for itself (TOKIO_WORKER_THREADS), to show that it \
        changes nothing.";
     variables =
       [
         ({
            name = "JWT_SECRET";
            services = [ (Gateway : service_telemetry_telemetry_services_item) ];
            read_by = (Service : read_by);
            provided_by = (Launcher : provided_by);
            required = true;
            effect_ =
              "The gateway's signing key ring: comma-separated keys of at \
               least 32 characters, whitespace around each ignored. Media \
               tokens are signed with the first key, and a media token signed \
               with any key is accepted. Unset, or with a key shorter than 32 \
               characters, the gateway refuses to start.";
          }
           : variables_item);
         ({
            name = "XYNOLOG_OIDC_CLIENT_ID";
            services =
              [
                (Gateway : service_telemetry_telemetry_services_item);
                (Dispatcher : service_telemetry_telemetry_services_item);
                (Archivist : service_telemetry_telemetry_services_item);
                (Librarian : service_telemetry_telemetry_services_item);
                (Weaver : service_telemetry_telemetry_services_item);
                (Smelter : service_telemetry_telemetry_services_item);
              ];
            read_by = (Service : read_by);
            provided_by = (Launcher : provided_by);
            required = true;
            effect_ =
              "The client id of the service's own account at the issuer, whose \
               token the service signs in with: the gateway's reaches the \
               Archivist, and every other service's is its bearer at the bus. \
               Unset, the service refuses to start.";
          }
           : variables_item);
         ({
            name = "XYNOLOG_OIDC_CLIENT_SECRET";
            services =
              [
                (Gateway : service_telemetry_telemetry_services_item);
                (Dispatcher : service_telemetry_telemetry_services_item);
                (Archivist : service_telemetry_telemetry_services_item);
                (Librarian : service_telemetry_telemetry_services_item);
                (Weaver : service_telemetry_telemetry_services_item);
                (Smelter : service_telemetry_telemetry_services_item);
              ];
            read_by = (Service : read_by);
            provided_by = (Launcher : provided_by);
            required = true;
            effect_ =
              "That account's secret. Unset, the service refuses to start, and \
               its output never carries the value.";
          }
           : variables_item);
         ({
            name = "XYNOLOG_OIDC_CLIENT_KEY";
            services = [ (Worker : service_telemetry_telemetry_services_item) ];
            read_by = (Service : read_by);
            provided_by = (Launcher : provided_by);
            required = true;
            effect_ =
              "The worker's key: an RSA private key, PEM and unencrypted, \
               whose public half each knowledge base's issuer holds on the \
               client the worker's document names there. Each sign-in carries \
               an assertion signed with it (private_key_jwt), and no secret. \
               Unset or empty, a key it cannot read, or one that is not RSA, \
               the worker refuses to start (WORKER-SERVICE.md B3).";
          }
           : variables_item);
         ({
            name = "OTEL_EXPORTER_OTLP_ENDPOINT";
            services =
              [
                (Gateway : service_telemetry_telemetry_services_item);
                (Dispatcher : service_telemetry_telemetry_services_item);
                (Archivist : service_telemetry_telemetry_services_item);
                (Librarian : service_telemetry_telemetry_services_item);
                (Weaver : service_telemetry_telemetry_services_item);
                (Smelter : service_telemetry_telemetry_services_item);
                (Worker : service_telemetry_telemetry_services_item);
              ];
            read_by = (Service : read_by);
            provided_by = (Launcher : provided_by);
            required = false;
            effect_ =
              "The OTLP/HTTP collector spans and metrics are exported to. \
               Unset, with OTEL_CONSOLE_EXPORTER not `true`, nothing is \
               exported.";
          }
           : variables_item);
         ({
            name = "OTEL_SERVICE_NAME";
            services =
              [
                (Gateway : service_telemetry_telemetry_services_item);
                (Dispatcher : service_telemetry_telemetry_services_item);
                (Archivist : service_telemetry_telemetry_services_item);
                (Librarian : service_telemetry_telemetry_services_item);
                (Weaver : service_telemetry_telemetry_services_item);
                (Smelter : service_telemetry_telemetry_services_item);
                (Worker : service_telemetry_telemetry_services_item);
              ];
            read_by = (Service : read_by);
            provided_by = (Operator : provided_by);
            required = false;
            effect_ =
              "The `service.name` exported spans and metrics carry; `xynolog-` \
               and the service's name, such as `xynolog-gateway`, when unset.";
          }
           : variables_item);
         ({
            name = "OTEL_SDK_DISABLED";
            services =
              [
                (Gateway : service_telemetry_telemetry_services_item);
                (Dispatcher : service_telemetry_telemetry_services_item);
                (Archivist : service_telemetry_telemetry_services_item);
                (Librarian : service_telemetry_telemetry_services_item);
                (Weaver : service_telemetry_telemetry_services_item);
                (Smelter : service_telemetry_telemetry_services_item);
                (Worker : service_telemetry_telemetry_services_item);
              ];
            read_by = (Service : read_by);
            provided_by = (Operator : provided_by);
            required = false;
            effect_ = "`true` exports nothing, whatever else is set.";
          }
           : variables_item);
         ({
            name = "OTEL_CONSOLE_EXPORTER";
            services =
              [
                (Gateway : service_telemetry_telemetry_services_item);
                (Dispatcher : service_telemetry_telemetry_services_item);
                (Archivist : service_telemetry_telemetry_services_item);
                (Librarian : service_telemetry_telemetry_services_item);
                (Weaver : service_telemetry_telemetry_services_item);
                (Smelter : service_telemetry_telemetry_services_item);
                (Worker : service_telemetry_telemetry_services_item);
              ];
            read_by = (Service : read_by);
            provided_by = (Operator : provided_by);
            required = false;
            effect_ =
              "`true`, with no OTEL_EXPORTER_OTLP_ENDPOINT, writes spans and \
               metrics to the service's output instead of exporting them.";
          }
           : variables_item);
         ({
            name = "OTEL_METRICS_EXPORTER";
            services =
              [
                (Gateway : service_telemetry_telemetry_services_item);
                (Dispatcher : service_telemetry_telemetry_services_item);
                (Archivist : service_telemetry_telemetry_services_item);
                (Librarian : service_telemetry_telemetry_services_item);
                (Weaver : service_telemetry_telemetry_services_item);
                (Smelter : service_telemetry_telemetry_services_item);
                (Worker : service_telemetry_telemetry_services_item);
              ];
            read_by = (Service : read_by);
            provided_by = (Operator : provided_by);
            required = false;
            effect_ =
              "`console` writes metrics to the service's output, while spans \
               still go to OTEL_EXPORTER_OTLP_ENDPOINT.";
          }
           : variables_item);
         ({
            name = "OTEL_METRIC_EXPORT_INTERVAL";
            services =
              [
                (Gateway : service_telemetry_telemetry_services_item);
                (Dispatcher : service_telemetry_telemetry_services_item);
                (Archivist : service_telemetry_telemetry_services_item);
                (Librarian : service_telemetry_telemetry_services_item);
                (Weaver : service_telemetry_telemetry_services_item);
                (Smelter : service_telemetry_telemetry_services_item);
                (Worker : service_telemetry_telemetry_services_item);
              ];
            read_by = (Service : read_by);
            provided_by = (Operator : provided_by);
            required = false;
            effect_ =
              "Milliseconds between metric exports; 30000 when unset or not a \
               positive integer.";
          }
           : variables_item);
         ({
            name = "OTEL_BSP_SCHEDULE_DELAY";
            services =
              [
                (Gateway : service_telemetry_telemetry_services_item);
                (Dispatcher : service_telemetry_telemetry_services_item);
                (Archivist : service_telemetry_telemetry_services_item);
                (Librarian : service_telemetry_telemetry_services_item);
                (Weaver : service_telemetry_telemetry_services_item);
                (Smelter : service_telemetry_telemetry_services_item);
                (Worker : service_telemetry_telemetry_services_item);
              ];
            read_by = (Opentelemetry : read_by);
            provided_by = (Operator : provided_by);
            required = false;
            effect_ =
              "Milliseconds a finished span waits to be exported in a batch; \
               5000 when unset.";
          }
           : variables_item);
         ({
            name = "XYNOLOG_BUS_LOG";
            services =
              [
                (Gateway : service_telemetry_telemetry_services_item);
                (Dispatcher : service_telemetry_telemetry_services_item);
                (Archivist : service_telemetry_telemetry_services_item);
                (Librarian : service_telemetry_telemetry_services_item);
                (Weaver : service_telemetry_telemetry_services_item);
                (Smelter : service_telemetry_telemetry_services_item);
                (Worker : service_telemetry_telemetry_services_item);
              ];
            read_by = (Service : read_by);
            provided_by = (Operator : provided_by);
            required = false;
            effect_ =
              "Any non-empty value writes one `[bus <op>] <channel> \
               \226\128\166` line to the service's output for each frame it \
               sends, accepts, receives or delivers, and each content read.";
          }
           : variables_item);
         ({
            name = "SUPERVISE_EVENTS";
            services =
              [
                (Gateway : service_telemetry_telemetry_services_item);
                (Dispatcher : service_telemetry_telemetry_services_item);
                (Archivist : service_telemetry_telemetry_services_item);
                (Librarian : service_telemetry_telemetry_services_item);
                (Weaver : service_telemetry_telemetry_services_item);
                (Smelter : service_telemetry_telemetry_services_item);
                (Worker : service_telemetry_telemetry_services_item);
              ];
            read_by = (Service : read_by);
            provided_by = (Image : provided_by);
            required = false;
            effect_ =
              "The supervisor's events log, one `starting <SUPERVISE_NAME>` \
               line per life of the process. With SUPERVISE_NAME, the service \
               reports `xynolog.process.restarts` from it: its lives, less \
               one. Without either, the metric does not exist.";
          }
           : variables_item);
         ({
            name = "SUPERVISE_NAME";
            services =
              [
                (Gateway : service_telemetry_telemetry_services_item);
                (Dispatcher : service_telemetry_telemetry_services_item);
                (Archivist : service_telemetry_telemetry_services_item);
                (Librarian : service_telemetry_telemetry_services_item);
                (Weaver : service_telemetry_telemetry_services_item);
                (Smelter : service_telemetry_telemetry_services_item);
                (Worker : service_telemetry_telemetry_services_item);
              ];
            read_by = (Service : read_by);
            provided_by = (Image : provided_by);
            required = false;
            effect_ =
              "The name the supervisor records each life under, in \
               SUPERVISE_EVENTS.";
          }
           : variables_item);
       ];
   }
    : t)
