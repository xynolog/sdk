using System.Text.Json;
using Xynolog;
using Xynolog.Errors;
using Xynolog.Identifiers;
using Xynolog.Registry;
using Xynolog.Storage;
using Xynolog.Types;

internal sealed class LiveDriver : IDisposable
{
    private readonly object gate = new();
    private readonly Dictionary<string, Observation> observations = new(StringComparer.Ordinal);
    private static readonly string DriverKey = RegistryStorage.PersonKey(UserId.Parse("did:web:conformance.example:users:driver"));
    private readonly MemoryStorage kept = new();
    private XynologClient? client;
    private ConnectionState? reported;

    private XynologClient Client => client ?? throw new InvalidOperationException("No client is open");

    internal async Task RunAsync(JsonElement args)
    {
        var id = args.GetProperty("id").GetInt64();
        try
        {
            object? answer = null;
            switch (Text(args, "op"))
            {
                case "open": Open(args); break;
                case "close": Client.Dispose(); break;
                case "sync": if (client is { } active) Report(active, active.State); break;
                case "observe":
                    var observer = Text(args, "observer");
                    var query = QueryOf(args.GetProperty("query"));
                    await Begin(observer, query.ReadAsync).ConfigureAwait(false);
                    break;
                case "unobserve": Stop(Text(args, "observer")); break;
                case "fresh": answer = new { value = await QueryOf(args.GetProperty("query")).FreshAsync().ConfigureAwait(false) }; break;
                case "invalidate": QueryOf(args.GetProperty("query")).Invalidate(); break;
                case "delete":
                    await Client.Mark.DeleteAsync(ResourceId.Parse(Text(args, "resource")), AnnotationId.Parse(Text(args, "annotation"))).ConfigureAwait(false);
                    break;
                case "markDelegate":
                    var mark = Client.Mark.Delegate(ResourceId.Parse(Text(args, "resource")), Required<MarkJobParams>(args, "params"));
                    Follow(Text(args, "observer"), mark);
                    break;
                case "yieldDelegate":
                    var stall = args.TryGetProperty("stallDeadlineMs", out var deadline) ? deadline.GetInt32() : (int?)null;
                    var yield = Client.Yield.Delegate(Required<GenerationJobParams>(args, "params"), stall);
                    Follow(Text(args, "observer"), yield);
                    break;
                default: WireDriver.Say(Lines.Unsupported(id)); return;
            }
            WireDriver.Say(Lines.Ok(id, JsonSerializer.SerializeToElement(answer)));
        }
        catch (XynologError error) { WireDriver.Say(Lines.Failed(id, error)); }
        catch (Exception error) { WireDriver.Say(Lines.Misuse(id, error)); }
    }

    private void Open(JsonElement args)
    {
        if (client is { State: not ConnectionState.Closed }) throw new InvalidOperationException("A client is already open");
        var persistence = args.TryGetProperty("persist", out var persist) && persist.GetBoolean()
            ? new CachePersistence(kept, "conformance", DriverKey) : null;
        var rows = StatedTiming.Rows(args);
        var clientTiming = StatedTiming.Read<ClientTiming>(StatedTiming.Take<ClientTiming>(rows));
        var opened = new XynologClient(Text(args, "baseUrl"), Text(args, "token"), clientTiming: clientTiming,
            transportTiming: StatedTiming.Read<TransportTiming>(rows), persistence: persistence);
        lock (gate)
        {
            reported = null;
            client = opened;
        }
        _ = ReportStatesAsync(opened);
        _ = ReportErrorsAsync(opened);
    }

    private async Task ReportStatesAsync(XynologClient opened)
    {
        await foreach (var state in opened.Transport.States().ConfigureAwait(false)) Report(opened, state);
    }

    private void Report(XynologClient opened, ConnectionState state)
    {
        lock (gate)
        {
            if (opened != client || state == reported) return;
            reported = state;
            WireDriver.Say(Lines.State(state));
        }
    }

    private static async Task ReportErrorsAsync(XynologClient opened)
    {
        await foreach (var error in opened.Transport.Errors().ConfigureAwait(false)) WireDriver.Say(Lines.ErrorStream(error));
    }

