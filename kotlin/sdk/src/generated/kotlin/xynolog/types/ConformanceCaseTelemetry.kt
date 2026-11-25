// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonPrimitive

/** Run the client exporting to an OTLP receiver, and once it has exited hold what it exported to specs/src/sdk-telemetry/telemetry.json. A worker case also holds the worker to a trace of its own for each job it ran (conformance/worker/README.md). */
@Serializable(with = ConformanceCaseTelemetry.Serializer::class)
public data object ConformanceCaseTelemetry {
    internal object Serializer : ConstantSerializer<ConformanceCaseTelemetry>(ConformanceCaseTelemetry, JsonPrimitive(true))
}
