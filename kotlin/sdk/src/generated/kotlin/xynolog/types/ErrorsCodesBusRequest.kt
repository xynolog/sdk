// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Why a bus request did not resolve. */
@Serializable
public data class ErrorsCodesBusRequest(
    /** Its documentation, in prose: what a generated type or member says of it. */
    public val docs: String,
    /** The code, as every SDK names it. */
    public val unrecognizedFailure: String,
    /** Each code, and the wire's `CommandError.code` it restates, where it restates one. */
    public val codes: kotlin.collections.List<ErrorsCodesBusRequestCodesItem>,
) {
    /** How Java makes a `ErrorsCodesBusRequest`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val docs: String,
        private val unrecognizedFailure: String,
        private val codes: kotlin.collections.List<ErrorsCodesBusRequestCodesItem>,
    ) {
        public fun build(): ErrorsCodesBusRequest = ErrorsCodesBusRequest(docs = docs, unrecognizedFailure = unrecognizedFailure, codes = codes)
    }

    public companion object {
        /** A builder of a `ErrorsCodesBusRequest` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(docs: String, unrecognizedFailure: String, codes: kotlin.collections.List<ErrorsCodesBusRequestCodesItem>): Builder = Builder(docs, unrecognizedFailure, codes)
    }
}
