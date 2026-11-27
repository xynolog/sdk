// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlin.ExperimentalStdlibApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import xynolog.identifiers.JobId

/** A held job that showed no activity for `heldJobStallMs` (contract/WORKER-CONTRACT.md V2): what a worker's claims say on `stalled`. What its host does then is the host's. */
@Serializable
public data class HeldJobStall(
    @get:JvmExposeBoxed
    public val jobId: JobId,
    public val jobType: JobType,
    /** When the worker was handed the job. */
    public val heldSince: String,
    /** When the job last showed activity: its claim, a progress report, a checkpoint or a commit. */
    public val lastActivityAt: String,
    /** How long it has shown none, in milliseconds. */
    public val silentForMs: Long,
    /** The `heldJobStallMs` it was held to, in milliseconds. */
    public val thresholdMs: Long,
) {
    /** How Java makes a `HeldJobStall`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val jobId: JobId,
        private val jobType: JobType,
        private val heldSince: String,
        private val lastActivityAt: String,
        private val silentForMs: Long,
        private val thresholdMs: Long,
    ) {
        public fun build(): HeldJobStall = HeldJobStall(jobId = jobId, jobType = jobType, heldSince = heldSince, lastActivityAt = lastActivityAt, silentForMs = silentForMs, thresholdMs = thresholdMs)
    }

    public companion object {
        /** A builder of a `HeldJobStall` that states these, and what its setters add. */
        @JvmStatic
        @JvmExposeBoxed
        public fun builder(jobId: JobId, jobType: JobType, heldSince: String, lastActivityAt: String, silentForMs: Long, thresholdMs: Long): Builder = Builder(jobId, jobType, heldSince, lastActivityAt, silentForMs, thresholdMs)
    }
}
