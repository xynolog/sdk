// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The suite abandoned the operation, and the SDK reported nothing else. */
@Serializable
public data class ConformanceDriverLineAbandoned(
    /** The operation's id. */
    public val id: Long,
    /** It was abandoned. */
    public val abandoned: Boolean,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineAbandoned`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val id: Long,
        private val abandoned: Boolean,
    ) {
        public fun build(): ConformanceDriverLineAbandoned = ConformanceDriverLineAbandoned(id = id, abandoned = abandoned)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineAbandoned` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(id: Long, abandoned: Boolean): Builder = Builder(id, abandoned)
    }
}
