// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** How a text is cut before it is embedded. */
@Serializable
public data class KnowledgeIndexSpecEmbeddingChunking(
    /** The size of a piece. */
    public val chunkSize: Long,
    /** How much of one piece the next repeats. */
    public val overlap: Long,
) {
    /** How Java makes a `KnowledgeIndexSpecEmbeddingChunking`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val chunkSize: Long,
        private val overlap: Long,
    ) {
        public fun build(): KnowledgeIndexSpecEmbeddingChunking = KnowledgeIndexSpecEmbeddingChunking(chunkSize = chunkSize, overlap = overlap)
    }

    public companion object {
        /** A builder of a `KnowledgeIndexSpecEmbeddingChunking` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(chunkSize: Long, overlap: Long): Builder = Builder(chunkSize, overlap)
    }
}
