// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** An option that becomes params fields. */
@Serializable
public data class ControlCliCommandsValueFlagsValueFields(
    /** The params fields it becomes, each `<method>.<field path>`. */
    public val fields: kotlin.collections.List<String>,
    /** What else a reader of the row must know. */
    public val notes: String? = null,
) : ControlCliCommandsValueFlagsValue {
    /** How Java makes a `ControlCliCommandsValueFlagsValueFields`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val fields: kotlin.collections.List<String>,
    ) {
        private var notes: String? = null

        public fun notes(notes: String?): Builder = apply { this.notes = notes }

        public fun build(): ControlCliCommandsValueFlagsValueFields = ControlCliCommandsValueFlagsValueFields(fields = fields, notes = notes)
    }

    public companion object {
        /** A builder of a `ControlCliCommandsValueFlagsValueFields` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(fields: kotlin.collections.List<String>): Builder = Builder(fields)
    }
}
