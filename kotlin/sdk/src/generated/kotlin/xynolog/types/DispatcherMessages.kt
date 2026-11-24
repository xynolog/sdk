// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** dispatcher/messages.json: the words of the dispatcher's own refusals, and of the errors it writes into a job. */
@Serializable
public data class DispatcherMessages(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each refusal the dispatcher makes itself, on the operation's failure channel. */
    public val refusals: kotlin.collections.List<DispatcherMessagesRefusalsItem>,
    /** Each error the dispatcher writes into a job on its own, as a `job:fail` would. */
    public val errors: kotlin.collections.List<DispatcherMessagesErrorsItem>,
) {
    /** How Java makes a `DispatcherMessages`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val refusals: kotlin.collections.List<DispatcherMessagesRefusalsItem>,
        private val errors: kotlin.collections.List<DispatcherMessagesErrorsItem>,
    ) {
        public fun build(): DispatcherMessages = DispatcherMessages(comment = comment, refusals = refusals, errors = errors)
    }

    public companion object {
        /** A builder of a `DispatcherMessages` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, refusals: kotlin.collections.List<DispatcherMessagesRefusalsItem>, errors: kotlin.collections.List<DispatcherMessagesErrorsItem>): Builder = Builder(comment, refusals, errors)
    }
}
