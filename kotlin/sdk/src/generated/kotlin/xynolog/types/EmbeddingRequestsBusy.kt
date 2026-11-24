// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A request for the vectors of documents that the provider answers busy is asked again, after each wait in turn, while the request's own time allows the wait. A provider busy at every asking fails the request with that status. A query is asked once. */
@Serializable
public data class EmbeddingRequestsBusy(
    /** The statuses by which a provider says it is busy. */
    public val statuses: kotlin.collections.List<Long>,
    /** The wait before each asking again, in order. */
    public val againAfterSeconds: kotlin.collections.List<Long>,
) {
    /** How Java makes a `EmbeddingRequestsBusy`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val statuses: kotlin.collections.List<Long>,
        private val againAfterSeconds: kotlin.collections.List<Long>,
    ) {
        public fun build(): EmbeddingRequestsBusy = EmbeddingRequestsBusy(statuses = statuses, againAfterSeconds = againAfterSeconds)
    }

    public companion object {
        /** A builder of a `EmbeddingRequestsBusy` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(statuses: kotlin.collections.List<Long>, againAfterSeconds: kotlin.collections.List<Long>): Builder = Builder(statuses, againAfterSeconds)
    }
}
