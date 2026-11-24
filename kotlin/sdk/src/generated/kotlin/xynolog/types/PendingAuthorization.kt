// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonIgnoreUnknownKeys

/** What a sign-in by a page redirect remembers across the trip to the issuer and back: the verifier and the state the issuer's response must match, where the person was connecting, what they believed they were connecting to, and the issuer's endpoints, so its completion asks nothing twice. */
@Serializable
@JsonIgnoreUnknownKeys
public data class PendingAuthorization(
    /** What the issuer's response must carry back to belong to this sign-in: random, as base64url. */
    public val state: String,
    /** The PKCE code verifier (RFC 7636) the authorization code is exchanged with: random, as base64url. */
    public val verifier: String,
    /** Where the issuer sends the person back to, named again when the code is exchanged. */
    public val redirectUri: String,
    /** Where the person was connecting. */
    public val target: HttpEndpoint,
    /** The issuer the knowledge base trusts, and the endpoints of it a client uses. */
    public val issuer: PendingAuthorizationIssuer,
    /** The registered knowledge base being signed in to again. Absent when it is none. */
    public val kbId: String? = null,
    /** The did of what the person believed they clicked, checked against the answer and never assumed. Absent when they named nothing. */
    public val expectedDid: String? = null,
    /** The name of what the person believed they clicked. Absent when they named nothing. */
    public val expectedName: String? = null,
) {
    /** How Java makes a `PendingAuthorization`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val state: String,
        private val verifier: String,
        private val redirectUri: String,
        private val target: HttpEndpoint,
        private val issuer: PendingAuthorizationIssuer,
    ) {
        private var kbId: String? = null
        private var expectedDid: String? = null
        private var expectedName: String? = null

        public fun kbId(kbId: String?): Builder = apply { this.kbId = kbId }
        public fun expectedDid(expectedDid: String?): Builder = apply { this.expectedDid = expectedDid }
        public fun expectedName(expectedName: String?): Builder = apply { this.expectedName = expectedName }

        public fun build(): PendingAuthorization = PendingAuthorization(state = state, verifier = verifier, redirectUri = redirectUri, target = target, issuer = issuer, kbId = kbId, expectedDid = expectedDid, expectedName = expectedName)
    }

    public companion object {
        /** A builder of a `PendingAuthorization` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(state: String, verifier: String, redirectUri: String, target: HttpEndpoint, issuer: PendingAuthorizationIssuer): Builder = Builder(state, verifier, redirectUri, target, issuer)
    }
}
