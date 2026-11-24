using System.Globalization;
using System.Text.Json;
using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Types;

namespace Xynolog.Session;

/// <summary>Addresses a knowledge base's gateway and asks it who a token names.</summary>
public static class Gateway
{
    /// <summary>Whether a host is a DNS name of letters, digits and inner hyphens, each label 1 to 63
    /// characters.</summary>
    public static bool IsValidHostname(string host) => host.Split('.').All(label =>
        label.Length is >= 1 and <= 63 && char.IsAsciiLetterOrDigit(label[0]) && char.IsAsciiLetterOrDigit(label[^1]) &&
        label.All(character => char.IsAsciiLetterOrDigit(character) || character == '-'));

    /// <summary>The gateway's origin, as scheme, lowercased host and port.</summary>
    public static string Origin(HttpEndpoint endpoint)
    {
        if (!IsValidHostname(endpoint.Host)) throw new SignInError(SignInErrorCode.Discovery, "Invalid knowledge-base hostname");
        // Serialization checks the generated protocol enum and port bounds before forming an origin.
        var wire = JsonSerializer.SerializeToElement(endpoint);
        return wire.GetProperty("protocol").GetString() + "://" + endpoint.Host.ToLowerInvariant() + ":" + endpoint.Port.ToString(CultureInfo.InvariantCulture);
    }

    /// <summary>Asks the gateway at <paramref name="origin"/> who <paramref name="token"/> signs in as, once, without
    /// retrying.</summary>
    public static async Task<UserResponse> GetCurrentUserAsync(string origin, string token, HttpClient? httpClient = null,
        TimeProvider? timeProvider = null, CancellationToken cancellation = default)
    {
        using var transport = new HttpTransport(origin, token, [], httpClient: httpClient, timeProvider: timeProvider);
        return await transport.AnswerAsync<UserResponse>(GatewayRoute.GetCurrentUser.Method, GatewayRoute.GetCurrentUser.Path, cancellation: cancellation, retry: false).ConfigureAwait(Spawning.Captures);
    }
}
