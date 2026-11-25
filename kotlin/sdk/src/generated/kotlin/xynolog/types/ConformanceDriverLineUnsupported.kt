// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** The driver has no such operation. It says so at once, before it reads its next operation. */
@Serializable
public data class ConformanceDriverLineUnsupported(
    /** The operation's id. */
    public val id: Long,
    /** It has none. */
    @EncodeDefault
    public val unsupported: ConformanceDriverLineUnsupportedUnsupported = ConformanceDriverLineUnsupportedUnsupported,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineUnsupported`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val id: Long,
    ) {
        public fun build(): ConformanceDriverLineUnsupported = ConformanceDriverLineUnsupported(id = id)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineUnsupported` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(id: Long): Builder = Builder(id)
    }
}
