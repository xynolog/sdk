// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A worker driver: a held job stalled. */
@Serializable
public data class ConformanceDriverLineStalled(
    /** The job's id. */
    public val stalled: String,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineStalled`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val stalled: String,
    ) {
        public fun build(): ConformanceDriverLineStalled = ConformanceDriverLineStalled(stalled = stalled)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineStalled` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(stalled: String): Builder = Builder(stalled)
    }
}
