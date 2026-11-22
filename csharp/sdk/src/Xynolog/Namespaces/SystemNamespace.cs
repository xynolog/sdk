using Xynolog.Http;
using Xynolog.Types;

namespace Xynolog.Namespaces;

/// <summary>What the knowledge base says about itself.</summary>
public sealed class SystemNamespace
{
    private readonly HttpTransport transport;

    internal SystemNamespace(HttpTransport transport) => this.transport = transport;

    /// <summary>Asks the gateway whether it is up and serving.</summary>
    public Task<HealthResponse> HealthCheckAsync(CancellationToken cancellation = default) =>
        transport.HealthCheckAsync(cancellation);

    /// <summary>Asks the gateway for its status, version and features, and whom it takes the client to be.</summary>
    public Task<StatusResponse> StatusAsync(CancellationToken cancellation = default) =>
        transport.GetStatusAsync(cancellation);
}
