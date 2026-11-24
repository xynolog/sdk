// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class GatewayResponseHeadersEveryItem(
    /** A header's name, as HTTP spells it; a receiver reads it in any case. */
    public val name: String,
    /** Its value, exactly. */
    public val value: String,
) {
    /** How Java makes a `GatewayResponseHeadersEveryItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val value: String,
    ) {
        public fun build(): GatewayResponseHeadersEveryItem = GatewayResponseHeadersEveryItem(name = name, value = value)
    }

    public companion object {
        /** A builder of a `GatewayResponseHeadersEveryItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, value: String): Builder = Builder(name, value)
    }
}
