// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A line of the bus log. */
@Serializable
public data class ServiceTelemetryLogLinesBus(
    /** Its head. */
    public val line: String,
    /** What follows the head, in order, each where there is one. */
    public val parts: kotlin.collections.List<ServiceTelemetryLogLinesBusPartsItem>,
    /** Each operation a line names. */
    public val ops: kotlin.collections.List<String>,
) {
    /** How Java makes a `ServiceTelemetryLogLinesBus`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val line: String,
        private val parts: kotlin.collections.List<ServiceTelemetryLogLinesBusPartsItem>,
        private val ops: kotlin.collections.List<String>,
    ) {
        public fun build(): ServiceTelemetryLogLinesBus = ServiceTelemetryLogLinesBus(line = line, parts = parts, ops = ops)
    }

    public companion object {
        /** A builder of a `ServiceTelemetryLogLinesBus` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(line: String, parts: kotlin.collections.List<ServiceTelemetryLogLinesBusPartsItem>, ops: kotlin.collections.List<String>): Builder = Builder(line, parts, ops)
    }
}
