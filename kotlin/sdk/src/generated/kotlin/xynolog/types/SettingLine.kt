// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One value of a setting, and where it came from, as xynolog settings shows it. A secret's value is never one: a secret setting shows where the value is kept. */
@Serializable
public data class SettingLine(
    /** The value in effect. */
    public val value: String,
    /** Where it came from: a record, a document, the default. */
    public val source: String,
) {
    /** How Java makes a `SettingLine`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val value: String,
        private val source: String,
    ) {
        public fun build(): SettingLine = SettingLine(value = value, source = source)
    }

    public companion object {
        /** A builder of a `SettingLine` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(value: String, source: String): Builder = Builder(value, source)
    }
}
