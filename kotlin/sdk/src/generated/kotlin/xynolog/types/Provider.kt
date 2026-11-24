// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** How an inference provider is reached. */
@Serializable
public data class Provider(
    /** Where the provider's API is reached. Anthropic's own API, and the shared Ollama, are stated by no baseURL. */
    public val baseURL: String? = null,
    public val apiKey: SecretRef? = null,
) {
    /** How Java makes a `Provider`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor() {
        private var baseURL: String? = null
        private var apiKey: SecretRef? = null

        public fun baseURL(baseURL: String?): Builder = apply { this.baseURL = baseURL }
        public fun apiKey(apiKey: SecretRef?): Builder = apply { this.apiKey = apiKey }

        public fun build(): Provider = Provider(baseURL = baseURL, apiKey = apiKey)
    }

    public companion object {
        /** A builder of a `Provider` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(): Builder = Builder()
    }
}
