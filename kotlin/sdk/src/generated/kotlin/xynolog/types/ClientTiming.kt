// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** client/timing.json: the timings every Xynolog client keeps. */
@Serializable
public data class ClientTiming(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each timing. */
    public val timing: kotlin.collections.List<ClientTimingTimingItem>,
) {
    /** How Java makes a `ClientTiming`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val timing: kotlin.collections.List<ClientTimingTimingItem>,
    ) {
        public fun build(): ClientTiming = ClientTiming(comment = comment, timing = timing)
    }

    public companion object {
        /** A builder of a `ClientTiming` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, timing: kotlin.collections.List<ClientTimingTimingItem>): Builder = Builder(comment, timing)
    }
}
