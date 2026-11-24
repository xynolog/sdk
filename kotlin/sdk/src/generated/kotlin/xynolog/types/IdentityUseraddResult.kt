// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The created account's sign-in identity. A generated password is present only in this one answer and is not stored by the launcher. */
@Serializable
public data class IdentityUseraddResult(
    /** The account's email address. */
    public val email: String,
    /** The identity the account acts under in Xynolog. */
    public val identity: String,
    /** Whether a new account was created. */
    public val created: Boolean,
    /** The generated password, returned once so the operator can share it with the user. Absent when the operator supplied the password. */
    public val generatedPassword: String? = null,
) {
    /** How Java makes a `IdentityUseraddResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val email: String,
        private val identity: String,
        private val created: Boolean,
    ) {
        private var generatedPassword: String? = null

        public fun generatedPassword(generatedPassword: String?): Builder = apply { this.generatedPassword = generatedPassword }

        public fun build(): IdentityUseraddResult = IdentityUseraddResult(email = email, identity = identity, created = created, generatedPassword = generatedPassword)
    }

    public companion object {
        /** A builder of a `IdentityUseraddResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(email: String, identity: String, created: Boolean): Builder = Builder(email, identity, created)
    }
}
