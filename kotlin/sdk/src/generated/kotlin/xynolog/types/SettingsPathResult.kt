// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Where a machine document is. When there is none, it is written from the launcher's catalog first, as a start writes it; one that does not hold is refused, as a start refuses it. */
@Serializable
public data class SettingsPathResult(
    /** The document's path. */
    public val path: String,
) {
    /** How Java makes a `SettingsPathResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val path: String,
    ) {
        public fun build(): SettingsPathResult = SettingsPathResult(path = path)
    }

    public companion object {
        /** A builder of a `SettingsPathResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(path: String): Builder = Builder(path)
    }
}
