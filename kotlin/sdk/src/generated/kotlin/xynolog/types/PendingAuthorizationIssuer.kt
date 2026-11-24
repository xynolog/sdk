// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonIgnoreUnknownKeys

/** The issuer the knowledge base trusts, and the endpoints of it a client uses. */
@Serializable
@JsonIgnoreUnknownKeys
public data class PendingAuthorizationIssuer(
    /** The issuer's identifier. */
    public val issuer: String,
    /** The issuer's authorization endpoint, where the person is sent. */
    public val authorization: String,
    /** The issuer's token endpoint, where the code is exchanged. */
    public val token: String,
    /** The issuer's device authorization endpoint (RFC 8628). Absent when the issuer has none. */
    public val device: String? = null,
    /** The issuer's revocation endpoint (RFC 7009). Absent when the issuer has none. */
    public val revocation: String? = null,
) {
    /** How Java makes a `PendingAuthorizationIssuer`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val issuer: String,
        private val authorization: String,
        private val token: String,
    ) {
        private var device: String? = null
        private var revocation: String? = null

        public fun device(device: String?): Builder = apply { this.device = device }
        public fun revocation(revocation: String?): Builder = apply { this.revocation = revocation }

        public fun build(): PendingAuthorizationIssuer = PendingAuthorizationIssuer(issuer = issuer, authorization = authorization, token = token, device = device, revocation = revocation)
    }

    public companion object {
        /** A builder of a `PendingAuthorizationIssuer` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(issuer: String, authorization: String, token: String): Builder = Builder(issuer, authorization, token)
    }
}
