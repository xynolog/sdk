// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A graph store somebody else runs. */
@Serializable
public data class KnowledgeIndexSpecGraphExternal(
    /** Where it listens: `bolt://host:port`. */
    public val uri: String,
    public val password: SecretRef,
) {
    /** How Java makes a `KnowledgeIndexSpecGraphExternal`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val uri: String,
        private val password: SecretRef,
    ) {
        public fun build(): KnowledgeIndexSpecGraphExternal = KnowledgeIndexSpecGraphExternal(uri = uri, password = password)
    }

    public companion object {
        /** A builder of a `KnowledgeIndexSpecGraphExternal` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(uri: String, password: SecretRef): Builder = Builder(uri, password)
    }
}
