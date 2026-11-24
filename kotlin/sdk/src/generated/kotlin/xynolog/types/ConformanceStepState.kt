// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The transport comes to report this state. */
@Serializable
public data class ConformanceStepState(
    /** The state. */
    public val state: ConformanceStepStateState,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepState`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val state: ConformanceStepStateState,
    ) {
        public fun build(): ConformanceStepState = ConformanceStepState(state = state)
    }

    public companion object {
        /** A builder of a `ConformanceStepState` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(state: ConformanceStepStateState): Builder = Builder(state)
    }
}
