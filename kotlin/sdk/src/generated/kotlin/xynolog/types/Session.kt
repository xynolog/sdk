// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The launcher's own stored sign-in for a stack (xynolog login), never Desktop's. No token is in it. */
@Serializable
public data class Session(
    /** valid: the stack's gateway accepts the stored token. expired: it refuses it (a refresh, or xynolog login, renews it). unverified: the stack did not answer. none: nothing is stored. */
    public val state: SessionState,
    /** The email the session was signed in as, when the store records one. */
    public val email: String? = null,
) {
    /** How Java makes a `Session`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val state: SessionState,
    ) {
        private var email: String? = null

        public fun email(email: String?): Builder = apply { this.email = email }

        public fun build(): Session = Session(state = state, email = email)
    }

    public companion object {
        /** A builder of a `Session` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(state: SessionState): Builder = Builder(state)
    }
}
