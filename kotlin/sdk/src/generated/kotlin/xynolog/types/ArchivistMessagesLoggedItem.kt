// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ArchivistMessagesLoggedItem(
    /** The situation's name. */
    public val name: String,
    public val level: LogLevel,
    /** When it is written, and what fills each `{name}` of its text. */
    public val situation: String,
    /** The line's message, word for word. */
    public val message: String,
    /** The fields the line is logged with whose form is stated, by name: each a text whose `{name}` is filled as the row's `situation` says. The line may carry others. */
    public val fields: kotlin.collections.Map<String, String>,
) {
    /** How Java makes a `ArchivistMessagesLoggedItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val level: LogLevel,
        private val situation: String,
        private val message: String,
        private val fields: kotlin.collections.Map<String, String>,
    ) {
        public fun build(): ArchivistMessagesLoggedItem = ArchivistMessagesLoggedItem(name = name, level = level, situation = situation, message = message, fields = fields)
    }

    public companion object {
        /** A builder of a `ArchivistMessagesLoggedItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, level: LogLevel, situation: String, message: String, fields: kotlin.collections.Map<String, String>): Builder = Builder(name, level, situation, message, fields)
    }
}
