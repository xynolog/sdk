// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** roots.forget's params. */
@Serializable
public data class RootsForgetParams(
    /** The version of the control API the request is written to. */
    public val apiVersion: ApiVersion,
    /** The registered root to forget: its path, or its basename when only one registered root has it. */
    public val root: String,
) {
    /** How Java makes a `RootsForgetParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
        private val root: String,
    ) {
        public fun build(): RootsForgetParams = RootsForgetParams(apiVersion = apiVersion, root = root)
    }

    public companion object {
        /** A builder of a `RootsForgetParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion, root: String): Builder = Builder(apiVersion, root)
    }
}
