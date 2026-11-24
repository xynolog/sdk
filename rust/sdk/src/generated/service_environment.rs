// Generated from protocol/specs/src/service-environment/variables.json; do not edit.
// Regenerate: make generate (codegen/lib/service_environment/service_environment.ml)
/// The gateway's signing key ring: comma-separated keys of at least 32 characters, whitespace around each ignored. Media tokens are signed with the first key, and a media token signed with any key is accepted. Unset, or with a key shorter than 32 characters, the gateway refuses to start.
pub const JWT_SECRET: &str = "JWT_SECRET";
/// The client id of the service's own account at the issuer, whose token the service signs in with: the gateway's reaches the Archivist, and every other service's is its bearer at the bus. Unset, the service refuses to start.
pub const XYNOLOG_OIDC_CLIENT_ID: &str = "XYNOLOG_OIDC_CLIENT_ID";
/// That account's secret. Unset, the service refuses to start, and its output never carries the value.
pub const XYNOLOG_OIDC_CLIENT_SECRET: &str = "XYNOLOG_OIDC_CLIENT_SECRET";
/// The worker's key: an RSA private key, PEM and unencrypted, whose public half each knowledge base's issuer holds on the client the worker's document names there. Each sign-in carries an assertion signed with it (private_key_jwt), and no secret. Unset or empty, a key it cannot read, or one that is not RSA, the worker refuses to start (WORKER-SERVICE.md B3).
pub const XYNOLOG_OIDC_CLIENT_KEY: &str = "XYNOLOG_OIDC_CLIENT_KEY";
/// The OTLP/HTTP collector spans and metrics are exported to. Unset, with OTEL_CONSOLE_EXPORTER not `true`, nothing is exported.
pub const OTEL_EXPORTER_OTLP_ENDPOINT: &str = "OTEL_EXPORTER_OTLP_ENDPOINT";
/// The `service.name` exported spans and metrics carry; `xynolog-` and the service's name, such as `xynolog-gateway`, when unset.
pub const OTEL_SERVICE_NAME: &str = "OTEL_SERVICE_NAME";
/// `true` exports nothing, whatever else is set.
pub const OTEL_SDK_DISABLED: &str = "OTEL_SDK_DISABLED";
/// `true`, with no OTEL_EXPORTER_OTLP_ENDPOINT, writes spans and metrics to the service's output instead of exporting them.
pub const OTEL_CONSOLE_EXPORTER: &str = "OTEL_CONSOLE_EXPORTER";
/// `console` writes metrics to the service's output, while spans still go to OTEL_EXPORTER_OTLP_ENDPOINT.
pub const OTEL_METRICS_EXPORTER: &str = "OTEL_METRICS_EXPORTER";
/// Milliseconds between metric exports; 30000 when unset or not a positive integer.
pub const OTEL_METRIC_EXPORT_INTERVAL: &str = "OTEL_METRIC_EXPORT_INTERVAL";
/// Milliseconds a finished span waits to be exported in a batch; 5000 when unset.
pub const OTEL_BSP_SCHEDULE_DELAY: &str = "OTEL_BSP_SCHEDULE_DELAY";
/// Any non-empty value writes one `[bus <op>] <channel> …` line to the service's output for each frame it sends, accepts, receives or delivers, and each content read.
pub const XYNOLOG_BUS_LOG: &str = "XYNOLOG_BUS_LOG";
/// The supervisor's events log, one `starting <SUPERVISE_NAME>` line per life of the process. With SUPERVISE_NAME, the service reports `xynolog.process.restarts` from it: its lives, less one. Without either, the metric does not exist.
pub const SUPERVISE_EVENTS: &str = "SUPERVISE_EVENTS";
/// The name the supervisor records each life under, in SUPERVISE_EVENTS.
pub const SUPERVISE_NAME: &str = "SUPERVISE_NAME";
