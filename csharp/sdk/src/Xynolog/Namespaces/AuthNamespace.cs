using Xynolog.Http;
using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog.Namespaces;

/// <summary>The gateway's view of who is signed in.</summary>
public sealed class AuthNamespace
{
    private readonly HttpTransport transport;

    internal AuthNamespace(HttpTransport transport) => this.transport = transport;

    /// <summary>Asks the gateway for the user the client is signed in as.</summary>
    public Task<UserResponse> MeAsync(CancellationToken cancellation = default) =>
        transport.GetCurrentUserAsync(cancellation);

    /// <summary>Asks the gateway for a short-lived token that lets a URL of the resource's media be fetched without the
    /// client's credential.</summary>
    public Task<MediaTokenResponse> MediaTokenAsync(ResourceId resourceId, CancellationToken cancellation = default) =>
        transport.GetMediaTokenAsync(resourceId, cancellation);

    /// <summary>Asks the gateway which authorization server the knowledge base trusts to sign users in.</summary>
    public Task<ProtectedResourceMetadata> ProtectedResourceMetadataAsync(CancellationToken cancellation = default) =>
        transport.GetProtectedResourceMetadataAsync(cancellation);
}
