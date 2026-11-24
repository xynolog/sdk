// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** An issuer somebody else runs. */
@Serializable
public data class StackKnowledgeBaseSpecIssuerExternal(
    /** `oidc`, or `keycloak`. */
    public val type: String,
    /** The URL in its tokens' `iss` claim. */
    public val url: String,
) {
    /** How Java makes a `StackKnowledgeBaseSpecIssuerExternal`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val type: String,
        private val url: String,
    ) {
        public fun build(): StackKnowledgeBaseSpecIssuerExternal = StackKnowledgeBaseSpecIssuerExternal(type = type, url = url)
    }

    public companion object {
        /** A builder of a `StackKnowledgeBaseSpecIssuerExternal` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(type: String, url: String): Builder = Builder(type, url)
    }
}
