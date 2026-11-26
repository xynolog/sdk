// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ClientDiscoveryAbsentReasonsItem(
    public val reason: DiscoveryAbsentReason,
    /** What it is, in prose. */
    public val docs: String,
) {
    /** How Java makes a `ClientDiscoveryAbsentReasonsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val reason: DiscoveryAbsentReason,
        private val docs: String,
    ) {
        public fun build(): ClientDiscoveryAbsentReasonsItem = ClientDiscoveryAbsentReasonsItem(reason = reason, docs = docs)
    }

    public companion object {
        /** A builder of a `ClientDiscoveryAbsentReasonsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(reason: DiscoveryAbsentReason, docs: String): Builder = Builder(reason, docs)
    }
}
