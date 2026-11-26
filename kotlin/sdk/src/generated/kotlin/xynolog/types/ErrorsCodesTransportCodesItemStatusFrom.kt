// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A code read from every HTTP status at or above one. */
@Serializable
public data class ErrorsCodesTransportCodesItemStatusFrom(
    /** The code, as every SDK names it. */
    public val code: String,
    /** Its documentation, in prose: what a generated type or member says of it. */
    public val docs: String,
    public val statusFrom: HttpStatus,
) : ErrorsCodesTransportCodesItem {
    /** How Java makes a `ErrorsCodesTransportCodesItemStatusFrom`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val code: String,
        private val docs: String,
        private val statusFrom: HttpStatus,
    ) {
        public fun build(): ErrorsCodesTransportCodesItemStatusFrom = ErrorsCodesTransportCodesItemStatusFrom(code = code, docs = docs, statusFrom = statusFrom)
    }

    public companion object {
        /** A builder of a `ErrorsCodesTransportCodesItemStatusFrom` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(code: String, docs: String, statusFrom: HttpStatus): Builder = Builder(code, docs, statusFrom)
    }
}
