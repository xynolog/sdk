using System.Diagnostics;
using System.Text.Json;
using Xynolog.Errors;
using Xynolog.Identifiers;
using Xynolog.Jobs;
using Xynolog.Types;

namespace Xynolog;

/// <summary>A job a worker has claimed: what it asks for, and the lifecycle messages that report on it and settle it.</summary>
public partial interface IHeldJob
{
    /// <summary>The job as its claim handed it.</summary>
    public HeldJobRecord Record { get; }
    /// <summary>Which attempt of the job this is, counting from 1.</summary>
    public long Attempt { get; }
    /// <summary>The annotation a yield job's gathered context is focused on, if it is focused on one.</summary>
    public AnnotationId? AnnotationId { get; }
    /// <summary>The trace the job was dispatched in, which its lifecycle messages continue.</summary>
    public ActivityContext Trace { get; }
    /// <summary>Signalled when the job is cancelled while held, so its work can stop.</summary>
    public CancellationToken Cancelled { get; }
    /// <summary>Whether the job has been completed, failed or cancelled, after which it accepts no further
    /// message.</summary>
    public bool Settled { get; }
    /// <summary>Announces that work on the job has begun; it must be the job's first lifecycle message.</summary>
    public Task StartAsync(CancellationToken cancellation = default);
    /// <summary>Reports how far the job has got.</summary>
    public Task ProgressAsync(JobProgress progress, CancellationToken cancellation = default);
    /// <summary>Records the units finished so far, and how far each unfinished one got, so a later attempt resumes from
    /// them.</summary>
    public Task CheckpointAsync(JobCheckpoint checkpoint, CancellationToken cancellation = default);
    /// <summary>Writes annotations the job made to a resource, confirming them by reading back the last one if the write
    /// times out.</summary>
    public Task CommitAsync(ResourceId resourceId, IReadOnlyList<Annotation> annotations, CancellationToken cancellation = default);
    /// <summary>Settles the job as failed, saying whether it will be retried and what a retry may resume from.</summary>
    public Task FailAsync(string error, JobFailure? failure = null, CancellationToken cancellation = default);
    /// <summary>Settles the job as cancelled, with what was finished before it stopped.</summary>
    public Task CancelAsync(JobReached? reached = null, CancellationToken cancellation = default);
}

/// <summary>A claimed job. Its lifecycle operations are serialized and it settles once.</summary>
public abstract partial class HeldJob : IHeldJob
{
    private static readonly IReadOnlyDictionary<string, UnitCursor> EmptyCursors =
        System.Collections.ObjectModel.ReadOnlyDictionary<string, UnitCursor>.Empty;
    private readonly Claims holder;
    private readonly Bus wire;
    private readonly SemaphoreSlim turn = new(1, 1);
    private readonly CancellationTokenSource cancelled = new();
    private Task? signalling;
    private DurabilityEvidence? durability;
    private bool begun;
    private volatile bool settled;

    private protected HeldJob(Claims holder, Bus wire, JobRunning job, ActivityContext trace)
    {
        this.holder = holder;
        this.wire = wire;
        Record = new HeldJobRecord
        {
            JobId = job.Metadata.Id,
            JobType = job.Metadata.Type,
            ResourceId = job.Params.ResourceId,
            Params = job.Params,
            CompletedUnits = job.Metadata.CompletedUnits ?? [],
            UnitCursors = job.Metadata.UnitCursors ?? EmptyCursors,
            RetryCount = job.Metadata.RetryCount,
            MaxRetries = job.Metadata.MaxRetries,
        };
        Cancelled = cancelled.Token;
        Trace = trace;
        if (JobType == JobType.Yield && Params.AdditionalProperties.TryGetValue("context", out var context) &&
            context.ValueKind == JsonValueKind.Object &&
            context.Deserialize<GatheredContext>() is { Focus: GatheredContextFocus.Annotation(var anchored) })
            AnnotationId = anchored.Annotation.Id;
    }

    /// <inheritdoc/>
    public HeldJobRecord Record { get; }
    /// <inheritdoc/>
    public long Attempt => RetryCount + 1;
    /// <inheritdoc/>
    public AnnotationId? AnnotationId { get; }
    /// <inheritdoc/>
    public ActivityContext Trace { get; }
    /// <inheritdoc/>
    public CancellationToken Cancelled { get; }
    /// <inheritdoc/>
    public bool Settled => settled;

    /// <inheritdoc/>
    public Task StartAsync(CancellationToken cancellation = default) => WhileHeldAsync(async () =>
    {
        if (begun) throw new InvalidOperationException("Start must be the job's first lifecycle message.");
        begun = true;
        await wire.EmitAsync(BusChannels.JobStart, new JobStartCommand
        {
            JobId = JobId,
            JobType = JobType,
            ResourceId = ResourceId,
            Attempt = Attempt,
            AnnotationId = AnnotationId,
        }, cancellation: cancellation).ConfigureAwait(Spawning.Captures);
    }, cancellation);

