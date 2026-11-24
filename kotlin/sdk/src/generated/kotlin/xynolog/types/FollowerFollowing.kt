// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** How far a follower of the record has followed it, as every follower says it at its health port (WEAVER.md § Health, SMELTER.md § Health). */
@Serializable
public data class FollowerFollowing(
    /** The latest sweep's phase: `pending` before its stream first opens, `running`, `done`, or `due` where the record could not be listed and the sweep is tried again. */
    public val sweep: FollowerFollowingSweep,
    /** How many resources' logs a failed taking has stopped until the next sweep. */
    public val stopped: Long,
    /** How many events it refused as recorded since it started. */
    public val refused: Long,
    /** How many times its stream has dropped since it started. */
    public val streamDrops: Long,
) {
    /** How Java makes a `FollowerFollowing`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val sweep: FollowerFollowingSweep,
        private val stopped: Long,
        private val refused: Long,
        private val streamDrops: Long,
    ) {
        public fun build(): FollowerFollowing = FollowerFollowing(sweep = sweep, stopped = stopped, refused = refused, streamDrops = streamDrops)
    }

    public companion object {
        /** A builder of a `FollowerFollowing` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(sweep: FollowerFollowingSweep, stopped: Long, refused: Long, streamDrops: Long): Builder = Builder(sweep, stopped, refused, streamDrops)
    }
}
