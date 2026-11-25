using System.Runtime.CompilerServices;
using System.Threading.Channels;
using Xynolog.Http;
using Xynolog.Types;

namespace Xynolog;

/// <summary>
/// An upload that starts immediately. Read what it reports once and await the created resource. It reports
/// <see cref="UploadProgress.Started"/> with the file's size before any bytes are sent, a
/// <see cref="UploadProgress.Progress"/> as they are sent, and <see cref="UploadProgress.Finished"/> with the
/// resource made, once the knowledge base has answered. An upload that fails reports no resource, and its failure is
/// thrown to its reader and its awaiter.
/// </summary>
public sealed class Upload : IAsyncEnumerable<UploadProgress>, IDisposable
{
    private readonly object gate = new();
    private readonly CancellationTokenSource stopping;
    private readonly Channel<UploadProgress> progress = Channel.CreateUnbounded<UploadProgress>(
        new UnboundedChannelOptions { SingleReader = true });
    private readonly Task<CreateResourceResponse> completion;
    private bool finished;
    private int consumed;

    internal Upload(HttpContentTransport content, ResourceUpload request, CancellationToken cancellation)
    {
        stopping = CancellationTokenSource.CreateLinkedTokenSource(cancellation);
        completion = SendAsync(content, request);
    }

    /// <summary>Waits for the knowledge base's answer and returns the resource made; cancelling stops the upload.</summary>
    public async Task<CreateResourceResponse> CompleteAsync(CancellationToken cancellation = default)
    {
        using var registration = cancellation.Register(Dispose);
        return await Spawning.WaitAsync(completion, cancellation).ConfigureAwait(Spawning.Captures);
    }

    /// <summary>Lets the upload be awaited for the resource made, as <see cref="CompleteAsync"/> does.</summary>
    public TaskAwaiter<CreateResourceResponse> GetAwaiter() => CompleteAsync().GetAwaiter();

    /// <summary>Reads the upload's progress, once; the stream ends when the upload does and throws its failure.</summary>
    public IAsyncEnumerator<UploadProgress> GetAsyncEnumerator(CancellationToken cancellationToken = default)
    {
        if (Interlocked.Exchange(ref consumed, 1) != 0)
            throw new InvalidOperationException("Upload progress can be read once.");
        return ReadAsync(cancellationToken).GetAsyncEnumerator();
    }

    /// <summary>Stops the upload if it has not finished.</summary>
    public void Dispose()
    {
        lock (gate)
        {
            if (!finished) stopping.Cancel();
        }
    }

    private async IAsyncEnumerable<UploadProgress> ReadAsync([EnumeratorCancellation] CancellationToken cancellation)
    {
        try
        {
            await foreach (var update in Spawning.ReadAll(progress.Reader, cancellation).ConfigureAwait(Spawning.Captures))
                yield return update;
            await completion.ConfigureAwait(Spawning.Captures);
        }
        finally { Dispose(); }
    }

    private async Task<CreateResourceResponse> SendAsync(HttpContentTransport content, ResourceUpload request)
    {
        try
        {
            stopping.Token.ThrowIfCancellationRequested();
            return await content.UploadAsync(request, new Reporter(progress.Writer), stopping.Token).ConfigureAwait(Spawning.Captures);
        }
        finally
        {
            lock (gate)
            {
                finished = true;
                progress.Writer.TryComplete();
                // Dispose under the same lock used to cancel the in-flight upload.
                stopping.Dispose();
            }
        }
    }

    private sealed class Reporter(ChannelWriter<UploadProgress> writer) : IProgress<UploadProgress>
    {
        public void Report(UploadProgress value) => writer.TryWrite(value);
    }
}
