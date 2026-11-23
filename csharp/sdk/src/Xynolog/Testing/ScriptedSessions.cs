using System.Collections.Concurrent;
using System.Text.Json;
using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Protocol;
using Xynolog.Registry;
using Xynolog.Session;
using Xynolog.Types;

namespace Xynolog.Testing;

/// <summary>A scripted answer to one renewal of a credential: a token, or a failure.</summary>
public closed record Renewal
{
    /// <summary>Renews the credential to a token.</summary>
    /// <param name="Value">The renewed token, or null for a renewal that yields none.</param>
    public sealed record Token(string? Value) : Renewal;
    /// <summary>Fails the renewal.</summary>
    /// <param name="Error">The error the renewal throws.</param>
    public sealed record Failure(SignInError Error) : Renewal;
}

/// <summary>A factory that opens real sessions with scripted gateway answers, identity, and renewal.</summary>
public sealed class ScriptedSessions(Func<string, string, JsonElement, JsonElement?>? answer = null,
    TimeProvider? timeProvider = null, Random? random = null) : SessionFactory
{
    private readonly ConcurrentQueue<Renewal> renewals = new();
    private readonly ConcurrentQueue<(string KbId, FaultyTransport Transport)> built = new();
    private readonly ConcurrentQueue<StoredSession> revoked = new();
    private readonly TimeProvider clock = timeProvider ?? TimeProvider.System;
    private readonly Random random = random ?? Random.Shared;
    private volatile Func<string, string, JsonElement, JsonElement?>? refusal;
    private volatile string? constructFailure;
    private volatile UserResponse? user;
    private long identityDelayTicks;
    private int renewed;

    /// <summary>The stored sessions revoked through the factory, in order.</summary>
    public IReadOnlyList<StoredSession> Revoked => revoked.ToArray();
    /// <summary>How many renewals the factory's sessions have asked for.</summary>
    public int Renewed => Volatile.Read(ref renewed);
    /// <summary>The scripted transports the factory built for a knowledge base, in the order it opened them.</summary>
    public IReadOnlyList<FaultyTransport> Transports(string kbId) =>
        built.Where(entry => entry.KbId == kbId).Select(entry => entry.Transport).ToArray();

    /// <summary>Queues the answers to the next renewals, one renewal each, in order.</summary>
    public void QueueRenewals(params Renewal[] scripted)
    {
        foreach (var renewal in scripted) renewals.Enqueue(renewal);
    }

    /// <summary>Scripts whom the credential of every later session belongs to.</summary>
    public void SaysWho(UserResponse identity) => user = identity;
    /// <summary>Makes every later identity check wait <paramref name="delay"/> before it answers.</summary>
    public void AnswersAfter(TimeSpan delay) => Interlocked.Exchange(ref identityDelayTicks, delay.Ticks);
    /// <summary>Makes every later open fail with <paramref name="reason"/>, or, given null, succeed again.</summary>
    public void RefuseToBuild(string? reason) => constructFailure = reason;
    /// <summary>Scripts refusals of correlated requests: given the knowledge base, the operation and the payload, a
    /// failure body it returns refuses the request; null scripts none.</summary>
    public void RefuseWhen(Func<string, string, JsonElement, JsonElement?>? refuse) => refusal = refuse;

    /// <summary>Opens a real session to the options' knowledge base over a scripted transport, its identity and
    /// renewals as scripted.</summary>
    public async Task<OpenedSession> OpenAsync(SessionFactoryOptions options, CancellationToken cancellation = default)
    {
        cancellation.ThrowIfCancellationRequested();
        var kb = options.Kb;
        if (constructFailure is { } reason)
            throw new SessionError(ProtocolFacts.SessionError("construct-failed"), reason);
        if (kb.Endpoint is not KbEndpoint.HttpEndpointCase(var endpoint))
            throw new SessionError(ProtocolFacts.SessionError("construct-failed"), "The scripted session requires an HTTP endpoint.");
        var origin = Gateway.Origin(endpoint);
        var transport = new FaultyTransport(respond: Answer, timeProvider: clock)
        {
            Refusal = (operation, payload) => refusal?.Invoke(kb.Id, operation, payload),
        };
        built.Enqueue((kb.Id, transport));
        var http = new HttpClient(transport) { Timeout = Timeout.InfiniteTimeSpan };
        var stored = RegistryStorage.KeptIn(options.Storage, kb.Id);
        var identity = user;
        var delay = TimeSpan.FromTicks(Interlocked.Read(ref identityDelayTicks));
        var kept = new KeptSession(stored, RenewAsync, IdentifyAsync, clock, random, options.Signals.NotifySessionEnded);
        XynologClient? client = null;
        try
        {
            await kept.ReadyAsync(cancellation).ConfigureAwait(Spawning.Captures);
            var bus = new HttpTransport(origin, kept.State.Token,
                BusRegistry.BridgedChannels,
                refresher: kept.RefreshAsync, httpClient: http, timeProvider: clock, random: random);
            var openedClient = client = new XynologClient(bus);
            var session = new XynologSession(new KbTarget { Id = kb.Id, Label = kb.Label, Endpoint = kb.Endpoint }, openedClient, kept);
            return new OpenedSession(openedClient, async () =>
            {
                // The client first, its closing save awaited, then the session, then what the session was built on.
                try
                {
                    try
                    {
                        openedClient.Dispose();
                        await openedClient.Flushed.ConfigureAwait(Spawning.Captures);
                    }
                    finally
                    {
                        session.Dispose();
                        await kept.DisposeAsync().ConfigureAwait(Spawning.Captures);
                    }
                }
                finally { http.Dispose(); }
            }, session);
        }
        catch
        {
            kept.Dispose();
            client?.Dispose();
            http.Dispose();
            throw;
        }

        JsonElement? Answer(string operation, JsonElement payload) => answer is { } scripted
            ? scripted(kb.Id, operation, payload)
            : throw new TransportError(ProtocolFacts.Error(0), $"No response scripted for '{operation}' of knowledge base '{kb.Id}'.");

        async Task<UserResponse> IdentifyAsync(string _, CancellationToken stop)
        {
            if (delay > TimeSpan.Zero) await Task.Delay(delay, clock, stop).ConfigureAwait(Spawning.Captures);
            return identity ?? throw new TransportError(ProtocolFacts.Error(0), $"No identity scripted for knowledge base '{kb.Id}'.");
        }

        async Task<string?> RenewAsync(string? _, CancellationToken stop)
        {
            Interlocked.Increment(ref renewed);
            if (!renewals.TryDequeue(out var renewal))
                throw new SignInError(ProtocolFacts.SignInError("exchange"), $"No renewal scripted for knowledge base '{kb.Id}'.", 503);
            if (renewal is Renewal.Failure(var error)) throw error;
            if (renewal is Renewal.Token(var token) && token is not null && await stored.HeldAsync(stop).ConfigureAwait(Spawning.Captures) is { } read)
                return await stored.RenewedAsync(read, token, read.Refresh, stop).ConfigureAwait(Spawning.Captures);
            return null;
        }
    }

    /// <summary>Records the stored session as revoked, without a request.</summary>
    public Task RevokeAsync(StoredSession stored, CancellationToken cancellation = default)
    {
        cancellation.ThrowIfCancellationRequested();
        revoked.Enqueue(stored);
        return Task.CompletedTask;
    }
}
