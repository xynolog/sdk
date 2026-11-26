// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** client/option-defaults.json: what a public option of a Xynolog client is when its caller leaves it out, where the client, not the service, decides. */
@Serializable
public data class ClientOptionDefaults(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each default, once. */
    public val defaults: kotlin.collections.List<ClientOptionDefaultsDefaultsItem>,
) {
    /** How Java makes a `ClientOptionDefaults`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val defaults: kotlin.collections.List<ClientOptionDefaultsDefaultsItem>,
    ) {
        public fun build(): ClientOptionDefaults = ClientOptionDefaults(comment = comment, defaults = defaults)
    }

    public companion object {
        /** A builder of a `ClientOptionDefaults` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, defaults: kotlin.collections.List<ClientOptionDefaultsDefaultsItem>): Builder = Builder(comment, defaults)
    }
}
