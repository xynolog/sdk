// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A worker driver: its worker claimed a job. */
@Serializable
public data class ConformanceDriverLineClaimed(
    /** The job, as the worker read the record. */
    public val claimed: HeldJobRecord,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineClaimed`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val claimed: HeldJobRecord,
    ) {
        public fun build(): ConformanceDriverLineClaimed = ConformanceDriverLineClaimed(claimed = claimed)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineClaimed` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(claimed: HeldJobRecord): Builder = Builder(claimed)
    }
}
