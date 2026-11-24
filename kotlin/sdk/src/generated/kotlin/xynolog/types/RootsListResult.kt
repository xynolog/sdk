// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Every knowledge base this machine knows, as xynolog roots lists them: the local roots first, then the codespace stacks. */
@Serializable
public data class RootsListResult(
    /** Each root. */
    public val roots: kotlin.collections.List<Root>,
    /** What xynolog roots warns of without failing: an invalid XYNOLOG_ROOT, a clone whose project file is refused. */
    public val warnings: kotlin.collections.List<String>? = null,
) {
    /** How Java makes a `RootsListResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val roots: kotlin.collections.List<Root>,
    ) {
        private var warnings: kotlin.collections.List<String>? = null

        public fun warnings(warnings: kotlin.collections.List<String>?): Builder = apply { this.warnings = warnings }

        public fun build(): RootsListResult = RootsListResult(roots = roots, warnings = warnings)
    }

    public companion object {
        /** A builder of a `RootsListResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(roots: kotlin.collections.List<Root>): Builder = Builder(roots)
    }
}
