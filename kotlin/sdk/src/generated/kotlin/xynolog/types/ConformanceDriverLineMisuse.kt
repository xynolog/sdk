// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The suite's arguments made no sense: the suite's mistake, never the SDK's. */
@Serializable
public data class ConformanceDriverLineMisuse(
    /** The operation's id. */
    public val id: Long,
    /** What made no sense. */
    public val misuse: String,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineMisuse`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val id: Long,
        private val misuse: String,
    ) {
        public fun build(): ConformanceDriverLineMisuse = ConformanceDriverLineMisuse(id = id, misuse = misuse)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineMisuse` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(id: Long, misuse: String): Builder = Builder(id, misuse)
    }
}
