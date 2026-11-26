// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class ClientTestingDeliveryOps(
    /** What it is, in prose. */
    public val docs: String,
    /** The steps an interleaving is of. */
    public val ops: kotlin.collections.List<String>,
) {
    /** How Java makes a `ClientTestingDeliveryOps`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val docs: String,
        private val ops: kotlin.collections.List<String>,
    ) {
        public fun build(): ClientTestingDeliveryOps = ClientTestingDeliveryOps(docs = docs, ops = ops)
    }

    public companion object {
        /** A builder of a `ClientTestingDeliveryOps` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(docs: String, ops: kotlin.collections.List<String>): Builder = Builder(docs, ops)
    }
}
