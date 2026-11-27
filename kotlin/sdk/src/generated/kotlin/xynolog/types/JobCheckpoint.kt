// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a held job states when it checkpoints (`job:checkpoint`, contract/JOBS.md § Checkpoints): the units finished, and the furthest each unit begun got. */
@Serializable
public data class JobCheckpoint(
    /** Entity-type units whose annotations have been fully emitted so far. Unioned into the running job's metadata checkpoint; a retry after recovery skips them. */
    public val completedUnits: kotlin.collections.List<String>,
    /** The furthest each unit begun got, keyed by unit, with what it had counted there — the grain `completedUnits` cannot express. A unit named in `completedUnits` is stated here too, by the cursor it ended at: a later attempt skips it whole and counts it by that cursor. A cursor never says a unit is finished; only `completedUnits` does. Merged monotonically per unit, finished or not: a stale snapshot must never move a cursor backward. */
    public val unitCursors: kotlin.collections.Map<String, UnitCursor>? = null,
) {
    /** How Java makes a `JobCheckpoint`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val completedUnits: kotlin.collections.List<String>,
    ) {
        private var unitCursors: kotlin.collections.Map<String, UnitCursor>? = null

        public fun unitCursors(unitCursors: kotlin.collections.Map<String, UnitCursor>?): Builder = apply { this.unitCursors = unitCursors }

        public fun build(): JobCheckpoint = JobCheckpoint(completedUnits = completedUnits, unitCursors = unitCursors)
    }

    public companion object {
        /** A builder of a `JobCheckpoint` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(completedUnits: kotlin.collections.List<String>): Builder = Builder(completedUnits)
    }
}
