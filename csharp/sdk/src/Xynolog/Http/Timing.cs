using Xynolog.Protocol;
namespace Xynolog.Http;

/// <summary>The deadlines, retry budgets and stream cadence a client keeps, each the protocol's value
/// (protocol/specs/src/client/timing.json) unless a caller sets its own.</summary>
public sealed record Timing
{
    /// <summary>The first wait, in milliseconds, before a failed stream is opened again; each further failure doubles
    /// it.</summary>
    public int ReconnectMs { get; init; } = ProtocolFacts.Timing("reconnectMs").GetInt32();
    /// <summary>How long, in milliseconds, a removal from the subscription waits before the stream is reopened without
    /// it.</summary>
    public int LazyRemoveMs { get; init; } = ProtocolFacts.Timing("lazyRemoveMs").GetInt32();
    /// <summary>How long, in milliseconds, a superseded connection keeps draining after its replacement
    /// opens.</summary>
    public int LingerMs { get; init; } = ProtocolFacts.Timing("lingerMs").GetInt32();
    /// <summary>How many of the event ids it delivered last a client remembers, so that a frame both streams of a
    /// handoff carry is delivered once.</summary>
    public int SeenEventIdsCount { get; init; } = ProtocolFacts.Timing("seenEventIdsCount").GetInt32();
    /// <summary>The deadline, in milliseconds, on one HTTP request that is neither the stream nor an emit.</summary>
    public int HttpRequestMs { get; init; } = ProtocolFacts.Timing("httpRequestTimeoutMs").GetInt32();
    /// <summary>How long, in milliseconds, a client waits for the gateway to answer the request that opens its
    /// stream.</summary>
    public int StreamOpenMs { get; init; } = ProtocolFacts.Timing("streamOpenTimeoutMs").GetInt32();
    /// <summary>The deadline, in milliseconds, on one emit to the bus.</summary>
    public int EmitTimeoutMs { get; init; } = ProtocolFacts.Timing("emitTimeoutMs").GetInt32();
    /// <summary>How long, in milliseconds, a bus request has from the call to be answered.</summary>
    public int BusRequestTimeoutMs { get; init; } = ProtocolFacts.Timing("busRequestTimeoutMs").GetInt32();
    /// <summary>How long, in milliseconds, bus-driven invalidations of one cache key fold into a single
    /// refetch.</summary>
    public int InvalidationWindowMs { get; init; } = ProtocolFacts.Timing("invalidationWindowMs").GetInt32();
    /// <summary>How long, in milliseconds, a followed job may say nothing before the client asks for its
    /// status.</summary>
    public int JobSilenceMs { get; init; } = ProtocolFacts.Timing("jobSilenceMs").GetInt32();
    /// <summary>How often, in milliseconds, a client asks for the status of a job that has gone silent.</summary>
    public int JobStatusPollMs { get; init; } = ProtocolFacts.Timing("jobStatusPollMs").GetInt32();
    /// <summary>How long, in milliseconds, a party that takes jobs waits for the answer to one claim.</summary>
    public int JobClaimTimeoutMs { get; init; } = ProtocolFacts.Timing("jobClaimTimeoutMs").GetInt32();
    /// <summary>How long, in milliseconds, a held job may show no activity before its holder calls it
    /// stalled.</summary>
    public int HeldJobStallMs { get; init; } = ProtocolFacts.Timing("heldJobStallMs").GetInt32();
    /// <summary>How often, in milliseconds, a party that holds a job checks how long it has shown no
    /// activity.</summary>
    public int HeldJobStallCheckMs { get; init; } = ProtocolFacts.Timing("heldJobStallCheckMs").GetInt32();
    /// <summary>How long, in milliseconds, a worker waits for a commit of annotations to be acknowledged.</summary>
    public int MarkCommitTimeoutMs { get; init; } = ProtocolFacts.Timing("markCommitTimeoutMs").GetInt32();
    /// <summary>The retry budget of one emit.</summary>
    public RetryPolicy EmitRetry { get; init; } = RetryPolicy.FromTiming("emitRetry");
}

/// <summary>A retry budget: how many attempts to make, and a backoff between them that starts at one delay and doubles
/// up to another.</summary>
/// <param name="Attempts">How many attempts to make, the first included.</param>
/// <param name="InitialDelayMs">The backoff before the second attempt, in milliseconds.</param>
/// <param name="MaxDelayMs">The longest the backoff grows to, in milliseconds.</param>
public sealed record RetryPolicy(int Attempts, int InitialDelayMs, int MaxDelayMs)
{
    internal static RetryPolicy FromTiming(string entry)
    {
        var budget = ProtocolFacts.Timing(entry);
        return new(budget.GetProperty("attempts").GetInt32(), budget.GetProperty("initialDelayMs").GetInt32(), budget.GetProperty("maxDelayMs").GetInt32());
    }
}
