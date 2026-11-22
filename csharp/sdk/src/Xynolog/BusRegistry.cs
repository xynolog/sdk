using Xynolog.Errors;
using Xynolog.Protocol;

namespace Xynolog;

/// <summary>The bus channels the Protocol defines, as a transport subscribes to them.</summary>
public static class BusRegistry
{
    /// <summary>The channels whose frames are a knowledge base's stored events.</summary>
    public static readonly IReadOnlyList<string> PersistedEventTypes = Array.AsReadOnly(ProtocolFacts.EventChannels().ToArray());

    /// <summary>The channels a full client's transport is given: every channel whose audience is everyone, and every
    /// operation's replies.</summary>
    public static readonly IReadOnlyList<string> BridgedChannels =
        [.. ProtocolFacts.Channels("everyone"), .. ReplyChannelsFor(ProtocolFacts.Operations().Select(operation => operation.Request))];

    /// <summary>The result and failure channels of every operation that one of the request channels starts, each named
    /// once.</summary>
    public static IReadOnlyList<string> ReplyChannelsFor(params IEnumerable<string> requests)
    {
        var replies = new List<string>();
        foreach (var request in requests)
        {
            foreach (var (_, result, failure) in ProtocolFacts.Operations().Where(operation => operation.Request == request))
            {
                if (!replies.Contains(result)) replies.Add(result);
                if (!replies.Contains(failure)) replies.Add(failure);
            }
        }
        return replies.AsReadOnly();
    }

    /// <summary>The error for waiting on a channel the transport is not subscribed to, so its frames can never
    /// arrive.</summary>
    public static BusRequestError Unsubscribed(string channel) => new(ProtocolFacts.BusError("unsubscribed"),
        "Transport is not subscribed to " + channel + ": a frame on it can never arrive on this connection. Add the channel to this client's channels.");
}
