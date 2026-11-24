// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A list or map bounded by a member of the request. */
@Serializable
public data class BusReplyBoundsRepliesValueValueBy(
    /** The member of the request that bounds it: an array, or an integer with a maximum. */
    public val by: String,
) : BusReplyBoundsRepliesValueValue {
    /** How Java makes a `BusReplyBoundsRepliesValueValueBy`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val by: String,
    ) {
        public fun build(): BusReplyBoundsRepliesValueValueBy = BusReplyBoundsRepliesValueValueBy(by = by)
    }

    public companion object {
        /** A builder of a `BusReplyBoundsRepliesValueValueBy` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(by: String): Builder = Builder(by)
    }
}
