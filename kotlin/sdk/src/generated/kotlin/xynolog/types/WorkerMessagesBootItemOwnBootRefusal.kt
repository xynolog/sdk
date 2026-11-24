// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class WorkerMessagesBootItemOwnBootRefusal(
    /** The situation's name. */
    public val name: String,
    /** When it is written, and what fills each `{name}` of its text. */
    public val situation: String,
    /** The refusal, in place of the line's `{refusal}`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies. */
    public val refusal: String,
) : WorkerMessagesBootItem {
    /** How Java makes a `WorkerMessagesBootItemOwnBootRefusal`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val situation: String,
        private val refusal: String,
    ) {
        public fun build(): WorkerMessagesBootItemOwnBootRefusal = WorkerMessagesBootItemOwnBootRefusal(name = name, situation = situation, refusal = refusal)
    }

    public companion object {
        /** A builder of a `WorkerMessagesBootItemOwnBootRefusal` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, situation: String, refusal: String): Builder = Builder(name, situation, refusal)
    }
}
