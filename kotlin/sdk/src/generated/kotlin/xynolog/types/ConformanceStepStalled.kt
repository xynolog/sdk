// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** A worker case: the next held job the worker says has stalled. */
@Serializable
public data class ConformanceStepStalled(
    public val stalled: JsonElement,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepStalled`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val stalled: JsonElement,
    ) {
        public fun build(): ConformanceStepStalled = ConformanceStepStalled(stalled = stalled)
    }

    public companion object {
        /** A builder of a `ConformanceStepStalled` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(stalled: JsonElement): Builder = Builder(stalled)
    }
}
