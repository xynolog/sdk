// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** roots.init's params: the local directory, permanent identity, and optional configuration inputs xynolog init takes. */
@Serializable
public data class RootsInitParams(
    public val apiVersion: ApiVersion,
    /** Existing local directory in which to create the knowledge base. */
    public val path: String,
    /** The permanent did:web domain, in colon-path form, such as owner.github.io:repo. */
    public val domain: String,
    /** Project name. Absent: the directory basename. */
    public val name: String? = null,
    /** Human-readable site name. Absent: the project name. */
    public val siteName: String? = null,
    /** Inference provider for the generated local stack documents. */
    public val inference: RootsInitParamsInference? = null,
    /** The primary model bound to roles and jobs. */
    public val model: String? = null,
    /** A light model example emitted in the generated config. */
    public val modelLight: String? = null,
    /** Ollama embedding model name, without the ollama: prefix. */
    public val embedding: String? = null,
    /** Inference document name. Absent: the provider name. */
    public val configName: String? = null,
    /** Anthropic API base URL. */
    public val anthropicEndpoint: String? = null,
    /** Local Ollama API base URL. */
    public val ollamaBase: String? = null,
    /** Ollama registry base URL. */
    public val ollamaRegistry: String? = null,
) {
    /** How Java makes a `RootsInitParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
        private val path: String,
        private val domain: String,
    ) {
        private var name: String? = null
        private var siteName: String? = null
        private var inference: RootsInitParamsInference? = null
        private var model: String? = null
        private var modelLight: String? = null
        private var embedding: String? = null
        private var configName: String? = null
        private var anthropicEndpoint: String? = null
        private var ollamaBase: String? = null
        private var ollamaRegistry: String? = null

        public fun name(name: String?): Builder = apply { this.name = name }
        public fun siteName(siteName: String?): Builder = apply { this.siteName = siteName }
        public fun inference(inference: RootsInitParamsInference?): Builder = apply { this.inference = inference }
        public fun model(model: String?): Builder = apply { this.model = model }
        public fun modelLight(modelLight: String?): Builder = apply { this.modelLight = modelLight }
        public fun embedding(embedding: String?): Builder = apply { this.embedding = embedding }
        public fun configName(configName: String?): Builder = apply { this.configName = configName }
        public fun anthropicEndpoint(anthropicEndpoint: String?): Builder = apply { this.anthropicEndpoint = anthropicEndpoint }
        public fun ollamaBase(ollamaBase: String?): Builder = apply { this.ollamaBase = ollamaBase }
        public fun ollamaRegistry(ollamaRegistry: String?): Builder = apply { this.ollamaRegistry = ollamaRegistry }

        public fun build(): RootsInitParams = RootsInitParams(apiVersion = apiVersion, path = path, domain = domain, name = name, siteName = siteName, inference = inference, model = model, modelLight = modelLight, embedding = embedding, configName = configName, anthropicEndpoint = anthropicEndpoint, ollamaBase = ollamaBase, ollamaRegistry = ollamaRegistry)
    }

    public companion object {
        /** A builder of a `RootsInitParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion, path: String, domain: String): Builder = Builder(apiVersion, path, domain)
    }
}
