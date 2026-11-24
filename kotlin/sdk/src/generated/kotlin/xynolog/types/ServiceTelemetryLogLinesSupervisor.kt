// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The line the supervisor writes when it starts a service. */
@Serializable
public data class ServiceTelemetryLogLinesSupervisor(
    /** The line. */
    public val line: String,
    /** What a service counts the lines that hold of, for each of its lives. */
    public val counted: String,
) {
    /** How Java makes a `ServiceTelemetryLogLinesSupervisor`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val line: String,
        private val counted: String,
    ) {
        public fun build(): ServiceTelemetryLogLinesSupervisor = ServiceTelemetryLogLinesSupervisor(line = line, counted = counted)
    }

    public companion object {
        /** A builder of a `ServiceTelemetryLogLinesSupervisor` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(line: String, counted: String): Builder = Builder(line, counted)
    }
}
