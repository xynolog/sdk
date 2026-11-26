// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** client/discovery-absent.json: why a client that read a launcher's discovery document found no launcher. */
@Serializable
public data class ClientDiscoveryAbsent(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each reason, and what it means. */
    public val reasons: kotlin.collections.List<ClientDiscoveryAbsentReasonsItem>,
) {
    /** How Java makes a `ClientDiscoveryAbsent`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val reasons: kotlin.collections.List<ClientDiscoveryAbsentReasonsItem>,
    ) {
        public fun build(): ClientDiscoveryAbsent = ClientDiscoveryAbsent(comment = comment, reasons = reasons)
    }

    public companion object {
        /** A builder of a `ClientDiscoveryAbsent` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, reasons: kotlin.collections.List<ClientDiscoveryAbsentReasonsItem>): Builder = Builder(comment, reasons)
    }
}
