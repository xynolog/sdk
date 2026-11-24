// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** settings.get's params. */
@Serializable
public data class SettingsGetParams(
    /** The version of the control API the request is written to. */
    public val apiVersion: ApiVersion,
    /** The setting, as xynolog settings names it. */
    public val name: String,
    /** The machine-wide form of a knowledge-base setting: --default. */
    public val default: Boolean? = null,
    /** A knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the clone the control server was started in. */
    public val root: String? = null,
) {
    /** How Java makes a `SettingsGetParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
        private val name: String,
    ) {
        private var default: Boolean? = null
        private var root: String? = null

        public fun default(default: Boolean?): Builder = apply { this.default = default }
        public fun root(root: String?): Builder = apply { this.root = root }

        public fun build(): SettingsGetParams = SettingsGetParams(apiVersion = apiVersion, name = name, default = default, root = root)
    }

    public companion object {
        /** A builder of a `SettingsGetParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion, name: String): Builder = Builder(apiVersion, name)
    }
}
