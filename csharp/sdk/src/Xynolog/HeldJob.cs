using System.Diagnostics;
using System.Text.Json;
using Xynolog.Errors;
using Xynolog.Identifiers;
using Xynolog.Jobs;
using Xynolog.Protocol;
using Xynolog.Types;

namespace Xynolog;

/// <summary>A job a worker has claimed: what it asks for, and the lifecycle messages that report on it and settle it.</summary>
public interface IHeldJob
{
    /// <summary>The job's identity.</summary>
    public JobId JobId { get; }
    /// <summary>The kind of work the job asks for.</summary>
    public JobType JobType { get; }
    /// <summary>The resource the job works on.</summary>
    public ResourceId ResourceId { get; }
    /// <summary>What the job was asked to do, as its creator stated it.</summary>
    public JobParams Params { get; }
    /// <summary>The units of work an earlier attempt finished, which this attempt need not do again.</summary>
    public IReadOnlyList<string> CompletedUnits { get; }
    /// <summary>How far an earlier attempt got within each unfinished unit, by unit.</summary>
    public IReadOnlyDictionary<string, UnitCursor> UnitCursors { get; }
    /// <summary>How many earlier attempts of the job failed.</summary>
    public long RetryCount { get; }
    /// <summary>How many failed attempts the job may be retried after.</summary>
    public long MaxRetries { get; }
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
    public Task CheckpointAsync(IReadOnlyList<string> completedUnits, IReadOnlyDictionary<string, UnitCursor>? unitCursors = null, CancellationToken cancellation = default);
    /// <summary>Writes annotations the job made to a resource, confirming them by reading back the last one if the write
    /// times out.</summary>
    public Task CommitAsync(ResourceId resourceId, IReadOnlyList<Annotation> annotations, CancellationToken cancellation = default);
    /// <summary>Settles the job as failed, saying whether it will be retried and what a retry may resume from.</summary>
    public Task FailAsync(string error, FailureClass? failureClass = null, IReadOnlyList<string>? completedUnits = null,
        IReadOnlyDictionary<string, UnitCursor>? unitCursors = null, CancellationToken cancellation = default);
    /// <summary>Settles the job as cancelled, with what was finished before it stopped.</summary>
    public Task CancelAsync(IReadOnlyList<string>? completedUnits = null, IReadOnlyDictionary<string, UnitCursor>? unitCursors = null,
        CancellationToken cancellation = default);
}

/// <summary>A claimed job. Its lifecycle operations are serialized and it settles once.</summary>
public abstract class HeldJob : IHeldJob
{
    private readonly Claims holder;
    private readonly Bus wire;
    private readonly JobRunning job;
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
        this.job = job;
        Cancelled = cancelled.Token;
        Trace = trace;
        if (JobType == JobType.Yield && Params.AdditionalProperties.TryGetValue("context", out var context) &&
            context.ValueKind == JsonValueKind.Object &&
            context.Deserialize<GatheredContext>() is { Focus: GatheredContextFocus.AnnotationCase(var anchored) })
            AnnotationId = anchored.Annotation.Id;
    }

    /// <inheritdoc/>
    public JobId JobId => job.Metadata.Id;
    /// <inheritdoc/>
    public JobType JobType => job.Metadata.Type;
    /// <inheritdoc/>
    public ResourceId ResourceId => Params.ResourceId;
    /// <inheritdoc/>
    public JobParams Params => job.Params;
    /// <inheritdoc/>
    public IReadOnlyList<string> CompletedUnits => job.Metadata.CompletedUnits ?? [];
    /// <inheritdoc/>
    public IReadOnlyDictionary<string, UnitCursor> UnitCursors => job.Metadata.UnitCursors ?? EmptyCursors;
    /// <inheritdoc/>
    public long RetryCount => job.Metadata.RetryCount;
    /// <inheritdoc/>
    public long MaxRetries => job.Metadata.MaxRetries;
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
    private static readonly IReadOnlyDictionary<string, UnitCursor> EmptyCursors =
        System.Collections.ObjectModel.ReadOnlyDictionary<string, UnitCursor>.Empty;

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
    public Task CheckpointAsync(IReadOnlyList<string> completedUnits, IReadOnlyDictionary<string, UnitCursor>? unitCursors = null,
        CancellationToken cancellation = default) => WhileHeldAsync(async () =>
    {
        Working();
        await wire.EmitAsync(BusChannels.JobCheckpoint, new JobCheckpointCommand
        {
            JobId = JobId,
            CompletedUnits = completedUnits,
            UnitCursors = unitCursors,
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
            catch (BusRequestError error) when (error.Code == ProtocolFacts.BusError("timeout"))
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
        catch (BusRequestError error) when (error.Code != ProtocolFacts.BusError("timeout") &&
            error.Code != ProtocolFacts.BusError("closed") && error.Code != ProtocolFacts.BusError("unsubscribed"))
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
    public Task FailAsync(string error, FailureClass? failureClass = null, IReadOnlyList<string>? completedUnits = null,
        IReadOnlyDictionary<string, UnitCursor>? unitCursors = null, CancellationToken cancellation = default) =>
        SettleAsync(() => SayFailureAsync(error, failureClass, completedUnits, unitCursors, cancellation), false, cancellation);

    private Task SayFailureAsync(string error, FailureClass? failureClass, IReadOnlyList<string>? completedUnits,
        IReadOnlyDictionary<string, UnitCursor>? unitCursors, CancellationToken cancellation) =>
        wire.EmitAsync(BusChannels.JobFail, new JobFailCommand
        {
            JobId = JobId,
            JobType = JobType,
            ResourceId = ResourceId,
            Attempt = Attempt,
            AnnotationId = AnnotationId,
            Error = error,
            FailureClass = failureClass,
            CompletedUnits = completedUnits,
            UnitCursors = unitCursors,
            WillRetry = WorkerRules.WillRetryAfter(RetryCount, MaxRetries, failureClass),
            Durability = durability is DurabilityEvidence.ProbeRefused or DurabilityEvidence.ProbeUnreachable ? durability : null,
        }, cancellation: cancellation);

    /// <inheritdoc/>
    public Task CancelAsync(IReadOnlyList<string>? completedUnits = null, IReadOnlyDictionary<string, UnitCursor>? unitCursors = null,
        CancellationToken cancellation = default) => SettleAsync(() => wire.EmitAsync(BusChannels.JobCancel, new JobCancelCommand
        {
            JobId = JobId,
            JobType = JobType,
            ResourceId = ResourceId,
            AnnotationId = AnnotationId,
            CompletedUnits = completedUnits,
            UnitCursors = unitCursors,
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
            await FinishAsync(() => SayFailureAsync("The worker stopped while it held the job", null, null, null, default), false).ConfigureAwait(Spawning.Captures);
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
        durability => new JobCompleteCommand.MarkJobCompleteCommandCase(new MarkJobCompleteCommand
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
        durability => new JobCompleteCommand.YieldJobCompleteCommandCase(new YieldJobCompleteCommand
        {
            JobId = JobId,
            ResourceId = ResourceId,
            Attempt = Attempt,
            AnnotationId = AnnotationId,
            Result = result,
            Durability = durability,
        }), cancellation);
}
