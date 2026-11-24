// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** An account in a knowledge base's launcher-managed identity realm. Passwords and tokens are never included. */
@Serializable
public data class IdentityUser(
    /** The account's sign-in name, normally its email address. */
    public val email: String,
    /** The identity the account acts under in Xynolog. */
    public val identity: String,
    /** Whether the identity provider currently allows this account to sign in. */
    public val enabled: Boolean,
) {
    /** How Java makes a `IdentityUser`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val email: String,
        private val identity: String,
        private val enabled: Boolean,
    ) {
        public fun build(): IdentityUser = IdentityUser(email = email, identity = identity, enabled = enabled)
    }

    public companion object {
        /** A builder of a `IdentityUser` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(email: String, identity: String, enabled: Boolean): Builder = Builder(email, identity, enabled)
    }
}
