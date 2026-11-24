// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** Its JOSE header, exactly. */
@Serializable
public data class GatewayMediaTokenHeader(
    @EncodeDefault
    public val alg: GatewayMediaTokenHeaderAlg = GatewayMediaTokenHeaderAlg.HS256,
    @EncodeDefault
    public val typ: GatewayMediaTokenHeaderTyp = GatewayMediaTokenHeaderTyp.JWT,
) {
    /** How Java makes a `GatewayMediaTokenHeader`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor() {
        public fun build(): GatewayMediaTokenHeader = GatewayMediaTokenHeader()
    }

    public companion object {
        /** A builder of a `GatewayMediaTokenHeader` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(): Builder = Builder()
    }
}
