// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** `streams`: the principal already holds as many streams as its coefficient of `x-xynolog-limits.streamsPerPrincipal` allows. `emit-rate`: the principal's emits have used its bucket, whose rate and burst are its coefficient of `x-xynolog-limits.emitsPerPrincipal`, per gateway process. `unanswered-requests`: the client already awaits as many replies as `BusSubscribeRequest.pendingReplies` may name. `capacity`: the gateway holds as many queued bytes as it can. `refusal-rate`: the request's credential was refused, and the requests its holder has had refused have used their allowance; it answers only a request whose token has already failed verification, so it says what a 401 says, and a client that can renew its token renews it and sends the request again rather than waiting (contract/TRANSPORT-CONTRACT.md § A refused credential). */
@Serializable
public enum class ErrorsCodesTransportCodesItemStatusLimitRefusalsItemCode(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("streams")
    Streams("streams"),

    @SerialName("emit-rate")
    EmitRate("emit-rate"),

    @SerialName("unanswered-requests")
    UnansweredRequests("unanswered-requests"),

    @SerialName("capacity")
    Capacity("capacity"),

    @SerialName("refusal-rate")
    RefusalRate("refusal-rate"),
}
