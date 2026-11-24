// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ServiceTelemetryTelemetryMetricsItem(
    /** The row's name; `{channel}` in it is the bus channel, and `{jobType}` the job's type. */
    public val name: String,
    /** The services that export the row. */
    public val services: kotlin.collections.List<ServiceTelemetryTelemetryMetricsItemServicesItem>,
    /** The metric's instrument. */
    public val instrument: ServiceTelemetryTelemetryMetricsItemInstrument,
    /** When the row arrives. */
    public val `when`: ServiceTelemetryTelemetryMetricsItemWhen,
    /** The only signal planes a gateway row arrives on. */
    public val planes: kotlin.collections.List<ServiceTelemetryTelemetryMetricsItemPlanesItem>? = null,
    /** What the row says. */
    public val meaning: String,
    /** The attributes the span carries. */
    public val attributes: kotlin.collections.List<ServiceTelemetryTelemetryMetricsItemAttributesItem>,
) {
    /** How Java makes a `ServiceTelemetryTelemetryMetricsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val services: kotlin.collections.List<ServiceTelemetryTelemetryMetricsItemServicesItem>,
        private val instrument: ServiceTelemetryTelemetryMetricsItemInstrument,
        private val `when`: ServiceTelemetryTelemetryMetricsItemWhen,
        private val meaning: String,
        private val attributes: kotlin.collections.List<ServiceTelemetryTelemetryMetricsItemAttributesItem>,
    ) {
        private var planes: kotlin.collections.List<ServiceTelemetryTelemetryMetricsItemPlanesItem>? = null

        public fun planes(planes: kotlin.collections.List<ServiceTelemetryTelemetryMetricsItemPlanesItem>?): Builder = apply { this.planes = planes }

        public fun build(): ServiceTelemetryTelemetryMetricsItem = ServiceTelemetryTelemetryMetricsItem(name = name, services = services, instrument = instrument, `when` = `when`, planes = planes, meaning = meaning, attributes = attributes)
    }

    public companion object {
        /** A builder of a `ServiceTelemetryTelemetryMetricsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, services: kotlin.collections.List<ServiceTelemetryTelemetryMetricsItemServicesItem>, instrument: ServiceTelemetryTelemetryMetricsItemInstrument, `when`: ServiceTelemetryTelemetryMetricsItemWhen, meaning: String, attributes: kotlin.collections.List<ServiceTelemetryTelemetryMetricsItemAttributesItem>): Builder = Builder(name, services, instrument, `when`, meaning, attributes)
    }
}
