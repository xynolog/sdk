// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A code read from one HTTP status. */
@Serializable
public data class ErrorsCodesTransportCodesItemStatus(
    /** The code, as every SDK names it. */
    public val code: String,
    /** Its documentation, in prose: what a generated type or member says of it. */
    public val docs: String,
    public val status: HttpStatus,
    /** The limit refusals read as this code and not as the code of their status: each a status and the LimitRefusal `code` it carries, as a row of gateway/messages.json states them. */
    public val limitRefusals: kotlin.collections.List<ErrorsCodesTransportCodesItemStatusLimitRefusalsItem>? = null,
) : ErrorsCodesTransportCodesItem {
    /** How Java makes a `ErrorsCodesTransportCodesItemStatus`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val code: String,
        private val docs: String,
        private val status: HttpStatus,
    ) {
        private var limitRefusals: kotlin.collections.List<ErrorsCodesTransportCodesItemStatusLimitRefusalsItem>? = null

        public fun limitRefusals(limitRefusals: kotlin.collections.List<ErrorsCodesTransportCodesItemStatusLimitRefusalsItem>?): Builder = apply { this.limitRefusals = limitRefusals }

        public fun build(): ErrorsCodesTransportCodesItemStatus = ErrorsCodesTransportCodesItemStatus(code = code, docs = docs, status = status, limitRefusals = limitRefusals)
    }

    public companion object {
        /** A builder of a `ErrorsCodesTransportCodesItemStatus` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(code: String, docs: String, status: HttpStatus): Builder = Builder(code, docs, status)
    }
}