    /// <inheritdoc/>
    public Task ProgressAsync(JobProgress progress, CancellationToken cancellation = default) => WhileHeldAsync(async () =>
    {
        Working();
        await wire.EmitAsync(BusChannels.JobReportProgress, new JobReportProgressCommand
        {
            JobId = JobId,
            JobType = JobType,
            ResourceId = ResourceId,
            Attempt = Attempt,
            AnnotationId = AnnotationId,
            Percentage = progress.Percentage,
            Progress = AnnotationId is { } anchor ? progress with { AnnotationId = anchor } : progress,
        }, cancellation: cancellation).ConfigureAwait(Spawning.Captures);
    }, cancellation);

    /// <inheritdoc/>
    public Task CheckpointAsync(JobCheckpoint checkpoint, CancellationToken cancellation = default) => WhileHeldAsync(async () =>
    {
        Working();
        await wire.EmitAsync(BusChannels.JobCheckpoint, new JobCheckpointCommand
        {
            JobId = JobId,
            CompletedUnits = checkpoint.CompletedUnits,
            UnitCursors = checkpoint.UnitCursors,
        }, cancellation: cancellation).ConfigureAwait(Spawning.Captures);
    }, cancellation);

    /// <inheritdoc/>
    public Task CommitAsync(ResourceId resourceId, IReadOnlyList<Annotation> annotations, CancellationToken cancellation = default) =>
        WhileHeldAsync(async () =>
        {
            if (annotations.Count == 0) return;
            var last = annotations[^1].Id;
            try
            {
                await wire.RequestAsync(BusOperations.MarkCommit, new MarkCommitCommand
                {
                    JobId = JobId,
                    ResourceId = resourceId,
                    Annotations = annotations,
                }, holder.CommitTimeoutMs, cancellation).ConfigureAwait(Spawning.Captures);
            }
            catch (BusRequestError error) when (error.Code == BusRequestErrorCode.Timeout)
            {
                var observed = await ProbeAsync(resourceId, last, cancellation).ConfigureAwait(Spawning.Captures);
                Observe(observed);
                if (observed != DurabilityEvidence.ProbeConfirmed) throw;
                return;
            }
            Observe(DurabilityEvidence.Acknowledged);
        }, cancellation);

    private async Task<DurabilityEvidence> ProbeAsync(ResourceId resourceId, AnnotationId annotationId, CancellationToken cancellation)
    {
        try
        {
            var answer = await wire.RequestAsync(BusOperations.BrowseAnnotationRequested,
                new BrowseAnnotationRequest { ResourceId = resourceId, AnnotationId = annotationId },
                holder.CommitTimeoutMs, cancellation).ConfigureAwait(Spawning.Captures);
            return answer.Response.Annotation.Id == annotationId ? DurabilityEvidence.ProbeConfirmed : DurabilityEvidence.ProbeRefused;
        }
        catch (BusRequestError error) when (error.Code != BusRequestErrorCode.Timeout &&
            error.Code != BusRequestErrorCode.Closed && error.Code != BusRequestErrorCode.Unsubscribed)
        {
            return DurabilityEvidence.ProbeRefused;
        }
        catch (XynologError) { return DurabilityEvidence.ProbeUnreachable; }
    }

    private static int Weakness(DurabilityEvidence evidence) => evidence switch
    {
        DurabilityEvidence.Acknowledged => 0,
        DurabilityEvidence.ProbeConfirmed => 1,
        DurabilityEvidence.ProbeRefused or DurabilityEvidence.ProbeUnreachable => 2,
        _ => throw new ArgumentOutOfRangeException(nameof(evidence)),
    };

    private void Observe(DurabilityEvidence evidence)
    {
        if (durability is not { } previous || Weakness(evidence) > Weakness(previous)) durability = evidence;
    }

    /// <inheritdoc/>
    public Task FailAsync(string error, JobFailure? failure = null, CancellationToken cancellation = default) =>
        SettleAsync(() => SayFailureAsync(error, failure, cancellation), false, cancellation);

    private Task SayFailureAsync(string error, JobFailure? failure, CancellationToken cancellation) =>
        wire.EmitAsync(BusChannels.JobFail, new JobFailCommand
        {
            JobId = JobId,
            JobType = JobType,
            ResourceId = ResourceId,
            Attempt = Attempt,
            AnnotationId = AnnotationId,
            Error = error,
            FailureClass = failure?.FailureClass,
            CompletedUnits = failure?.CompletedUnits,
            UnitCursors = failure?.UnitCursors,
            WillRetry = WorkerRules.WillRetryAfter(RetryCount, MaxRetries, failure?.FailureClass),
            Durability = durability is DurabilityEvidence.ProbeRefused or DurabilityEvidence.ProbeUnreachable ? durability : null,
        }, cancellation: cancellation);

