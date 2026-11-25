using Xynolog.Errors;
using Xynolog.Types;

namespace Xynolog.Http;

/// <summary>Retries an operation on a jittered, doubling backoff.</summary>
public static class Retry
{
    /// <summary>Runs <paramref name="attempt"/> until it succeeds, making another attempt after each error
    /// <paramref name="retryable"/> accepts while the policy has attempts left, after a jittered backoff or the error's
    /// stated wait when that is longer.</summary>
    public static async Task<T> RetryWithBackoffAsync<T>(RetryBudget policy, Func<CancellationToken, Task<T>> attempt,
        Func<XynologError, bool> retryable, Func<XynologError, TimeSpan?> statedWait,
        TimeProvider? timeProvider = null, Random? random = null, CancellationToken cancellation = default)
    {
        var clock = timeProvider ?? TimeProvider.System;
        var source = random ?? Random.Shared;
        var cap = TimeSpan.FromMilliseconds(policy.InitialDelayMs);
        var maximum = TimeSpan.FromMilliseconds(policy.MaxDelayMs);
        for (var made = 1; ; made++)
        {
            try { return await attempt(cancellation).ConfigureAwait(Spawning.Captures); }
            catch (XynologError error) when (made < policy.Attempts && retryable(error))
            {
                var wait = EqualJitter(cap, source);
                if (statedWait(error) is TimeSpan stated && stated > wait) wait = stated;
                await Task.Delay(wait, clock, cancellation).ConfigureAwait(Spawning.Captures);
            }
            cap = cap * 2 < maximum ? cap * 2 : maximum;
        }
    }

    /// <summary>Callers backing off on one schedule do not come back at one instant, and the wait never exceeds <paramref name="cap"/>.</summary>
    internal static TimeSpan EqualJitter(TimeSpan cap, Random random) => cap / 2 + cap / 2 * random.NextDouble();
}
