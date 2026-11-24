// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The graph store the Weaver writes and the Librarian reads. The knowledge base's graph is in the database its DID names (specs/src/graph/database-cases.json): a Neo4j the launcher runs makes it when it first starts, and one somebody else runs must already hold it. */
@Serializable
public data class KnowledgeIndexSpecGraph(
    /** The graph store's driver: `neo4j`. */
    public val type: String,
    /** The user the services sign in to the store as. */
    public val username: String,
    public val image: Image? = null,
    public val resources: Resources? = null,
    /** A graph store somebody else runs. */
    public val external: KnowledgeIndexSpecGraphExternal? = null,
) {
    /** How Java makes a `KnowledgeIndexSpecGraph`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val type: String,
        private val username: String,
    ) {
        private var image: Image? = null
        private var resources: Resources? = null
        private var external: KnowledgeIndexSpecGraphExternal? = null

        public fun image(image: Image?): Builder = apply { this.image = image }
        public fun resources(resources: Resources?): Builder = apply { this.resources = resources }
        public fun external(external: KnowledgeIndexSpecGraphExternal?): Builder = apply { this.external = external }

        public fun build(): KnowledgeIndexSpecGraph = KnowledgeIndexSpecGraph(type = type, username = username, image = image, resources = resources, external = external)
    }

    public companion object {
        /** A builder of a `KnowledgeIndexSpecGraph` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(type: String, username: String): Builder = Builder(type, username)
    }
}
