// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The SDK failed the operation. */
@Serializable
public data class ConformanceDriverLineFailed(
    /** The operation's id. */
    public val id: Long,
    /** The failure. */
    public val error: ConformanceFailure,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineFailed`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val id: Long,
        private val error: ConformanceFailure,
    ) {
        public fun build(): ConformanceDriverLineFailed = ConformanceDriverLineFailed(id = id, error = error)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineFailed` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(id: Long, error: ConformanceFailure): Builder = Builder(id, error)
    }
}
