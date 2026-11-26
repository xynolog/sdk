// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class IdentifiersKindsKindsItemAcceptsItem(
    /** A string the kind's rule is asked about. */
    public val id: String,
    /** What the case shows, in prose. */
    public val why: String,
) {
    /** How Java makes a `IdentifiersKindsKindsItemAcceptsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val id: String,
        private val why: String,
    ) {
        public fun build(): IdentifiersKindsKindsItemAcceptsItem = IdentifiersKindsKindsItemAcceptsItem(id = id, why = why)
    }

    public companion object {
        /** A builder of a `IdentifiersKindsKindsItemAcceptsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(id: String, why: String): Builder = Builder(id, why)
    }
}
