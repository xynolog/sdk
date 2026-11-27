using System.Text.Json;
using Xynolog.Types;

namespace Xynolog.Jobs;

/// <summary>What a party that takes jobs subscribes to and decides, as the protocol states it.</summary>
public static partial class WorkerRules
{
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
