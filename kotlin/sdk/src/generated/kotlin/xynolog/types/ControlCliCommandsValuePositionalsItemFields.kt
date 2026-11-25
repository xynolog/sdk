// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** An operand that becomes params fields. */
@Serializable
public data class ControlCliCommandsValuePositionalsItemFields(
    /** The operand, as its usage writes it. */
    public val name: String,
    /** The params fields it becomes, each `<method>.<field path>`. */
    public val fields: kotlin.collections.List<String>,
) : ControlCliCommandsValuePositionalsItem {
    /** How Java makes a `ControlCliCommandsValuePositionalsItemFields`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val fields: kotlin.collections.List<String>,
    ) {
        public fun build(): ControlCliCommandsValuePositionalsItemFields = ControlCliCommandsValuePositionalsItemFields(name = name, fields = fields)
    }

    public companion object {
        /** A builder of a `ControlCliCommandsValuePositionalsItemFields` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, fields: kotlin.collections.List<String>): Builder = Builder(name, fields)
    }
}
