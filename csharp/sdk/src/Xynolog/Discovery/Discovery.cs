using System.Net;
using System.Net.Http.Headers;
using System.Runtime.CompilerServices;
using System.Text.Json;
using System.Text.Json.Serialization;
using Xynolog.Protocol;
using Xynolog.Types;

namespace Xynolog.Discovery;

/// <summary>What one read of a launcher's discovery document found: its state, or <see cref="Unchanged"/>.</summary>
public abstract record DiscoveryRead;
/// <summary>The knowledge bases a launcher manages, or why none could be read.</summary>
public abstract record DiscoveryState : DiscoveryRead;
/// <summary>No discovery document could be read, or what was read is not one.</summary>
/// <param name="Reason">Why there is none.</param>
/// <param name="Diagnostic">What went wrong, in prose, when there is more to say.</param>
public sealed record Absent(DiscoveryAbsentReason Reason, string? Diagnostic = null) : DiscoveryState;
/// <summary>A discovery document, and the knowledge bases it lists.</summary>
/// <param name="Kbs">The knowledge bases the launcher manages.</param>
public sealed record Managed(IReadOnlyList<DiscoveredKB> Kbs) : DiscoveryState;
/// <summary>The document has not changed since the last read that found one.</summary>
public sealed record Unchanged : DiscoveryRead;

/// <summary>Where discovery documents are read from: a file, a URL, or anything that yields one.</summary>
public interface DiscoveryTransport
{
    /// <summary>Reads the document once, giving its state, or that it has not changed.</summary>
    public Task<DiscoveryRead> ReadAsync(CancellationToken cancellation = default);
}

/// <summary>How the knowledge bases a launcher manages changed between two reads, keyed by host and port.</summary>
/// <param name="State">The state the latest read found.</param>
/// <param name="Added">The entries at an address the previous state did not list.</param>
/// <param name="Updated">The entries at an address the previous state listed differently.</param>
/// <param name="Removed">The entries of the previous state at an address the latest one does not list.</param>
/// <param name="Duplicated">The addresses the latest state lists more than once, as host:port.</param>
public sealed record DiscoveryDiff(DiscoveryState State, IReadOnlyList<DiscoveredKB> Added,
    IReadOnlyList<DiscoveredKB> Updated, IReadOnlyList<DiscoveredKB> Removed, IReadOnlyList<string> Duplicated);

/// <summary>Finds the knowledge bases a launcher manages, from its discovery document, and follows them as they
/// change.</summary>
public static class LauncherDiscovery
{
    /// <summary>How long <see cref="SubscribeDiscovery"/> waits between reads unless told otherwise.</summary>
    public static readonly TimeSpan DiscoveryInterval = TimeSpan.FromMilliseconds(Timings.DiscoveryIntervalMs);
    private static readonly TimeSpan RequestDeadline = TimeSpan.FromMilliseconds(Timings.HttpRequestTimeoutMs);
    private static readonly long Version = JsonSerializer.Deserialize<JsonElement>(ProtocolTables.Discovery)
        .GetProperty("properties").GetProperty("version").GetProperty("enum").EnumerateArray().Single().GetInt64();
    private static readonly HttpClient SharedHttp = new(new SocketsHttpHandler { UseProxy = false }) { Timeout = Timeout.InfiniteTimeSpan };

    /// <summary>Reads a discovery document's text as the knowledge bases it lists, or as why it is not one.</summary>
    public static DiscoveryState ParseDiscoveryDocument(string text)
    {
        JsonDocument parsed;
        try { parsed = JsonDocument.Parse(text); }
        catch (JsonException error) { return new Absent(DiscoveryAbsentReason.NotJson, error.Message); }
        using (parsed)
        {
            var root = parsed.RootElement;
            if (root.ValueKind != JsonValueKind.Object || !root.TryGetProperty("version", out var stated) ||
                stated.ValueKind != JsonValueKind.Number || !stated.TryGetInt64(out var version))
                return new Absent(DiscoveryAbsentReason.Invalid, "A discovery document requires a numeric version.");
            if (version != Version)
                return new Absent(DiscoveryAbsentReason.UnsupportedVersion, $"Discovery document version {version} is unsupported.");
            try
            {
                var document = root.Deserialize<DiscoveryDocument>() ?? throw new JsonException("Missing discovery document.");
                foreach (var kb in document.Kbs)
                    if (kb.Port is < 1 or > 65535) throw new JsonException($"Invalid port for {kb.Host}.");
                return new Managed(document.Kbs);
            }
            catch (JsonException error) { return new Absent(DiscoveryAbsentReason.Invalid, error.Message); }
        }
    }

    /// <summary>Reads discovery documents as text a function supplies, such as a file's contents; a missing or unreadable
    /// file reads as <see cref="Absent"/>.</summary>
    public static DiscoveryTransport TextDiscovery(Func<CancellationToken, Task<string>> readText) => new TextReader(readText);

    /// <summary>Reads discovery documents from a URL, asking with the last document's entity tag so an unchanged one reads
    /// as <see cref="Unchanged"/>.</summary>
    public static DiscoveryTransport HttpDiscovery(string url, HttpClient? httpClient = null, TimeProvider? timeProvider = null) =>
        new HttpReader(url, httpClient ?? SharedHttp, timeProvider ?? TimeProvider.System);

