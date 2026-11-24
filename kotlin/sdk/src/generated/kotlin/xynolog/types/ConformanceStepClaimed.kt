// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** A worker case: the next job the worker reports as claimed, as it read the record. */
@Serializable
public data class ConformanceStepClaimed(
    public val claimed: JsonElement,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepClaimed`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val claimed: JsonElement,
    ) {
        public fun build(): ConformanceStepClaimed = ConformanceStepClaimed(claimed = claimed)
    }

    public companion object {
        /** A builder of a `ConformanceStepClaimed` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(claimed: JsonElement): Builder = Builder(claimed)
    }
}
