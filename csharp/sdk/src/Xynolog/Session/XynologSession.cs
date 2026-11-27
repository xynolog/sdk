using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Protocol;
using Xynolog.Registry;
using Xynolog.SignIn;
using Xynolog.State;
using Xynolog.Storage;
using Xynolog.Types;

namespace Xynolog.Session;

/// <summary>Owns a kept credential and binds it to a caller-owned client's transport.</summary>
public sealed class XynologSession : IStateUnit
{
    private readonly KeptSession kept;
    private readonly UnitWork work;
    private readonly IDisposable relayed;

    /// <summary>A random identifier, new for each session.</summary>
    public string Id { get; } = Guid.NewGuid().ToString();
    /// <summary>The knowledge base the session is signed in to.</summary>
    public KbTarget Kb { get; }
    /// <summary>The client whose transport carries the session's token.</summary>
    public XynologClient Client { get; }
    /// <summary>The access token the session holds, null before it has one and once it ends.</summary>
    public StateValue<string?> Token { get; }
    /// <summary>Who the gateway says the token signs in as, null until it has said and once the session ends.</summary>
    public StateValue<UserResponse?> User { get; }
    /// <summary>The state of the client's event stream.</summary>
    public StateValue<ConnectionState> StreamState { get; }
    /// <summary>When the token held expires, in Unix seconds, or null when none is held or it states no expiry.</summary>
    public double? ExpiresAt => Token.Value is { } token ? Tokens.TokenExpiry(token) : null;

