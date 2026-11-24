// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One setting the launcher keeps, as xynolog settings shows it. */
@Serializable
public data class Setting(
    /** Its name, as xynolog settings takes it. */
    public val name: String,
    /** Whether this is the machine-wide form of a knowledge-base setting (secret-store --default). */
    public val default: Boolean,
    /** What it applies to: every knowledge base on this machine, or one. */
    public val appliesTo: SettingAppliesTo,
    /** The values in effect, one per line xynolog settings shows. */
    public val values: kotlin.collections.List<SettingLine>,
    /** Whether settings.set and settings.unset change it. */
    public val settable: Boolean,
    /** For one they do not: how it is changed instead. */
    public val changedBy: String? = null,
) {
    /** How Java makes a `Setting`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val default: Boolean,
        private val appliesTo: SettingAppliesTo,
        private val values: kotlin.collections.List<SettingLine>,
        private val settable: Boolean,
    ) {
        private var changedBy: String? = null

        public fun changedBy(changedBy: String?): Builder = apply { this.changedBy = changedBy }

        public fun build(): Setting = Setting(name = name, default = default, appliesTo = appliesTo, values = values, settable = settable, changedBy = changedBy)
    }

    public companion object {
        /** A builder of a `Setting` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, default: Boolean, appliesTo: SettingAppliesTo, values: kotlin.collections.List<SettingLine>, settable: Boolean): Builder = Builder(name, default, appliesTo, values, settable)
    }
}
