using System.Diagnostics;
using System.Text.Json;
using System.Threading.Channels;
using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Identifiers;
using Xynolog.Jobs;
using Xynolog.Types;

namespace Xynolog;

/// <summary>One worker's claims. The first read starts the worker and StopAsync releases its job.</summary>
public sealed class Claims
{
    private readonly object gate = new();
    private readonly HttpTransport transport;
    private readonly Bus wire;
    private readonly IReadOnlyList<JobFilter> accepts;
    private readonly JsonElement command;
    private readonly JsonElement[] filters;
    private readonly CancellationTokenSource watching = new();
    private readonly Channel<HeldJob> handed = Channel.CreateUnbounded<HeldJob>();
    private readonly Broadcast<ClaimRefusal> refusals = new(keptForFirst: XynologError.KeptForFirstReader);
    private readonly Broadcast<HeldJobStall> stalls = new(keptForFirst: XynologError.KeptForFirstReader);
    private readonly TimeProvider clock;
    private readonly int claimTimeoutMs;
    private readonly int stallMs;
    private readonly int stallCheckMs;
    private Task? pending;
    private Dictionary<JobId, long>? pendingCancellations;
    private Task? stopping;
    private HeldJob? held;
    private long claimedAtSequence;
    private bool begun;
    private bool stopped;
    private bool wakeOwed;
    private bool stallReported;
    private DateTimeOffset? lastQueued;
    private DateTimeOffset? lastClaimed;
    private DateTimeOffset? lastFinished;
    private DateTimeOffset? lastActivity;
    private long activeAt;
    private long jobsCompleted;

    internal Claims(HttpTransport transport, Bus wire, ClaimOptions options)
    {
        ArgumentNullException.ThrowIfNull(options);
        if (options.Accepts.Count == 0) throw new ArgumentException("A worker must accept at least one job filter.", nameof(options));
        this.transport = transport;
        this.wire = wire;
        clock = transport.Clock;
        var timing = transport.Settings;
        claimTimeoutMs = checked((int)(options.JobClaimTimeoutMs ?? timing.JobClaimTimeoutMs));
        stallMs = checked((int)(options.HeldJobStallMs ?? timing.HeldJobStallMs));
        stallCheckMs = checked((int)(options.HeldJobStallCheckMs ?? timing.HeldJobStallCheckMs));
        CommitTimeoutMs = checked((int)(options.MarkCommitTimeoutMs ?? timing.MarkCommitTimeoutMs));
        accepts = options.Accepts;
        command = JsonSerializer.SerializeToElement(new JobClaimCommand { Accepts = options.Accepts });
        filters = options.Accepts.Select(filter => JsonSerializer.SerializeToElement(filter)).ToArray();
    }

    internal int CommitTimeoutMs { get; }

    /// <summary>Waits for the next job this worker claims, starting the worker on the first call; null once the worker is
    /// stopped.</summary>
    public async Task<IHeldJob?> NextAsync(CancellationToken cancellation = default)
    {
        cancellation.ThrowIfCancellationRequested();
        Begin();
        while (await handed.Reader.WaitToReadAsync(cancellation).ConfigureAwait(Spawning.Captures))
        {
            lock (gate)
            {
                if (stopped) return null;
                if (handed.Reader.TryRead(out var job) && !job.Settled) return job;
            }
        }
        return null;
    }

    /// <summary>Each claim refused from now on. Of those refused before anyone reads them, the latest
    /// errorsKeptForFirstReaderCount (protocol/specs/src/client/timing.json) are kept for the first reader, in the order
    /// refused.</summary>
    public IAsyncEnumerable<ClaimRefusal> Refused(CancellationToken cancellation = default) => refusals.Observe(cancellation);

    /// <summary>Each held job found stalled from now on, once per job. Of those found before anyone reads them, the latest
    /// errorsKeptForFirstReaderCount (protocol/specs/src/client/timing.json) are kept for the first reader, in the order
    /// found.</summary>
    public IAsyncEnumerable<HeldJobStall> Stalled(CancellationToken cancellation = default) => stalls.Observe(cancellation);

