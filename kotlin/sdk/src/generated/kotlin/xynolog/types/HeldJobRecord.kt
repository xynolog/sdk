// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlin.ExperimentalStdlibApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import xynolog.identifiers.JobId
import xynolog.identifiers.ResourceId

/** The job a worker holds, as its claim hands it: read from the `JobRunning` that `job:claimed` carries, its metadata's id, type, units, cursors and retries, and its params with the resource they name. A unit the job has not reached is no member of `completedUnits` and no key of `unitCursors`. */
@Serializable
public data class HeldJobRecord(
    @get:JvmExposeBoxed
    public val jobId: JobId,
    public val jobType: JobType,
    @get:JvmExposeBoxed
    public val resourceId: ResourceId,
    public val params: JobParams,
    /** The units a worker has finished, merged across checkpoints and failures as a set. */
    public val completedUnits: kotlin.collections.List<String>,
    /** The furthest each unit begun got, keyed by unit, with what it had counted there. A finished unit keeps its cursor: where it ended, and its final counts. */
    public val unitCursors: kotlin.collections.Map<String, UnitCursor>,
    public val retryCount: Long,
    /** How many transient failures the queue retries: 0 for generation, whose re-run produces different content; 1 for every other type. */
    public val maxRetries: Long,
) {
    /** How Java makes a `HeldJobRecord`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val jobId: JobId,
        private val jobType: JobType,
        private val resourceId: ResourceId,
        private val params: JobParams,
        private val completedUnits: kotlin.collections.List<String>,
        private val unitCursors: kotlin.collections.Map<String, UnitCursor>,
        private val retryCount: Long,
        private val maxRetries: Long,
    ) {
        public fun build(): HeldJobRecord = HeldJobRecord(jobId = jobId, jobType = jobType, resourceId = resourceId, params = params, completedUnits = completedUnits, unitCursors = unitCursors, retryCount = retryCount, maxRetries = maxRetries)
    }

    public companion object {
        /** A builder of a `HeldJobRecord` that states these, and what its setters add. */
        @JvmStatic
        @JvmExposeBoxed
        public fun builder(jobId: JobId, jobType: JobType, resourceId: ResourceId, params: JobParams, completedUnits: kotlin.collections.List<String>, unitCursors: kotlin.collections.Map<String, UnitCursor>, retryCount: Long, maxRetries: Long): Builder = Builder(jobId, jobType, resourceId, params, completedUnits, unitCursors, retryCount, maxRetries)
    }
}
