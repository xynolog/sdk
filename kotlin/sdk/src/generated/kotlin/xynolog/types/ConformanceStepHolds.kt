// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** Live: the state the observer holds now is this one. */
@Serializable
public data class ConformanceStepHolds(
    /** The observer. */
    public val holds: String,
    public val state: JsonElement,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepHolds`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val holds: String,
        private val state: JsonElement,
    ) {
        public fun build(): ConformanceStepHolds = ConformanceStepHolds(holds = holds, state = state)
    }

    public companion object {
        /** A builder of a `ConformanceStepHolds` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(holds: String, state: JsonElement): Builder = Builder(holds, state)
    }
}
