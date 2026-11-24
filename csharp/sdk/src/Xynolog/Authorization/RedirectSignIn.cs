using System.Net;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Identifiers;
using Xynolog.Registry;
using Xynolog.Session;
using Xynolog.SignIn;
using Xynolog.Storage;
using Xynolog.Types;

namespace Xynolog.Authorization;

/// <summary>Thrown when a knowledge base cannot be asked who it is, or does not say, so its identity cannot be
/// verified.</summary>
public sealed class IdentityUnverifiableError : XynologError
{
    internal IdentityUnverifiableError(string reason, string message, Exception? cause = null)
        : base(reason, message, inner: cause) { }
}

/// <summary>Signs a person in through the browser: an OAuth authorization-code grant with PKCE, begun on one page and
/// completed on the page the issuer sends them back to.</summary>
public static class RedirectSignIn
{
    /// <summary>The session storage key the pending sign-in is kept under between its beginning and its
    /// completion.</summary>
    public static readonly string PendingAuthorizationKey = RegistryStorage.PendingKey;
    /// <summary>The PKCE S256 code challenge of a verifier: its SHA-256, base64url-encoded without padding.</summary>
    public static string CodeChallenge(string verifier) => Base64Url(SHA256.HashData(Encoding.UTF8.GetBytes(verifier)));

    /// <summary>Discovers the target's issuer, keeps the pending sign-in in storage, and returns the address to send the
    /// person to.</summary>
    public static async Task<string> BeginAuthorizationAsync(BeginAuthorizationOptions options, ISessionStorage storage,
        HttpClient? httpClient = null, TimeProvider? timeProvider = null, Random? random = null, CancellationToken cancellation = default)
    {
        RequireHttpAddress(options.RedirectUri);
        using var issuer = new SignIn.Issuer(httpClient, timeProvider, random);
        var found = await issuer.DiscoverAsync(options.Target, cancellation).ConfigureAwait(Spawning.Captures);
        var record = new PendingAuthorization
        {
            State = Base64Url(RandomNumberGenerator.GetBytes(24)),
            Verifier = Base64Url(RandomNumberGenerator.GetBytes(48)),
            RedirectUri = options.RedirectUri,
            Target = options.Target,
            Issuer = new PendingAuthorizationIssuer
            {
                Issuer = found.Issuer,
                Authorization = found.Authorization,
                Token = found.Token,
                Device = found.Device,
                Revocation = found.Revocation,
            },
            KbId = options.KbId,
            ExpectedDid = options.ExpectedDid,
            ExpectedName = options.ExpectedName,
        };
        var destination = new UriBuilder(RequireHttpAddress(found.Authorization));
        var query = new Dictionary<string, string>
        {
            ["response_type"] = "code",
            ["client_id"] = SignInPolicy.BrowserClientId,
            ["redirect_uri"] = record.RedirectUri,
            ["scope"] = SignInPolicy.Scope,
            ["state"] = record.State,
            ["code_challenge"] = CodeChallenge(record.Verifier),
            ["code_challenge_method"] = "S256",
        };
        var existing = destination.Query.TrimStart('?');
        if (ParseQuery(existing).Any(pair => query.ContainsKey(pair.Key)))
            throw Refused(SignInErrorCode.Discovery, "The issuer's authorization endpoint already names a grant parameter.");
        destination.Query = string.Join("&", (existing.Length == 0 ? Array.Empty<string>() : [existing])
            .Concat(query.Select(pair => pair.Key + "=" + Uri.EscapeDataString(pair.Value))));
        cancellation.ThrowIfCancellationRequested();
        storage.Set(PendingAuthorizationKey, RegistryStorage.Write(record));
        return destination.Uri.AbsoluteUri;
    }

