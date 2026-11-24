// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A completed sign-in, kept in the launcher's sign-in store. No token is in it. */
@Serializable
public data class AuthLoginResult(
    /** The stack's key in the sign-in store. */
    public val key: String,
    /** Who the gateway says is signed in: their email, else their DID. */
    public val who: String,
    /** The issuer the knowledge base named, where the person signed in. */
    public val issuer: String,
) {
    /** How Java makes a `AuthLoginResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val key: String,
        private val who: String,
        private val issuer: String,
    ) {
        public fun build(): AuthLoginResult = AuthLoginResult(key = key, who = who, issuer = issuer)
    }

    public companion object {
        /** A builder of a `AuthLoginResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(key: String, who: String, issuer: String): Builder = Builder(key, who, issuer)
    }
}
