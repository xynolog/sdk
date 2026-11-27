// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class IdentifiersKindsKindsItem(
    /** The component under components/schemas that states the kind, by name. */
    public val schema: String,
    /** The property names that always carry the kind. */
    public val properties: kotlin.collections.List<String>,
    /** Strings the kind's rule takes. */
    public val accepts: kotlin.collections.List<IdentifiersKindsKindsItemAcceptsItem>,
    /** Strings the kind's rule does not take. */
    public val refuses: kotlin.collections.List<IdentifiersKindsKindsItemAcceptsItem>,
) {
    /** How Java makes a `IdentifiersKindsKindsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val schema: String,
        private val properties: kotlin.collections.List<String>,
        private val accepts: kotlin.collections.List<IdentifiersKindsKindsItemAcceptsItem>,
        private val refuses: kotlin.collections.List<IdentifiersKindsKindsItemAcceptsItem>,
    ) {
        public fun build(): IdentifiersKindsKindsItem = IdentifiersKindsKindsItem(schema = schema, properties = properties, accepts = accepts, refuses = refuses)
    }

    public companion object {
        /** A builder of a `IdentifiersKindsKindsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(schema: String, properties: kotlin.collections.List<String>, accepts: kotlin.collections.List<IdentifiersKindsKindsItemAcceptsItem>, refuses: kotlin.collections.List<IdentifiersKindsKindsItemAcceptsItem>): Builder = Builder(schema, properties, accepts, refuses)
    }
}
