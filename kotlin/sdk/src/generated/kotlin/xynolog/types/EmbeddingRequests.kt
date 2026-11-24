// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** embedding/requests.json: how a service asks its embedding provider for the vectors of many texts. */
@Serializable
public data class EmbeddingRequests(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** How each kind of provider is asked, by its `type` (EmbeddingConfig): every kind, and no other. */
    public val providers: kotlin.collections.Map<String, EmbeddingRequestsProvidersValue>,
    /** How long each request has, counted from when it is sent and not from when its batch began. Asking a busy provider again is within it. */
    public val requestSeconds: Long,
    /** A request for the vectors of documents that the provider answers busy is asked again, after each wait in turn, while the request's own time allows the wait. A provider busy at every asking fails the request with that status. A query is asked once. */
    public val busy: EmbeddingRequestsBusy,
    /** How many times, at most, a starting service asks again a provider that answered 404, taken to be still fetching the model, or could not be reached, taken to be still starting: within the time the service has to start. */
    public val startAgain: Long,
) {
    /** How Java makes a `EmbeddingRequests`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val providers: kotlin.collections.Map<String, EmbeddingRequestsProvidersValue>,
        private val requestSeconds: Long,
        private val busy: EmbeddingRequestsBusy,
        private val startAgain: Long,
    ) {
        public fun build(): EmbeddingRequests = EmbeddingRequests(comment = comment, providers = providers, requestSeconds = requestSeconds, busy = busy, startAgain = startAgain)
    }

    public companion object {
        /** A builder of a `EmbeddingRequests` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, providers: kotlin.collections.Map<String, EmbeddingRequestsProvidersValue>, requestSeconds: Long, busy: EmbeddingRequestsBusy, startAgain: Long): Builder = Builder(comment, providers, requestSeconds, busy, startAgain)
    }
}
