// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A live query that asks an operation of the registry, by its request's channel. */
@Serializable
public data class ClientRefreshQueriesItemAsks(
    /** A query, by its name. */
    public val name: String,
    /** What one is kept per; absent, the knowledge base has one. */
    public val per: ClientRefreshQueriesItemAsksPer? = null,
    /** The channel's name. */
    public val asks: String,
    /** Its answers are kept across a client's lives. */
    public val persisted: ClientRefreshQueriesItemAsksPersisted? = null,
    /** A reference to the schema of its value. */
    public val value: ClientRefreshQueriesItemAsksValue,
    /** What it is, in prose. */
    public val docs: String,
) : ClientRefreshQueriesItem {
    /** How Java makes a `ClientRefreshQueriesItemAsks`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val asks: String,
        private val value: ClientRefreshQueriesItemAsksValue,
        private val docs: String,
    ) {
        private var per: ClientRefreshQueriesItemAsksPer? = null
        private var persisted: ClientRefreshQueriesItemAsksPersisted? = null

        public fun per(per: ClientRefreshQueriesItemAsksPer?): Builder = apply { this.per = per }
        public fun persisted(persisted: ClientRefreshQueriesItemAsksPersisted?): Builder = apply { this.persisted = persisted }

        public fun build(): ClientRefreshQueriesItemAsks = ClientRefreshQueriesItemAsks(name = name, per = per, asks = asks, persisted = persisted, value = value, docs = docs)
    }

    public companion object {
        /** A builder of a `ClientRefreshQueriesItemAsks` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, asks: String, value: ClientRefreshQueriesItemAsksValue, docs: String): Builder = Builder(name, asks, value, docs)
    }
}
