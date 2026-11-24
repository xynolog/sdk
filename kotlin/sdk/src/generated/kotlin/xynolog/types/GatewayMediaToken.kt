// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** gateway/media-token.json: what a media token is. */
@Serializable
public data class GatewayMediaToken(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Its JOSE header, exactly. */
    public val header: GatewayMediaTokenHeader,
    /** Its claims beside `iat` and `exp`, each filled as the table says. */
    public val claims: GatewayMediaTokenClaims,
    /** `exp` less `iat`. */
    public val lifetimeSeconds: Long,
) {
    /** How Java makes a `GatewayMediaToken`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val header: GatewayMediaTokenHeader,
        private val claims: GatewayMediaTokenClaims,
        private val lifetimeSeconds: Long,
    ) {
        public fun build(): GatewayMediaToken = GatewayMediaToken(comment = comment, header = header, claims = claims, lifetimeSeconds = lifetimeSeconds)
    }

    public companion object {
        /** A builder of a `GatewayMediaToken` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, header: GatewayMediaTokenHeader, claims: GatewayMediaTokenClaims, lifetimeSeconds: Long): Builder = Builder(comment, header, claims, lifetimeSeconds)
    }
}
