// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class EmbeddingRequestsProvidersValue(
    /** How many texts one request carries, at most: a batch is cut into slices of this many, each one request, in the order of the texts. */
    public val textsPerRequest: Long,
    /** How many requests are made of the provider at once, however many resources are being indexed. */
    public val atOnce: Long,
) {
    /** How Java makes a `EmbeddingRequestsProvidersValue`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val textsPerRequest: Long,
        private val atOnce: Long,
    ) {
        public fun build(): EmbeddingRequestsProvidersValue = EmbeddingRequestsProvidersValue(textsPerRequest = textsPerRequest, atOnce = atOnce)
    }

    public companion object {
        /** A builder of a `EmbeddingRequestsProvidersValue` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(textsPerRequest: Long, atOnce: Long): Builder = Builder(textsPerRequest, atOnce)
    }
}
