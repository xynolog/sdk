using System.Text.Json;
using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Protocol;
using Xynolog.Session;
using Xynolog.Types;

namespace Xynolog.SignIn;

/// <summary>Signs people in and out through the issuer a knowledge base trusts, and renews their kept
/// sign-ins.</summary>
public sealed partial class Issuer
{
    internal sealed record Endpoints(string Issuer, string Authorization, string Token, string? Device, string? Revocation);

    private static string DiscoveryAddress(string address, int? status = null)
    {
        if (!Uri.TryCreate(address, UriKind.Absolute, out var uri) || uri.Scheme is not ("http" or "https") || string.IsNullOrEmpty(uri.Host))
            throw new SignInError(SignInErrorCode.Discovery, "The issuer named an invalid HTTP address", status);
        return address;
    }

    internal async Task<Endpoints> ConfigurationAsync(string issuer, CancellationToken cancellation)
    {
        var answer = await AnswerAsync(DiscoveryAddress(issuer).TrimEnd('/') + "/.well-known/openid-configuration", errorCode: SignInErrorCode.Discovery, cancellation: cancellation).ConfigureAwait(Spawning.Captures);
        if (answer.Status is < 200 or >= 300 || answer.Text("issuer") != issuer || answer.Text("authorization_endpoint") is not { Length: > 0 } authorization || answer.Text("token_endpoint") is not string token || token.Length == 0)
            throw new SignInError(SignInErrorCode.Discovery, "The issuer did not describe its endpoints", answer.Status);
        return new Endpoints(issuer, DiscoveryAddress(authorization, answer.Status), DiscoveryAddress(token, answer.Status),
            answer.Text("device_authorization_endpoint") is string device ? DiscoveryAddress(device, answer.Status) : null,
            answer.Text("revocation_endpoint") is string revocation ? DiscoveryAddress(revocation, answer.Status) : null);
    }

    internal async Task<Endpoints> DiscoverAsync(HttpEndpoint endpoint, CancellationToken cancellation)
    {
        string origin;
        try { origin = Gateway.Origin(endpoint); }
        catch (JsonException error) { throw new SignInError(SignInErrorCode.Discovery, "Invalid gateway endpoint.", inner: error); }
        var answer = await AnswerAsync(origin + GatewayRoute.GetProtectedResourceMetadata.Path, errorCode: SignInErrorCode.Discovery, cancellation: cancellation).ConfigureAwait(Spawning.Captures);
        if (answer.Status == 404) throw new SignInError(SignInErrorCode.NoIssuer, "The knowledge base trusts no external issuer", answer.Status);
        if (answer.Status is < 200 or >= 300) throw new SignInError(SignInErrorCode.Discovery, "The gateway refused metadata discovery", answer.Status);
        ProtectedResourceMetadata metadata;
        try { metadata = answer.Body?.Deserialize<ProtectedResourceMetadata>() ?? throw new JsonException("No resource metadata"); }
        catch (JsonException error) { throw new SignInError(SignInErrorCode.Discovery, "The gateway answered with invalid resource metadata", answer.Status, error); }
        if (metadata.AuthorizationServers.Count == 0) throw new SignInError(SignInErrorCode.NoIssuer, "The knowledge base trusts no external issuer");
        return await ConfigurationAsync(metadata.AuthorizationServers[0], cancellation).ConfigureAwait(Spawning.Captures);
    }

