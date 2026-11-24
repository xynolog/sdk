// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The launcher's session for a stack, ended. Desktop's own session is not touched. */
@Serializable
public data class AuthLogoutResult(
    /** The stack's key in the sign-in store. Absent when no stack is recorded. */
    public val key: String? = null,
    /** Whether a session was stored. false: nothing was done. */
    public val wasSignedIn: Boolean,
    /** Whether the issuer revoked the session's refresh token. false with wasSignedIn: the local token is forgotten, and the refresh token stays valid at the issuer until it expires. */
    public val revoked: Boolean,
) {
    /** How Java makes a `AuthLogoutResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val wasSignedIn: Boolean,
        private val revoked: Boolean,
    ) {
        private var key: String? = null

        public fun key(key: String?): Builder = apply { this.key = key }

        public fun build(): AuthLogoutResult = AuthLogoutResult(key = key, wasSignedIn = wasSignedIn, revoked = revoked)
    }

    public companion object {
        /** A builder of a `AuthLogoutResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(wasSignedIn: Boolean, revoked: Boolean): Builder = Builder(wasSignedIn, revoked)
    }
}
