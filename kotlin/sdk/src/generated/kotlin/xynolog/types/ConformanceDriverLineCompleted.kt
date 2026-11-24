// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The live driver: the observer's live query completed. */
@Serializable
public data class ConformanceDriverLineCompleted(
    /** The observer. */
    public val completed: String,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineCompleted`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val completed: String,
    ) {
        public fun build(): ConformanceDriverLineCompleted = ConformanceDriverLineCompleted(completed = completed)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineCompleted` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(completed: String): Builder = Builder(completed)
    }
}
