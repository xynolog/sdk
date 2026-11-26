// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** sdk-telemetry/telemetry.json: the telemetry a Xynolog SDK's transports export over OTLP: its spans and metrics, the transport each comes from, and the attributes each carries. */
@Serializable
public data class SdkTelemetryTelemetry(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    public val spans: kotlin.collections.List<SdkTelemetryTelemetrySpansItem>,
    public val metrics: kotlin.collections.List<SdkTelemetryTelemetryMetricsItem>,
) {
    /** How Java makes a `SdkTelemetryTelemetry`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val spans: kotlin.collections.List<SdkTelemetryTelemetrySpansItem>,
        private val metrics: kotlin.collections.List<SdkTelemetryTelemetryMetricsItem>,
    ) {
        public fun build(): SdkTelemetryTelemetry = SdkTelemetryTelemetry(comment = comment, spans = spans, metrics = metrics)
    }

    public companion object {
        /** A builder of a `SdkTelemetryTelemetry` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, spans: kotlin.collections.List<SdkTelemetryTelemetrySpansItem>, metrics: kotlin.collections.List<SdkTelemetryTelemetryMetricsItem>): Builder = Builder(comment, spans, metrics)
    }
}
