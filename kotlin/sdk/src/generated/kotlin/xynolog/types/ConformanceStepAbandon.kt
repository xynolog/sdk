// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Abandon an operation started with `as`, as its caller would. */
@Serializable
public data class ConformanceStepAbandon(
    /** The operation. */
    public val abandon: String,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepAbandon`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val abandon: String,
    ) {
        public fun build(): ConformanceStepAbandon = ConformanceStepAbandon(abandon = abandon)
    }

    public companion object {
        /** A builder of a `ConformanceStepAbandon` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(abandon: String): Builder = Builder(abandon)
    }
}
