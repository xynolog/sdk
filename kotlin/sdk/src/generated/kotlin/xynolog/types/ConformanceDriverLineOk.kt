// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** The operation succeeded. */
@Serializable
public data class ConformanceDriverLineOk(
    /** The operation's id. */
    public val id: Long,
    public val ok: JsonElement,
) : ConformanceDriverLine {
    /** How Java makes a `ConformanceDriverLineOk`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val id: Long,
        private val ok: JsonElement,
    ) {
        public fun build(): ConformanceDriverLineOk = ConformanceDriverLineOk(id = id, ok = ok)
    }

    public companion object {
        /** A builder of a `ConformanceDriverLineOk` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(id: Long, ok: JsonElement): Builder = Builder(id, ok)
    }
}
