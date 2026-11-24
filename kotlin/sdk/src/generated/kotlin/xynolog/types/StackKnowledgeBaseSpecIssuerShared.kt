// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The issuer the launcher runs for the knowledge bases on a machine (the state home's Issuer document). The launcher creates the knowledge base's realm in it. */
@Serializable
public data class StackKnowledgeBaseSpecIssuerShared(
    /** How long a token the realm mints stays valid, in seconds: the window in which a disabled account can still act. */
    public val accessTokenLifespan: Long,
) {
    /** How Java makes a `StackKnowledgeBaseSpecIssuerShared`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val accessTokenLifespan: Long,
    ) {
        public fun build(): StackKnowledgeBaseSpecIssuerShared = StackKnowledgeBaseSpecIssuerShared(accessTokenLifespan = accessTokenLifespan)
    }

    public companion object {
        /** A builder of a `StackKnowledgeBaseSpecIssuerShared` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(accessTokenLifespan: Long): Builder = Builder(accessTokenLifespan)
    }
}
