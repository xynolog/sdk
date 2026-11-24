// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The model that turns text into vectors. Vectors made by one model are not comparable with another's, so the model is the index's. */
@Serializable
public data class KnowledgeIndexSpecEmbedding(
    /** Who serves the model: `ollama`, or `voyage`. */
    public val type: String,
    /** The model, as its provider names it. */
    public val model: String,
    /** How a text is cut before it is embedded. */
    public val chunking: KnowledgeIndexSpecEmbeddingChunking,
    /** Where the provider's API is reached. The shared Ollama is stated by no endpoint. */
    public val endpoint: String? = null,
    public val apiKey: SecretRef? = null,
) {
    /** How Java makes a `KnowledgeIndexSpecEmbedding`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val type: String,
        private val model: String,
        private val chunking: KnowledgeIndexSpecEmbeddingChunking,
    ) {
        private var endpoint: String? = null
        private var apiKey: SecretRef? = null

        public fun endpoint(endpoint: String?): Builder = apply { this.endpoint = endpoint }
        public fun apiKey(apiKey: SecretRef?): Builder = apply { this.apiKey = apiKey }

        public fun build(): KnowledgeIndexSpecEmbedding = KnowledgeIndexSpecEmbedding(type = type, model = model, chunking = chunking, endpoint = endpoint, apiKey = apiKey)
    }

    public companion object {
        /** A builder of a `KnowledgeIndexSpecEmbedding` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(type: String, model: String, chunking: KnowledgeIndexSpecEmbeddingChunking): Builder = Builder(type, model, chunking)
    }
}
