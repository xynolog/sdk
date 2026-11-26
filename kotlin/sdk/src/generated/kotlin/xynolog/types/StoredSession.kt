// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonIgnoreUnknownKeys

/** What is kept of a sign-in: the tokens an issuer issued, the client they were issued to, and the issuer's endpoints a renewal and a sign-out need, learned once at sign-in so no session asks again. TOKENS, never a password. A stored value that lacks a member it requires is no session. */
@Serializable
@JsonIgnoreUnknownKeys
public data class StoredSession(
    /** The access token: short-lived, sent as a Bearer token. */
    public val access: AccessToken,
    /** The refresh token: what renews the access token at the issuer without another sign-in. */
    public val refresh: String,
    /** The client the tokens were issued to, which a renewal and a revocation name. */
    public val clientId: String,
    /** The issuer's token endpoint, where the refresh grant is made. */
    public val tokenEndpoint: String,
    /** The issuer's revocation endpoint (RFC 7009), where a sign-out tells it to forget the refresh token. Absent when the issuer has none. */
    public val revocationEndpoint: String? = null,
    /** Who the gateway said the sign-in's person is, as the key their caches and stream position are kept under (`lastEventIdKeyPrefix`), never the did itself. Written once the gateway names the person, on the sign-in whose token it was asked about; a renewal keeps it, a new sign-in starts without it, and forgetting the sign-in, however it is forgotten, reads it first to delete what is kept under it. Absent for a sign-in whose gateway has not yet named its person. */
    public val personKey: String? = null,
) {
    /** How Java makes a `StoredSession`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val access: AccessToken,
        private val refresh: String,
        private val clientId: String,
        private val tokenEndpoint: String,
    ) {
        private var revocationEndpoint: String? = null
        private var personKey: String? = null

        public fun revocationEndpoint(revocationEndpoint: String?): Builder = apply { this.revocationEndpoint = revocationEndpoint }
        public fun personKey(personKey: String?): Builder = apply { this.personKey = personKey }

        public fun build(): StoredSession = StoredSession(access = access, refresh = refresh, clientId = clientId, tokenEndpoint = tokenEndpoint, revocationEndpoint = revocationEndpoint, personKey = personKey)
    }

    public companion object {
        /** A builder of a `StoredSession` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(access: AccessToken, refresh: String, clientId: String, tokenEndpoint: String): Builder = Builder(access, refresh, clientId, tokenEndpoint)
    }
}
