// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class SdkTelemetryTelemetrySpansItem(
    /** The row's name; `{channel}` in it is the bus channel, and `{jobType}` the job's type. */
    public val name: String,
    /** The transport the row comes from: `bus`, the stream and emits; `content`, uploads and reads. */
    public val transport: SdkTelemetryTelemetrySpansItemTransport,
    /** The span's kind, in OTLP's words. */
    public val kind: ServiceTelemetryTelemetrySpansItemKind,
    /** What the row says. */
    public val meaning: String,
    /** The attributes the span carries. */
    public val attributes: kotlin.collections.List<SdkTelemetryTelemetrySpansItemAttributesItem>,
) {
    /** How Java makes a `SdkTelemetryTelemetrySpansItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val transport: SdkTelemetryTelemetrySpansItemTransport,
        private val kind: ServiceTelemetryTelemetrySpansItemKind,
        private val meaning: String,
        private val attributes: kotlin.collections.List<SdkTelemetryTelemetrySpansItemAttributesItem>,
    ) {
        public fun build(): SdkTelemetryTelemetrySpansItem = SdkTelemetryTelemetrySpansItem(name = name, transport = transport, kind = kind, meaning = meaning, attributes = attributes)
    }

    public companion object {
        /** A builder of a `SdkTelemetryTelemetrySpansItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, transport: SdkTelemetryTelemetrySpansItemTransport, kind: ServiceTelemetryTelemetrySpansItemKind, meaning: String, attributes: kotlin.collections.List<SdkTelemetryTelemetrySpansItemAttributesItem>): Builder = Builder(name, transport, kind, meaning, attributes)
    }
}
