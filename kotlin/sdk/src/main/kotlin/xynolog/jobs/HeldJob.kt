@file:OptIn(kotlin.ExperimentalStdlibApi::class)

package xynolog.jobs

import kotlinx.coroutines.launch
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.jsonObject
import xynolog.bus.Operation
import xynolog.bus.Operations
import xynolog.bus.readOf
import xynolog.bus.resultOf
import xynolog.channels.Channels
import xynolog.errors.BusRequestError
import xynolog.errors.BusRequestErrorCode
import xynolog.errors.XynologError
import xynolog.identifiers.AnnotationId
import xynolog.identifiers.ResourceId
import xynolog.telemetry.continuing
import xynolog.telemetry.futureOf
import xynolog.transport.Variable
import xynolog.transport.Watched
import xynolog.types.Annotation
import xynolog.types.BrowseAnnotationRequest
import xynolog.types.DurabilityEvidence
import xynolog.types.GatheredContext
import xynolog.types.GatheredContextFocusAnnotation
import xynolog.types.HeldJobRecord
import xynolog.types.JobCancelCommand
import xynolog.types.JobCheckpoint
import xynolog.types.JobCheckpointCommand
import xynolog.types.JobFailCommand
import xynolog.types.JobFailure
import xynolog.types.JobParams
import xynolog.types.JobProgress
import xynolog.types.JobReached
import xynolog.types.JobReportProgressCommand
import xynolog.types.JobRunning
import xynolog.types.JobStartCommand
import xynolog.types.JobType
import xynolog.types.MarkCommitCommand
import xynolog.types.MarkJobCompleteCommand
import xynolog.types.MarkJobResult
import xynolog.types.TraceCarrier
import xynolog.types.YieldJobCompleteCommand
import xynolog.types.YieldJobResult
import xynolog.types.wireJson
import java.util.concurrent.CompletableFuture

/** The error of a job failed because its worker stopped, and not because the work failed. */
internal const val STOPPED_WHILE_HELD = "The worker stopped while it held the job"

/** The error of a job let go of without being settled. */
private const val LET_GO_UNSETTLED = "The worker let go of the job without settling it"

/**
 * How weak an observation of a commit is, as evidence that the batch is on
 * the record. The two a commit is not established by are equally weak.
 */
private fun weakness(evidence: DurabilityEvidence): Int = when (evidence) {
    DurabilityEvidence.Acknowledged -> 0
    DurabilityEvidence.ProbeConfirmed -> 1
    DurabilityEvidence.ProbeRefused, DurabilityEvidence.ProbeUnreachable -> 2
}

/**
 * The annotation a job is anchored to: the one a `yield` job's context is
 * focused on. A `mark` job has none, and nor has a `yield` job whose context
 * is no gathered context.
 */
private fun anchorOf(jobType: JobType, params: JobParams): AnnotationId? {
    if (jobType != JobType.Yield) return null
    val written = params.rest["context"] ?: return null
    val read = readOf(GatheredContext.serializer().descriptor, written)
    if (read.fault != null) return null
    val context = try {
        wireJson.decodeFromJsonElement(GatheredContext.serializer(), read.value)
    } catch (_: IllegalArgumentException) {
        return null
    }
    return (context.focus as? GatheredContextFocusAnnotation)?.annotation?.id
}

/** The job as `claimed` hands it. */
private fun heldRecord(claimed: JobRunning): HeldJobRecord = HeldJobRecord(
    jobId = claimed.metadata.id,
    jobType = claimed.metadata.type,
    resourceId = claimed.params.resourceId,
    params = claimed.params,
    completedUnits = claimed.metadata.completedUnits.orEmpty(),
    unitCursors = claimed.metadata.unitCursors.orEmpty(),
    retryCount = claimed.metadata.retryCount,
    maxRetries = claimed.metadata.maxRetries,
)

/**
 * A job a worker holds, from its claim until it settles it: a `mark` job
 * (`HeldMarkJob`) or a `yield` one (`HeldYieldJob`), whose completion is its
 * verb's. It says its own start, progress and checkpoints, and it settles
 * once: `complete`, `fail` and `cancel` each say the outcome and release the
 * job in one call, and a second is refused. It commits for itself, citing
 * itself, and says how its commits were established when it settles.
 * Closing it settles it as a failure if nothing else has, and does nothing
 * once it is settled: so `use` lets go of a job that nobody settled, and
 * the queue does not wait for its sweep to learn of it.
 *
 * Its values are the claimed record's (WORKER-CONTRACT R1, R2); `trace` is
 * the trace its reply arrived in, which a worker's span for the job
 * continues, and none for a reply that arrived in none.
 */
