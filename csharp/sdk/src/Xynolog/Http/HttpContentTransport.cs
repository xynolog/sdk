using Xynolog.Errors;
using System.Diagnostics;
using System.Net;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Net.Http.Headers;
using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog.Http;

/// <summary>A resource's bytes, read whole, with their media type.</summary>
/// <param name="ContentType">The bytes' media type.</param>
/// <param name="Bytes">The content, read whole.</param>
public sealed record BinaryContent(string ContentType, byte[] Bytes);
/// <summary>A resource's bytes as a stream to read, with their media type; disposing it ends the read.</summary>
/// <param name="ContentType">The bytes' media type.</param>
/// <param name="Stream">The bytes, as they arrive.</param>
public sealed record BinaryStream(string ContentType, Stream Stream) : IDisposable
{
    /// <summary>Closes the stream, and the response it reads.</summary>
    public void Dispose() => Stream.Dispose();
}

/// <summary>Uploads and reads resources' content over a transport's HTTP connection to its gateway.</summary>
public sealed class HttpContentTransport(HttpTransport transport) : IDisposable
{
    private readonly CancellationTokenSource lifetime = new();
    private readonly object gate = new();
    private readonly HashSet<Stream> streams = [];
    private bool closed;

    /// <summary>Ends every read in progress, closing the streams it handed out.</summary>
    public void Dispose()
    {
        Stream[] ending;
        lock (gate)
        {
            if (closed) return;
            closed = true;
            ending = streams.ToArray();
            streams.Clear();
        }
        try { lifetime.Cancel(); }
        finally
        {
            foreach (var stream in ending) stream.Dispose();
            lifetime.Dispose();
        }
    }

    private void Released(Stream stream) { lock (gate) { streams.Remove(stream); } }

    private CancellationTokenSource Link(CancellationToken cancellation)
    {
        lock (gate)
        {
            ObjectDisposedException.ThrowIf(closed, this);
            return CancellationTokenSource.CreateLinkedTokenSource(lifetime.Token, cancellation);
        }
    }

    /// <summary>Uploads a resource, reporting its progress, and returns the new resource's id.</summary>
    public async Task<ResourceId> PutBinaryAsync(ResourceUpload request, IProgress<UploadProgress>? progress = null, CancellationToken cancellation = default) =>
        (await UploadAsync(request, progress, cancellation).ConfigureAwait(Spawning.Captures)).ResourceId;

    internal async Task<CreateResourceResponse> UploadAsync(ResourceUpload request, IProgress<UploadProgress>? progress, CancellationToken cancellation)
    {
        using var linked = Link(cancellation);
        cancellation = linked.Token;
        using var activity = SdkTelemetry.Start("content.put", new ActivityTagsCollection { { TelemetryKeys.ContentFormat, request.Format }, { TelemetryKeys.ContentSizeBytes, request.File.LongLength } });
        progress?.Report(new UploadProgress.StartedCase(new UploadProgressStarted { TotalBytes = request.File.LongLength }));
        using var response = await transport.ExchangeAsync(GatewayRoute.UploadResource.Method, GatewayRoute.UploadResource.Path, () =>
        {
            var form = new MultipartFormDataContent();
            var metadata = JsonSerializer.SerializeToElement(request);
            foreach (var field in metadata.EnumerateObject())
            {
                if (field.Name == UploadField.File) continue;
                form.Add(new StringContent(field.Value.ValueKind == JsonValueKind.String ? field.Value.GetString() ?? throw new JsonException("Null upload member") : field.Value.GetRawText()), field.Name);
            }
            var file = new ProgressContent(request.File, progress);
            file.Headers.ContentType = new MediaTypeHeaderValue(request.Format);
            form.Add(file, UploadField.File, request.Name);
            return form;
        }, upload: true, cancellation: cancellation).ConfigureAwait(Spawning.Captures);
        var created = await transport.ReplyAsync<CreateResourceResponse>(response, GatewayRoute.UploadResource.Path, cancellation).ConfigureAwait(Spawning.Captures);
        progress?.Report(new UploadProgress.FinishedCase(new UploadProgressFinished { ResourceId = created.ResourceId }));
        return created;
    }

    /// <summary>Reads a resource's representation whole.</summary>
    public async Task<BinaryContent> GetBinaryAsync(ResourceId resource, CancellationToken cancellation = default)
    {
        using var linked = Link(cancellation);
        cancellation = linked.Token;
        using var activity = SdkTelemetry.Start("content.get", new ActivityTagsCollection { { TelemetryKeys.ResourceId, resource.Value } });
        using var response = await transport.ExchangeAsync(GatewayRoute.GetResourceRepresentation.Method, PathOf(GatewayRoute.GetResourceRepresentation, resource), cancellation: cancellation).ConfigureAwait(Spawning.Captures);
        return new BinaryContent(ContentType(response.Content), await response.Content.ReadAsByteArrayAsync(cancellation).ConfigureAwait(Spawning.Captures));
    }

    /// <summary>Opens a resource's representation as a stream, which the caller disposes.</summary>
    public async Task<BinaryStream> GetBinaryStreamAsync(ResourceId resource, CancellationToken cancellation = default)
    {
        using var linked = Link(cancellation);
        cancellation = linked.Token;
        var activity = SdkTelemetry.Start("content.get", new ActivityTagsCollection { { TelemetryKeys.ResourceId, resource.Value }, { TelemetryKeys.ContentStream, true } });
        var response = await transport.ExchangeAsync(GatewayRoute.GetResourceRepresentation.Method, PathOf(GatewayRoute.GetResourceRepresentation, resource), cancellation: cancellation).ConfigureAwait(Spawning.Captures);
        try
        {
            var mediaType = ContentType(response.Content);
            var stream = new ResponseStream(await response.Content.ReadAsStreamAsync(cancellation).ConfigureAwait(Spawning.Captures), response, activity, lifetime.Token, Released);
            lock (gate)
            {
                ObjectDisposedException.ThrowIf(closed, this);
                streams.Add(stream);
            }
            return new BinaryStream(mediaType, stream);
        }
        catch { activity?.Dispose(); response.Dispose(); throw; }
    }

