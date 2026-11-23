using System.Runtime.CompilerServices;
using Xynolog.Types;

namespace Xynolog;

/// <summary>The job's identity, progress, retryable setbacks, the frames of its lifecycle that were refused, and its
/// completion.</summary>
public closed record JobEvent<T>
{
    /// <summary>The knowledge base created the job, and named it.</summary>
    /// <param name="Value">The knowledge base's answer naming the job.</param>
    public sealed record Created(JobCreatedResultResponse Value) : JobEvent<T>;
    /// <summary>The job reported its progress.</summary>
    /// <param name="Value">The progress reported.</param>
    public sealed record Progress(JobProgress Value) : JobEvent<T>;
    /// <summary>An attempt of the job failed, and the job may yet be retried.</summary>
    /// <param name="Value">The failure reported.</param>
    public sealed record Failed(JobFailCommand Value) : JobEvent<T>;

    /// <summary>A frame of a job's progress, completion or failure, refused by its transport or as its channel's: its
    /// channel, and the member and reason of its fault. It names no job, so it may be this job's or another's, and it is
    /// no word of the job: the follower goes on, and its silence goes on being counted. It comes only after
    /// <see cref="Created"/>.</summary>
    public sealed record Refused(string Channel, string Member, FrameRefusalReason Reason) : JobEvent<T>;

    /// <summary>The job completed: the last event of its lifecycle.</summary>
    /// <param name="Value">The job's result.</param>
    public sealed record Complete(T Value) : JobEvent<T>;
}

/// <summary>A job followed once, by awaiting its completion or reading its lifecycle events.</summary>
public sealed class Delegation<T> : IAsyncEnumerable<JobEvent<T>>
{
    private readonly Running<JobEvent<T>> following;

    internal Delegation(Func<Action<JobEvent<T>>?, CancellationToken, Task<T>> follow) =>
        following = new(async (report, cancellation) => new JobEvent<T>.Complete(await follow(report, cancellation).ConfigureAwait(Spawning.Captures)));

    /// <summary>Follows the job, reading each event of its lifecycle through its completion.</summary>
    public IAsyncEnumerator<JobEvent<T>> GetAsyncEnumerator(CancellationToken cancellationToken = default) =>
        following.GetAsyncEnumerator(cancellationToken);

    /// <summary>Follows the job and returns its result once it completes.</summary>
    public async Task<T> CompleteAsync(CancellationToken cancellation = default)
    {
        var terminal = await following.CompleteAsync(cancellation).ConfigureAwait(Spawning.Captures);
        return terminal is JobEvent<T>.Complete(var completion)
            ? completion : throw new InvalidOperationException("A delegation ended without its completion.");
    }

    /// <summary>Lets the job be awaited for its result, as <see cref="CompleteAsync"/> does.</summary>
    public TaskAwaiter<T> GetAwaiter() => CompleteAsync().GetAwaiter();
}
