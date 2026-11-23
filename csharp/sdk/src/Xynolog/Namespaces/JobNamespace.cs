using Xynolog.Errors;
using Xynolog.Identifiers;
using Xynolog.Http;
using Xynolog.Protocol;
using Xynolog.Types;

namespace Xynolog.Namespaces;

/// <summary>Jobs: their lifecycle as it is announced, their status, their cancellation, and, for a worker, the claiming of
/// them.</summary>
public sealed class JobNamespace
{
    private readonly Bus wire;
    private readonly EventBus bus;
    private readonly HttpTransport transport;
    private readonly TimeProvider clock;
    private readonly CancellationToken closed;

    internal JobNamespace(Bus wire, EventBus bus, HttpTransport transport)
    {
        this.wire = wire;
        this.bus = bus;
        this.transport = transport;
        clock = transport.Clock;
        closed = transport.Closed;
    }

    /// <summary>Claims, for a worker, each job it comes to hold that one of the filters accepts.</summary>
    public Claims Claim(IReadOnlyList<JobFilter> accepts) => new(transport, wire, accepts);

    /// <summary>Observes queued jobs. Wire announcements require a transport subscribed to this channel.</summary>
    public IAsyncEnumerable<Heard<JobQueuedEvent>> Queued(CancellationToken cancellation = default) =>
        bus.Frames(BusChannels.JobQueued, cancellation: cancellation);

    /// <summary>Observes jobs' progress reports on this client's own bus, from now on.</summary>
    public IAsyncEnumerable<Heard<JobReportProgressCommand>> Progress(CancellationToken cancellation = default) =>
        bus.Frames(BusChannels.JobReportProgress, cancellation: cancellation);

    /// <summary>Observes jobs' completions on this client's own bus, from now on.</summary>
    public IAsyncEnumerable<Heard<JobCompleteCommand>> Complete(CancellationToken cancellation = default) =>
        bus.Frames(BusChannels.JobComplete, cancellation: cancellation);

    /// <summary>Observes jobs' failures on this client's own bus, from now on.</summary>
    public IAsyncEnumerable<Heard<JobFailCommand>> Fail(CancellationToken cancellation = default) =>
        bus.Frames(BusChannels.JobFail, cancellation: cancellation);

    /// <summary>Asks the queue for the job's status.</summary>
    public async Task<JobStatusResponse> StatusAsync(JobId jobId, CancellationToken cancellation = default) =>
        (await wire.RequestAsync(BusOperations.JobStatusRequested, new JobStatusRequest { JobId = jobId },
            cancellation: cancellation).ConfigureAwait(Spawning.Captures)).Response;

    /// <summary>Reports whether the queue accepted cancellation of the job.</summary>
    public async Task<bool> CancelAsync(JobId jobId, CancellationToken cancellation = default) =>
        (await wire.RequestAsync(BusOperations.JobCancelRequested, new JobCancelRequest { JobId = jobId },
            cancellation: cancellation).ConfigureAwait(Spawning.Captures)).Response.Cancelled;

    /// <summary>Returns the first terminal status, reporting each status received along the way. It asks every
    /// <paramref name="intervalMs"/>, jobPollMs when named none, and fails as timed out at <paramref name="timeoutMs"/>
    /// from its first ask, jobPollTimeoutMs when named none.</summary>
    public async Task<JobStatusResponse> PollUntilCompleteAsync(JobId jobId, int? intervalMs = null, int? timeoutMs = null,
        Action<JobStatusResponse>? onStatus = null, CancellationToken cancellation = default)
    {
        var everyMs = intervalMs ?? ProtocolFacts.Timing("jobPollMs").GetInt32();
        var limitMs = timeoutMs ?? ProtocolFacts.Timing("jobPollTimeoutMs").GetInt32();
        ArgumentOutOfRangeException.ThrowIfNegativeOrZero(everyMs, nameof(intervalMs));
        ArgumentOutOfRangeException.ThrowIfNegativeOrZero(limitMs, nameof(timeoutMs));
        var interval = TimeSpan.FromMilliseconds(everyMs);
        using var deadline = new CancellationTokenSource(TimeSpan.FromMilliseconds(limitMs), clock);
        using var waiting = CancellationTokenSource.CreateLinkedTokenSource(deadline.Token, closed, cancellation);
        try
        {
            while (true)
            {
                waiting.Token.ThrowIfCancellationRequested();
                var status = await StatusAsync(jobId, waiting.Token).ConfigureAwait(Spawning.Captures);
                waiting.Token.ThrowIfCancellationRequested();
                onStatus?.Invoke(status);
                if (status.Status is not (JobStatusResponseStatus.Pending or JobStatusResponseStatus.Running)) return status;
                await Task.Delay(interval, clock, waiting.Token).ConfigureAwait(Spawning.Captures);
            }
        }
        catch (OperationCanceledException) when (!cancellation.IsCancellationRequested && closed.IsCancellationRequested)
        {
            throw new BusRequestError(ProtocolFacts.BusError("closed"), "The client closed while polling the job");
        }
        catch (OperationCanceledException) when (!cancellation.IsCancellationRequested && deadline.IsCancellationRequested)
        {
            throw new BusRequestError(ProtocolFacts.BusError("timeout"), "Job polling timed out");
        }
    }
}
