// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** client/connection-states.json: where a client's stream can be, and where it can move from each. */
@Serializable
public data class ClientConnectionStates(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each state, in ConnectionState's order, what it means, and the states it can move to. */
    public val states: kotlin.collections.List<ClientConnectionStatesStatesItem>,
) {
    /** How Java makes a `ClientConnectionStates`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val states: kotlin.collections.List<ClientConnectionStatesStatesItem>,
    ) {
        public fun build(): ClientConnectionStates = ClientConnectionStates(comment = comment, states = states)
    }

    public companion object {
        /** A builder of a `ClientConnectionStates` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, states: kotlin.collections.List<ClientConnectionStatesStatesItem>): Builder = Builder(comment, states)
    }
}
