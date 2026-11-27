// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ClientConnectionStatesStatesItem(
    public val state: ConnectionState,
    /** What the state is, in prose. */
    public val meaning: String,
    /** The states it can move to, in ConnectionState's order; none for a terminal state. */
    public val moves: kotlin.collections.List<ConnectionState>,
) {
    /** How Java makes a `ClientConnectionStatesStatesItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val state: ConnectionState,
        private val meaning: String,
        private val moves: kotlin.collections.List<ConnectionState>,
    ) {
        public fun build(): ClientConnectionStatesStatesItem = ClientConnectionStatesStatesItem(state = state, meaning = meaning, moves = moves)
    }

    public companion object {
        /** A builder of a `ClientConnectionStatesStatesItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(state: ConnectionState, meaning: String, moves: kotlin.collections.List<ConnectionState>): Builder = Builder(state, meaning, moves)
    }
}
