// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The local directory where xynolog init created and registered the knowledge base. */
@Serializable
public data class RootsInitResult(
    public val path: String,
) {
    /** How Java makes a `RootsInitResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val path: String,
    ) {
        public fun build(): RootsInitResult = RootsInitResult(path = path)
    }

    public companion object {
        /** A builder of a `RootsInitResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(path: String): Builder = Builder(path)
    }
}