    /// <summary>Takes the pending sign-in from storage, checks the issuer's response at the callback address against it,
    /// and exchanges its code for the session's tokens.</summary>
    public static async Task<(PendingAuthorization Pending, StoredSession Session)> CompleteAuthorizationAsync(
        string callbackUrl, ISessionStorage storage, HttpClient? httpClient = null, TimeProvider? timeProvider = null, Random? random = null,
        CancellationToken cancellation = default)
    {
        cancellation.ThrowIfCancellationRequested();
        string? stored = null;
        storage.Update(PendingAuthorizationKey, value => { stored = value; return null; });
        var record = RegistryStorage.Read<PendingAuthorization>(stored);
        if (record is null || record.State.Length == 0 || record.Verifier.Length == 0)
            throw Refused(SignInErrorCode.NoPending, "No sign-in is pending here.");
        var callback = RequireHttpAddress(callbackUrl);
        var redirect = RequireHttpAddress(record.RedirectUri);
        if (callback.GetLeftPart(UriPartial.Path) != redirect.GetLeftPart(UriPartial.Path))
            throw Refused(SignInErrorCode.State, "The response arrived at a different redirect address.");
        var query = ParseQuery(callback.Query.TrimStart('?')).ToLookup(pair => pair.Key, pair => pair.Value, StringComparer.Ordinal);
        string? One(string name) => query[name].Take(2).ToArray() is [var only] ? only : null;
        if (One("state") != record.State) throw Refused(SignInErrorCode.State, "The response does not belong to the pending sign-in.");
        if (One("error") is { } error) throw Refused(error == "access_denied" ? SignInErrorCode.Denied : SignInErrorCode.Exchange, "The issuer refused the sign-in.");
        if (One("code") is not { Length: > 0 } code) throw Refused(SignInErrorCode.Exchange, "The response has no authorization code.");
        RequireHttpAddress(record.Issuer.Token);

        using var issuer = new SignIn.Issuer(httpClient, timeProvider, random);
        var answer = await issuer.AnswerAsync(record.Issuer.Token, new Dictionary<string, string>
        {
            ["grant_type"] = "authorization_code",
            ["code"] = code,
            ["redirect_uri"] = record.RedirectUri,
            ["client_id"] = SignInPolicy.BrowserClientId,
            ["code_verifier"] = record.Verifier,
        }, cancellation: cancellation).ConfigureAwait(Spawning.Captures);
        if (answer.Status != 200 || answer.Text("access_token") is not { Length: > 0 } access ||
            answer.Text("refresh_token") is not { Length: > 0 } refresh)
            throw Refused(SignInErrorCode.Exchange, "The issuer did not return both tokens.", answer.Status);
        return (record, new StoredSession
        {
            Access = access,
            Refresh = refresh,
            ClientId = SignInPolicy.BrowserClientId,
            TokenEndpoint = record.Issuer.Token,
            RevocationEndpoint = record.Issuer.Revocation,
        });
    }

    /// <summary>Asks the knowledge base, with a new access token, to describe itself, giving its DID and
    /// description.</summary>
    /// <exception cref="IdentityUnverifiableError">The knowledge base could not be reached or did not report who it
    /// is.</exception>
    public static async Task<ConnectionIdentity> DescribeConnectionAsync(HttpEndpoint target, string access,
        HttpClient? httpClient = null, TimeProvider? timeProvider = null, Random? random = null, CancellationToken cancellation = default)
    {
        KbDescription description;
        try
        {
            using var client = new XynologClient(new HttpTransport(Gateway.Origin(target), access,
                BusRegistry.ReplyChannelsFor(BusOperations.BrowseKbRequested.Request.Name), httpClient: httpClient,
                timeProvider: timeProvider, random: random));
            description = await client.Browse.KbAsync(cancellation).ConfigureAwait(Spawning.Captures);
        }
        catch (Exception error) when (error is XynologError or JsonException)
        {
            var reason = error is BusRequestError rejected && rejected.Code == BusRequestErrorCode.Rejected ? IdentityUnverifiableReason.NotReported : IdentityUnverifiableReason.Unreachable;
            throw new IdentityUnverifiableError(reason, error.Message, error);
        }
        try { return new ConnectionIdentity { Did = Identity.KbDid(description.Domain), Description = description }; }
        catch (FormatException error) { throw new IdentityUnverifiableError(IdentityUnverifiableReason.NotReported, error.Message, error); }
    }

    private static Uri RequireHttpAddress(string? address) =>
        Uri.TryCreate(address, UriKind.Absolute, out var uri) && uri.Scheme is "https" or "http" &&
        string.IsNullOrEmpty(uri.UserInfo) && string.IsNullOrEmpty(uri.Fragment)
        ? uri : throw Refused(SignInErrorCode.Exchange, "The sign-in requires a valid HTTP address.");

    private static IEnumerable<KeyValuePair<string, string>> ParseQuery(string query)
    {
        foreach (var part in query.Split('&', StringSplitOptions.RemoveEmptyEntries))
        {
            var pair = part.Split('=', 2);
            yield return new(WebUtility.UrlDecode(pair[0]), pair.Length == 2 ? WebUtility.UrlDecode(pair[1]) : "");
        }
    }

    private static string Base64Url(byte[] bytes) => Convert.ToBase64String(bytes).TrimEnd('=').Replace('+', '-').Replace('/', '_');
    private static SignInError Refused(string code, string message, int? status = null) => new(code, message, status);
}
