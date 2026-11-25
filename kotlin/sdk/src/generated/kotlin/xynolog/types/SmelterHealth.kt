// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** The Smelter's health answer (SMELTER.md § Health): seven members, each from what the Smelter holds, for it asks nothing of the gateway, its embedding provider or its vector database to answer. `status` is `ok` whenever it answers, and says what else is so in the members beside it. */
@Serializable
public data class SmelterHealth(
    @EncodeDefault
    public val status: SmelterHealthStatus = SmelterHealthStatus.Ok,
    /** The DID of the knowledge base it serves: the one its settings name, which that knowledge base said it is before the Smelter reached its index. */
    public val kb: KbDid,
    /** The state of its own stream of the record, one of client/connection-states.json's. Events are delivered to it while it is `open`. */
    public val stream: ConnectionState,
    /** How far it has followed the record. Its sweep is also `due` where its start's reconcile failed. */
    public val following: FollowerFollowing,
    /** How many events it has applied since it started: events of the kinds that do something, and not refused. Neither an event taken as nothing nor the work of a reconcile or a rebuild is counted. */
    public val eventsProcessed: Long,
    /** How far the latest reconcile has got: the pass's `summary` when it is done, or its `error` when it failed. */
    public val reconcile: SmelterHealthReconcile,
    /** What the Smelter holds its index to, and what this start did for that. */
    public val index: SmelterHealthIndex,
) {
    /** How Java makes a `SmelterHealth`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val kb: KbDid,
        private val stream: ConnectionState,
        private val following: FollowerFollowing,
        private val eventsProcessed: Long,
        private val reconcile: SmelterHealthReconcile,
        private val index: SmelterHealthIndex,
    ) {
        public fun build(): SmelterHealth = SmelterHealth(kb = kb, stream = stream, following = following, eventsProcessed = eventsProcessed, reconcile = reconcile, index = index)
    }

    public companion object {
        /** A builder of a `SmelterHealth` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(kb: KbDid, stream: ConnectionState, following: FollowerFollowing, eventsProcessed: Long, reconcile: SmelterHealthReconcile, index: SmelterHealthIndex): Builder = Builder(kb, stream, following, eventsProcessed, reconcile, index)
    }
}
