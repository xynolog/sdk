// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** An attribute of the resource the services' spans and metrics are exported under. */
@Serializable
public data class ServiceTelemetryTelemetryResourceItem(
    /** The attribute's key. */
    public val key: String,
    /** The services that export the row. */
    public val services: kotlin.collections.List<ServiceTelemetryTelemetryResourceItemServicesItem>,
    /** What the attribute says. */
    public val meaning: String,
    /** Its value when nothing says another, with `{service}` the service's name. */
    public val default: String? = null,
) {
    /** How Java makes a `ServiceTelemetryTelemetryResourceItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val key: String,
        private val services: kotlin.collections.List<ServiceTelemetryTelemetryResourceItemServicesItem>,
        private val meaning: String,
    ) {
        private var default: String? = null

        public fun default(default: String?): Builder = apply { this.default = default }

        public fun build(): ServiceTelemetryTelemetryResourceItem = ServiceTelemetryTelemetryResourceItem(key = key, services = services, meaning = meaning, default = default)
    }

    public companion object {
        /** A builder of a `ServiceTelemetryTelemetryResourceItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(key: String, services: kotlin.collections.List<ServiceTelemetryTelemetryResourceItemServicesItem>, meaning: String): Builder = Builder(key, services, meaning)
    }
}
