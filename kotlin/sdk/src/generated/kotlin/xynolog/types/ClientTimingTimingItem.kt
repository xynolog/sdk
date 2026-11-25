// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ClientTimingTimingItem(
    /** The timing's name: a duration's ends in Ms, a retry budget's in Retry, a count's in Count. */
    public val name: String,
    public val value: ClientTimingTimingItemValue,
    /** What it is, in prose. */
    public val docs: String,
) {
    /** How Java makes a `ClientTimingTimingItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val value: ClientTimingTimingItemValue,
        private val docs: String,
    ) {
        public fun build(): ClientTimingTimingItem = ClientTimingTimingItem(name = name, value = value, docs = docs)
    }

    public companion object {
        /** A builder of a `ClientTimingTimingItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, value: ClientTimingTimingItemValue, docs: String): Builder = Builder(name, value, docs)
    }
}