    /// <inheritdoc/>
    public Task CancelAsync(JobReached? reached = null, CancellationToken cancellation = default) => SettleAsync(() => wire.EmitAsync(BusChannels.JobCancel, new JobCancelCommand
    {
        JobId = JobId,
        JobType = JobType,
        ResourceId = ResourceId,
        AnnotationId = AnnotationId,
        CompletedUnits = reached?.CompletedUnits,
        UnitCursors = reached?.UnitCursors,
    }, cancellation: cancellation), false, cancellation);

    private protected Task CompleteAsync(Func<DurabilityEvidence?, JobCompleteCommand> command, CancellationToken cancellation) =>
        SettleAsync(() => wire.EmitAsync(BusChannels.JobComplete, command(durability), cancellation: cancellation), true, cancellation);

    internal async Task FailOnStopAsync()
    {
        await turn.WaitAsync().ConfigureAwait(Spawning.Captures);
        try
        {
            if (settled) return;
            using var context = Trace != default
                ? new Activity("worker stop").SetParentId(Trace.TraceId, Trace.SpanId, Trace.TraceFlags) : null;
            if (context is not null)
            {
                context.TraceStateString = Trace.TraceState;
                context.Start();
            }
            await FinishAsync(() => SayFailureAsync("The worker stopped while it held the job", null, default), false).ConfigureAwait(Spawning.Captures);
        }
        catch (XynologError) { /* The dispatcher's sweep handles a failure the worker could not deliver. */ }
        finally { turn.Release(); }
    }

    internal void SignalCancellation()
    {
        if (!settled && signalling is null) signalling = Spawning.CancelAsync(cancelled);
    }

    private async Task EndCancellationAsync()
    {
        if (signalling is not null) await signalling.ConfigureAwait(Spawning.Options(ConfigureAwaitOptions.SuppressThrowing));
        cancelled.Dispose();
    }

    private void Working()
    {
        begun = true;
        holder.Active(this);
    }

    private async Task WhileHeldAsync(Func<Task> action, CancellationToken cancellation)
    {
        await Spawning.WaitAsync(turn, cancellation).ConfigureAwait(Spawning.Captures);
        try
        {
            RequireHeld();
            await action().ConfigureAwait(Spawning.Captures);
        }
        finally { turn.Release(); }
    }

    private Task SettleAsync(Func<Task> action, bool completed, CancellationToken cancellation) =>
        WhileHeldAsync(() => FinishAsync(action, completed), cancellation);

    private async Task FinishAsync(Func<Task> action, bool completed)
    {
        settled = true;
        var delivered = false;
        try
        {
            await action().ConfigureAwait(Spawning.Captures);
            delivered = true;
        }
        finally
        {
            holder.Release(this, completed && delivered);
            _ = EndCancellationAsync();
        }
    }

    private void RequireHeld()
    {
        if (settled) throw new InvalidOperationException("Job " + JobId.Value + " is already settled.");
    }
}

/// <summary>A claimed mark job, which completes with the annotations it marked.</summary>
public sealed class HeldMarkJob : HeldJob
{
    internal HeldMarkJob(Claims holder, Bus wire, JobRunning job, ActivityContext trace) : base(holder, wire, job, trace) { }

    /// <summary>Settles the job as completed with its result.</summary>
    public Task CompleteAsync(MarkJobResult result, CancellationToken cancellation = default) => CompleteAsync(
        durability => new JobCompleteCommand.MarkJobCompleteCommand(new MarkJobCompleteCommand
        {
            JobId = JobId,
            ResourceId = ResourceId,
            Attempt = Attempt,
            Result = result,
            Durability = durability,
        }), cancellation);
}

/// <summary>A claimed yield job, which completes with what it yielded.</summary>
public sealed class HeldYieldJob : HeldJob
{
    internal HeldYieldJob(Claims holder, Bus wire, JobRunning job, ActivityContext trace) : base(holder, wire, job, trace) { }

    /// <summary>Settles the job as completed with its result.</summary>
    public Task CompleteAsync(YieldJobResult result, CancellationToken cancellation = default) => CompleteAsync(
        durability => new JobCompleteCommand.YieldJobCompleteCommand(new YieldJobCompleteCommand
        {
            JobId = JobId,
            ResourceId = ResourceId,
            Attempt = Attempt,
            AnnotationId = AnnotationId,
            Result = result,
            Durability = durability,
        }), cancellation);
}
