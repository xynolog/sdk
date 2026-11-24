// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The lines of a service's logger. */
@Serializable
public data class ServiceTelemetryLogLinesLogger(
    /** The services whose document names a LogFormat. */
    public val services: kotlin.collections.List<ServiceTelemetryLogLinesLoggerServicesItem>,
    /** A line of the `json` format. */
    public val json: ServiceTelemetryLogLinesLoggerJson,
    /** A line of the `simple` format. */
    public val simple: String,
) {
    /** How Java makes a `ServiceTelemetryLogLinesLogger`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val services: kotlin.collections.List<ServiceTelemetryLogLinesLoggerServicesItem>,
        private val json: ServiceTelemetryLogLinesLoggerJson,
        private val simple: String,
    ) {
        public fun build(): ServiceTelemetryLogLinesLogger = ServiceTelemetryLogLinesLogger(services = services, json = json, simple = simple)
    }

    public companion object {
        /** A builder of a `ServiceTelemetryLogLinesLogger` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(services: kotlin.collections.List<ServiceTelemetryLogLinesLoggerServicesItem>, json: ServiceTelemetryLogLinesLoggerJson, simple: String): Builder = Builder(services, json, simple)
    }
}
