// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** client/refresh.json: what a Xynolog client asks again for, and when. */
@Serializable
public data class ClientRefresh(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** The live queries. */
    public val queries: kotlin.collections.List<ClientRefreshQueriesItem>,
    /** A row per trigger. */
    public val refresh: kotlin.collections.List<ClientRefreshRefreshItem>,
) {
    /** How Java makes a `ClientRefresh`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val queries: kotlin.collections.List<ClientRefreshQueriesItem>,
        private val refresh: kotlin.collections.List<ClientRefreshRefreshItem>,
    ) {
        public fun build(): ClientRefresh = ClientRefresh(comment = comment, queries = queries, refresh = refresh)
    }

    public companion object {
        /** A builder of a `ClientRefresh` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, queries: kotlin.collections.List<ClientRefreshQueriesItem>, refresh: kotlin.collections.List<ClientRefreshRefreshItem>): Builder = Builder(comment, queries, refresh)
    }
}
