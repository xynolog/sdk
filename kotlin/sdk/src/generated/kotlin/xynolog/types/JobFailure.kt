// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a held job's failure states beside its error (`job:fail`): what it had reached, and the failure's class when the worker knows it. What its commits observed is the held job's own to state. */
@Serializable
public data class JobFailure(
    /** Entity-type units whose annotations were fully emitted before this failure (checkpointed resume). The queue records them on the retried job's metadata; a retried claim skips them so completed work is neither redone nor duplicated. */
    public val completedUnits: kotlin.collections.List<String>? = null,
    /** The furthest each unit begun got, keyed by unit, with what it had counted there — the grain `completedUnits` cannot express. A unit named in `completedUnits` is stated here too, by the cursor it ended at: a later attempt skips it whole and counts it by that cursor. A cursor never says a unit is finished; only `completedUnits` does. Merged monotonically per unit, finished or not: a stale snapshot must never move a cursor backward. */
    public val unitCursors: kotlin.collections.Map<String, UnitCursor>? = null,
    public val failureClass: FailureClass? = null,
) {
    /** How Java makes a `JobFailure`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor() {
        private var completedUnits: kotlin.collections.List<String>? = null
        private var unitCursors: kotlin.collections.Map<String, UnitCursor>? = null
        private var failureClass: FailureClass? = null

        public fun completedUnits(completedUnits: kotlin.collections.List<String>?): Builder = apply { this.completedUnits = completedUnits }
        public fun unitCursors(unitCursors: kotlin.collections.Map<String, UnitCursor>?): Builder = apply { this.unitCursors = unitCursors }
        public fun failureClass(failureClass: FailureClass?): Builder = apply { this.failureClass = failureClass }

        public fun build(): JobFailure = JobFailure(completedUnits = completedUnits, unitCursors = unitCursors, failureClass = failureClass)
    }

    public companion object {
        /** A builder of a `JobFailure` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(): Builder = Builder()
    }
}
