// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** The next failure on the client's error stream is this one. */
@Serializable
public data class ConformanceStepError(
    public val error: JsonElement,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepError`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val error: JsonElement,
    ) {
        public fun build(): ConformanceStepError = ConformanceStepError(error = error)
    }

    public companion object {
        /** A builder of a `ConformanceStepError` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(error: JsonElement): Builder = Builder(error)
    }
}
