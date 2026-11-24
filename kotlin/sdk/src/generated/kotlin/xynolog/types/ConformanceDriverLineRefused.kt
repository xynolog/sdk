// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A worker driver: a claim was refused. */
@Serializable
public data class ConformanceDriverLineRefused(
    /** The refusal: with a code when the bus refused it, with none when the worker did. */
    public val refused: ConformanceFailure,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineRefused`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val refused: ConformanceFailure,
    ) {
        public fun build(): ConformanceDriverLineRefused = ConformanceDriverLineRefused(refused = refused)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineRefused` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(refused: ConformanceFailure): Builder = Builder(refused)
    }
}
