// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One engine at one knowledge base: which it is, the jobs it claims, and what its claims can say of themselves (WORKER-CONTRACT V1). */
@Serializable
public data class WorkerEngineHealth(
    public val engine: Engine,
    /** The jobs it claims, as its claims state them. */
    public val jobs: kotlin.collections.List<JobFilter>,
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
    /** How Java makes a `WorkerEngineHealth`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val engine: Engine,
        private val jobs: kotlin.collections.List<JobFilter>,
        private val lastQueuedEventAt: String?,
        private val lastClaimAt: String?,
        private val lastFinishedAt: String?,
        private val lastActivityAt: String?,
        private val activeJob: WorkerActiveJob?,
        private val jobsCompleted: Long,
    ) {
        public fun build(): WorkerEngineHealth = WorkerEngineHealth(engine = engine, jobs = jobs, lastQueuedEventAt = lastQueuedEventAt, lastClaimAt = lastClaimAt, lastFinishedAt = lastFinishedAt, lastActivityAt = lastActivityAt, activeJob = activeJob, jobsCompleted = jobsCompleted)
    }

    public companion object {
        /** A builder of a `WorkerEngineHealth` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(engine: Engine, jobs: kotlin.collections.List<JobFilter>, lastQueuedEventAt: String?, lastClaimAt: String?, lastFinishedAt: String?, lastActivityAt: String?, activeJob: WorkerActiveJob?, jobsCompleted: Long): Builder = Builder(engine, jobs, lastQueuedEventAt, lastClaimAt, lastFinishedAt, lastActivityAt, activeJob, jobsCompleted)
    }
}
