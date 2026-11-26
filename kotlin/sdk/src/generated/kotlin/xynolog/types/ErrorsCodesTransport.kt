// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The transport-neutral failure vocabulary. */
@Serializable
public data class ErrorsCodesTransport(
    /** Its documentation, in prose: what a generated type or member says of it. */
    public val docs: String,
    /** The code, as every SDK names it. */
    public val unclassified: String,
    /** Each code, and the HTTP statuses it is read from. */
    public val codes: kotlin.collections.List<ErrorsCodesTransportCodesItem>,
) {
    /** How Java makes a `ErrorsCodesTransport`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val docs: String,
        private val unclassified: String,
        private val codes: kotlin.collections.List<ErrorsCodesTransportCodesItem>,
    ) {
        public fun build(): ErrorsCodesTransport = ErrorsCodesTransport(docs = docs, unclassified = unclassified, codes = codes)
    }

    public companion object {
        /** A builder of a `ErrorsCodesTransport` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(docs: String, unclassified: String, codes: kotlin.collections.List<ErrorsCodesTransportCodesItem>): Builder = Builder(docs, unclassified, codes)
    }
}
