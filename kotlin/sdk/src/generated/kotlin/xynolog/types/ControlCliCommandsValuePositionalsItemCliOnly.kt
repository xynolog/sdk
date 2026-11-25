// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** An operand the API has no place for. */
@Serializable
public data class ControlCliCommandsValuePositionalsItemCliOnly(
    /** The operand, as its usage writes it. */
    public val name: String,
    /** Why it has no place in the API. */
    public val cliOnly: String,
) : ControlCliCommandsValuePositionalsItem {
    /** How Java makes a `ControlCliCommandsValuePositionalsItemCliOnly`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val cliOnly: String,
    ) {
        public fun build(): ControlCliCommandsValuePositionalsItemCliOnly = ControlCliCommandsValuePositionalsItemCliOnly(name = name, cliOnly = cliOnly)
    }

    public companion object {
        /** A builder of a `ControlCliCommandsValuePositionalsItemCliOnly` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, cliOnly: String): Builder = Builder(name, cliOnly)
    }
}
