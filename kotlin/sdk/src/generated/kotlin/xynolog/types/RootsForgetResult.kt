// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A forgotten registry row. Only the row is removed: no file of the clone, and none of its persistent stack state. */
@Serializable
public data class RootsForgetResult(
    /** The forgotten root's path. */
    public val path: String,
    /** Whether its directory was already gone. */
    public val directoryMissing: Boolean,
    /** The key whose persistent stack state remains, when some does and no surviving root shares its DID: xynolog clean --root <key> removes it. */
    public val persistentState: String? = null,
) {
    /** How Java makes a `RootsForgetResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val path: String,
        private val directoryMissing: Boolean,
    ) {
        private var persistentState: String? = null

        public fun persistentState(persistentState: String?): Builder = apply { this.persistentState = persistentState }

        public fun build(): RootsForgetResult = RootsForgetResult(path = path, directoryMissing = directoryMissing, persistentState = persistentState)
    }

    public companion object {
        /** A builder of a `RootsForgetResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(path: String, directoryMissing: Boolean): Builder = Builder(path, directoryMissing)
    }
}