    /// <summary>
    /// A script's session over a kept sign-in, with the client it is made over. It renews through
    /// <paramref name="kept"/>, and its client's transport carries the token the session holds. A sign-in that cannot be
    /// read as the session is made is this call's failure. The session asks the gateway who its token is, unless it is
    /// told not to <paramref name="validate"/>. Given a <paramref name="storage"/>, the client keeps the queries
    /// protocol/specs/src/client/refresh.json marks persisted there, for the person <paramref name="kept"/> names as the
    /// session is made, whose kept documents its caches hold from the start, or else for the person the gateway names
    /// once that is recorded on <paramref name="kept"/>; it writes only while <paramref name="kept"/> still names them.
    /// A sign-in it cannot read or record ends that keeping, said on <see cref="Errors"/> as session.keep-failed, and
    /// each write the storage refuses is said there as session.save-refused. The session signs out when the issuer refuses
    /// its renewal, or a renewal gives no token, or the gateway refuses a token the issuer has just issued: its sign-in is
    /// forgotten, and <paramref name="onAuthFailed"/> is told why before that is said on <see cref="Errors"/>. Ending the
    /// opened session ends the client, waits for its closing save, and then ends the session, so what that save says
    /// reaches the session's errors. A renewal under way at the issuer then is not ended: the close waits for it, and the
    /// tokens it brings are kept in <paramref name="kept"/>, not taken by the session. Its client keeps
    /// <paramref name="clientTiming"/>, and its transport <paramref name="transportTiming"/>: each the protocol's when
    /// null.
    /// </summary>
    public static async Task<OpenedSession> FromKeptAsync(KbTarget kb, ISignInKept kept, ISessionStorage? storage = null,
        HttpClient? httpClient = null, TimeProvider? timeProvider = null, Random? random = null, bool validate = OptionDefaults.KeptSignInSessionFromKeptValidate,
        Action<SessionEndReason>? onAuthFailed = null, ClientTiming? clientTiming = null, TransportTiming? transportTiming = null,
        CancellationToken cancellation = default)
    {
        ArgumentNullException.ThrowIfNull(kb);
        ArgumentNullException.ThrowIfNull(kept);
        if (kb.Endpoint is not KbEndpoint.HttpEndpoint(var endpoint))
            throw new SessionError(SessionErrorCode.ConstructFailed, "A session from a kept sign-in requires an HTTP endpoint.");
        var held = await kept.HeldAsync(cancellation).ConfigureAwait(Spawning.Captures);
        var errors = new Broadcast<XynologError>(keptForFirst: XynologError.KeptForFirstReader);
        var persistence = storage is null ? null : new CachePersistence(storage, kb.Id, kept, errors.Publish);
        if (persistence is not null && held is { PersonKey: { } named }) persistence.Attach(named);
        var credentials = new KeptSession(endpoint, kept, httpClient, timeProvider, random, errors, validate,
            answered: (token, user, recording) => persistence is null ? Task.CompletedTask : persistence.RecordAsync(token, user, recording),
            onAuthFailed: onAuthFailed);
        HttpTransport? transport = null;
        try
        {
            transport = new HttpTransport(Gateway.Origin(endpoint), credentials.State.Token, BusRegistry.BridgedChannels,
                timing: transportTiming, refresher: credentials.RefreshAsync, httpClient: httpClient,
                timeProvider: timeProvider, random: random);
            var client = new XynologClient(transport, persistence, clientTiming);
            var session = new XynologSession(kb, client, credentials);
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
                    await credentials.DisposeAsync().ConfigureAwait(Spawning.Captures);
                }
            }, session);
        }
        catch
        {
            credentials.Dispose();
            transport?.Dispose();
            throw;
        }
    }

    internal XynologSession(KbTarget kb, XynologClient client, KeptSession kept)
    {
        Kb = kb;
        Client = client;
        this.kept = kept;
        work = new UnitWork(client.Transport.Closed);
        var initial = kept.State;
        Token = new(initial.Token);
        User = new(initial.User);
        StreamState = new(client.State);
        relayed = client.Transport.RelayFailures(kept.Say);
        client.Transport.SetToken(initial.Token);
        work.Run(FollowIdentityAsync);
        work.Run(FollowStreamAsync);
    }

    /// <summary>
    /// The session's one stream of what went wrong: its own errors, each a <see cref="SessionError"/>, and its client's
    /// transport's failures, each said once. Of what it says before anyone reads it, the latest errorsKeptForFirstReaderCount
    /// (protocol/specs/src/client/timing.json) are kept for the first reader, in the order said. It ends when the session
    /// ends.
    /// </summary>
    public IAsyncEnumerable<XynologError> Errors(CancellationToken cancellation = default) => kept.Errors(cancellation);

    /// <summary>Waits until the session has read its kept sign-in, renewed an expired token and, unless told not to, asked
    /// the gateway who the token is.</summary>
    public async Task ReadyAsync(CancellationToken cancellation = default)
    {
        await kept.ReadyAsync(cancellation).ConfigureAwait(Spawning.Captures);
        UpdateIdentity();
    }

    /// <summary>Answers the gateway's refusal of <paramref name="refused"/>: the token renewed, the one held for a token
    /// already replaced, or null once the session has ended.</summary>
    public async Task<string?> RefreshAsync(string? refused, CancellationToken cancellation = default)
    {
        var token = await kept.RefreshAsync(refused, cancellation).ConfigureAwait(Spawning.Captures);
        UpdateIdentity();
        return token;
    }

    private async Task FollowIdentityAsync(CancellationToken cancellation)
    {
        await foreach (var _ in kept.States(cancellation).ConfigureAwait(Spawning.Captures))
            UpdateIdentity();
    }

    private async Task FollowStreamAsync(CancellationToken cancellation)
    {
        await foreach (var state in Client.Transport.States(cancellation).ConfigureAwait(Spawning.Captures))
            StreamState.Set(state);
    }

    internal void UpdateIdentity()
    {
        lock (work.Gate)
        {
            if (!work.Active) return;
            var identity = kept.State;
            Client.Transport.SetToken(identity.Token);
            Token.Set(identity.Token);
            User.Set(identity.User);
        }
    }

    /// <summary>Ends the session: stops renewing, clears the client's token, and closes its state values.</summary>
    public void Dispose()
    {
        lock (work.Gate)
        {
            work.Dispose();
            relayed.Dispose();
            try { kept.Dispose(); }
            finally
            {
                Client.Transport.SetToken(null);
                Token.Set(null);
                User.Set(null);
                Token.Close();
                User.Close();
                StreamState.Close();
            }
        }
    }
}
