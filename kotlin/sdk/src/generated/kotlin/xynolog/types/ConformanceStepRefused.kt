// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** A worker case: the next refusal of a claim the worker reports. */
@Serializable
public data class ConformanceStepRefused(
    public val refused: JsonElement,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepRefused`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val refused: JsonElement,
    ) {
        public fun build(): ConformanceStepRefused = ConformanceStepRefused(refused = refused)
    }

    public companion object {
        /** A builder of a `ConformanceStepRefused` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(refused: JsonElement): Builder = Builder(refused)
    }
}