    private Task Begin(string name, Func<string, TaskCompletionSource, CancellationToken, Task> work)
    {
        var observation = new Observation();
        lock (gate)
        {
            if (!observations.TryAdd(name, observation))
            {
                observation.Cancellation.Dispose();
                throw new InvalidOperationException("Observer already exists: " + name);
            }
        }
        var first = new TaskCompletionSource(TaskCreationOptions.RunContinuationsAsynchronously);
        _ = RunObservationAsync();
        return first.Task;

        async Task RunObservationAsync()
        {
            try { await work(name, first, observation.Cancellation.Token).ConfigureAwait(false); }
            catch (OperationCanceledException) when (observation.Cancellation.IsCancellationRequested) { }
            catch (Exception error) { WireDriver.Say(Lines.Unread(name, error)); }
            finally
            {
                lock (gate)
                {
                    observations.Remove(name);
                    if (!observation.Cancellation.IsCancellationRequested) WireDriver.Say(Lines.Completed(name));
                    observation.Cancellation.Dispose();
                }
                first.TrySetResult();
            }
        }
    }

    private void Stop(string name)
    {
        lock (gate)
        {
            if (!observations.TryGetValue(name, out var observation)) throw new InvalidOperationException("No observer named " + name);
            observation.Cancellation.Cancel();
        }
    }

    private void Follow<T>(string name, Delegation<T> delegation) =>
        _ = Begin(name, async (observer, first, cancellation) =>
        {
            first.TrySetResult();
            await foreach (var update in delegation.WithCancellation(cancellation).ConfigureAwait(false))
            {
                var value = update switch
                {
                    JobEvent<T>.Created(var data) => Event("created", data),
                    JobEvent<T>.Progress(var data) => Event("progress", data),
                    JobEvent<T>.Failed(var data) => Event("failed", data),
                    JobEvent<T>.Refused(var channel, var member, var reason) => Event("refused", new { channel, member, reason }),
                    JobEvent<T>.Complete(var data) => Event("complete", data),
                };
                WireDriver.Say(Lines.Value(observer, value));
            }
        });

    private IQuery QueryOf(JsonElement args)
    {
        ResourceId Resource() => ResourceId.Parse(Text(args, "resource"));
        T? Filters<T>() where T : class => args.TryGetProperty("filters", out _) ? Required<T>(args, "filters") : null;
        return Text(args, "query") switch
        {
            "resource" => Query(Client.Browse.Resource(Resource())),
            "resources" => Query(Client.Browse.Resources(Filters<BrowseResourcesRequest>())),
            "annotations" => Query(Client.Browse.Annotations(Resource())),
            "annotation" => Query(Client.Browse.Annotation(Resource(), AnnotationId.Parse(Text(args, "annotation")))),
            "events" => Query(Client.Browse.Events(Resource())),
            "referencedBy" => Query(Client.Gather.ReferencedBy(Resource())),
            "matchedResources" => Query(Client.Match.Resources(Text(args, "search"), Filters<ResourceSearchFilters>())),
            "entityTypes" => Query(Client.Browse.EntityTypes()),
            "tagSchemas" => Query(Client.Browse.TagSchemas()),
            "engines" => Query(Client.Browse.Engines()),
            var name => throw new InvalidOperationException("Unknown query " + name),
        };
    }

    private static IQuery Query<T>(Cached<T> cached) =>
        new QueryView<T>(cached, value => JsonSerializer.SerializeToElement(value));

    private static string Text(JsonElement row, string key) => row.GetProperty(key).GetString() ?? throw new InvalidOperationException("Missing " + key);
    private static T Required<T>(JsonElement row, string key) where T : class =>
        row.GetProperty(key).Deserialize<T>() ?? throw new InvalidOperationException("Missing " + key);
    private static JsonElement Event<T>(string kind, T data) => JsonSerializer.SerializeToElement(new { kind, data }, WireDriver.Json);

    public void Dispose() => client?.Dispose();

    private sealed class Observation
    {
        internal CancellationTokenSource Cancellation { get; } = new();
    }

    private interface IQuery
    {
        public Task ReadAsync(string observer, TaskCompletionSource first, CancellationToken cancellation);
        public Task<JsonElement> FreshAsync();
        public void Invalidate();
    }

    private sealed class QueryView<T>(Cached<T> cached, Func<T, JsonElement> encode) : IQuery
    {
        public async Task ReadAsync(string observer, TaskCompletionSource first, CancellationToken cancellation)
        {
            await foreach (var state in cached.WithCancellation(cancellation).ConfigureAwait(false))
            {
                WireDriver.Say(state switch
                {
                    CacheState<T>.Pending => Lines.Pending(observer),
                    CacheState<T>.Ready(var value) => Lines.Value(observer, encode(value)),
                    CacheState<T>.Failed(var error) => Lines.Unread(observer, error),
                });
                first.TrySetResult();
            }
        }

        public async Task<JsonElement> FreshAsync() => encode(await cached.FreshAsync().ConfigureAwait(false));
        public void Invalidate() => cached.Invalidate();
    }
}
