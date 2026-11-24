// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** settings.list's params. */
@Serializable
public data class SettingsListParams(
    /** The version of the control API the request is written to. */
    public val apiVersion: ApiVersion,
    /** A knowledge base's clone, by path or by the basename of a registered root, as --root takes it. Absent: the clone the control server was started in. */
    public val root: String? = null,
) {
    /** How Java makes a `SettingsListParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
    ) {
        private var root: String? = null

        public fun root(root: String?): Builder = apply { this.root = root }

        public fun build(): SettingsListParams = SettingsListParams(apiVersion = apiVersion, root = root)
    }

    public companion object {
        /** A builder of a `SettingsListParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion): Builder = Builder(apiVersion)
    }
}