public sealed class HeldJob(
    private val holder: Holder,
    claimed: JobRunning,
    private val cancelling: Variable<Boolean>,
    /** The trace the job is run in: the one its reply arrived in, or none. */
    public val trace: TraceCarrier?,
) : HeldJobRecordMembers(heldRecord(claimed)),
    AutoCloseable {
    /** Which attempt this is, from 1. Every lifecycle message states it. */
    public val attempt: Long = retryCount + 1

    /** The annotation the job is anchored to: the one a `yield` job's context is focused on. */
    @get:JvmExposeBoxed
    public val annotationId: AnnotationId? = anchorOf(jobType, params)

    /** Whether a cancellation has named this job: the work stops where it can, and the worker says `cancel`. It ends once the job is settled. */
    public val cancelled: Watched<Boolean> = cancelling.reading()

    private var begun = false
    private var settledAt = false

    /** The weakest of what this job's commits observed: none until one is committed. */
    private var durability: DurabilityEvidence? = null

    /** Whether the job has been settled: completed, failed or cancelled. */
    public val settled: Boolean get() = synchronized(this) { settledAt }

    private fun unsettled(saying: String): Unit = synchronized(this) {
        check(!settledAt) { "Job ${jobId.value} is already settled: it cannot say $saying" }
    }

    /** The job is settled from the moment it is asked to be, so a second settle is refused while the first is on its way. */
    internal fun settling(saying: String): Unit = synchronized(this) {
        check(!settledAt) { "Job ${jobId.value} is already settled: it cannot say $saying" }
        settledAt = true
    }

    /** Settle it, if nothing has: whether this did. */
    private fun settlingIfUnsettled(): Boolean = synchronized(this) {
        if (settledAt) return false
        settledAt = true
        true
    }

    private fun working(saying: String) {
        synchronized(this) {
            check(!settledAt) { "Job ${jobId.value} is already settled: it cannot say $saying" }
            begun = true
        }
        holder.active()
    }

    /** `job:start`: the job's first message, said once. */
    public suspend fun start() {
        synchronized(this) {
            check(!settledAt) { "Job ${jobId.value} is already settled: it cannot say ${Channels.JOB_START.name}" }
            check(!begun) { "job:start is a held job's first message, said once: job ${jobId.value} has already said more" }
            begun = true
        }
        holder.wire.emit(Channels.JOB_START, JobStartCommand(resourceId = resourceId, jobId = jobId, jobType = jobType, attempt = attempt, annotationId = annotationId))
    }

    /** `start`, for Java. */
    public fun startFuture(): CompletableFuture<Unit> = holder.scope.futureOf { start() }

    /** `job:report-progress`. Counts as activity. */
    public suspend fun progress(progress: JobProgress) {
        working(Channels.JOB_REPORT_PROGRESS.name)
        val said = if (annotationId == null) progress else progress.copy(annotationId = annotationId)
        holder.wire.emit(
            Channels.JOB_REPORT_PROGRESS,
            JobReportProgressCommand(resourceId = resourceId, jobId = jobId, jobType = jobType, attempt = attempt, annotationId = annotationId, percentage = progress.percentage, progress = said),
        )
    }

    /** `progress`, for Java. */
    public fun progressFuture(progress: JobProgress): CompletableFuture<Unit> = holder.scope.futureOf { progress(progress) }

    /** `job:checkpoint`: what a later attempt resumes from. The units finished, and the furthest each unit begun got. Counts as activity. */
    public suspend fun checkpoint(checkpoint: JobCheckpoint) {
        working(Channels.JOB_CHECKPOINT.name)
        holder.wire.emit(Channels.JOB_CHECKPOINT, JobCheckpointCommand(jobId = jobId, completedUnits = checkpoint.completedUnits, unitCursors = checkpoint.unitCursors))
    }

    /** `checkpoint`, for Java. */
    public fun checkpointFuture(checkpoint: JobCheckpoint): CompletableFuture<Unit> = holder.scope.futureOf { checkpoint(checkpoint) }

    /**
     * `mark:commit` for this job, returning once the batch is established: the
     * record acknowledged it, or, when no acknowledgement came, answered that
     * the batch's last annotation is on the resource (WORKER-CONTRACT A4, A5).
     * The record appends a batch in order, so the last being there says all
     * of it is; a batch is never sent a second time to find out. A commit
     * that was not established throws what its unanswered request threw, and
     * what was observed is said when the job settles. A batch of no
     * annotations is no commit.
     */
    public suspend fun commit(resourceId: ResourceId, annotations: List<Annotation>) {
        unsettled(Operations.MARK_COMMIT.request.name)
        if (annotations.isEmpty()) return
        val batch = MarkCommitCommand(jobId = jobId, resourceId = resourceId, annotations = annotations)
        try {
            answered(Operations.MARK_COMMIT, wireJson.encodeToJsonElement(MarkCommitCommand.serializer(), batch).jsonObject)
        } catch (unanswered: BusRequestError) {
            // The record's refusal, and every other failure of the request, is the commit's as it is: only an
            // acknowledgement that did not arrive leaves what the record holds unknown.
            if (unanswered.reason != BusRequestErrorCode.Timeout) throw unanswered
            val observed = askWhetherRecorded(resourceId, annotations.last().id)
            observe(observed)
            if (observed != DurabilityEvidence.ProbeConfirmed) throw unanswered
            return
        }
        observe(DurabilityEvidence.Acknowledged)
    }

    /** `commit`, for Java. */
    @JvmExposeBoxed
    public fun commitFuture(resourceId: ResourceId, annotations: List<Annotation>): CompletableFuture<Unit> = holder.scope.futureOf { commit(resourceId, annotations) }

    /**
     * What asking whether the annotation is on the resource observes. A
     * failure reply means the question was answered and the answer was not
     * the annotation; any other failure means nobody answered. Only the
     * annotation establishes the commit.
     */
    private suspend fun askWhetherRecorded(resourceId: ResourceId, annotationId: AnnotationId): DurabilityEvidence {
        val question = BrowseAnnotationRequest(resourceId = resourceId, annotationId = annotationId)
        try {
            answered(Operations.BROWSE_ANNOTATION_REQUESTED, wireJson.encodeToJsonElement(BrowseAnnotationRequest.serializer(), question).jsonObject)
        } catch (unconfirmed: XynologError) {
            val refused = unconfirmed is BusRequestError && unconfirmed.reason == BusRequestErrorCode.Rejected
            return if (refused) DurabilityEvidence.ProbeRefused else DurabilityEvidence.ProbeUnreachable
        }
        return DurabilityEvidence.ProbeConfirmed
    }

    /** One of a commit's requests, waiting as long as a commit waits. What it is answered with is not read: that the record answered establishes it. */
    private suspend fun answered(operation: Operation<*, *, *>, payload: JsonObject) {
        resultOf(holder.transport, operation, payload, holder.markCommitTimeoutMs, holder.clock)
    }

    /** Remember `evidence` if it is weaker than what is remembered; of two equally weak, the first seen is kept. */
    private fun observe(evidence: DurabilityEvidence): Unit = synchronized(this) {
        val held = durability
        if (held == null || weakness(evidence) > weakness(held)) durability = evidence
    }

    /** How the job's commits were established, for its completion. */
    internal fun durabilityForCompletion(): DurabilityEvidence? = synchronized(this) { durability }

    /**
     * Settle: `job:fail`, saying whether the queue will retry, from the
     * record's budget and the failure's class, and what a commit that was not
     * established observed. `failure` is what the worker knows beside the
     * error: the failure's class, and what the job had reached.
     */
    public suspend fun fail(error: String, failure: JobFailure? = null) {
        settling(Channels.JOB_FAIL.name)
        failed(error, failure)
    }

    /** `fail`, for Java. */
    public fun failFuture(error: String, failure: JobFailure?): CompletableFuture<Unit> = holder.scope.futureOf { fail(error, failure) }

    /** Say `job:fail` for a job settled already, and release it. */
    private suspend fun failed(error: String, failure: JobFailure?) {
        // Stated only when a commit was not established: otherwise the failure says nothing of the job's commits.
        val observed = synchronized(this) { durability }
        val notEstablished = observed != null && weakness(observed) > weakness(DurabilityEvidence.ProbeConfirmed)
        val said = JobFailCommand(
            resourceId = resourceId,
            jobId = jobId,
            jobType = jobType,
            attempt = attempt,
            annotationId = annotationId,
            error = error,
            completedUnits = failure?.completedUnits,
            unitCursors = failure?.unitCursors,
            failureClass = failure?.failureClass,
            willRetry = willRetryAfter(retryCount, maxRetries, failure?.failureClass),
            durability = if (notEstablished) observed else null,
        )
        try {
            holder.wire.emit(Channels.JOB_FAIL, said)
        } finally {
            holder.released(this, false)
        }
    }

    /**
     * Fail the job for a reason that is not the work's, unless it is settled
     * already: with no class, so the record's budget decides what becomes of
     * it. One that cannot be said is not said; the dispatcher's sweep
     * concludes the job.
     */
    internal suspend fun failFor(reason: String) {
        if (!settlingIfUnsettled()) return
        try {
            failed(reason, null)
        } catch (_: XynologError) {
            // Released all the same.
        }
    }

    /**
     * Settle: `job:cancel`, once the work has stopped for a cancellation, with
     * what it had reached: the units it finished and the furthest each unit
     * begun got. It names no attempt: the message is its command's fields and
     * no more.
     */
    public suspend fun cancel(reached: JobReached? = null) {
        settling(Channels.JOB_CANCEL.name)
        val said = JobCancelCommand(resourceId = resourceId, jobId = jobId, jobType = jobType, annotationId = annotationId, completedUnits = reached?.completedUnits, unitCursors = reached?.unitCursors)
        try {
            holder.wire.emit(Channels.JOB_CANCEL, said)
        } finally {
            holder.released(this, false)
        }
    }

    /** `cancel`, for Java. */
    public fun cancelFuture(reached: JobReached?): CompletableFuture<Unit> = holder.scope.futureOf { cancel(reached) }

    /** Say `job:complete`, released whether or not the gateway took it. */
    internal suspend fun completed(say: suspend () -> Unit) {
        try {
            say()
        } finally {
            holder.released(this, true)
        }
    }

    /** Let go of the job: one nobody settled is failed, in its trace, as a task of the worker's, since closing cannot wait. A settled one is let go of as it is. */
    override fun close() {
        if (!settlingIfUnsettled()) return
        holder.scope.launch(continuing(trace)) {
            try {
                failed(LET_GO_UNSETTLED, null)
            } catch (_: XynologError) {
                // Released all the same: the dispatcher's sweep concludes it.
            }
        }
    }
}

