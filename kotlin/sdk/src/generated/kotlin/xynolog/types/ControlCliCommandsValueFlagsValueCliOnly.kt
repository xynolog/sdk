// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** An option the API has no place for. */
@Serializable
public data class ControlCliCommandsValueFlagsValueCliOnly(
    /** Why it has no place in the API. */
    public val cliOnly: String,
) : ControlCliCommandsValueFlagsValue {
    /** How Java makes a `ControlCliCommandsValueFlagsValueCliOnly`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val cliOnly: String,
    ) {
        public fun build(): ControlCliCommandsValueFlagsValueCliOnly = ControlCliCommandsValueFlagsValueCliOnly(cliOnly = cliOnly)
    }

    public companion object {
        /** A builder of a `ControlCliCommandsValueFlagsValueCliOnly` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(cliOnly: String): Builder = Builder(cliOnly)
    }
}
