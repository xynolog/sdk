// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** Nothing changed since the last read of a launcher's discovery document. */
@Serializable
public data class DiscoveryUnchanged(
    @EncodeDefault
    public val kind: DiscoveryUnchangedKind = DiscoveryUnchangedKind.Unchanged,
) : DiscoveryRead {
    /** How Java makes a `DiscoveryUnchanged`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor() {
        public fun build(): DiscoveryUnchanged = DiscoveryUnchanged()
    }

    public companion object {
        /** A builder of a `DiscoveryUnchanged` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(): Builder = Builder()
    }
}
