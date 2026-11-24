using System.Text.Json;
using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Protocol;
using Xynolog.Types;

namespace Xynolog.SignIn;

public sealed partial class Issuer : IDisposable
{
    private static readonly RetryPolicy RefreshRetry = Timings.RefreshRetry;

    private readonly HttpClient? client;
    private readonly HttpMessageInvoker? owned;
    private readonly TimeProvider clock;
    private readonly Random random;
    private readonly CancellationTokenSource lifetime = new();

    /// <summary>Talks to issuers through <paramref name="httpClient"/>, or through a client of its own when none is
    /// given.</summary>
    /// <param name="httpClient">The client issuers are asked with, if not one of its own.</param>
    /// <param name="timeProvider">The clock deadlines and retries keep to, if not the system's.</param>
    /// <param name="random">The source of retry jitter, if not the shared one.</param>
    public Issuer(HttpClient? httpClient = null, TimeProvider? timeProvider = null, Random? random = null)
    {
        client = httpClient;
        if (client is null) owned = new HttpMessageInvoker(new SocketsHttpHandler { UseProxy = false });
        clock = timeProvider ?? TimeProvider.System;
        this.random = random ?? Random.Shared;
    }

    /// <summary>Renews the kept sign-in when its access token is <paramref name="holding"/> or has expired, giving the
    /// access token kept after, or null when none is kept.</summary>
    public Task<string?> RenewAsync(ISignInKept kept, string? holding, CancellationToken cancellation = default)
    {
        lifetime.Token.ThrowIfCancellationRequested();
        return KeptRenewal.RenewAsync(kept, holding, RefreshAsync, clock, cancellation);
    }

    private Task<IssuedTokens> RefreshAsync(StoredSession held, CancellationToken cancellation) =>
        GrantByRefreshRuleAsync(token => GrantAsync(held, token), cancellation);

    internal async Task<T> GrantByRefreshRuleAsync<T>(Func<CancellationToken, Task<T>> grant, CancellationToken cancellation)
    {
        using var linked = CancellationTokenSource.CreateLinkedTokenSource(cancellation, lifetime.Token);
        return await Retry.RetryWithBackoffAsync(RefreshRetry, grant, error => error is SignInError && ProtocolFacts.RetryRefresh(error.Status),
            _ => null, clock, random, linked.Token).ConfigureAwait(Spawning.Captures);
    }

    private async Task<IssuedTokens> GrantAsync(StoredSession held, CancellationToken cancellation)
    {
        var answer = await AnswerAsync(held.TokenEndpoint, new Dictionary<string, string>
        {
            ["grant_type"] = "refresh_token",
            ["refresh_token"] = held.Refresh,
            ["client_id"] = held.ClientId,
        }, cancellation: cancellation).ConfigureAwait(Spawning.Captures);
        if (answer.Status != 200) throw Failure("The issuer refused the refresh grant", answer.Status);
        return Issued(answer, held.Refresh);
    }

    /// <summary>The tokens the issuer's answer issued; a refresh token it does not rotate is the one
    /// <paramref name="kept"/>, and with none kept it must issue one.</summary>
    private static IssuedTokens Issued(IssuerAnswer answer, string? kept)
    {
        var access = answer.Text("access_token");
        if (string.IsNullOrEmpty(access)) throw Failure("The issuer answered without an access token", answer.Status);
        var refresh = kept;
        if (answer.Body is JsonElement body && body.TryGetProperty("refresh_token", out var stated))
        {
            if (stated.ValueKind != JsonValueKind.String || string.IsNullOrEmpty(stated.GetString())) throw Failure("The issuer answered with an invalid refresh token", answer.Status);
            refresh = stated.GetString();
        }
        return new IssuedTokens { Access = access, Refresh = refresh ?? throw Failure("The issuer returned no refresh token", answer.Status) };
    }

    internal sealed record IssuerAnswer(int Status, JsonElement? Body)
    {
        internal string? Text(string name) => Body is JsonElement body && body.TryGetProperty(name, out var value) && value.ValueKind == JsonValueKind.String ? value.GetString() : null;
        internal double? Seconds(string name) => Body is JsonElement body && body.TryGetProperty(name, out var value) && value.ValueKind == JsonValueKind.Number && value.TryGetDouble(out var seconds) && seconds >= 0 && double.IsFinite(seconds) ? seconds : null;
        internal long? WholeSeconds(string name) => Body is JsonElement body && body.TryGetProperty(name, out var value) && value.ValueKind == JsonValueKind.Number && value.TryGetInt64(out var seconds) && seconds >= 0 ? seconds : null;
    }

    internal async Task<IssuerAnswer> AnswerAsync(string url, Dictionary<string, string>? form = null,
        string errorCode = SignInErrorCode.Exchange, CancellationToken cancellation = default)
    {
        lifetime.Token.ThrowIfCancellationRequested();
        using var request = new HttpRequestMessage(form is null ? HttpMethod.Get : HttpMethod.Post, url);
        request.Headers.Accept.ParseAdd("application/json");
        if (form is not null) request.Content = new FormUrlEncodedContent(form);
        using var deadline = new CancellationTokenSource(TimeSpan.FromMilliseconds(Timings.HttpRequestTimeoutMs), clock);
        using var linked = CancellationTokenSource.CreateLinkedTokenSource(cancellation, lifetime.Token, deadline.Token);
        int? status = null;
        try
        {
            using var response = client is not null
                ? await client.SendAsync(request, HttpCompletionOption.ResponseHeadersRead, linked.Token).ConfigureAwait(Spawning.Captures)
                : await (owned ?? throw new InvalidOperationException("No issuer HTTP handler")).SendAsync(request, linked.Token).ConfigureAwait(Spawning.Captures);
            status = (int)response.StatusCode;
            var bytes = await response.Content.ReadAsByteArrayAsync(linked.Token).ConfigureAwait(Spawning.Captures);
            if (bytes.Length == 0) return new IssuerAnswer(status.Value, null);
            try
            {
                using var document = JsonDocument.Parse(bytes);
                if (document.RootElement.ValueKind != JsonValueKind.Object) throw new JsonException("The issuer answered with no JSON object");
                return new IssuerAnswer(status.Value, document.RootElement.Clone());
            }
            catch (JsonException) when (!response.IsSuccessStatusCode) { return new IssuerAnswer(status.Value, null); }
        }
        catch (OperationCanceledException) when (!cancellation.IsCancellationRequested && !lifetime.IsCancellationRequested)
        { throw new SignInError(errorCode, "The issuer did not answer before the deadline"); }
        catch (Exception error) when (error is HttpRequestException or IOException)
        { throw new SignInError(errorCode, "The issuer did not answer", inner: error); }
        catch (JsonException error)
        { throw new SignInError(errorCode, "The issuer answered with invalid JSON", status, error); }
    }

    private static SignInError Failure(string message, int? status, Exception? inner = null) => new(SignInErrorCode.Exchange, message, status, inner);

    /// <summary>Ends every request in flight and releases the client it made, if it made one.</summary>
    public void Dispose() { lifetime.Cancel(); owned?.Dispose(); }
}
