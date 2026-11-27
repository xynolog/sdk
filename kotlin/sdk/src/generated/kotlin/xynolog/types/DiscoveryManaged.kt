// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** The knowledge bases a launcher manages: none is a launcher that manages nothing. */
@Serializable
public data class DiscoveryManaged(
    @EncodeDefault
    public val kind: DiscoveryManagedKind = DiscoveryManagedKind.Managed,
    /** Each knowledge base, as the document lists it. */
    public val kbs: kotlin.collections.List<DiscoveredKB>,
) : DiscoveryRead,
    DiscoveryState {
    /** How Java makes a `DiscoveryManaged`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val kbs: kotlin.collections.List<DiscoveredKB>,
    ) {
        public fun build(): DiscoveryManaged = DiscoveryManaged(kbs = kbs)
    }

    public companion object {
        /** A builder of a `DiscoveryManaged` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(kbs: kotlin.collections.List<DiscoveredKB>): Builder = Builder(kbs)
    }
}
