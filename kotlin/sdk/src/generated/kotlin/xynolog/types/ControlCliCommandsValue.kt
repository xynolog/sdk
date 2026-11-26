// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A command. */
@Serializable
public data class ControlCliCommandsValue(
    /** The Go function in cli/internal/launcher whose switch reads the command's options. */
    public val parser: String,
    /** The method's name. */
    public val method: String,
    /** The command's operands, which no switch reads by name. */
    public val positionals: kotlin.collections.List<ControlCliCommandsValuePositionalsItem>? = null,
    /** Each option, by its flag. */
    public val flags: kotlin.collections.Map<String, ControlCliCommandsValueFlagsValue>,
) {
    /** How Java makes a `ControlCliCommandsValue`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val parser: String,
        private val method: String,
        private val flags: kotlin.collections.Map<String, ControlCliCommandsValueFlagsValue>,
    ) {
        private var positionals: kotlin.collections.List<ControlCliCommandsValuePositionalsItem>? = null

        public fun positionals(positionals: kotlin.collections.List<ControlCliCommandsValuePositionalsItem>?): Builder = apply { this.positionals = positionals }

        public fun build(): ControlCliCommandsValue = ControlCliCommandsValue(parser = parser, method = method, positionals = positionals, flags = flags)
    }

    public companion object {
        /** A builder of a `ControlCliCommandsValue` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(parser: String, method: String, flags: kotlin.collections.Map<String, ControlCliCommandsValueFlagsValue>): Builder = Builder(parser, method, flags)
    }
}
