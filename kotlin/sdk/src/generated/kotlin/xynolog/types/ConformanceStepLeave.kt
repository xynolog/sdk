// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Live: the observer stops observing. */
@Serializable
public data class ConformanceStepLeave(
    /** The observer. */
    public val leave: String,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepLeave`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val leave: String,
    ) {
        public fun build(): ConformanceStepLeave = ConformanceStepLeave(leave = leave)
    }

    public companion object {
        /** A builder of a `ConformanceStepLeave` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(leave: String): Builder = Builder(leave)
    }
}
