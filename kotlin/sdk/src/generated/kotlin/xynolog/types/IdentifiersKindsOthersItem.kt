// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class IdentifiersKindsOthersItem(
    /** A property named like an id. */
    public val property: String,
    /** What it carries instead. */
    public val docs: String,
) {
    /** How Java makes a `IdentifiersKindsOthersItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val property: String,
        private val docs: String,
    ) {
        public fun build(): IdentifiersKindsOthersItem = IdentifiersKindsOthersItem(property = property, docs = docs)
    }

    public companion object {
        /** A builder of a `IdentifiersKindsOthersItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(property: String, docs: String): Builder = Builder(property, docs)
    }
}
