// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The issuer the knowledge base trusts: the one the launcher runs for the knowledge bases on a machine, at `shared`, with the knowledge base's own realm in it, or somebody else's, at `external`. */
@Serializable
public data class StackKnowledgeBaseSpecIssuer(
    /** The issuer the launcher runs for the knowledge bases on a machine (the state home's Issuer document). The launcher creates the knowledge base's realm in it. */
    public val shared: StackKnowledgeBaseSpecIssuerShared? = null,
    /** An issuer somebody else runs. */
    public val external: StackKnowledgeBaseSpecIssuerExternal? = null,
    /** The claim a person's DID is built from: did:web:<site domain>:users:<its value>. */
    public val subjectClaim: String,
) {
    /** How Java makes a `StackKnowledgeBaseSpecIssuer`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val subjectClaim: String,
    ) {
        private var shared: StackKnowledgeBaseSpecIssuerShared? = null
        private var external: StackKnowledgeBaseSpecIssuerExternal? = null

        public fun shared(shared: StackKnowledgeBaseSpecIssuerShared?): Builder = apply { this.shared = shared }
        public fun external(external: StackKnowledgeBaseSpecIssuerExternal?): Builder = apply { this.external = external }

        public fun build(): StackKnowledgeBaseSpecIssuer = StackKnowledgeBaseSpecIssuer(shared = shared, external = external, subjectClaim = subjectClaim)
    }

    public companion object {
        /** A builder of a `StackKnowledgeBaseSpecIssuer` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(subjectClaim: String): Builder = Builder(subjectClaim)
    }
}
