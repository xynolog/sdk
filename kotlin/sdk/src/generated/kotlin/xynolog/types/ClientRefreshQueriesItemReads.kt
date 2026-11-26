// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A live query that reads a GET of the gateway's API. */
@Serializable
public data class ClientRefreshQueriesItemReads(
    /** A query, by its name. */
    public val name: String,
    /** What one is kept per; absent, the knowledge base has one. */
    public val per: ClientRefreshQueriesItemReadsPer? = null,
    /** The GET of the gateway's API it reads. */
    public val reads: String,
    /** Its answers are kept across a client's lives. */
    public val persisted: ClientRefreshQueriesItemReadsPersisted? = null,
    /** A reference to the schema of its value. */
    public val value: ClientRefreshQueriesItemReadsValue,
    /** What it is, in prose. */
    public val docs: String,
) : ClientRefreshQueriesItem {
    /** How Java makes a `ClientRefreshQueriesItemReads`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val reads: String,
        private val value: ClientRefreshQueriesItemReadsValue,
        private val docs: String,
    ) {
        private var per: ClientRefreshQueriesItemReadsPer? = null
        private var persisted: ClientRefreshQueriesItemReadsPersisted? = null

        public fun per(per: ClientRefreshQueriesItemReadsPer?): Builder = apply { this.per = per }
        public fun persisted(persisted: ClientRefreshQueriesItemReadsPersisted?): Builder = apply { this.persisted = persisted }

        public fun build(): ClientRefreshQueriesItemReads = ClientRefreshQueriesItemReads(name = name, per = per, reads = reads, persisted = persisted, value = value, docs = docs)
    }

    public companion object {
        /** A builder of a `ClientRefreshQueriesItemReads` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, reads: String, value: ClientRefreshQueriesItemReadsValue, docs: String): Builder = Builder(name, reads, value, docs)
    }
}
