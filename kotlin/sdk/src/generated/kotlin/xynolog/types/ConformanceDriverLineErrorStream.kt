// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The error stream carried a failure. */
@Serializable
public data class ConformanceDriverLineErrorStream(
    /** The failure. */
    public val error: ConformanceFailure,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineErrorStream`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val error: ConformanceFailure,
    ) {
        public fun build(): ConformanceDriverLineErrorStream = ConformanceDriverLineErrorStream(error = error)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineErrorStream` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(error: ConformanceFailure): Builder = Builder(error)
    }
}
