// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What a worker can say of itself at any moment (contract/WORKER-CONTRACT.md V1): what a worker's claims hand it as `vitals`, and what the worker service answers of each engine beside the engine and its jobs (worker/WorkerEngineHealth.json). */
@Serializable
public data class WorkerVitals(
    /** When a `job:queued` last reached it, or null. */
    public val lastQueuedEventAt: String?,
    /** When it was last handed a job, or null. A claim answered with none pending is not one. */
    public val lastClaimAt: String?,
    /** When a job it held last settled, or null. */
    public val lastFinishedAt: String?,
    /** When it was last active, or null. */
    public val lastActivityAt: String?,
    public val activeJob: WorkerActiveJob?,
    /** How many jobs it has completed since the service started. */
    public val jobsCompleted: Long,
) {
    /** How Java makes a `WorkerVitals`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val lastQueuedEventAt: String?,
        private val lastClaimAt: String?,
        private val lastFinishedAt: String?,
        private val lastActivityAt: String?,
        private val activeJob: WorkerActiveJob?,
        private val jobsCompleted: Long,
    ) {
        public fun build(): WorkerVitals = WorkerVitals(lastQueuedEventAt = lastQueuedEventAt, lastClaimAt = lastClaimAt, lastFinishedAt = lastFinishedAt, lastActivityAt = lastActivityAt, activeJob = activeJob, jobsCompleted = jobsCompleted)
    }

    public companion object {
        /** A builder of a `WorkerVitals` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(lastQueuedEventAt: String?, lastClaimAt: String?, lastFinishedAt: String?, lastActivityAt: String?, activeJob: WorkerActiveJob?, jobsCompleted: Long): Builder = Builder(lastQueuedEventAt, lastClaimAt, lastFinishedAt, lastActivityAt, activeJob, jobsCompleted)
    }
}
