// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ErrorsCodesTransportCodesItemStatusLimitRefusalsItem(
    public val status: HttpStatus,
    /** `streams`: the principal already holds as many streams as its coefficient of `x-xynolog-limits.streamsPerPrincipal` allows. `emit-rate`: the principal's emits have used its bucket, whose rate and burst are its coefficient of `x-xynolog-limits.emitsPerPrincipal`, per gateway process. `unanswered-requests`: the client already awaits as many replies as `BusSubscribeRequest.pendingReplies` may name. `capacity`: the gateway holds as many queued bytes as it can. `refusal-rate`: the request's credential was refused, and the requests its holder has had refused have used their allowance; it answers only a request whose token has already failed verification, so it says what a 401 says, and a client that can renew its token renews it and sends the request again rather than waiting (contract/TRANSPORT-CONTRACT.md § A refused credential). */
    public val code: ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCode,
) {
    /** How Java makes a `ErrorsCodesTransportCodesItemStatusLimitRefusalsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val status: HttpStatus,
        private val code: ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCode,
    ) {
        public fun build(): ErrorsCodesTransportCodesItemStatusLimitRefusalsItem = ErrorsCodesTransportCodesItemStatusLimitRefusalsItem(status = status, code = code)
    }

    public companion object {
        /** A builder of a `ErrorsCodesTransportCodesItemStatusLimitRefusalsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(status: HttpStatus, code: ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCode): Builder = Builder(status, code)
    }
}
