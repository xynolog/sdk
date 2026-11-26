// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Why a request of the launcher's control API failed: each code, the JSON-RPC code an answer carries it under, and whether a request that fails with it is retryable. */
@Serializable
public data class ErrorsCodesControl(
    /** Its documentation, in prose: what a generated type or member says of it. */
    public val docs: String,
    public val codes: kotlin.collections.List<ErrorsCodesControlCodesItem>,
) {
    /** How Java makes a `ErrorsCodesControl`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val docs: String,
        private val codes: kotlin.collections.List<ErrorsCodesControlCodesItem>,
    ) {
        public fun build(): ErrorsCodesControl = ErrorsCodesControl(docs = docs, codes = codes)
    }

    public companion object {
        /** A builder of a `ErrorsCodesControl` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(docs: String, codes: kotlin.collections.List<ErrorsCodesControlCodesItem>): Builder = Builder(docs, codes)
    }
}
