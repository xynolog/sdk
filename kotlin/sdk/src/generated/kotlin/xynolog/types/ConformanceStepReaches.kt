// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** Live: the observer comes to hold this state. */
@Serializable
public data class ConformanceStepReaches(
    /** The observer. */
    public val reaches: String,
    public val state: JsonElement,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepReaches`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val reaches: String,
        private val state: JsonElement,
    ) {
        public fun build(): ConformanceStepReaches = ConformanceStepReaches(reaches = reaches, state = state)
    }

    public companion object {
        /** A builder of a `ConformanceStepReaches` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(reaches: String, state: JsonElement): Builder = Builder(reaches, state)
    }
}
