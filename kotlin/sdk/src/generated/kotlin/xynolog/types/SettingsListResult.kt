// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Every setting the launcher keeps: the machine's, then the knowledge base's. */
@Serializable
public data class SettingsListResult(
    /** The knowledge base whose settings are listed, when one resolved. */
    public val root: String? = null,
    /** Why no knowledge base resolved, when none did: its settings are not listed. */
    public val unresolved: String? = null,
    /** Each setting. */
    public val settings: kotlin.collections.List<Setting>,
) {
    /** How Java makes a `SettingsListResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val settings: kotlin.collections.List<Setting>,
    ) {
        private var root: String? = null
        private var unresolved: String? = null

        public fun root(root: String?): Builder = apply { this.root = root }
        public fun unresolved(unresolved: String?): Builder = apply { this.unresolved = unresolved }

        public fun build(): SettingsListResult = SettingsListResult(root = root, unresolved = unresolved, settings = settings)
    }

    public companion object {
        /** A builder of a `SettingsListResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(settings: kotlin.collections.List<Setting>): Builder = Builder(settings)
    }
}
