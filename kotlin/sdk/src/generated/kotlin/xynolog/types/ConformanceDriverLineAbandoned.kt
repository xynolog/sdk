// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** The suite abandoned the operation, and the SDK reported nothing else. */
@Serializable
public data class ConformanceDriverLineAbandoned(
    /** The operation's id. */
    public val id: Long,
    /** It was abandoned. */
    @EncodeDefault
    public val abandoned: ConformanceDriverLineAbandonedAbandoned = ConformanceDriverLineAbandonedAbandoned,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineAbandoned`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val id: Long,
    ) {
        public fun build(): ConformanceDriverLineAbandoned = ConformanceDriverLineAbandoned(id = id)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineAbandoned` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(id: Long): Builder = Builder(id)
    }
}
