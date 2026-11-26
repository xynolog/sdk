// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** An option that selects a method. */
@Serializable
public data class ControlCliCommandsValueFlagsValueMethod(
    /** The method's name. */
    public val method: String,
) : ControlCliCommandsValueFlagsValue {
    /** How Java makes a `ControlCliCommandsValueFlagsValueMethod`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val method: String,
    ) {
        public fun build(): ControlCliCommandsValueFlagsValueMethod = ControlCliCommandsValueFlagsValueMethod(method = method)
    }

    public companion object {
        /** A builder of a `ControlCliCommandsValueFlagsValueMethod` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(method: String): Builder = Builder(method)
    }
}
