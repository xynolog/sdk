// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** No launcher was found, and why. */
@Serializable
public data class DiscoveryReadAbsent(
    @EncodeDefault
    public val kind: DiscoveryReadAbsentKind = DiscoveryReadAbsentKind.Absent,
    /** Why: one of client/discovery-absent.json's reasons. */
    public val reason: String,
    /** What was wrong, in words, when there is more to say. */
    public val diagnostic: String? = null,
) : DiscoveryRead {
    /** How Java makes a `DiscoveryReadAbsent`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val reason: String,
    ) {
        private var diagnostic: String? = null

        public fun diagnostic(diagnostic: String?): Builder = apply { this.diagnostic = diagnostic }

        public fun build(): DiscoveryReadAbsent = DiscoveryReadAbsent(reason = reason, diagnostic = diagnostic)
    }

    public companion object {
        /** A builder of a `DiscoveryReadAbsent` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(reason: String): Builder = Builder(reason)
    }
}