    /// <summary>A snapshot of the worker's activity now.</summary>
    public WorkerVitals Vitals()
    {
        lock (gate)
        {
            var active = held is { } job && lastClaimed is { } since
                ? new WorkerActiveJob { JobId = job.JobId, Type = job.JobType, Since = Stamp(since) }
                : null;
            return new WorkerVitals
            {
                LastQueuedEventAt = Stamp(lastQueued),
                LastClaimAt = Stamp(lastClaimed),
                LastFinishedAt = Stamp(lastFinished),
                LastActivityAt = Stamp(lastActivity),
                ActiveJob = active,
                JobsCompleted = jobsCompleted,
            };
        }
    }

    /// <summary>The worker's health as its engine reports it: its vitals now, the engine it runs, and the jobs it
    /// takes.</summary>
    public WorkerEngineHealth Health(Engine engine)
    {
        ArgumentNullException.ThrowIfNull(engine);
        return Health(Vitals(), engine, accepts);
    }

    internal static WorkerEngineHealth Health(WorkerVitals vitals, Engine engine, IReadOnlyList<JobFilter> jobs) =>
        new()
        {
            Engine = engine,
            Jobs = jobs,
            LastQueuedEventAt = vitals.LastQueuedEventAt,
            LastClaimAt = vitals.LastClaimAt,
            LastFinishedAt = vitals.LastFinishedAt,
            LastActivityAt = vitals.LastActivityAt,
            ActiveJob = vitals.ActiveJob,
            JobsCompleted = vitals.JobsCompleted,
        };

    private static string? Stamp(DateTimeOffset? at) => at is { } known ? Stamp(known) : null;

    private static string Stamp(DateTimeOffset at) =>
        at.ToUniversalTime().ToString("yyyy-MM-dd'T'HH:mm:ss.fff'Z'", System.Globalization.CultureInfo.InvariantCulture);

    /// <summary>Stops the worker, failing the job it holds and waiting for a claim in flight to settle.</summary>
    public Task StopAsync()
    {
        lock (gate)
        {
            if (stopping is not null) return stopping;
            var holding = held;
            var claiming = pending;
            End();
            stopping = StopCoreAsync(holding, claiming);
            return stopping;
        }
    }

    private async Task StopCoreAsync(HeldJob? holding, Task? claiming)
    {
        if (holding is not null) await holding.FailOnStopAsync().ConfigureAwait(Spawning.Captures);
        if (claiming is not null) await claiming.ConfigureAwait(Spawning.Captures);
    }

    private void Begin()
    {
        lock (gate)
        {
            if (begun || stopped) return;
            var missing = WorkerRules.JobClaimChannels.Where(channel => !transport.IsSubscribed(channel)).ToArray();
            if (missing.Length != 0)
                throw new BusRequestError(BusRequestErrorCode.Unsubscribed, "The worker stream is missing " + string.Join(", ", missing));
            begun = true;
            var stop = watching.Token;
            _ = WatchFramesAsync(stop);
            _ = WatchStallsAsync(stop);
            _ = WatchStatesAsync(stop);
        }
    }

    private void End()
    {
        lock (gate)
        {
            if (stopped) return;
            stopped = true;
            pendingCancellations = null;
            handed.Writer.TryComplete();
            stalls.Close();
            refusals.Close();
            watching.Cancel();
            watching.Dispose();
        }
    }

    private async Task WatchStatesAsync(CancellationToken stop)
    {
        var wasOpen = false;
        try
        {
            await foreach (var state in transport.States(stop).ConfigureAwait(Spawning.Captures))
            {
                var open = state == ConnectionState.Open;
                if (open && !wasOpen) Wake();
                wasOpen = open;
            }
        }
        catch (OperationCanceledException) when (stop.IsCancellationRequested) { }
        finally { End(); }
    }

    private async Task WatchFramesAsync(CancellationToken stop)
    {
        try
        {
            var frames = transport.ReceivedFrames([BusChannels.JobQueued.Name, BusChannels.JobCancelRequested.Name], null, stop);
            await foreach (var carried in frames.ConfigureAwait(Spawning.Captures))
            {
                if (carried.Channel == BusChannels.JobQueued.Name)
                {
                    lock (gate) lastQueued = clock.GetUtcNow();
                    var wakes = carried switch
                    {
                        ReceivedBusFrame announced => filters.Any(filter => WorkerRules.JobMatchesFilter(filter, announced.Frame.Payload)),
                        // No filter can be compared with what cannot be read: a refused announcement counts as one that matches.
                        FrameRefusal => true,
                    };
                    if (wakes) Wake();
                }
                // A refused frame, or one whose payload is not its channel's, names no job to cancel.
                else if (Bus.HeardOf<JobCancelRequest>(carried) is Heard<JobCancelRequest>.Delivered { Received: var received, Payload: var requested })
                {
                    lock (gate)
                    {
                        if (held is { } job && requested.JobId == job.JobId && received.Sequence > claimedAtSequence)
                            job.SignalCancellation();
                        else if (pendingCancellations is { } buffered)
                            buffered[requested.JobId] = received.Sequence;
                    }
                }
            }
        }
        catch (OperationCanceledException) when (stop.IsCancellationRequested) { }
    }

