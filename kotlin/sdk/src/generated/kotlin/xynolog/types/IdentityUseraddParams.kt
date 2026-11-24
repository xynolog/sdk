// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Create one account in the launcher-managed Keycloak realm for a specific local knowledge base. */
@Serializable
public data class IdentityUseraddParams(
    public val apiVersion: ApiVersion,
    public val target: LocalTarget,
    /** The email address that will sign in to this knowledge base. */
    public val email: String,
    /** The user's password. Secret: carried only in this local control request, never in progress, diagnostics, or persistent state. */
    public val password: String? = null,
    /** Generate a random password in the launcher and return it once in the result. */
    public val generatePassword: Boolean,
) {
    /** How Java makes a `IdentityUseraddParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
        private val target: LocalTarget,
        private val email: String,
        private val generatePassword: Boolean,
    ) {
        private var password: String? = null

        public fun password(password: String?): Builder = apply { this.password = password }

        public fun build(): IdentityUseraddParams = IdentityUseraddParams(apiVersion = apiVersion, target = target, email = email, password = password, generatePassword = generatePassword)
    }

    public companion object {
        /** A builder of a `IdentityUseraddParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion, target: LocalTarget, email: String, generatePassword: Boolean): Builder = Builder(apiVersion, target, email, generatePassword)
    }
}
