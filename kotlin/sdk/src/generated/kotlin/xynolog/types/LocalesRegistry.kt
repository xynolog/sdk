// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** locales/registry.json: the languages Xynolog supports. */
@Serializable
public data class LocalesRegistry(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    public val locales: kotlin.collections.List<LocalesRegistryLocalesItem>,
) {
    /** How Java makes a `LocalesRegistry`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val locales: kotlin.collections.List<LocalesRegistryLocalesItem>,
    ) {
        public fun build(): LocalesRegistry = LocalesRegistry(comment = comment, locales = locales)
    }

    public companion object {
        /** A builder of a `LocalesRegistry` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, locales: kotlin.collections.List<LocalesRegistryLocalesItem>): Builder = Builder(comment, locales)
    }
}
