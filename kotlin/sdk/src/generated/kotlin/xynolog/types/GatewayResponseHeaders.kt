// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** gateway/response-headers.json: the headers on every response the gateway sends. */
@Serializable
public data class GatewayResponseHeaders(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each header every response carries, and its value. */
    public val every: kotlin.collections.List<GatewayResponseHeadersEveryItem>,
    /** The header that names the request. */
    public val requestId: String,
    /** Each header no response carries. */
    public val absent: kotlin.collections.List<String>,
    /** How the gateway answers an `OPTIONS` request. */
    public val preflight: GatewayResponseHeadersPreflight,
) {
    /** How Java makes a `GatewayResponseHeaders`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val every: kotlin.collections.List<GatewayResponseHeadersEveryItem>,
        private val requestId: String,
        private val absent: kotlin.collections.List<String>,
        private val preflight: GatewayResponseHeadersPreflight,
    ) {
        public fun build(): GatewayResponseHeaders = GatewayResponseHeaders(comment = comment, every = every, requestId = requestId, absent = absent, preflight = preflight)
    }

    public companion object {
        /** A builder of a `GatewayResponseHeaders` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, every: kotlin.collections.List<GatewayResponseHeadersEveryItem>, requestId: String, absent: kotlin.collections.List<String>, preflight: GatewayResponseHeadersPreflight): Builder = Builder(comment, every, requestId, absent, preflight)
    }
}
