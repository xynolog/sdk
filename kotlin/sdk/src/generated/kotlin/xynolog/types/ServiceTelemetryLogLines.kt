// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** service-telemetry/log-lines.json: the lines a service writes to its log, and the line of its supervisor it counts. */
@Serializable
public data class ServiceTelemetryLogLines(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** The lines of a service's logger. */
    public val logger: ServiceTelemetryLogLinesLogger,
    /** A line of the bus log. */
    public val bus: ServiceTelemetryLogLinesBus,
    /** The line the supervisor writes when it starts a service. */
    public val supervisor: ServiceTelemetryLogLinesSupervisor,
) {
    /** How Java makes a `ServiceTelemetryLogLines`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val logger: ServiceTelemetryLogLinesLogger,
        private val bus: ServiceTelemetryLogLinesBus,
        private val supervisor: ServiceTelemetryLogLinesSupervisor,
    ) {
        public fun build(): ServiceTelemetryLogLines = ServiceTelemetryLogLines(comment = comment, logger = logger, bus = bus, supervisor = supervisor)
    }

    public companion object {
        /** A builder of a `ServiceTelemetryLogLines` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, logger: ServiceTelemetryLogLinesLogger, bus: ServiceTelemetryLogLinesBus, supervisor: ServiceTelemetryLogLinesSupervisor): Builder = Builder(comment, logger, bus, supervisor)
    }
}
