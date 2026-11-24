// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The client puts nothing more on the wire for this many milliseconds. */
@Serializable
public data class ConformanceStepQuiet(
    /** How long, in milliseconds. */
    public val quiet: Long,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepQuiet`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val quiet: Long,
    ) {
        public fun build(): ConformanceStepQuiet = ConformanceStepQuiet(quiet = quiet)
    }

    public companion object {
        /** A builder of a `ConformanceStepQuiet` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(quiet: Long): Builder = Builder(quiet)
    }
}
