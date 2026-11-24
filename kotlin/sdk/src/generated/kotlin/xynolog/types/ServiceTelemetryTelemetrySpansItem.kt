// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ServiceTelemetryTelemetrySpansItem(
    /** The row's name; `{channel}` in it is the bus channel, and `{jobType}` the job's type. */
    public val name: String,
    /** The services that export the row. */
    public val services: kotlin.collections.List<ServiceTelemetryTelemetrySpansItemServicesItem>,
    /** The span's kind, in OTLP's words. */
    public val kind: ServiceTelemetryTelemetrySpansItemKind,
    /** When the row arrives. */
    public val `when`: ServiceTelemetryTelemetrySpansItemWhen,
    /** What the row says. */
    public val meaning: String,
    /** The attributes the span carries. */
    public val attributes: kotlin.collections.List<ServiceTelemetryTelemetrySpansItemAttributesItem>,
) {
    /** How Java makes a `ServiceTelemetryTelemetrySpansItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val services: kotlin.collections.List<ServiceTelemetryTelemetrySpansItemServicesItem>,
        private val kind: ServiceTelemetryTelemetrySpansItemKind,
        private val `when`: ServiceTelemetryTelemetrySpansItemWhen,
        private val meaning: String,
        private val attributes: kotlin.collections.List<ServiceTelemetryTelemetrySpansItemAttributesItem>,
    ) {
        public fun build(): ServiceTelemetryTelemetrySpansItem = ServiceTelemetryTelemetrySpansItem(name = name, services = services, kind = kind, `when` = `when`, meaning = meaning, attributes = attributes)
    }

    public companion object {
        /** A builder of a `ServiceTelemetryTelemetrySpansItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, services: kotlin.collections.List<ServiceTelemetryTelemetrySpansItemServicesItem>, kind: ServiceTelemetryTelemetrySpansItemKind, `when`: ServiceTelemetryTelemetrySpansItemWhen, meaning: String, attributes: kotlin.collections.List<ServiceTelemetryTelemetrySpansItemAttributesItem>): Builder = Builder(name, services, kind, `when`, meaning, attributes)
    }
}
