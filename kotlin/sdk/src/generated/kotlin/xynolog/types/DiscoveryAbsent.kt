// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** No launcher was found, and why. */
@Serializable
public data class DiscoveryAbsent(
    @EncodeDefault
    public val kind: DiscoveryAbsentKind = DiscoveryAbsentKind.Absent,
    /** Why: one of client/discovery-absent.json's reasons. */
    public val reason: DiscoveryAbsentReason,
    /** What was wrong, in words, when there is more to say. */
    public val diagnostic: String? = null,
) : DiscoveryRead,
    DiscoveryState {
    /** How Java makes a `DiscoveryAbsent`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val reason: DiscoveryAbsentReason,
    ) {
        private var diagnostic: String? = null

        public fun diagnostic(diagnostic: String?): Builder = apply { this.diagnostic = diagnostic }

        public fun build(): DiscoveryAbsent = DiscoveryAbsent(reason = reason, diagnostic = diagnostic)
    }

    public companion object {
        /** A builder of a `DiscoveryAbsent` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(reason: DiscoveryAbsentReason): Builder = Builder(reason)
    }
}
