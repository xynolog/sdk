// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** bus/reply-bounds.json: each list or map an operation's reply carries that its own schema does not bound, and what bounds it. */
@Serializable
public data class BusReplyBounds(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each operation, by its request's channel. */
    public val replies: kotlin.collections.Map<String, kotlin.collections.Map<String, BusReplyBoundsRepliesValueValue>>,
) {
    /** How Java makes a `BusReplyBounds`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val replies: kotlin.collections.Map<String, kotlin.collections.Map<String, BusReplyBoundsRepliesValueValue>>,
    ) {
        public fun build(): BusReplyBounds = BusReplyBounds(comment = comment, replies = replies)
    }

    public companion object {
        /** A builder of a `BusReplyBounds` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, replies: kotlin.collections.Map<String, kotlin.collections.Map<String, BusReplyBoundsRepliesValueValue>>): Builder = Builder(comment, replies)
    }
}
