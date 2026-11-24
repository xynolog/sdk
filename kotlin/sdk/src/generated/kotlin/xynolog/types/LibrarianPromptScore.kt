// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class LibrarianPromptScore(
    public val candidate: Double,
    public val score: Double,
) {
    /** How Java makes a `LibrarianPromptScore`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val candidate: Double,
        private val score: Double,
    ) {
        public fun build(): LibrarianPromptScore = LibrarianPromptScore(candidate = candidate, score = score)
    }

    public companion object {
        /** A builder of a `LibrarianPromptScore` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(candidate: Double, score: Double): Builder = Builder(candidate, score)
    }
}
