// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What every sign-in asks for. */
@Serializable
public data class SessionOauthScopes(
    /** The scopes, separated by a space. */
    public val value: String,
    /** Its documentation, in prose. */
    public val docs: String,
) {
    /** How Java makes a `SessionOauthScopes`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val value: String,
        private val docs: String,
    ) {
        public fun build(): SessionOauthScopes = SessionOauthScopes(value = value, docs = docs)
    }

    public companion object {
        /** A builder of a `SessionOauthScopes` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(value: String, docs: String): Builder = Builder(value, docs)
    }
}
