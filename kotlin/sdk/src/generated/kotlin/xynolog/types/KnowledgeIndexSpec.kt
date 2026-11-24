// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The indexes, the services that keep and read them, and the knowledge base they index. */
@Serializable
public data class KnowledgeIndexSpec(
    /** The name of the KnowledgeBase document whose record this indexes. */
    public val knowledgeBase: String,
    public val logLevel: LogLevel,
    /** The graph store the Weaver writes and the Librarian reads. The knowledge base's graph is in the database its DID names (specs/src/graph/database-cases.json): a Neo4j the launcher runs makes it when it first starts, and one somebody else runs must already hold it. */
    public val graph: KnowledgeIndexSpecGraph,
    /** The vector store the Smelter writes and the Librarian reads: the one the launcher runs for the knowledge bases on a machine, at `shared`; one of the knowledge base's own the launcher runs, from `image` with `resources`; or somebody else's, at `external`. Exactly one of the three. */
    public val vectors: KnowledgeIndexSpecVectors,
    /** The model that turns text into vectors. Vectors made by one model are not comparable with another's, so the model is the index's. */
    public val embedding: KnowledgeIndexSpecEmbedding,
    /** The Librarian: it answers gathers and searches from the indexes. */
    public val librarian: KnowledgeIndexSpecLibrarian,
    /** The Smelter: it writes the vectors and the anchored text. */
    public val smelter: KnowledgeIndexSpecSmelter,
    /** The Weaver: it writes the graph. */
    public val weaver: KnowledgeIndexSpecWeaver,
) {
    /** How Java makes a `KnowledgeIndexSpec`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val knowledgeBase: String,
        private val logLevel: LogLevel,
        private val graph: KnowledgeIndexSpecGraph,
        private val vectors: KnowledgeIndexSpecVectors,
        private val embedding: KnowledgeIndexSpecEmbedding,
        private val librarian: KnowledgeIndexSpecLibrarian,
        private val smelter: KnowledgeIndexSpecSmelter,
        private val weaver: KnowledgeIndexSpecWeaver,
    ) {
        public fun build(): KnowledgeIndexSpec = KnowledgeIndexSpec(knowledgeBase = knowledgeBase, logLevel = logLevel, graph = graph, vectors = vectors, embedding = embedding, librarian = librarian, smelter = smelter, weaver = weaver)
    }

    public companion object {
        /** A builder of a `KnowledgeIndexSpec` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(knowledgeBase: String, logLevel: LogLevel, graph: KnowledgeIndexSpecGraph, vectors: KnowledgeIndexSpecVectors, embedding: KnowledgeIndexSpecEmbedding, librarian: KnowledgeIndexSpecLibrarian, smelter: KnowledgeIndexSpecSmelter, weaver: KnowledgeIndexSpecWeaver): Builder = Builder(knowledgeBase, logLevel, graph, vectors, embedding, librarian, smelter, weaver)
    }
}
