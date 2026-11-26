// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ErrorsCodesSpanRefusalCodesItem(
    /** The code, as every SDK names it. */
    public val code: String,
    /** Its documentation, in prose: what a generated type or member says of it. */
    public val docs: String,
) {
    /** How Java makes a `ErrorsCodesSpanRefusalCodesItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val code: String,
        private val docs: String,
    ) {
        public fun build(): ErrorsCodesSpanRefusalCodesItem = ErrorsCodesSpanRefusalCodesItem(code = code, docs = docs)
    }

    public companion object {
        /** A builder of a `ErrorsCodesSpanRefusalCodesItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(code: String, docs: String): Builder = Builder(code, docs)
    }
}
