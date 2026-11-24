// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class SmelterMessagesLoggedItem(
    /** The situation's name. */
    public val name: String,
    public val level: LogLevel,
    /** When it is written, what fills each `{name}` of its fields, and what each fact it carries says. */
    public val situation: String,
    /** The line's message, word for word. */
    public val message: String,
    /** The facts the line is logged with whose form is stated, by name: each a text whose `{name}` is filled as the row's `situation` says. A fact that is a number is its decimal digits. */
    public val fields: kotlin.collections.Map<String, String>,
    /** The facts the line is logged with beside `fields`, whose value the row's `situation` says and whose form is not stated. The line may carry others. */
    public val carries: kotlin.collections.List<String>,
) {
    /** How Java makes a `SmelterMessagesLoggedItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val level: LogLevel,
        private val situation: String,
        private val message: String,
        private val fields: kotlin.collections.Map<String, String>,
        private val carries: kotlin.collections.List<String>,
    ) {
        public fun build(): SmelterMessagesLoggedItem = SmelterMessagesLoggedItem(name = name, level = level, situation = situation, message = message, fields = fields, carries = carries)
    }

    public companion object {
        /** A builder of a `SmelterMessagesLoggedItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, level: LogLevel, situation: String, message: String, fields: kotlin.collections.Map<String, String>, carries: kotlin.collections.List<String>): Builder = Builder(name, level, situation, message, fields, carries)
    }
}
