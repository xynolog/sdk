// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A vector store somebody else runs, with the token each service presents to it: the Smelter's may make, write and delete this knowledge base's collections, and the Librarian's may read them. */
@Serializable
public data class KnowledgeIndexSpecVectorsExternal(
    /** A host name or address the stack's containers can reach. */
    public val host: String,
    /** The port its REST API listens on. */
    public val port: Long,
    public val smelterToken: SecretRef,
    public val librarianToken: SecretRef,
) {
    /** How Java makes a `KnowledgeIndexSpecVectorsExternal`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val host: String,
        private val port: Long,
        private val smelterToken: SecretRef,
        private val librarianToken: SecretRef,
    ) {
        public fun build(): KnowledgeIndexSpecVectorsExternal = KnowledgeIndexSpecVectorsExternal(host = host, port = port, smelterToken = smelterToken, librarianToken = librarianToken)
    }

    public companion object {
        /** A builder of a `KnowledgeIndexSpecVectorsExternal` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(host: String, port: Long, smelterToken: SecretRef, librarianToken: SecretRef): Builder = Builder(host, port, smelterToken, librarianToken)
    }
}
