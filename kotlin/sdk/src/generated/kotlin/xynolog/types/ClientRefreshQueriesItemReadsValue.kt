// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** A reference to the schema of its value. */
@Serializable
public data class ClientRefreshQueriesItemReadsValue(
    /** The $id of the schema of what its cache holds for a key: a component, or a member within one. */
    @SerialName("\$ref")
    public val ref: String,
) {
    /** How Java makes a `ClientRefreshQueriesItemReadsValue`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val ref: String,
    ) {
        public fun build(): ClientRefreshQueriesItemReadsValue = ClientRefreshQueriesItemReadsValue(ref = ref)
    }

    public companion object {
        /** A builder of a `ClientRefreshQueriesItemReadsValue` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(ref: String): Builder = Builder(ref)
    }
}
