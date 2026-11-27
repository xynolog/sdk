using System.Net;
using System.Net.Http.Headers;
using System.Runtime.CompilerServices;
using System.Text.Json;
using System.Text.Json.Serialization;
using Xynolog.Protocol;
using Xynolog.Serialization;
using Xynolog.Types;

namespace Xynolog.Discovery;

/// <summary>Where discovery documents are read from: a file, a URL, or anything that yields one.</summary>
public interface DiscoveryTransport
{
    /// <summary>Reads the document once, giving its state, or that it has not changed.</summary>
    public Task<DiscoveryRead> ReadAsync(CancellationToken cancellation = default);
}

/// <summary>Finds the knowledge bases a launcher manages, from its discovery document, and follows them as they
/// change.</summary>
public static partial class LauncherDiscovery
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
        catch (JsonException error) { return Absent(DiscoveryAbsentReason.NotJson, error.Message); }
        using (parsed)
        {
            var root = parsed.RootElement;
            if (root.ValueKind != JsonValueKind.Object || !root.TryGetProperty("version", out var stated) ||
                stated.ValueKind != JsonValueKind.Number || !stated.TryGetInt64(out var version))
                return Absent(DiscoveryAbsentReason.Invalid, "A discovery document requires a numeric version.");
            if (version != Version)
                return Absent(DiscoveryAbsentReason.UnsupportedVersion, $"Discovery document version {version} is unsupported.");
            return Required.TryRead<DiscoveryDocument>(root, out var document, out var fault)
                ? new DiscoveryState.DiscoveryManaged(new DiscoveryManaged { Kbs = document.Kbs })
                : Absent(DiscoveryAbsentReason.Invalid, fault.Said());
        }
    }

    private static DiscoveryState.DiscoveryAbsent Absent(DiscoveryAbsentReason reason, string? diagnostic) =>
        new(new DiscoveryAbsent { Reason = reason, Diagnostic = diagnostic });

    /// <summary>The read that found <paramref name="state"/>.</summary>
    private static DiscoveryRead ReadOf(DiscoveryState state) => state switch
    {
        DiscoveryState.DiscoveryAbsent(var absent) => new DiscoveryRead.DiscoveryAbsent(absent),
        DiscoveryState.DiscoveryManaged(var managed) => new DiscoveryRead.DiscoveryManaged(managed),
    };

    /// <summary>The state <paramref name="read"/> found; null when it found the document unchanged.</summary>
    private static DiscoveryState? StateOf(DiscoveryRead read) => read switch
    {
        DiscoveryRead.DiscoveryAbsent(var absent) => new DiscoveryState.DiscoveryAbsent(absent),
        DiscoveryRead.DiscoveryManaged(var managed) => new DiscoveryState.DiscoveryManaged(managed),
        DiscoveryRead.DiscoveryUnchanged => null,
    };

    /// <summary>Reads discovery documents as text a function supplies, such as a file's contents; a missing or unreadable
    /// file reads as <see cref="DiscoveryRead.DiscoveryAbsent"/>.</summary>
    public static DiscoveryTransport TextDiscovery(Func<CancellationToken, Task<string>> readText) => new TextReader(readText);

    /// <summary>Reads discovery documents from a URL, asking with the last document's entity tag so an unchanged one reads
    /// as <see cref="DiscoveryRead.DiscoveryUnchanged"/>.</summary>
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
            if (StateOf(await transport.ReadAsync(cancellation).ConfigureAwait(Spawning.Captures)) is { } state && Difference(previous, state) is { } change)
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
        var old = previous is DiscoveryState.DiscoveryManaged(var before) ? before.Kbs.ToLookup(Address, StringComparer.Ordinal) : Enumerable.Empty<DiscoveredKB>().ToLookup(Address);
        var now = current is DiscoveryState.DiscoveryManaged(var after) ? after.Kbs.ToLookup(Address, StringComparer.Ordinal) : Enumerable.Empty<DiscoveredKB>().ToLookup(Address);
        var added = now.Where(group => !old.Contains(group.Key)).SelectMany(group => group).ToArray();
        var removed = old.Where(group => !now.Contains(group.Key)).SelectMany(group => group).ToArray();
        var updated = now.Where(group => old.Contains(group.Key) && !SameEntries(old[group.Key], group)).SelectMany(group => group).ToArray();
        var changed = previous is null || previous.GetType() != current.GetType() ||
            previous is DiscoveryState.DiscoveryAbsent(var oldAbsent) && current is DiscoveryState.DiscoveryAbsent(var newAbsent) && oldAbsent.Reason != newAbsent.Reason;
        return changed || added.Length + removed.Length + updated.Length > 0
            ? new DiscoveryDiff
            {
                State = current,
                Added = added,
                Updated = updated,
                Removed = removed,
                Duplicated = now.Where(group => group.Count() > 1).Select(group => group.Key).ToArray(),
            }
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
            try { return ReadOf(ParseDiscoveryDocument(await read(cancellation).ConfigureAwait(Spawning.Captures))); }
            catch (Exception error) when (error is FileNotFoundException or DirectoryNotFoundException) { return ReadOf(Absent(DiscoveryAbsentReason.NotFound, null)); }
            catch (Exception error) when (error is IOException or UnauthorizedAccessException or System.Text.DecoderFallbackException)
            { return ReadOf(Absent(DiscoveryAbsentReason.Unreadable, error.Message)); }
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
                if (response.StatusCode == HttpStatusCode.NotModified && tag is not null) return new DiscoveryRead.DiscoveryUnchanged(new DiscoveryUnchanged());
                tag = null;
                var media = response.Content.Headers.ContentType?.MediaType;
                if (!response.IsSuccessStatusCode || media?.Contains("json", StringComparison.OrdinalIgnoreCase) != true)
                    return ReadOf(Absent(DiscoveryAbsentReason.NotFound, $"HTTP {(int)response.StatusCode}, content type {media}"));
                var state = ParseDiscoveryDocument(await response.Content.ReadAsStringAsync(waiting.Token).ConfigureAwait(Spawning.Captures));
                if (state is DiscoveryState.DiscoveryManaged) tag = response.Headers.ETag;
                return ReadOf(state);
            }
            catch (Exception error) when (error is HttpRequestException or IOException ||
                error is OperationCanceledException && !cancellation.IsCancellationRequested)
            {
                tag = null;
                return ReadOf(Absent(DiscoveryAbsentReason.Unreadable, error.Message));
            }
            finally { turn.Release(); }
        }
    }
}
