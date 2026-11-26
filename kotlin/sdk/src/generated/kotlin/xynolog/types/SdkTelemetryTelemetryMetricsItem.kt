// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class SdkTelemetryTelemetryMetricsItem(
    /** The row's name; `{channel}` in it is the bus channel, and `{jobType}` the job's type. */
    public val name: String,
    /** The transport the row comes from: `bus`, the stream and emits; `content`, uploads and reads. */
    public val transport: SdkTelemetryTelemetryMetricsItemTransport,
    /** The metric's instrument. */
    public val instrument: SdkTelemetryTelemetryMetricsItemInstrument,
    /** What the row says. */
    public val meaning: String,
    /** The attributes the span carries. */
    public val attributes: kotlin.collections.List<SdkTelemetryTelemetryMetricsItemAttributesItem>,
) {
    /** How Java makes a `SdkTelemetryTelemetryMetricsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val transport: SdkTelemetryTelemetryMetricsItemTransport,
        private val instrument: SdkTelemetryTelemetryMetricsItemInstrument,
        private val meaning: String,
        private val attributes: kotlin.collections.List<SdkTelemetryTelemetryMetricsItemAttributesItem>,
    ) {
        public fun build(): SdkTelemetryTelemetryMetricsItem = SdkTelemetryTelemetryMetricsItem(name = name, transport = transport, instrument = instrument, meaning = meaning, attributes = attributes)
    }

    public companion object {
        /** A builder of a `SdkTelemetryTelemetryMetricsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, transport: SdkTelemetryTelemetryMetricsItemTransport, instrument: SdkTelemetryTelemetryMetricsItemInstrument, meaning: String, attributes: kotlin.collections.List<SdkTelemetryTelemetryMetricsItemAttributesItem>): Builder = Builder(name, transport, instrument, meaning, attributes)
    }
}
