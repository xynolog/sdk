using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Protocol;
using Xynolog.Registry;
using Xynolog.Session;
using Xynolog.SignIn;
using Xynolog.Types;

namespace Xynolog.Testing;

/// <summary>What <see cref="TestSessions.CreateTestSessionAsync"/> builds a session on; each part left out takes a
/// default.</summary>
/// <param name="Transport">The scripted transport the client talks to, which stays the caller's; a fresh one when null.</param>
/// <param name="Kb">The knowledge base the session is to; a local test one when null.</param>
/// <param name="Kept">Where the sign-in is kept; in memory when null.</param>
/// <param name="TimeProvider">The clock the session keeps; the system's when null.</param>
/// <param name="Timing">The timing the transport keeps; the protocol's when null.</param>
/// <param name="Random">What the session's jitter is drawn from; the shared generator when null.</param>
public sealed record TestSessionOptions(FaultyTransport? Transport = null, KbTarget? Kb = null,
    ISignInKept? Kept = null, TimeProvider? TimeProvider = null, Timing? Timing = null, Random? Random = null);

/// <summary>An offline session over a real SDK client, which keeps nothing. Disposal closes the client, then the session.</summary>
public sealed class TestSession : IDisposable
{
    private readonly HttpClient http;
    private readonly KeptSession credentials;
    /// <summary>The session under test.</summary>
    public XynologSession Session { get; }
    /// <summary>The session's client.</summary>
    public XynologClient Client => Session.Client;
    /// <summary>The scripted transport the client talks to.</summary>
    public FaultyTransport Transport { get; }
    /// <summary>Where the session's sign-in is kept.</summary>
    public ISignInKept Kept { get; }

    internal TestSession(XynologSession session, FaultyTransport transport, ISignInKept kept, KeptSession credentials, HttpClient http)
    {
        Session = session;
        Transport = transport;
        Kept = kept;
        this.credentials = credentials;
        this.http = http;
    }

    /// <summary>Updates the live credential for a test without changing kept storage.</summary>
    public void SetToken(string? token)
    {
        credentials.SetOfflineToken(token);
        Session.UpdateIdentity();
    }

    /// <summary>Closes the client, then the session, then the HTTP client they shared.</summary>
    public void Dispose()
    {
        try
        {
            try { Client.Dispose(); }
            finally { Session.Dispose(); }
        }
        finally { http.Dispose(); }
    }
}

/// <summary>Makes offline sessions for tests.</summary>
public static class TestSessions
{
    /// <summary>Starts from the kept token without validating or renewing it. A supplied transport remains caller-owned.</summary>
    public static async Task<TestSession> CreateTestSessionAsync(TestSessionOptions? options = null, CancellationToken cancellation = default)
    {
        options ??= new();
        var kb = options.Kb ?? new KbTarget
        {
            Id = "test-kb",
            Label = "Test KB",
            Endpoint = new KbEndpoint.HttpEndpointCase(new HttpEndpoint { Host = "localhost", Port = 4000, Protocol = HttpEndpointProtocol.Http }),
        };
        if (kb.Endpoint is not KbEndpoint.HttpEndpointCase(var endpoint))
            throw new SessionError(ProtocolFacts.SessionError("construct-failed"), "The test session requires an HTTP endpoint.");
        var origin = Gateway.Origin(endpoint);
        var clock = options.TimeProvider ?? TimeProvider.System;
        var random = options.Random ?? Random.Shared;
        var transport = options.Transport ?? new FaultyTransport(timeProvider: clock);
        var http = new HttpClient(transport, disposeHandler: options.Transport is null) { Timeout = Timeout.InfiniteTimeSpan };
        var kept = options.Kept ?? new MemorySignIn();
        var credentials = new KeptSession(kept,
            (_, _) => throw new InvalidOperationException("An offline session does not renew."),
            (_, _) => throw new InvalidOperationException("An offline session does not validate."),
            clock, random, onAuthFailed: null, offline: true);
        XynologClient? client = null;
        try
        {
            await credentials.ReadyAsync(cancellation).ConfigureAwait(Spawning.Captures);
            var bus = new HttpTransport(origin, credentials.State.Token,
                BusRegistry.BridgedChannels,
                timing: options.Timing, refresher: credentials.RefreshAsync, httpClient: http, timeProvider: clock, random: random);
            client = new XynologClient(bus);
            return new TestSession(new XynologSession(kb, client, credentials), transport, kept, credentials, http);
        }
        catch
        {
            credentials.Dispose();
            client?.Dispose();
            http.Dispose();
            throw;
        }
    }
}
