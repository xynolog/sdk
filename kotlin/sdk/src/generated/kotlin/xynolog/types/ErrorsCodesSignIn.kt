// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A vocabulary that states nothing of its codes but each one's docs: here, why a job its client follows ended without a result. */
@Serializable
public data class ErrorsCodesSignIn(
    /** Its documentation, in prose: what a generated type or member says of it. */
    public val docs: String,
    public val codes: kotlin.collections.List<ErrorsCodesSignInCodesItem>,
) {
    /** How Java makes a `ErrorsCodesSignIn`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val docs: String,
        private val codes: kotlin.collections.List<ErrorsCodesSignInCodesItem>,
    ) {
        public fun build(): ErrorsCodesSignIn = ErrorsCodesSignIn(docs = docs, codes = codes)
    }

    public companion object {
        /** A builder of a `ErrorsCodesSignIn` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(docs: String, codes: kotlin.collections.List<ErrorsCodesSignInCodesItem>): Builder = Builder(docs, codes)
    }
}
