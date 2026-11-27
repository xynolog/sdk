// Generated from protocol/specs/src/client/surface.json and its client types; do not edit.
// Regenerate: make generate (codegen/lib/held_job/kotlin.ml)
@file:OptIn(kotlin.ExperimentalStdlibApi::class)

package xynolog.jobs

import xynolog.identifiers.JobId
import xynolog.identifiers.ResourceId
import xynolog.types.HeldJobRecord
import xynolog.types.JobParams
import xynolog.types.JobType
import xynolog.types.UnitCursor

/** The members of a held job that are its `HeldJobRecord`'s: each is the property of its name. */
public abstract class HeldJobRecordMembers internal constructor(
    /** The job as its claim handed it. */
    public val record: HeldJobRecord,
) {
    @get:JvmExposeBoxed
    public val jobId: JobId get() = record.jobId

    public val jobType: JobType get() = record.jobType

    @get:JvmExposeBoxed
    public val resourceId: ResourceId get() = record.resourceId

    public val params: JobParams get() = record.params

    /** The units a worker has finished, merged across checkpoints and failures as a set. */
    public val completedUnits: kotlin.collections.List<String> get() = record.completedUnits

    /** The furthest each unit begun got, keyed by unit, with what it had counted there. A finished unit keeps its cursor: where it ended, and its final counts. */
    public val unitCursors: kotlin.collections.Map<String, UnitCursor> get() = record.unitCursors

    public val retryCount: Long get() = record.retryCount

    /** How many transient failures the queue retries: 0 for generation, whose re-run produces different content; 1 for every other type. */
    public val maxRetries: Long get() = record.maxRetries
}
