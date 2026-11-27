using System.Diagnostics;
using System.Diagnostics.CodeAnalysis;
using System.Runtime.CompilerServices;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.Json.Serialization;
using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Identifiers;
using Xynolog.Protocol;
using Xynolog.Serialization;
using Xynolog.Types;

namespace Xynolog;

/// <summary>A bus channel whose frames carry payloads of <typeparamref name="T"/>; <see cref="BusChannels"/> holds
/// every one.</summary>
public sealed class BusChannel<T> where T : class
{
    internal BusChannel(string name, bool scoped) { Name = name; IsScoped = scoped; }
    /// <summary>The channel's name on the wire.</summary>
    public string Name { get; }
    /// <summary>Whether the channel's frames are delivered within one resource's scope, so that reading it names a
    /// resource.</summary>
    public bool IsScoped { get; }
}

/// <summary>A request on the bus with the channels its reply comes back on: a result, or a failure.</summary>
public sealed class BusOperation<TRequest, TResult, TFailure>
    where TRequest : class where TResult : class where TFailure : class
{
    internal BusOperation(BusChannel<TRequest> request, BusChannel<TResult> result, BusChannel<TFailure> failure)
    {
        Request = request;
        Result = result;
        Failure = failure;
    }

    /// <summary>The channel the request is emitted on.</summary>
    public BusChannel<TRequest> Request { get; }
    /// <summary>The channel a successful reply comes back on.</summary>
    public BusChannel<TResult> Result { get; }
    /// <summary>The channel a failed reply comes back on.</summary>
    public BusChannel<TFailure> Failure { get; }
}

/// <summary>What a transport delivers on a channel, one after another: a frame (<see cref="ReceivedBusFrame"/>), or, in
/// the place of a frame BusFrame does not allow that names its channel's readers, the frame's refusal
/// (<see cref="FrameRefusal"/>).</summary>
public closed record Carried
{
    /// <summary>The channel it was delivered on.</summary>
    public abstract string Channel { get; }

    /// <summary>What pairs it with the request awaiting it, when it carries one BusFrame allows.</summary>
    public abstract string? CorrelationId { get; }
}

/// <summary>A frame a transport delivered, with the trace it was emitted in.</summary>
/// <param name="Frame">The frame as it came.</param>
/// <param name="Trace">The trace context the frame carried, which work done for it continues.</param>
public sealed record ReceivedBusFrame(BusFrame Frame, ActivityContext Trace) : Carried
{
    /// <inheritdoc/>
    public override string Channel => Frame.Channel;
    /// <inheritdoc/>
    public override string? CorrelationId => Frame.CorrelationId;
    internal string? EventId { get; init; }
    internal long Sequence { get; init; }

    /// <summary>The user the gateway stamped on the frame's payload as its sender, if it stamped one.</summary>
    public UserId? UserId =>
        Frame.Payload.TryGetProperty(BusChannels.UserField, out var value) && value.ValueKind == JsonValueKind.String &&
        Identifiers.UserId.TryParse(value.GetString(), out var user) ? user : null;
}

/// <summary>A frame refused, in its place: BusFrame does not allow it, or its payload is not its channel's.
/// <paramref name="Member"/> is the way from the frame to the member its first fault is at, the names of the members it
/// is within and its own joined by dots (<c>payload.resourceId</c> is within its payload, and <c>payload</c> is the
/// payload itself); <paramref name="Reason"/> is why. <paramref name="Payload"/> is its payload as it came, the gateway's
/// stamps and all, and null when it carried none. <paramref name="CorrelationId"/> is the frame's, when it carries one
/// BusFrame allows: a request awaiting the reply it names fails with the refusal at once.</summary>
public sealed record FrameRefusal(string Channel, string Member, FrameRefusalReason Reason, JsonElement? Payload,
    string? CorrelationId, ResourceId? Scope) : Carried
{
    /// <inheritdoc/>
    public override string Channel { get; } = Channel;
    /// <inheritdoc/>
    public override string? CorrelationId { get; } = CorrelationId;
}

/// <summary>What a typed read gives for each frame: the frame, its payload decoded (<see cref="Delivered"/>), or, in its
/// place, the refusal of a frame BusFrame does not allow or whose payload is not its channel's
/// (<see cref="Refused"/>).</summary>
public closed record Heard<T> where T : class
{
    /// <summary>A frame, and its payload decoded.</summary>
    /// <param name="Received">The frame as it came.</param>
    /// <param name="Payload">Its payload, decoded as its channel's.</param>
    public sealed record Delivered(ReceivedBusFrame Received, T Payload) : Heard<T>;
    /// <summary>The refusal of a frame, in its place.</summary>
    /// <param name="Refusal">Why the frame was refused.</param>
    public sealed record Refused(FrameRefusal Refusal) : Heard<T>;
}

/// <summary>Typed access to the bus: emits payloads on channels, reads their frames, and makes requests that await a
/// reply.</summary>
public sealed class Bus
{
    private readonly HttpTransport transport;
    private readonly int requestTimeoutMs;

    /// <summary>Reads and writes the bus through a transport.</summary>
    public Bus(HttpTransport transport) : this(transport, Timings.BusRequestTimeoutMs)
    {
    }

    internal Bus(HttpTransport transport, int requestTimeoutMs)
    {
        this.transport = transport;
        this.requestTimeoutMs = requestTimeoutMs;
    }

