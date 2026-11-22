using Xynolog.Protocol;
using Xynolog.Errors;
using System.Net.Http.Json;
using System.Text.Json;
using Xynolog.Identifiers;
using Xynolog.Serialization;
using Xynolog.Types;

namespace Xynolog.Http;

/// <summary>The connection to a knowledge base's gateway: its bus stream, emits and requests, and the gateway's own
/// HTTP operations.</summary>
public sealed partial class HttpTransport
{
    /// <summary>Asks the gateway whether it is healthy.</summary>
    public Task<HealthResponse> HealthCheckAsync(CancellationToken cancellation = default) => AnswerAsync<HealthResponse>(GatewayRoute.GetHealth.Method, GatewayRoute.GetHealth.Path, cancellation: cancellation);
    /// <summary>Reads the gateway's status: its version, its features, and whom the credential authenticates
    /// as.</summary>
    public Task<StatusResponse> GetStatusAsync(CancellationToken cancellation = default) => AnswerAsync<StatusResponse>(GatewayRoute.GetStatus.Method, GatewayRoute.GetStatus.Path, cancellation: cancellation);
    /// <summary>Asks the gateway whom the transport's credential belongs to.</summary>
    public Task<UserResponse> GetCurrentUserAsync(CancellationToken cancellation = default) => AnswerAsync<UserResponse>(GatewayRoute.GetCurrentUser.Method, GatewayRoute.GetCurrentUser.Path, cancellation: cancellation);
    /// <summary>Reads, without a credential, the gateway's protected resource metadata, which names the authorization
    /// servers it trusts.</summary>
    public Task<ProtectedResourceMetadata> GetProtectedResourceMetadataAsync(CancellationToken cancellation = default) => AnswerAsync<ProtectedResourceMetadata>(GatewayRoute.GetProtectedResourceMetadata.Method, GatewayRoute.GetProtectedResourceMetadata.Path, authenticated: false, cancellation: cancellation);
    /// <summary>Asks the gateway for a token that grants access to one resource's media.</summary>
    public Task<MediaTokenResponse> GetMediaTokenAsync(ResourceId resource, CancellationToken cancellation = default) => AnswerAsync<MediaTokenResponse>(GatewayRoute.CreateMediaToken.Method, GatewayRoute.CreateMediaToken.Path, () => JsonContent.Create(new MediaTokenRequest { ResourceId = resource }), cancellation: cancellation);

    internal async Task<T> AnswerAsync<T>(HttpMethod method, string path, Func<HttpContent>? content = null, bool authenticated = true, CancellationToken cancellation = default, bool retry = true) where T : class
    {
        using var response = await ExchangeAsync(method, path, content, authenticated, cancellation: cancellation, retry: retry).ConfigureAwait(Spawning.Captures);
        return await ReplyAsync<T>(response, path, cancellation).ConfigureAwait(Spawning.Captures);
    }

    /// <summary>The reply to <paramref name="path"/> as <typeparamref name="T"/>, held to the table before it is decoded,
    /// as every reply is (<see cref="Required.TryRead"/>): one with a fault is refused, naming the fault.</summary>
    internal async Task<T> ReplyAsync<T>(HttpResponseMessage response, string path, CancellationToken cancellation) where T : class
    {
        using var deadline = new CancellationTokenSource(TimeSpan.FromMilliseconds(timing.HttpRequestMs), clock);
        using var linked = CancellationTokenSource.CreateLinkedTokenSource(deadline.Token, lifetime.Token, cancellation);
        try
        {
            var reply = await response.Content.ReadFromJsonAsync<JsonElement>(linked.Token).ConfigureAwait(Spawning.Captures);
            return Required.TryRead<T>(reply, out var decoded, out var fault)
                ? decoded
                : throw Report(new TransportError(ProtocolFacts.Error(0), $"{path}: the reply is not a {typeof(T).Name}: {fault}", (int)response.StatusCode));
        }
        catch (OperationCanceledException) when (!cancellation.IsCancellationRequested)
        {
            throw Report(new TransportError(ProtocolFacts.Error(503), path + ": response was not read"));
        }
        catch (JsonException error)
        {
            throw Report(new TransportError(ProtocolFacts.Error(0), error.Message, (int)response.StatusCode, error));
        }
    }

    internal async Task<HttpResponseMessage> ExchangeAsync(HttpMethod method, string path, Func<HttpContent>? content = null, bool authenticated = true, bool upload = false, CancellationToken cancellation = default, bool retry = true)
    {
        var key = upload ? Guid.NewGuid().ToString() : null;
        var repeatable = retry && ProtocolFacts.RetryTransport(503, method.Method, keyed: key is not null);
        var renewed = false;
        var sent = authenticated ? Token() : null;
        for (var attempt = 0; ; attempt++)
        {
            using var request = Request(method, path, sent);
            if (key is not null) request.Headers.Add(GatewayHeader.IdempotencyKey, key);
            request.Content = content?.Invoke();
            using var deadline = new CancellationTokenSource(upload ? Timeout.InfiniteTimeSpan : TimeSpan.FromMilliseconds(timing.HttpRequestMs), clock);
            using var linked = CancellationTokenSource.CreateLinkedTokenSource(deadline.Token, lifetime.Token, cancellation);
            HttpResponseMessage response;
            try
            {
                response = await SendAsync(request, linked.Token).ConfigureAwait(Spawning.Captures);
            }
            catch (OperationCanceledException) when (!cancellation.IsCancellationRequested)
            {
                throw Report(new TransportError(ProtocolFacts.Error(503), path + ": no response"));
            }
            catch (HttpRequestException) when (repeatable && attempt == 0 && !lifetime.IsCancellationRequested)
            {
                await Task.Delay(TimeSpan.FromMilliseconds(ProtocolFacts.Timing("requestRetryPauseMs").GetInt32()), clock, cancellation).ConfigureAwait(Spawning.Captures);
                continue;
            }
            catch (HttpRequestException error)
            {
                throw Report(new TransportError(ProtocolFacts.Error(503), error.Message, inner: error));
            }
            if (response.IsSuccessStatusCode) return response;
            var failure = await RefusalAsync(response, cancellation).ConfigureAwait(Spawning.Captures);
            if (failure.Code == ProtocolFacts.Error(401) && !renewed && sent is not null)
            {
                renewed = true;
                if (await RenewAsync(sent, cancellation).ConfigureAwait(Spawning.Captures) is { } renewal)
                {
                    sent = renewal;
                    response.Dispose();
                    attempt--;
                    continue;
                }
            }
            if (retry && attempt == 0 && ProtocolFacts.RetryTransport((int)response.StatusCode, method.Method, keyed: key is not null) && failure.Code != ProtocolFacts.Error(401))
            {
                var delay = Math.Max(RetryAfter(response), ProtocolFacts.Timing("requestRetryPauseMs").GetInt32());
                response.Dispose();
                using var waiting = CancellationTokenSource.CreateLinkedTokenSource(cancellation, lifetime.Token);
                try
                {
                    await Task.Delay(TimeSpan.FromMilliseconds(delay), clock, waiting.Token).ConfigureAwait(Spawning.Captures);
                }
                catch (OperationCanceledException) when (!cancellation.IsCancellationRequested)
                {
                    throw Report(new TransportError(ProtocolFacts.Error(0), path + ": the transport is closed"));
                }
                continue;
            }
            response.Dispose();
            throw Report(failure);
        }
    }

    private TransportError Report(TransportError error) { failures.Publish(error); return error; }
}
