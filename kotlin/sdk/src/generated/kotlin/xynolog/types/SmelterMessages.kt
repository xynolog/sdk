// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** smelter/messages.json: the words of the Smelter's refusals, and of the messages it logs that a reader relies on. */
@Serializable
public data class SmelterMessages(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each refusal of an operation, on the operation's failure channel. */
    public val refusals: kotlin.collections.List<SmelterMessagesRefusalsItem>,
    /** Each message the Smelter logs that a reader of its output relies on. */
    public val logged: kotlin.collections.List<SmelterMessagesLoggedItem>,
) {
    /** How Java makes a `SmelterMessages`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val refusals: kotlin.collections.List<SmelterMessagesRefusalsItem>,
        private val logged: kotlin.collections.List<SmelterMessagesLoggedItem>,
    ) {
        public fun build(): SmelterMessages = SmelterMessages(comment = comment, refusals = refusals, logged = logged)
    }

    public companion object {
        /** A builder of a `SmelterMessages` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, refusals: kotlin.collections.List<SmelterMessagesRefusalsItem>, logged: kotlin.collections.List<SmelterMessagesLoggedItem>): Builder = Builder(comment, refusals, logged)
    }
}
