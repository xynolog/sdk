using System.Text.Json;
using Xynolog.Types;

namespace Xynolog.Jobs;

/// <summary>What a party that takes jobs subscribes to and decides, as the protocol states it.</summary>
public static class WorkerRules
{
    /// <summary>The channels a party that claims jobs subscribes to: the replies to a claim, and the queued and
    /// cancel-requested jobs.</summary>
    public static readonly IReadOnlyList<string> JobClaimChannels =
        [.. BusRegistry.ReplyChannelsFor(BusOperations.JobClaim.Request.Name), BusChannels.JobQueued.Name, BusChannels.JobCancelRequested.Name];

    /// <summary>The channels a worker subscribes to in order to commit annotations: the replies to a commit and to its
    /// check that the commit landed.</summary>
    public static readonly IReadOnlyList<string> JobCommitChannels =
        BusRegistry.ReplyChannelsFor(BusOperations.MarkCommit.Request.Name, BusOperations.BrowseAnnotationRequested.Request.Name);

    /// <summary>Whether <paramref name="job"/> matches <paramref name="filter"/>: each member of a filter object
    /// matches the job's member of that name, and any other filter value equals the job.</summary>
    public static bool JobMatchesFilter(JsonElement filter, JsonElement job) => filter.ValueKind == JsonValueKind.Object
        ? job.ValueKind == JsonValueKind.Object && filter.EnumerateObject().All(field =>
            job.TryGetProperty(field.Name, out var actual) && JobMatchesFilter(field.Value, actual))
        : JsonElement.DeepEquals(filter, job);

    /// <summary>Whether a failed job will be queued again: it has retries left and its failure is transient or
    /// unclassified.</summary>
    public static bool WillRetryAfter(long retryCount, long maxRetries, FailureClass? failureClass) =>
        retryCount < maxRetries && failureClass is null or FailureClass.Transient;
}
