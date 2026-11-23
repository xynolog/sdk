using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Protocol;
using Xynolog.Session;
using Xynolog.SignIn;
using Xynolog.Storage;
using Xynolog.State;
using Xynolog.Types;

namespace Xynolog.Registry;

/// <summary>What a <see cref="XynologBrowser"/> is made with.</summary>
/// <param name="Storage">Where the registry keeps its knowledge bases, their sign-ins and their open resources.</param>
/// <param name="SessionFactory">Opens the active knowledge base's session.</param>
/// <param name="TimeProvider">The registry's clock; the system's when null.</param>
/// <param name="Random">The source of its sign-ins' retry jitter; the shared one when null.</param>
public sealed record XynologBrowserConfig(ISessionStorage Storage, SessionFactory SessionFactory, TimeProvider? TimeProvider = null,
    Random? Random = null);
/// <summary>What a <see cref="SessionFactory"/> opens a knowledge base's session with.</summary>
/// <param name="Kb">The knowledge base to open.</param>
/// <param name="Storage">The registry's storage, which holds the knowledge base's sign-in.</param>
/// <param name="Signals">Where the session says why it ended, and what else it notices about itself.</param>
public sealed record SessionFactoryOptions(KnowledgeBase Kb, ISessionStorage Storage, SessionSignals Signals);

/// <summary>Opens the sessions a <see cref="XynologBrowser"/> makes active, and revokes the sign-ins it signs out of.</summary>
public interface SessionFactory
{
    /// <summary>Opens a session with a registered knowledge base under its stored sign-in.</summary>
    public Task<OpenedSession> OpenAsync(SessionFactoryOptions options, CancellationToken cancellation = default);
    /// <summary>Revokes a sign-in the registry has already forgotten, at its issuer.</summary>
    public Task RevokeAsync(StoredSession stored, CancellationToken cancellation = default);
}

/// <summary>A knowledge base's open client, its session if it has one, and how to close them.</summary>
public sealed class OpenedSession : IAsyncDisposable
{
    private readonly Func<ValueTask> close;
    private readonly object gate = new();
    private Task? closing;
    /// <summary>The client that speaks to the knowledge base.</summary>
    public XynologClient Client { get; }
    /// <summary>The session the client runs in, or null for a client opened without one.</summary>
    public XynologSession? Session { get; }

    /// <summary>Pairs a client with its session and its close, which by default disposes the client.</summary>
    public OpenedSession(XynologClient client, Func<ValueTask>? close = null, XynologSession? session = null)
    {
        Client = client;
        Session = session;
        this.close = close ?? (() => { client.Dispose(); return ValueTask.CompletedTask; });
    }

    /// <summary>Closes the client and its session, once, however often it is called.</summary>
    public ValueTask DisposeAsync()
    {
        lock (gate) return new ValueTask(closing ??= Spawning.Run(CloseAsync));
    }

    private async Task CloseAsync() => await close().ConfigureAwait(Spawning.Captures);
}

/// <summary>
/// Opens an active knowledge base with the same kept session used for other HTTP clients. Its client keeps what it holds
/// for the person the knowledge base's sign-in names, from when the sign-in names them. Its session tells the signals it
/// is given why it ended, as it signs out.
/// </summary>
public sealed class HttpSessionFactory(HttpClient? httpClient = null, TimeProvider? timeProvider = null, Random? random = null) : SessionFactory
{
    /// <inheritdoc/>
    public async Task<OpenedSession> OpenAsync(SessionFactoryOptions options, CancellationToken cancellation = default)
    {
        if (options.Kb.Endpoint is not KbEndpoint.HttpEndpointCase(var endpoint))
            throw new SessionError(ProtocolFacts.SessionError("construct-failed"), "This factory requires an HTTP endpoint.");
        var errors = new Broadcast<XynologError>(keptForFirst: XynologError.KeptForFirstReader);
        // The client writes only while the sign-in stored beside it names its person, read through what holds it there.
        var persistence = new CachePersistence(options.Storage, options.Kb.Id, RegistryStorage.KeptIn(options.Storage, options.Kb.Id), errors.Publish);
        var signIn = RegistryStorage.KeptFor(persistence);
        if (RegistryStorage.StoredSession(options.Storage, options.Kb.Id) is { PersonKey: { } named }) persistence.Attach(named);
        var kept = new KeptSession(endpoint, signIn, httpClient, timeProvider, random, errors, validates: true, answered: persistence.RecordAsync,
            onAuthFailed: options.Signals.NotifySessionEnded);
        HttpTransport? transport = null;
        try
        {
            await kept.ReadyAsync(cancellation).ConfigureAwait(Spawning.Captures);
            var http = new HttpTransport(Gateway.Origin(endpoint), kept.State.Token,
                BusRegistry.BridgedChannels, refresher: kept.RefreshAsync,
                httpClient: httpClient, timeProvider: timeProvider, random: random);
            transport = http;
            var client = new XynologClient(http, persistence);
            var session = new XynologSession(new KbTarget { Id = options.Kb.Id, Endpoint = options.Kb.Endpoint, Label = options.Kb.Label },
                client, kept);
            return new OpenedSession(client, async () =>
            {
                // The client first, its closing save awaited: what that save says reaches the session's errors before they end.
                try
                {
                    client.Dispose();
                    await client.Flushed.ConfigureAwait(Spawning.Captures);
                }
                finally
                {
                    session.Dispose();
                    // A renewal under way at the issuer runs to its end, and what it brings is kept, before the close returns.
                    await kept.DisposeAsync().ConfigureAwait(Spawning.Captures);
                }
            }, session);
        }
        catch
        {
            kept.Dispose();
            transport?.Dispose();
            throw;
        }
    }

    /// <inheritdoc/>
    public async Task RevokeAsync(StoredSession stored, CancellationToken cancellation = default)
    {
        using var issuer = new Issuer(httpClient, timeProvider, random);
        await issuer.SignOutAsync(new MemorySignIn(stored), cancellation).ConfigureAwait(Spawning.Captures);
    }
}
