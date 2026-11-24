// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class SmelterMessagesRefusalsItem(
    /** The situation's name. */
    public val name: String,
    /** The operation it refuses: a request of bus/registry.json's operations that the Smelter answers. */
    public val operation: String,
    /** When it is written, and what fills each `{name}` of its text. */
    public val situation: String,
    /** The failure's `message`. A `{name}` in it is filled with what the row's `situation` names, and nothing else in it varies. */
    public val message: String,
) {
    /** How Java makes a `SmelterMessagesRefusalsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val operation: String,
        private val situation: String,
        private val message: String,
    ) {
        public fun build(): SmelterMessagesRefusalsItem = SmelterMessagesRefusalsItem(name = name, operation = operation, situation = situation, message = message)
    }

    public companion object {
        /** A builder of a `SmelterMessagesRefusalsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, operation: String, situation: String, message: String): Builder = Builder(name, operation, situation, message)
    }
}