    /// <summary>Reads the document on an interval and yields each change, the first read's state among them.</summary>
    public static async IAsyncEnumerable<DiscoveryDiff> SubscribeDiscovery(DiscoveryTransport transport, TimeSpan? interval = null,
        TimeProvider? timeProvider = null, [EnumeratorCancellation] CancellationToken cancellation = default)
    {
        var delay = interval ?? DiscoveryInterval;
        ArgumentOutOfRangeException.ThrowIfLessThanOrEqual(delay, TimeSpan.Zero);
        var clock = timeProvider ?? TimeProvider.System;
        DiscoveryState? previous = null;
        while (true)
        {
            cancellation.ThrowIfCancellationRequested();
            if (await transport.ReadAsync(cancellation).ConfigureAwait(Spawning.Captures) is DiscoveryState state && Difference(previous, state) is { } change)
            {
                previous = state;
                yield return change;
            }
            await Task.Delay(delay, clock, cancellation).ConfigureAwait(Spawning.Captures);
        }
    }

    internal static DiscoveryDiff? Difference(DiscoveryState? previous, DiscoveryState current)
    {
        static string Address(DiscoveredKB kb) => kb.Host + ":" + kb.Port.ToString(System.Globalization.CultureInfo.InvariantCulture);
        var old = previous is Managed before ? before.Kbs.ToLookup(Address, StringComparer.Ordinal) : Enumerable.Empty<DiscoveredKB>().ToLookup(Address);
        var now = current is Managed after ? after.Kbs.ToLookup(Address, StringComparer.Ordinal) : Enumerable.Empty<DiscoveredKB>().ToLookup(Address);
        var added = now.Where(group => !old.Contains(group.Key)).SelectMany(group => group).ToArray();
        var removed = old.Where(group => !now.Contains(group.Key)).SelectMany(group => group).ToArray();
        var updated = now.Where(group => old.Contains(group.Key) && !SameEntries(old[group.Key], group)).SelectMany(group => group).ToArray();
        var changed = previous is null || previous.GetType() != current.GetType() ||
            previous is Absent oldAbsent && current is Absent newAbsent && oldAbsent.Reason != newAbsent.Reason;
        return changed || added.Length + removed.Length + updated.Length > 0
            ? new DiscoveryDiff(current, added, updated, removed, now.Where(group => group.Count() > 1).Select(group => group.Key).ToArray())
            : null;
    }

    private static bool SameEntries(IEnumerable<DiscoveredKB> previous, IEnumerable<DiscoveredKB> current)
    {
        var unmatched = previous.ToList();
        foreach (var entry in current)
            if (!unmatched.Remove(entry)) return false;
        return unmatched.Count == 0;
    }

    private sealed class TextReader(Func<CancellationToken, Task<string>> read) : DiscoveryTransport
    {
        public async Task<DiscoveryRead> ReadAsync(CancellationToken cancellation = default)
        {
            try { return ParseDiscoveryDocument(await read(cancellation).ConfigureAwait(Spawning.Captures)); }
            catch (Exception error) when (error is FileNotFoundException or DirectoryNotFoundException) { return new Absent(DiscoveryAbsentReason.NotFound); }
            catch (Exception error) when (error is IOException or UnauthorizedAccessException or System.Text.DecoderFallbackException)
            { return new Absent(DiscoveryAbsentReason.Unreadable, error.Message); }
        }
    }

    private sealed class HttpReader(string url, HttpClient http, TimeProvider clock) : DiscoveryTransport
    {
        private readonly SemaphoreSlim turn = new(1, 1);
        private EntityTagHeaderValue? tag;

        public async Task<DiscoveryRead> ReadAsync(CancellationToken cancellation = default)
        {
            await Spawning.WaitAsync(turn, cancellation).ConfigureAwait(Spawning.Captures);
            try
            {
                using var request = new HttpRequestMessage(HttpMethod.Get, url);
                if (tag is not null) request.Headers.IfNoneMatch.Add(tag);
                using var deadline = new CancellationTokenSource(RequestDeadline, clock);
                using var waiting = CancellationTokenSource.CreateLinkedTokenSource(deadline.Token, cancellation);
                using var response = await http.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, waiting.Token).ConfigureAwait(Spawning.Captures);
                if (response.StatusCode == HttpStatusCode.NotModified && tag is not null) return new Unchanged();
                tag = null;
                var media = response.Content.Headers.ContentType?.MediaType;
                if (!response.IsSuccessStatusCode || media?.Contains("json", StringComparison.OrdinalIgnoreCase) != true)
                    return new Absent(DiscoveryAbsentReason.NotFound, $"HTTP {(int)response.StatusCode}, content type {media}");
                var state = ParseDiscoveryDocument(await response.Content.ReadAsStringAsync(waiting.Token).ConfigureAwait(Spawning.Captures));
                if (state is Managed) tag = response.Headers.ETag;
                return state;
            }
            catch (Exception error) when (error is HttpRequestException or IOException ||
                error is OperationCanceledException && !cancellation.IsCancellationRequested)
            {
                tag = null;
                return new Absent(DiscoveryAbsentReason.Unreadable, error.Message);
            }
            finally { turn.Release(); }
        }
    }
}
