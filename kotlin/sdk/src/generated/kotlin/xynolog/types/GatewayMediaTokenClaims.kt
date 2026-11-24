// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** Its claims beside `iat` and `exp`, each filled as the table says. */
@Serializable
public data class GatewayMediaTokenClaims(
    @EncodeDefault
    public val purpose: GatewayMediaTokenClaimsPurpose = GatewayMediaTokenClaimsPurpose.Media,
    @EncodeDefault
    public val iss: GatewayMediaTokenClaimsIss = GatewayMediaTokenClaimsIss.Domain,
    @EncodeDefault
    public val sub: GatewayMediaTokenClaimsSub = GatewayMediaTokenClaimsSub.ResourceId,
) {
    /** How Java makes a `GatewayMediaTokenClaims`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor() {
        public fun build(): GatewayMediaTokenClaims = GatewayMediaTokenClaims()
    }

    public companion object {
        /** A builder of a `GatewayMediaTokenClaims` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(): Builder = Builder()
    }
}
