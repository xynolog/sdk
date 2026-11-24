// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The vector store the Smelter writes and the Librarian reads: the one the launcher runs for the knowledge bases on a machine, at `shared`; one of the knowledge base's own the launcher runs, from `image` with `resources`; or somebody else's, at `external`. Exactly one of the three. */
@Serializable
public data class KnowledgeIndexSpecVectors(
    /** The vector store's driver: `qdrant`. */
    public val type: String,
    /** The vector store the launcher runs for the knowledge bases on a machine (the state home's VectorStore document). Each knowledge base keeps its index in collections of its own there, so nothing is said of it here. */
    public val shared: EmptyObject? = null,
    public val image: Image? = null,
    public val resources: Resources? = null,
    /** A vector store somebody else runs, with the token each service presents to it: the Smelter's may make, write and delete this knowledge base's collections, and the Librarian's may read them. */
    public val external: KnowledgeIndexSpecVectorsExternal? = null,
) {
    /** How Java makes a `KnowledgeIndexSpecVectors`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val type: String,
    ) {
        private var shared: EmptyObject? = null
        private var image: Image? = null
        private var resources: Resources? = null
        private var external: KnowledgeIndexSpecVectorsExternal? = null

        public fun shared(shared: EmptyObject?): Builder = apply { this.shared = shared }
        public fun image(image: Image?): Builder = apply { this.image = image }
        public fun resources(resources: Resources?): Builder = apply { this.resources = resources }
        public fun external(external: KnowledgeIndexSpecVectorsExternal?): Builder = apply { this.external = external }

        public fun build(): KnowledgeIndexSpecVectors = KnowledgeIndexSpecVectors(type = type, shared = shared, image = image, resources = resources, external = external)
    }

    public companion object {
        /** A builder of a `KnowledgeIndexSpecVectors` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(type: String): Builder = Builder(type)
    }
}