/** A `mark` job this worker holds, from its claim until it settles it. */
public class HeldMarkJob internal constructor(
    holder: Holder,
    claimed: JobRunning,
    cancelling: Variable<Boolean>,
    trace: TraceCarrier?,
) : HeldJob(holder, claimed, cancelling, trace) {
    private val scope = holder.scope
    private val wire = holder.wire

    /** Settle: `job:complete`, with what a `mark` job reports, and how its commits were established. */
    public suspend fun complete(result: MarkJobResult) {
        settling(Channels.JOB_COMPLETE.name)
        val said = MarkJobCompleteCommand(resourceId = resourceId, jobId = jobId, attempt = attempt, result = result, durability = durabilityForCompletion())
        completed { wire.emit(Channels.JOB_COMPLETE, said) }
    }

    /** `complete`, for Java. */
    public fun completeFuture(result: MarkJobResult): CompletableFuture<Unit> = scope.futureOf { complete(result) }
}

/** A `yield` job this worker holds, from its claim until it settles it. */
public class HeldYieldJob internal constructor(
    holder: Holder,
    claimed: JobRunning,
    cancelling: Variable<Boolean>,
    trace: TraceCarrier?,
) : HeldJob(holder, claimed, cancelling, trace) {
    private val scope = holder.scope
    private val wire = holder.wire

    /** Settle: `job:complete`, with what a `yield` job reports, and how its commits were established. */
    public suspend fun complete(result: YieldJobResult) {
        settling(Channels.JOB_COMPLETE.name)
        val said = YieldJobCompleteCommand(resourceId = resourceId, jobId = jobId, attempt = attempt, annotationId = annotationId, result = result, durability = durabilityForCompletion())
        completed { wire.emit(Channels.JOB_COMPLETE, said) }
    }

    /** `complete`, for Java. */
    public fun completeFuture(result: YieldJobResult): CompletableFuture<Unit> = scope.futureOf { complete(result) }
}