    /// <summary>Reads a resource's description as JSON-LD.</summary>
    public async Task<GetResourceResponse> GetResourceGraphAsync(ResourceId resource, CancellationToken cancellation = default)
    {
        using var linked = Link(cancellation);
        cancellation = linked.Token;
        using var activity = SdkTelemetry.Start("content.get_graph", new ActivityTagsCollection { { TelemetryKeys.ResourceId, resource.Value } });
        return await transport.AnswerAsync<GetResourceResponse>(GatewayRoute.GetResourceJsonLd.Method, PathOf(GatewayRoute.GetResourceJsonLd, resource), cancellation: cancellation).ConfigureAwait(Spawning.Captures);
    }
    /// <summary>Reads the annotations on a resource.</summary>
    public async Task<GetAnnotationsResponse> GetAnnotationsAsync(ResourceId resource, CancellationToken cancellation = default)
    {
        using var linked = Link(cancellation);
        cancellation = linked.Token;
        using var activity = SdkTelemetry.Start("content.get_annotations", new ActivityTagsCollection { { TelemetryKeys.ResourceId, resource.Value } });
        return await transport.AnswerAsync<GetAnnotationsResponse>(GatewayRoute.GetResourceAnnotations.Method, PathOf(GatewayRoute.GetResourceAnnotations, resource), cancellation: cancellation).ConfigureAwait(Spawning.Captures);
    }
    /// <summary>Reads a resource's text with the page locations of its items.</summary>
    public async Task<AnchoredTextAnswer> GetAnchoredTextAsync(ResourceId resource, CancellationToken cancellation = default)
    {
        using var linked = Link(cancellation);
        cancellation = linked.Token;
        using var activity = SdkTelemetry.Start("content.get_anchored_text", new ActivityTagsCollection { { TelemetryKeys.ResourceId, resource.Value } });
        return await transport.AnswerAsync<AnchoredTextAnswer>(GatewayRoute.GetResourceAnchoredText.Method, PathOf(GatewayRoute.GetResourceAnchoredText, resource), cancellation: cancellation).ConfigureAwait(Spawning.Captures);
    }
    private static string ContentType(HttpContent content) =>
        (content.Headers.NonValidated.TryGetValues("Content-Type", out var values) ? values.FirstOrDefault() : null)
        ?? throw new TransportError(TransportErrorCode.Error, "The content response has no media type");

    private static string PathOf(GatewayRoute route, ResourceId resource) => route.Path.Replace("{id}", Uri.EscapeDataString(resource.Value), StringComparison.Ordinal);

    private sealed class ProgressContent(byte[] bytes, IProgress<UploadProgress>? progress) : HttpContent
    {
        protected override bool TryComputeLength(out long length) { length = bytes.LongLength; return true; }
        protected override Task SerializeToStreamAsync(Stream stream, TransportContext? context) => SerializeToStreamAsync(stream, context, CancellationToken.None);
        protected override async Task SerializeToStreamAsync(Stream stream, TransportContext? context, CancellationToken cancellationToken)
        {
            for (var offset = 0; offset < bytes.Length;)
            {
                var count = Math.Min(65536, bytes.Length - offset);
                await stream.WriteAsync(bytes.AsMemory(offset, count), cancellationToken).ConfigureAwait(Spawning.Captures);
                offset += count;
                progress?.Report(new UploadProgress.ProgressCase(new UploadProgressProgress { BytesUploaded = offset, TotalBytes = bytes.LongLength }));
            }
        }
    }

    private sealed class ResponseStream(Stream stream, HttpResponseMessage response, Activity? activity, CancellationToken lifetime, Action<Stream> released) : Stream
    {
        private int closed;
        public override bool CanRead => Volatile.Read(ref closed) == 0 && stream.CanRead;
        public override bool CanSeek => false;
        public override bool CanWrite => false;
        public override long Length => throw new NotSupportedException();
        public override long Position { get => throw new NotSupportedException(); set => throw new NotSupportedException(); }
        public override int Read(byte[] buffer, int offset, int count) => stream.Read(buffer, offset, count);
        public override async ValueTask<int> ReadAsync(Memory<byte> buffer, CancellationToken cancellationToken = default)
        {
            using var linked = CancellationTokenSource.CreateLinkedTokenSource(lifetime, cancellationToken);
            return await stream.ReadAsync(buffer, linked.Token).ConfigureAwait(Spawning.Captures);
        }
        public override void Flush() => throw new NotSupportedException();
        public override long Seek(long offset, SeekOrigin origin) => throw new NotSupportedException();
        public override void SetLength(long value) => throw new NotSupportedException();
        public override void Write(byte[] buffer, int offset, int count) => throw new NotSupportedException();
        protected override void Dispose(bool disposing)
        {
            if (disposing && Interlocked.Exchange(ref closed, 1) == 0)
            {
                stream.Dispose();
                response.Dispose();
                activity?.Dispose();
                released(this);
            }
            base.Dispose(disposing);
        }
    }
}
