// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** control/cli.json: every option of the launcher commands the control API covers, and what it is in the API. */
@Serializable
public data class ControlCli(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each command, by its name. */
    public val commands: kotlin.collections.Map<String, ControlCliCommandsValue>,
) {
    /** How Java makes a `ControlCli`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val commands: kotlin.collections.Map<String, ControlCliCommandsValue>,
    ) {
        public fun build(): ControlCli = ControlCli(comment = comment, commands = commands)
    }

    public companion object {
        /** A builder of a `ControlCli` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, commands: kotlin.collections.Map<String, ControlCliCommandsValue>): Builder = Builder(comment, commands)
    }
}