    private async Task WatchStallsAsync(CancellationToken stop)
    {
        using var interval = new PeriodicTimer(TimeSpan.FromMilliseconds(stallCheckMs), clock);
        try
        {
            while (await interval.WaitForNextTickAsync(stop).ConfigureAwait(Spawning.Captures))
            {
                lock (gate)
                {
                    if (held is not { Settled: false } job || stallReported || lastClaimed is not { } since ||
                        lastActivity is not { } active) continue;
                    var silence = clock.GetElapsedTime(activeAt).TotalMilliseconds;
                    if (silence <= stallMs) continue;
                    stallReported = true;
                    stalls.Publish(new HeldJobStall
                    {
                        JobId = job.JobId,
                        JobType = job.JobType,
                        HeldSince = Stamp(since),
                        LastActivityAt = Stamp(active),
                        SilentForMs = (long)silence,
                        ThresholdMs = stallMs,
                    });
                }
            }
        }
        catch (OperationCanceledException) when (stop.IsCancellationRequested) { }
    }

    private void Wake()
    {
        lock (gate)
        {
            if (stopped || held is not null || transport.State != ConnectionState.Open) return;
            if (pending is not null) { wakeOwed = true; return; }
            pendingCancellations = [];
            pending = Spawning.Run(ClaimAsync);
        }
    }

    private async Task ClaimAsync()
    {
        // Settling may have woken this worker from the previous job's trace.
        Activity.Current = null;
        HeldJob? acquired = null;
        long replySequence = 0;
        ClaimRefusal? refused = null;
        try
        {
            var reply = await transport.RequestFrameAsync(BusOperations.JobClaim.Request.Name, command, claimTimeoutMs, default)
                .ConfigureAwait(Spawning.Captures);
            replySequence = reply.Sequence;
            var record = Bus.Decoded<JobClaimedResult>(reply.Frame.Channel, reply.Frame.Payload).Response;
            acquired = record.Metadata.Type switch
            {
                JobType.Mark => new HeldMarkJob(this, wire, record, reply.Trace),
                JobType.Yield => new HeldYieldJob(this, wire, record, reply.Trace),
                _ => throw new JsonException("Unknown claimed job type."),
            };
        }
        catch (BusRequestError error)
        {
            if (error.Code != BusRequestErrorCode.NonePending) refused = new ClaimRefusal { Code = error.Code, Message = error.Message };
        }
        catch (Exception error) when (error is TransportError or JsonException)
        {
            refused = new ClaimRefusal { Code = null, Message = error.Message };
        }

        lock (gate)
        {
            if (!stopped)
            {
                pending = null;
                var cancellations = pendingCancellations;
                pendingCancellations = null;
                if (acquired is { } job)
                {
                    held = job;
                    claimedAtSequence = replySequence;
                    // The event reader can see a cancellation before the claim's POST returns.
                    if (cancellations is not null && cancellations.TryGetValue(job.JobId, out var receivedAt) && receivedAt > replySequence)
                        job.SignalCancellation();
                    lastClaimed = MarkActive();
                    stallReported = false;
                    handed.Writer.TryWrite(job);
                }
                else
                {
                    if (refused is not null) refusals.Publish(refused);
                    if (wakeOwed) Wake();
                }
                wakeOwed = false;
                return;
            }
        }
        if (acquired is not null) await acquired.FailOnStopAsync().ConfigureAwait(Spawning.Captures);
    }

    internal void Active(HeldJob job)
    {
        lock (gate)
            if (held == job) MarkActive();
    }

    internal void Release(HeldJob job, bool completed)
    {
        lock (gate)
        {
            if (held != job) return;
            held = null;
            lastFinished = MarkActive();
            if (completed) jobsCompleted++;
            Wake();
        }
    }

    private DateTimeOffset MarkActive()
    {
        activeAt = clock.GetTimestamp();
        var now = clock.GetUtcNow();
        lastActivity = now;
        return now;
    }
}
