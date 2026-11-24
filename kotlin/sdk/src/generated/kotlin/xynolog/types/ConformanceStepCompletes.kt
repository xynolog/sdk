// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Live: the observer's live query completes. */
@Serializable
public data class ConformanceStepCompletes(
    /** The observer. */
    public val completes: String,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepCompletes`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val completes: String,
    ) {
        public fun build(): ConformanceStepCompletes = ConformanceStepCompletes(completes = completes)
    }

    public companion object {
        /** A builder of a `ConformanceStepCompletes` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(completes: String): Builder = Builder(completes)
    }
}
