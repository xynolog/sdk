// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class GatewayResponseHeadersPreflightEchoesItem(
    /** A header's name, as HTTP spells it; a receiver reads it in any case. */
    public val name: String,
    /** The request's header whose value it carries. */
    public val of: String,
) {
    /** How Java makes a `GatewayResponseHeadersPreflightEchoesItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val of: String,
    ) {
        public fun build(): GatewayResponseHeadersPreflightEchoesItem = GatewayResponseHeadersPreflightEchoesItem(name = name, of = of)
    }

    public companion object {
        /** A builder of a `GatewayResponseHeadersPreflightEchoesItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, of: String): Builder = Builder(name, of)
    }
}
