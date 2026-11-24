// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** gateway/messages.json: the words of the gateway's own refusals. */
@Serializable
public data class GatewayMessages(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each refusal the gateway makes itself. */
    public val messages: kotlin.collections.List<GatewayMessagesMessagesItem>,
    /** Each failure frame the gateway delivers itself, on the stream of the client whose request it answers. */
    public val failures: kotlin.collections.List<GatewayMessagesFailuresItem>,
    /** The `WWW-Authenticate` of a 401. */
    public val challenges: GatewayMessagesChallenges,
) {
    /** How Java makes a `GatewayMessages`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val messages: kotlin.collections.List<GatewayMessagesMessagesItem>,
        private val failures: kotlin.collections.List<GatewayMessagesFailuresItem>,
        private val challenges: GatewayMessagesChallenges,
    ) {
        public fun build(): GatewayMessages = GatewayMessages(comment = comment, messages = messages, failures = failures, challenges = challenges)
    }

    public companion object {
        /** A builder of a `GatewayMessages` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, messages: kotlin.collections.List<GatewayMessagesMessagesItem>, failures: kotlin.collections.List<GatewayMessagesFailuresItem>, challenges: GatewayMessagesChallenges): Builder = Builder(comment, messages, failures, challenges)
    }
}
