// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** identifiers/kinds.json: the kinds of id the protocol names, the properties that carry each, and the properties named like an id that carry something else. */
@Serializable
public data class IdentifiersKinds(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    public val kinds: kotlin.collections.List<IdentifiersKindsKindsItem>,
    public val others: kotlin.collections.List<IdentifiersKindsOthersItem>,
) {
    /** How Java makes a `IdentifiersKinds`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val kinds: kotlin.collections.List<IdentifiersKindsKindsItem>,
        private val others: kotlin.collections.List<IdentifiersKindsOthersItem>,
    ) {
        public fun build(): IdentifiersKinds = IdentifiersKinds(comment = comment, kinds = kinds, others = others)
    }

    public companion object {
        /** A builder of a `IdentifiersKinds` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, kinds: kotlin.collections.List<IdentifiersKindsKindsItem>, others: kotlin.collections.List<IdentifiersKindsOthersItem>): Builder = Builder(comment, kinds, others)
    }
}
