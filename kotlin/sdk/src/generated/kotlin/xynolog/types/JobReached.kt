// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a held job that stops on a cancellation states it had reached (`job:cancel`): the units finished, and the furthest each unit begun got. */
@Serializable
public data class JobReached(
    /** The units the worker had finished when it stopped. Recorded on the cancelled job's metadata so the work already done stays visible. */
    public val completedUnits: kotlin.collections.List<String>? = null,
    /** The furthest each unit begun got, keyed by unit, with what it had counted there — the grain `completedUnits` cannot express. A unit named in `completedUnits` is stated here too, by the cursor it ended at: a later attempt skips it whole and counts it by that cursor. A cursor never says a unit is finished; only `completedUnits` does. Merged monotonically per unit, finished or not: a stale snapshot must never move a cursor backward. */
    public val unitCursors: kotlin.collections.Map<String, UnitCursor>? = null,
) {
    /** How Java makes a `JobReached`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor() {
        private var completedUnits: kotlin.collections.List<String>? = null
        private var unitCursors: kotlin.collections.Map<String, UnitCursor>? = null

        public fun completedUnits(completedUnits: kotlin.collections.List<String>?): Builder = apply { this.completedUnits = completedUnits }
        public fun unitCursors(unitCursors: kotlin.collections.Map<String, UnitCursor>?): Builder = apply { this.unitCursors = unitCursors }

        public fun build(): JobReached = JobReached(completedUnits = completedUnits, unitCursors = unitCursors)
    }

    public companion object {
        /** A builder of a `JobReached` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(): Builder = Builder()
    }
}
