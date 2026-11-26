// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A row for a channel's events. */
@Serializable
public data class ClientRefreshRefreshItemOn(
    /** The channel's name. */
    public val on: String,
    /** Which of a channel's two ways of event the row is for. */
    public val `when`: ClientRefreshRefreshItemOnWhen? = null,
    /** Which keys the row reaches: the event's subject, or every key held. */
    public val reach: ClientRefreshRefreshItemOnReach? = null,
    /** Where in the event a subject row finds the resource and the annotation it names. */
    public val names: ClientRefreshRefreshItemOnNames? = null,
    /** A way into the event's payload: the names of the members it passes through and of its own, joined by dots. */
    public val carries: String? = null,
    /** The queries asked again. */
    public val refetches: kotlin.collections.List<String>? = null,
    /** The queries whose new value the event carries. */
    public val writes: kotlin.collections.List<String>? = null,
    /** The queries whose entity the event says is gone. */
    public val removes: kotlin.collections.List<String>? = null,
    /** What it is, in prose. */
    public val docs: String,
) : ClientRefreshRefreshItem {
    /** How Java makes a `ClientRefreshRefreshItemOn`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val on: String,
        private val docs: String,
    ) {
        private var `when`: ClientRefreshRefreshItemOnWhen? = null
        private var reach: ClientRefreshRefreshItemOnReach? = null
        private var names: ClientRefreshRefreshItemOnNames? = null
        private var carries: String? = null
        private var refetches: kotlin.collections.List<String>? = null
        private var writes: kotlin.collections.List<String>? = null
        private var removes: kotlin.collections.List<String>? = null

        public fun `when`(`when`: ClientRefreshRefreshItemOnWhen?): Builder = apply { this.`when` = `when` }
        public fun reach(reach: ClientRefreshRefreshItemOnReach?): Builder = apply { this.reach = reach }
        public fun names(names: ClientRefreshRefreshItemOnNames?): Builder = apply { this.names = names }
        public fun carries(carries: String?): Builder = apply { this.carries = carries }
        public fun refetches(refetches: kotlin.collections.List<String>?): Builder = apply { this.refetches = refetches }
        public fun writes(writes: kotlin.collections.List<String>?): Builder = apply { this.writes = writes }
        public fun removes(removes: kotlin.collections.List<String>?): Builder = apply { this.removes = removes }

        public fun build(): ClientRefreshRefreshItemOn = ClientRefreshRefreshItemOn(on = on, `when` = `when`, reach = reach, names = names, carries = carries, refetches = refetches, writes = writes, removes = removes, docs = docs)
    }

    public companion object {
        /** A builder of a `ClientRefreshRefreshItemOn` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(on: String, docs: String): Builder = Builder(on, docs)
    }
}
