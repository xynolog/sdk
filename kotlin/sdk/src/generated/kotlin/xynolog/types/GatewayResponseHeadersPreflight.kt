// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** How the gateway answers an `OPTIONS` request. */
@Serializable
public data class GatewayResponseHeadersPreflight(
    public val status: HttpStatus,
    /** Each header it carries beside those of `every`, and its value. */
    public val headers: kotlin.collections.List<GatewayResponseHeadersPreflightHeadersItem>,
    /** Each header it carries when the request carries the header it echoes, with that header's value. */
    public val echoes: kotlin.collections.List<GatewayResponseHeadersPreflightEchoesItem>,
    /** The value of the `Vary` it carries when it echoes a header: the request headers it echoes. */
    public val vary: String,
) {
    /** How Java makes a `GatewayResponseHeadersPreflight`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val status: HttpStatus,
        private val headers: kotlin.collections.List<GatewayResponseHeadersPreflightHeadersItem>,
        private val echoes: kotlin.collections.List<GatewayResponseHeadersPreflightEchoesItem>,
        private val vary: String,
    ) {
        public fun build(): GatewayResponseHeadersPreflight = GatewayResponseHeadersPreflight(status = status, headers = headers, echoes = echoes, vary = vary)
    }

    public companion object {
        /** A builder of a `GatewayResponseHeadersPreflight` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(status: HttpStatus, headers: kotlin.collections.List<GatewayResponseHeadersPreflightHeadersItem>, echoes: kotlin.collections.List<GatewayResponseHeadersPreflightEchoesItem>, vary: String): Builder = Builder(status, headers, echoes, vary)
    }
}