    /// <summary>Signs a person in by the OAuth device grant: hands <paramref name="onCode"/> the code to enter, waits for
    /// their approval, and keeps the sign-in.</summary>
    public async Task SignInDeviceAsync(HttpEndpoint endpoint, ISignInKept kept, Action<DeviceCode> onCode, CancellationToken cancellation = default)
    {
        using var linked = CancellationTokenSource.CreateLinkedTokenSource(cancellation, lifetime.Token);
        var issuer = await DiscoverAsync(endpoint, linked.Token).ConfigureAwait(Spawning.Captures);
        if (string.IsNullOrEmpty(issuer.Device)) throw new SignInError(SignInErrorCode.Discovery, "The issuer has no device authorization endpoint");
        var answer = await AnswerAsync(issuer.Device, new Dictionary<string, string>
        { ["client_id"] = SignInPolicy.ScriptClientId, ["scope"] = SignInPolicy.Scope }, cancellation: linked.Token).ConfigureAwait(Spawning.Captures);
        if (answer.Status != 200 || answer.Text("device_code") is not string device || device.Length == 0 ||
            answer.Text("user_code") is not string user || user.Length == 0 || answer.Text("verification_uri") is not string uri || uri.Length == 0 || answer.WholeSeconds("expires_in") is not long expires)
            throw Failure("The issuer refused device authorization", answer.Status);
        var started = clock.GetTimestamp();
        onCode(new DeviceCode { UserCode = user, VerificationUri = uri, VerificationUriComplete = answer.Text("verification_uri_complete"), ExpiresIn = expires });
        var interval = Math.Max(answer.Seconds("interval") ?? Timings.DevicePollMs / 1000.0, Timings.DevicePollFloorMs / 1000.0);
        while (true)
        {
            var remaining = expires - clock.GetElapsedTime(started).TotalSeconds;
            if (remaining <= 0) throw new SignInError(SignInErrorCode.Expired, "The device code expired");
            var wait = Math.Min(interval, remaining);
            // BCL timers cap a single wait; long issuer lifetimes keep their full deadline across chunks.
            while (wait > 0)
            {
                var chunk = Math.Min(wait, (uint.MaxValue - 1d) / 1000);
                await Task.Delay(TimeSpan.FromSeconds(chunk), clock, linked.Token).ConfigureAwait(Spawning.Captures);
                wait -= chunk;
            }
            if (clock.GetElapsedTime(started).TotalSeconds >= expires) throw new SignInError(SignInErrorCode.Expired, "The device code expired");
            var polled = await AnswerAsync(issuer.Token, new Dictionary<string, string>
            {
                ["grant_type"] = "urn:ietf:params:oauth:grant-type:device_code",
                ["device_code"] = device,
                ["client_id"] = SignInPolicy.ScriptClientId,
            }, cancellation: linked.Token).ConfigureAwait(Spawning.Captures);
            if (polled.Status == 200)
            {
                var issued = Issued(polled, null);
                await kept.KeepAsync(new StoredSession
                {
                    Access = issued.Access,
                    Refresh = issued.Refresh,
                    ClientId = SignInPolicy.ScriptClientId,
                    TokenEndpoint = issuer.Token,
                    RevocationEndpoint = issuer.Revocation,
                }, linked.Token).ConfigureAwait(Spawning.Captures);
                return;
            }
            switch (polled.Text("error"))
            {
                case "authorization_pending": break;
                case "slow_down": interval += Timings.DeviceSlowDownMs / 1000.0; break;
                case "access_denied": throw new SignInError(SignInErrorCode.Denied, "The sign-in was denied", polled.Status);
                case "expired_token": throw new SignInError(SignInErrorCode.Expired, "The device code expired", polled.Status);
                default: throw Failure("The issuer refused the device grant", polled.Status);
            }
        }
    }

    /// <summary>Revokes the kept sign-in's refresh token where the issuer allows, then forgets the sign-in.</summary>
    public async Task SignOutAsync(ISignInKept kept, CancellationToken cancellation = default)
    {
        using var linked = CancellationTokenSource.CreateLinkedTokenSource(cancellation, lifetime.Token);
        linked.Token.ThrowIfCancellationRequested();
        var held = await kept.HeldAsync(linked.Token).ConfigureAwait(Spawning.Captures);
        if (held is null) return;
        if (held.RevocationEndpoint is string endpoint)
        {
            try
            {
                await AnswerAsync(endpoint, new Dictionary<string, string>
                { ["token"] = held.Refresh, ["token_type_hint"] = "refresh_token", ["client_id"] = held.ClientId }, cancellation: linked.Token).ConfigureAwait(Spawning.Captures);
            }
            catch (SignInError)
            {
                // Revocation is best effort; local sign-out still forgets credentials when the issuer is unavailable.
            }
        }
        await kept.ForgetAsync(linked.Token).ConfigureAwait(Spawning.Captures);
    }
}