    /// <summary>Emits a payload on a channel; the result is how many subscribers the gateway delivered it to, or null when
    /// its acceptance did not say.</summary>
    public Task<long?> EmitAsync<T>(BusChannel<T> channel, T payload, ResourceId? scope = null,
        string? correlationId = null, CancellationToken cancellation = default) where T : class =>
        transport.EmitAsync(channel.Name, JsonSerializer.SerializeToElement(payload), scope, correlationId, cancellation);

    /// <summary>Each frame delivered on a channel from now on, its payload decoded or its refusal in its place; a scoped
    /// channel is read within one resource, which is required for it and refused for any other.</summary>
    public IAsyncEnumerable<Heard<T>> Frames<T>(BusChannel<T> channel, ResourceId? resource = null,
        CancellationToken cancellation = default) where T : class
    {
        if (channel.IsScoped != resource.HasValue)
            throw new ArgumentException("A resource is required exactly for a scoped channel.", nameof(resource));
        return DecodeFrames<T>(transport.ReceivedFrames([channel.Name], resource, cancellation), resource, cancellation);
    }

    /// <summary>Emits a request and waits for its reply, giving the decoded result; a failure reply, or none within the
    /// timeout, throws.</summary>
    public async Task<TResult> RequestAsync<TRequest, TResult, TFailure>(
        BusOperation<TRequest, TResult, TFailure> operation, TRequest payload, int? timeoutMs = null,
        CancellationToken cancellation = default)
        where TRequest : class where TResult : class where TFailure : class
    {
        var response = await transport.RequestFrameAsync(operation.Request.Name, JsonSerializer.SerializeToElement(payload),
            timeoutMs ?? requestTimeoutMs, cancellation).ConfigureAwait(Spawning.Captures);
        return Decoded<TResult>(response.Frame.Channel, response.Frame.Payload);
    }

    internal static async IAsyncEnumerable<Heard<T>> DecodeFrames<T>(IAsyncEnumerable<Carried> frames,
        ResourceId? resource, [EnumeratorCancellation] CancellationToken cancellation) where T : class
    {
        await foreach (var carried in frames.WithCancellation(cancellation).ConfigureAwait(Spawning.Captures))
        {
            // A stream carries every scope it holds on the one channel, and another reader may hold another resource's.
            if (resource is not null && ScopeOf(carried) != resource) continue;
            yield return HeardOf<T>(carried);
        }
    }

    /// <summary>What a typed read gives for <paramref name="carried"/>: a frame, its payload decoded, or the refusal of
    /// one whose payload is not its channel's; and a frame the transport refused, its refusal as it came.</summary>
    internal static Heard<T> HeardOf<T>(Carried carried) where T : class => carried switch
    {
        FrameRefusal refusal => new Heard<T>.Refused(refusal),
        ReceivedBusFrame received => TryDecode<T>(received.Frame.Payload, out var payload, out var fault)
            ? new Heard<T>.Delivered(received, payload)
            : new Heard<T>.Refused(new FrameRefusal(received.Channel, InPayload(fault.Member), fault.Reason,
                received.Frame.Payload, received.CorrelationId, received.Frame.Scope)),
    };

    /// <summary>The resource whose scope <paramref name="carried"/> was delivered on.</summary>
    internal static ResourceId? ScopeOf(Carried carried) => carried switch
    {
        ReceivedBusFrame received => received.Frame.Scope,
        FrameRefusal refusal => refusal.Scope,
    };

    /// <summary>A payload on <paramref name="channel"/>, as <typeparamref name="T"/>. Throws
    /// <see cref="TransportError"/> (<c>error</c>) for a payload that is not that channel's, saying its first fault in
    /// every SDK's words.</summary>
    internal static T Decoded<T>(string channel, JsonElement payload) where T : class =>
        TryDecode<T>(payload, out var decoded, out var fault)
            ? decoded
            : throw new TransportError(TransportErrorCode.Error, "a payload on " + channel + " is not that channel's: " + fault.Said());

    /// <summary>A payload as <typeparamref name="T"/>, held to the table before it is decoded, and decoded as the table
    /// reads it; or its first fault. What the gateway stamps on a payload (a member whose name begins <c>_</c>) is the
    /// bus's, not the payload's: one <typeparamref name="T"/> does not declare is left out before the payload is read.</summary>
    private static bool TryDecode<T>(JsonElement payload, [NotNullWhen(true)] out T? decoded,
        [NotNullWhen(false)] out Fault? fault) where T : class =>
        Required.TryRead(Declared(typeof(T).Name, payload), out decoded, out fault);

    /// <summary><paramref name="payload"/> without what the gateway stamped on it that <paramref name="schema"/> does
    /// not declare.</summary>
    private static JsonElement Declared(string schema, JsonElement payload)
    {
        if (payload.ValueKind != JsonValueKind.Object) return payload;
        JsonObject? copy = null;
        foreach (var property in payload.EnumerateObject())
        {
            if (!property.Name.StartsWith('_') || WireJson.Declares(schema, property.Name)) continue;
            copy ??= JsonNode.Parse(payload.GetRawText())?.AsObject() ?? throw new JsonException("A bus payload is null.");
            copy.Remove(property.Name);
        }
        return copy is null ? payload : JsonSerializer.SerializeToElement(copy);
    }

    /// <summary>The way from a frame to the member of its payload whose way from the payload is
    /// <paramref name="member"/>.</summary>
    private static string InPayload(string member) => member.Length == 0 ? "payload" : "payload." + member;
}
