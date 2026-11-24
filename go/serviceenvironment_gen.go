// Code generated from protocol/specs/src/service-environment/variables.json — DO NOT EDIT.
//
// Regenerate: make generate (codegen/lib/go_types/environment.ml)

package xynolog

// ServiceEnvironmentVariable is an environment variable a Xynolog service
// reads, beside its configuration document.
type ServiceEnvironmentVariable string

const (
	// ServiceEnvironmentVariableJwtSecret: The gateway's signing key ring:
	// comma-separated keys of at least 32 characters, whitespace around each
	// ignored. Media tokens are signed with the first key, and a media token
	// signed with any key is accepted. Unset, or with a key shorter than 32
	// characters, the gateway refuses to start.
	ServiceEnvironmentVariableJwtSecret ServiceEnvironmentVariable = "JWT_SECRET"

	// ServiceEnvironmentVariableXynologOidcClientId: The client id of the
	// service's own account at the issuer, whose token the service signs in
	// with: the gateway's reaches the Archivist, and every other service's is
	// its bearer at the bus. Unset, the service refuses to start.
	ServiceEnvironmentVariableXynologOidcClientId ServiceEnvironmentVariable = "XYNOLOG_OIDC_CLIENT_ID"

	// ServiceEnvironmentVariableXynologOidcClientSecret: That account's secret.
	// Unset, the service refuses to start, and its output never carries the
	// value.
	ServiceEnvironmentVariableXynologOidcClientSecret ServiceEnvironmentVariable = "XYNOLOG_OIDC_CLIENT_SECRET"

	// ServiceEnvironmentVariableXynologOidcClientKey: The worker's key: an RSA
	// private key, PEM and unencrypted, whose public half each knowledge base's
	// issuer holds on the client the worker's document names there. Each sign-in
	// carries an assertion signed with it (private_key_jwt), and no secret.
	// Unset or empty, a key it cannot read, or one that is not RSA, the worker
	// refuses to start (WORKER-SERVICE.md B3).
	ServiceEnvironmentVariableXynologOidcClientKey ServiceEnvironmentVariable = "XYNOLOG_OIDC_CLIENT_KEY"

	// ServiceEnvironmentVariableOtelExporterOtlpEndpoint: The OTLP/HTTP
	// collector spans and metrics are exported to. Unset, with
	// OTEL_CONSOLE_EXPORTER not `true`, nothing is exported.
	ServiceEnvironmentVariableOtelExporterOtlpEndpoint ServiceEnvironmentVariable = "OTEL_EXPORTER_OTLP_ENDPOINT"

	// ServiceEnvironmentVariableOtelServiceName: The `service.name` exported
	// spans and metrics carry; `xynolog-` and the service's name, such as
	// `xynolog-gateway`, when unset.
	ServiceEnvironmentVariableOtelServiceName ServiceEnvironmentVariable = "OTEL_SERVICE_NAME"

	// ServiceEnvironmentVariableOtelSdkDisabled: `true` exports nothing,
	// whatever else is set.
	ServiceEnvironmentVariableOtelSdkDisabled ServiceEnvironmentVariable = "OTEL_SDK_DISABLED"

	// ServiceEnvironmentVariableOtelConsoleExporter: `true`, with no
	// OTEL_EXPORTER_OTLP_ENDPOINT, writes spans and metrics to the service's
	// output instead of exporting them.
	ServiceEnvironmentVariableOtelConsoleExporter ServiceEnvironmentVariable = "OTEL_CONSOLE_EXPORTER"

	// ServiceEnvironmentVariableOtelMetricsExporter: `console` writes metrics to
	// the service's output, while spans still go to OTEL_EXPORTER_OTLP_ENDPOINT.
	ServiceEnvironmentVariableOtelMetricsExporter ServiceEnvironmentVariable = "OTEL_METRICS_EXPORTER"

	// ServiceEnvironmentVariableOtelMetricExportInterval: Milliseconds between
	// metric exports; 30000 when unset or not a positive integer.
	ServiceEnvironmentVariableOtelMetricExportInterval ServiceEnvironmentVariable = "OTEL_METRIC_EXPORT_INTERVAL"

	// ServiceEnvironmentVariableOtelBspScheduleDelay: Milliseconds a finished
	// span waits to be exported in a batch; 5000 when unset.
	ServiceEnvironmentVariableOtelBspScheduleDelay ServiceEnvironmentVariable = "OTEL_BSP_SCHEDULE_DELAY"

	// ServiceEnvironmentVariableXynologBusLog: Any non-empty value writes one
	// `[bus <op>] <channel> …` line to the service's output for each frame it
	// sends, accepts, receives or delivers, and each content read.
	ServiceEnvironmentVariableXynologBusLog ServiceEnvironmentVariable = "XYNOLOG_BUS_LOG"

	// ServiceEnvironmentVariableSuperviseEvents: The supervisor's events log,
	// one `starting <SUPERVISE_NAME>` line per life of the process. With
	// SUPERVISE_NAME, the service reports `xynolog.process.restarts` from it:
	// its lives, less one. Without either, the metric does not exist.
	ServiceEnvironmentVariableSuperviseEvents ServiceEnvironmentVariable = "SUPERVISE_EVENTS"

	// ServiceEnvironmentVariableSuperviseName: The name the supervisor records
	// each life under, in SUPERVISE_EVENTS.
	ServiceEnvironmentVariableSuperviseName ServiceEnvironmentVariable = "SUPERVISE_NAME"
)
