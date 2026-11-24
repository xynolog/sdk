// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A list or map not yet bounded, which grows. */
@Serializable
public data class BusReplyBoundsRepliesValueValueGrows(
    /** What it grows with. */
    public val grows: String,
) : BusReplyBoundsRepliesValueValue {
    /** How Java makes a `BusReplyBoundsRepliesValueValueGrows`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val grows: String,
    ) {
        public fun build(): BusReplyBoundsRepliesValueValueGrows = BusReplyBoundsRepliesValueValueGrows(grows = grows)
    }

    public companion object {
        /** A builder of a `BusReplyBoundsRepliesValueValueGrows` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(grows: String): Builder = Builder(grows)
    }
}
