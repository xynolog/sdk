// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A worker driver: a held job's cancellation was signalled. */
@Serializable
public data class ConformanceDriverLineSignalled(
    /** The job's id. */
    public val signalled: String,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineSignalled`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val signalled: String,
    ) {
        public fun build(): ConformanceDriverLineSignalled = ConformanceDriverLineSignalled(signalled = signalled)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineSignalled` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(signalled: String): Builder = Builder(signalled)
    }
}
