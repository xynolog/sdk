// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A line of the `json` format. */
@Serializable
public data class ServiceTelemetryLogLinesLoggerJson(
    /** Its first members, in order. */
    public val first: kotlin.collections.List<String>,
    /** The member that names the request a line was logged while answering. */
    public val requestId: String,
    /** The members that name the active trace and span, in that order. */
    public val trace: kotlin.collections.List<String>,
    /** Its last member: the moment. */
    public val last: String,
) {
    /** How Java makes a `ServiceTelemetryLogLinesLoggerJson`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val first: kotlin.collections.List<String>,
        private val requestId: String,
        private val trace: kotlin.collections.List<String>,
        private val last: String,
    ) {
        public fun build(): ServiceTelemetryLogLinesLoggerJson = ServiceTelemetryLogLinesLoggerJson(first = first, requestId = requestId, trace = trace, last = last)
    }

    public companion object {
        /** A builder of a `ServiceTelemetryLogLinesLoggerJson` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(first: kotlin.collections.List<String>, requestId: String, trace: kotlin.collections.List<String>, last: String): Builder = Builder(first, requestId, trace, last)
    }
}
