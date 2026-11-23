using Xynolog.Http;
using Xynolog.Namespaces;

namespace Xynolog;

/// <summary>A client of one knowledge base's gateway, its operations grouped by the protocol's namespaces.</summary>
public sealed class XynologClient : IDisposable
{
    private readonly HttpContentTransport content;
    private readonly LiveQueries live;
    private readonly IDisposable attachedBus;

    /// <summary>Connects to the gateway at <paramref name="baseUrl"/>, subscribed to every channel the client bridges,
    /// sending <paramref name="token"/>.</summary>
    public XynologClient(string baseUrl, string? token = null, HttpClient? httpClient = null,
        TimeProvider? timeProvider = null, Random? random = null, Timing? timing = null, CachePersistence? persistence = null)
        : this(new HttpTransport(baseUrl, token, BusRegistry.BridgedChannels,
            timing: timing, httpClient: httpClient, timeProvider: timeProvider, random: random), persistence)
    {
    }

    /// <summary>Owns the transport. Supply subscriptions for the operations the client will use.</summary>
    public XynologClient(HttpTransport transport, CachePersistence? persistence = null)
    {
        ArgumentNullException.ThrowIfNull(transport);
        Transport = transport;
        Wire = new Bus(transport);
        Bus = new EventBus();
        content = new HttpContentTransport(transport);
        live = new LiveQueries(Wire, Bus, transport, content, persistence);
        Browse = new BrowseNamespace(Wire, Bus, content, transport.Closed, live);
        Bind = new BindNamespace(Wire, Bus);
        Beckon = new BeckonNamespace(Wire, Bus);
        Gather = new GatherNamespace(Wire, live);
        Match = new MatchNamespace(Wire, Bus, live);
        Job = new JobNamespace(Wire, Bus, transport);
        var follower = new JobFollower(Wire, Bus, Job, transport.Clock, transport.Closed, transport.Settings);
        Mark = new MarkNamespace(Wire, Bus, follower);
        Yield = new YieldNamespace(follower, Wire, Bus, content);
        Frame = new FrameNamespace(Wire);
        Auth = new AuthNamespace(transport);
        System = new SystemNamespace(transport);
        attachedBus = transport.AttachBus(Bus);
        _ = CloseWithTransportAsync();
    }

    /// <summary>The typed bus on the gateway: emits, frames and requests.</summary>
    public Bus Wire { get; }
    /// <summary>The in-process bus that carries the client's local signals and the frames it receives.</summary>
    public EventBus Bus { get; }
    /// <summary>Binds references' bodies to resources.</summary>
    public BindNamespace Bind { get; }
    /// <summary>Draws a viewer's attention to resources and annotations.</summary>
    public BeckonNamespace Beckon { get; }
    /// <summary>Gathers the context of resources and annotations.</summary>
    public GatherNamespace Gather { get; }
    /// <summary>Searches for resources, by text or for a reference.</summary>
    public MatchNamespace Match { get; }
    /// <summary>Creates, deletes and archives annotations and resources, and delegates annotation jobs.</summary>
    public MarkNamespace Mark { get; }
    /// <summary>Reads resources, annotations, events and the knowledge base's vocabularies, live and cached.</summary>
    public BrowseNamespace Browse { get; }
    /// <summary>Creates resources: uploads, clones and generation jobs.</summary>
    public YieldNamespace Yield { get; }
    /// <summary>Claims, follows and cancels jobs.</summary>
    public JobNamespace Job { get; }
    /// <summary>The connection to the gateway, which the client owns and closes.</summary>
    public HttpTransport Transport { get; }
    /// <summary>The gateway's address.</summary>
    public string BaseUrl => Transport.BaseUrl;
    /// <summary>Where the client's connection to the gateway stands now.</summary>
    public ConnectionState State => Transport.State;
    /// <summary>Adds to the knowledge base's vocabulary: entity types and tag schemas.</summary>
    public FrameNamespace Frame { get; }
    /// <summary>Asks whom the credential belongs to, for media tokens, and for the gateway's protected resource
    /// metadata.</summary>
    public AuthNamespace Auth { get; }
    /// <summary>Asks for the gateway's health and status.</summary>
    public SystemNamespace System { get; }

    /// <summary>What the client's closing save still writes once it is disposed: complete when that save has written what
    /// it could.</summary>
    internal Task Flushed => live.Flushed;

    private async Task CloseWithTransportAsync()
    {
        await foreach (var state in Transport.States().ConfigureAwait(Spawning.Captures))
            if (state == ConnectionState.Closed) break;
        try { live.Dispose(); }
        finally { Bus.Dispose(); }
    }

    /// <summary>Closes the client's caches, content reads, bus and transport.</summary>
    public void Dispose()
    {
        try { live.Dispose(); }
        finally
        {
            try { content.Dispose(); }
            finally
            {
                attachedBus.Dispose();
                Bus.Dispose();
                Transport.Dispose();
            }
        }
    }
}
