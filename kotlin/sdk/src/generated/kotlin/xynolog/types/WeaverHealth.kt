// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** The Weaver's health answer (WEAVER.md § Health). `status` is `ok` whenever the Weaver answers: it says nothing of whether the Weaver can reach the gateway or the graph. */
@Serializable
public data class WeaverHealth(
    @EncodeDefault
    public val status: WeaverHealthStatus = WeaverHealthStatus.Ok,
    /** The DID of the knowledge base it serves: the one its settings name, which that knowledge base said it is before the Weaver connected to the graph database. */
    public val kb: KbDid,
    public val following: FollowerFollowing,
    /** How far the reconcile its first sweep is followed by has got (WEAVER.md § Reconcile): the pass's `summary` when it is done, or its `error` when it failed. */
    public val reconcile: WeaverHealthReconcile,
) {
    /** How Java makes a `WeaverHealth`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val kb: KbDid,
        private val following: FollowerFollowing,
        private val reconcile: WeaverHealthReconcile,
    ) {
        public fun build(): WeaverHealth = WeaverHealth(kb = kb, following = following, reconcile = reconcile)
    }

    public companion object {
        /** A builder of a `WeaverHealth` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(kb: KbDid, following: FollowerFollowing, reconcile: WeaverHealthReconcile): Builder = Builder(kb, following, reconcile)
    }
}
