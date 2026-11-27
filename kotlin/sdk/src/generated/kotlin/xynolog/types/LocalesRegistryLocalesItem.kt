// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class LocalesRegistryLocalesItem(
    /** The language's code, which names its translation files and its place in a URL. */
    public val code: String,
    /** What the language calls itself. */
    public val nativeName: String,
    /** What a model is told a text is written in. */
    public val englishName: String,
) {
    /** How Java makes a `LocalesRegistryLocalesItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val code: String,
        private val nativeName: String,
        private val englishName: String,
    ) {
        public fun build(): LocalesRegistryLocalesItem = LocalesRegistryLocalesItem(code = code, nativeName = nativeName, englishName = englishName)
    }

    public companion object {
        /** A builder of a `LocalesRegistryLocalesItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(code: String, nativeName: String, englishName: String): Builder = Builder(code, nativeName, englishName)
    }
}
