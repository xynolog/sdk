// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** A worker case: the next held job whose cancellation the worker says was signalled. */
@Serializable
public data class ConformanceStepSignalled(
    public val signalled: JsonElement,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepSignalled`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val signalled: JsonElement,
    ) {
        public fun build(): ConformanceStepSignalled = ConformanceStepSignalled(signalled = signalled)
    }

    public companion object {
        /** A builder of a `ConformanceStepSignalled` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(signalled: JsonElement): Builder = Builder(signalled)
    }
}
