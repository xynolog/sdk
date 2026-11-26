// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** How one poll's knowledge bases changed since the last state it gave. */
@Serializable
public data class DiscoveryDiff(
    /** Each knowledge base the last state did not have. */
    public val added: kotlin.collections.List<DiscoveredKB>,
    /** Each knowledge base the last state had at the same address, now otherwise. */
    public val updated: kotlin.collections.List<DiscoveredKB>,
    /** Each knowledge base the last state had, and this one does not. */
    public val removed: kotlin.collections.List<DiscoveredKB>,
) {
    /** How Java makes a `DiscoveryDiff`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val added: kotlin.collections.List<DiscoveredKB>,
        private val updated: kotlin.collections.List<DiscoveredKB>,
        private val removed: kotlin.collections.List<DiscoveredKB>,
    ) {
        public fun build(): DiscoveryDiff = DiscoveryDiff(added = added, updated = updated, removed = removed)
    }

    public companion object {
        /** A builder of a `DiscoveryDiff` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(added: kotlin.collections.List<DiscoveredKB>, updated: kotlin.collections.List<DiscoveredKB>, removed: kotlin.collections.List<DiscoveredKB>): Builder = Builder(added, updated, removed)
    }
}
