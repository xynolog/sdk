// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** session/oauth.json: the clients a Xynolog client signs in to the issuer as, and the scope every sign-in asks for. */
@Serializable
public data class SessionOauth(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** The clients the realm registers. */
    public val clients: kotlin.collections.List<SessionOauthClientsItem>,
    /** What every sign-in asks for. */
    public val scopes: SessionOauthScopes,
) {
    /** How Java makes a `SessionOauth`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val clients: kotlin.collections.List<SessionOauthClientsItem>,
        private val scopes: SessionOauthScopes,
    ) {
        public fun build(): SessionOauth = SessionOauth(comment = comment, clients = clients, scopes = scopes)
    }

    public companion object {
        /** A builder of a `SessionOauth` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, clients: kotlin.collections.List<SessionOauthClientsItem>, scopes: SessionOauthScopes): Builder = Builder(comment, clients, scopes)
    }
}
