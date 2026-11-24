// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** service-telemetry/telemetry.json: the telemetry each Xynolog service exports over OTLP: its spans and metrics, the services that export each, and the attributes each carries. */
@Serializable
public data class ServiceTelemetryTelemetry(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** The services that reach the bus through an SDK, and for each the SDK transports it uses, or of a transport it uses part of, the rows it exports. */
    public val sdk: kotlin.collections.Map<String, kotlin.collections.List<String>>,
    public val resource: kotlin.collections.List<ServiceTelemetryTelemetryResourceItem>,
    public val spans: kotlin.collections.List<ServiceTelemetryTelemetrySpansItem>,
    public val metrics: kotlin.collections.List<ServiceTelemetryTelemetryMetricsItem>,
) {
    /** How Java makes a `ServiceTelemetryTelemetry`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val sdk: kotlin.collections.Map<String, kotlin.collections.List<String>>,
        private val resource: kotlin.collections.List<ServiceTelemetryTelemetryResourceItem>,
        private val spans: kotlin.collections.List<ServiceTelemetryTelemetrySpansItem>,
        private val metrics: kotlin.collections.List<ServiceTelemetryTelemetryMetricsItem>,
    ) {
        public fun build(): ServiceTelemetryTelemetry = ServiceTelemetryTelemetry(comment = comment, sdk = sdk, resource = resource, spans = spans, metrics = metrics)
    }

    public companion object {
        /** A builder of a `ServiceTelemetryTelemetry` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, sdk: kotlin.collections.Map<String, kotlin.collections.List<String>>, resource: kotlin.collections.List<ServiceTelemetryTelemetryResourceItem>, spans: kotlin.collections.List<ServiceTelemetryTelemetrySpansItem>, metrics: kotlin.collections.List<ServiceTelemetryTelemetryMetricsItem>): Builder = Builder(comment, sdk, resource, spans, metrics)
    }
}
