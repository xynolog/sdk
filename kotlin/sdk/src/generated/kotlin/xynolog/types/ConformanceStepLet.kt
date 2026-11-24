// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** Name values for later steps. */
@Serializable
public data class ConformanceStepLet(
    /** Each name, and the value it takes. */
    public val let: kotlin.collections.Map<String, JsonElement>,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepLet`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val let: kotlin.collections.Map<String, JsonElement>,
    ) {
        public fun build(): ConformanceStepLet = ConformanceStepLet(let = let)
    }

    public companion object {
        /** A builder of a `ConformanceStepLet` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(let: kotlin.collections.Map<String, JsonElement>): Builder = Builder(let)
    }
}
