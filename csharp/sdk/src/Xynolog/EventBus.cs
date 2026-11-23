using System.Diagnostics;
using System.Text.Json;
using System.Runtime.CompilerServices;
using System.Threading.Channels;
using Xynolog.Errors;
using Xynolog.Identifiers;
using Xynolog.Protocol;
using Xynolog.Types;

namespace Xynolog;

/// <summary>In-process signals and received wire frames.</summary>
public sealed class EventBus : IDisposable
{
    private readonly object gate = new();
    private readonly Dictionary<string, HashSet<ChannelWriter<Carried>>> channels = new(StringComparer.Ordinal);
    private bool closed;

    /// <summary>Delivers a payload to the in-process listeners of a channel, scoped to a resource exactly when the channel
    /// is.</summary>
    /// <exception cref="BusRequestError">The bus is closed.</exception>
    public void Emit<T>(BusChannel<T> channel, T payload, ResourceId? scope = null,
        string? correlationId = null) where T : class
    {
        if (channel.IsScoped != scope.HasValue)
            throw new ArgumentException("A resource is required exactly for a scoped channel.", nameof(scope));

        var frame = new BusFrame
        {
            Channel = channel.Name,
            Payload = JsonSerializer.SerializeToElement(payload),
            Scope = scope,
            CorrelationId = correlationId,
        };
        lock (gate)
        {
            if (closed) throw new BusRequestError(ProtocolFacts.BusError("closed"), "The local bus is closed");
            Publish(new ReceivedBusFrame(frame, Activity.Current?.Context ?? default));
        }
    }

    /// <summary>The frames heard on a channel from now on, decoded, and for a scoped channel only those of the
    /// resource.</summary>
    public IAsyncEnumerable<Heard<T>> Frames<T>(BusChannel<T> channel, ResourceId? resource = null,
        CancellationToken cancellation = default) where T : class
    {
        if (channel.IsScoped != resource.HasValue)
            throw new ArgumentException("A resource is required exactly for a scoped channel.", nameof(resource));
        return Bus.DecodeFrames<T>(ReadFrames(channel.Name, cancellation), resource, cancellation);
    }

    private async IAsyncEnumerable<Carried> ReadFrames(string channel, [EnumeratorCancellation] CancellationToken cancellation)
    {
        using var subscription = Listen([channel]);
        await foreach (var carried in Spawning.ReadAll(subscription.Reader, cancellation).ConfigureAwait(Spawning.Captures))
            yield return carried;
    }

    internal Subscription Listen(string[] selected)
    {
        var source = Channel.CreateUnbounded<Carried>(new UnboundedChannelOptions { SingleReader = true });
        lock (gate)
        {
            if (closed) source.Writer.TryComplete();
            else
            {
                foreach (var name in selected)
                {
                    if (!channels.TryGetValue(name, out var listeners))
                        channels.Add(name, listeners = []);
                    listeners.Add(source.Writer);
                }
            }
        }
        return new Subscription(source.Reader, () =>
        {
            lock (gate)
            {
                foreach (var name in selected)
                {
                    if (channels.TryGetValue(name, out var listeners) && listeners.Remove(source.Writer) && listeners.Count == 0)
                        channels.Remove(name);
                }
                source.Writer.TryComplete();
            }
        });
    }

    internal sealed class Subscription(ChannelReader<Carried> reader, Action close) : IDisposable
    {
        private Action? release = close;
        internal ChannelReader<Carried> Reader { get; } = reader;
        public void Dispose() => Interlocked.Exchange(ref release, null)?.Invoke();
    }

    internal void Receive(Carried carried)
    {
        lock (gate) Publish(carried);
    }

    private void Publish(Carried carried)
    {
        if (channels.TryGetValue(carried.Channel, out var listeners))
            foreach (var listener in listeners) listener.TryWrite(carried);
    }

    /// <summary>Closes the bus: every listener's stream ends, and a later emit throws.</summary>
    public void Dispose()
    {
        lock (gate)
        {
            if (closed) return;
            closed = true;
            foreach (var listeners in channels.Values)
                foreach (var listener in listeners) listener.TryComplete();
            channels.Clear();
        }
    }
}
