using Xynolog.Protocol;
using Xynolog.Types;
namespace Xynolog.Http;

/// <summary>The deadlines, retry budgets and stream cadence a caller may set for a client, each named as
/// protocol/specs/src/client/timing.json names it and the protocol's value unless the caller sets its own.</summary>
public sealed record Timing
{
    /// <summary>The first wait, in milliseconds, before a failed stream is opened again; each further failure doubles
    /// it.</summary>
    public int ReconnectMs { get; init; } = Timings.ReconnectMs;
    /// <summary>How long, in milliseconds, a removal from the subscription waits before the stream is reopened without
    /// it.</summary>
    public int LazyRemoveMs { get; init; } = Timings.LazyRemoveMs;
    /// <summary>How long, in milliseconds, a superseded connection keeps draining after its replacement
    /// opens.</summary>
    public int LingerMs { get; init; } = Timings.LingerMs;
    /// <summary>How many of the event ids it delivered last a client remembers, so that a frame both streams of a
    /// handoff carry is delivered once.</summary>
    public int SeenEventIdsCount { get; init; } = Timings.SeenEventIdsCount;
    /// <summary>The deadline, in milliseconds, on one HTTP request that is neither the stream nor an emit.</summary>
    public int HttpRequestTimeoutMs { get; init; } = Timings.HttpRequestTimeoutMs;
    /// <summary>How long, in milliseconds, a client waits for the gateway to answer the request that opens its
    /// stream.</summary>
    public int StreamOpenTimeoutMs { get; init; } = Timings.StreamOpenTimeoutMs;
    /// <summary>The deadline, in milliseconds, on one emit to the bus.</summary>
    public int EmitTimeoutMs { get; init; } = Timings.EmitTimeoutMs;
    /// <summary>How long, in milliseconds, a bus request has from the call to be answered.</summary>
    public int BusRequestTimeoutMs { get; init; } = Timings.BusRequestTimeoutMs;
    /// <summary>How long, in milliseconds, bus-driven invalidations of one cache key fold into a single
    /// refetch.</summary>
    public int InvalidationWindowMs { get; init; } = Timings.InvalidationWindowMs;
    /// <summary>How long, in milliseconds, a followed job may say nothing before the client asks for its
    /// status.</summary>
    public int JobSilenceMs { get; init; } = Timings.JobSilenceMs;
    /// <summary>How often, in milliseconds, a client asks for the status of a job that has gone silent.</summary>
    public int JobStatusPollMs { get; init; } = Timings.JobStatusPollMs;
    /// <summary>How long, in milliseconds, a party that takes jobs waits for the answer to one claim.</summary>
    public int JobClaimTimeoutMs { get; init; } = Timings.JobClaimTimeoutMs;
    /// <summary>How long, in milliseconds, a held job may show no activity before its holder calls it
    /// stalled.</summary>
    public int HeldJobStallMs { get; init; } = Timings.HeldJobStallMs;
    /// <summary>How often, in milliseconds, a party that holds a job checks how long it has shown no
    /// activity.</summary>
    public int HeldJobStallCheckMs { get; init; } = Timings.HeldJobStallCheckMs;
    /// <summary>How long, in milliseconds, a worker waits for a commit of annotations to be acknowledged.</summary>
    public int MarkCommitTimeoutMs { get; init; } = Timings.MarkCommitTimeoutMs;
    /// <summary>The retry budget of one emit.</summary>
    public RetryBudget EmitRetry { get; init; } = Timings.EmitRetry;
}
