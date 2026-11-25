// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A row for what befalls the stream itself. */
@Serializable
public data class ClientRefreshRefreshItemStream(
    /** `reopened`, the stream open again after a drop; or `unreadable`, an event that cannot be read. */
    public val stream: ClientRefreshRefreshItemStreamStream,
    /** Which keys the row reaches: the event's subject, or every key held. */
    public val reach: ClientRefreshRefreshItemStreamReach? = null,
    /** The queries asked again. */
    public val refetches: kotlin.collections.List<String>? = null,
    /** What it is, in prose. */
    public val docs: String,
) : ClientRefreshRefreshItem {
    /** How Java makes a `ClientRefreshRefreshItemStream`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val stream: ClientRefreshRefreshItemStreamStream,
        private val docs: String,
    ) {
        private var reach: ClientRefreshRefreshItemStreamReach? = null
        private var refetches: kotlin.collections.List<String>? = null

        public fun reach(reach: ClientRefreshRefreshItemStreamReach?): Builder = apply { this.reach = reach }
        public fun refetches(refetches: kotlin.collections.List<String>?): Builder = apply { this.refetches = refetches }

        public fun build(): ClientRefreshRefreshItemStream = ClientRefreshRefreshItemStream(stream = stream, reach = reach, refetches = refetches, docs = docs)
    }

    public companion object {
        /** A builder of a `ClientRefreshRefreshItemStream` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(stream: ClientRefreshRefreshItemStreamStream, docs: String): Builder = Builder(stream, docs)
    }
}
