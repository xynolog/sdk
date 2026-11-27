using System.Text.Json;
using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Identifiers;
using Xynolog.Protocol;
using Xynolog.Types;

namespace Xynolog;

internal sealed class LiveQueries : IDisposable
{
    internal readonly record struct AnnotationKey(ResourceId Resource, AnnotationId Annotation);

    internal static readonly IReadOnlyList<string> PersistedQueries = Array.AsReadOnly(ProtocolTables.ClientRefresh.Queries
        .Where(KeptTable.Persisted).Select(KeptTable.Name).ToArray());
    internal static readonly ILookup<string, ClientRefreshRefreshItemOn> OnChannel = ProtocolTables.ClientRefresh.Refresh
        .OfType<ClientRefreshRefreshItem.On>().Select(row => row.Value).ToLookup(row => row.On, StringComparer.Ordinal);
    internal static readonly ILookup<ClientRefreshRefreshItemStreamStream, ClientRefreshRefreshItemStream> OnStream = ProtocolTables.ClientRefresh.Refresh
        .OfType<ClientRefreshRefreshItem.Stream>().Select(row => row.Value).ToLookup(row => row.Stream);
    private readonly EventBus.Subscription events;
    private readonly Dictionary<string, Query> queries;
    private readonly IRefreshedCache[] caches;
    private readonly LiveCacheStorage? persistence;
    private IReadOnlyList<EngineLimits> reportedLimits = [];

    internal Cache<ResourceId, ResourceDescriptor> ResourcesById { get; }
    internal Cache<BrowseResourcesRequest, ListResourcesResponse> Resources { get; }
    internal Cache<ResourceId, GetAnnotationsResponse> Annotations { get; }
    internal Cache<AnnotationKey, Annotation> Annotation { get; }
    internal Cache<ResourceId, IReadOnlyList<AttributedEvent>> Events { get; }
    internal Cache<ResourceId, IReadOnlyList<GetReferencedByResponseReferencedByItem>> ReferencedBy { get; }
    internal Cache<MatchResourcesRequest, MatchResourcesResponse> MatchedResources { get; }
    internal CacheEntry<IReadOnlyList<string>> EntityTypes { get; }
    internal CacheEntry<IReadOnlyList<TagSchema>> TagSchemas { get; }
    internal CacheEntry<IReadOnlyList<EngineEntry>> Engines { get; }

    /// <summary>The engines as the live query shows them: each joined, as it is shown, with the limits last reported for
    /// it.</summary>
    internal Cached<IReadOnlyList<EngineWithLimits>> EnginesWithLimits { get; }

    internal LiveQueries(Bus wire, EventBus bus, HttpTransport transport, HttpContentTransport content, CachePersistence? storage)
    {
        var clock = transport.Clock;
        persistence = storage is null ? null : new LiveCacheStorage(storage, clock, RefetchOwed);
        var window = TimeSpan.FromMilliseconds(transport.Settings.InvalidationWindowMs);
        ResourcesById = new(async (id, token) => (await wire.RequestAsync(BusOperations.BrowseResourceRequested,
            new BrowseResourceRequest { ResourceId = id }, cancellation: token).ConfigureAwait(Spawning.Captures)).Response.Resource, transport.SubscribeToResource, clock, window,
            persistence?.Changed(CacheQuery.Resource));
        Resources = new(async (request, token) => (await wire.RequestAsync(BusOperations.BrowseResourcesRequested, request,
            cancellation: token).ConfigureAwait(Spawning.Captures)).Response, null, clock, window);
        Annotations = new(content.GetAnnotationsAsync, transport.SubscribeToResource, clock, window, persistence?.Changed(CacheQuery.Annotations));
        Annotation = new(async (key, token) => (await wire.RequestAsync(BusOperations.BrowseAnnotationRequested,
            new BrowseAnnotationRequest { ResourceId = key.Resource, AnnotationId = key.Annotation }, cancellation: token)
            .ConfigureAwait(Spawning.Captures)).Response.Annotation, key => transport.SubscribeToResource(key.Resource), clock, window,
            persistence?.Changed(CacheQuery.Annotation));
        Events = new(async (id, token) => (await wire.RequestAsync(BusOperations.BrowseEventsRequested,
            new BrowseEventsRequest { ResourceId = id }, cancellation: token).ConfigureAwait(Spawning.Captures)).Response.Events, transport.SubscribeToResource, clock, window);
        ReferencedBy = new(async (id, token) => (await wire.RequestAsync(BusOperations.GatherReferencedByRequested,
            new GatherReferencedByRequest { ResourceId = id }, cancellation: token).ConfigureAwait(Spawning.Captures)).Response.ReferencedBy, transport.SubscribeToResource, clock, window);
        MatchedResources = new(async (request, token) => (await wire.RequestAsync(BusOperations.MatchResourcesRequested, request,
            cancellation: token).ConfigureAwait(Spawning.Captures)).Response, null, clock, window);

        var entityTypes = Singleton<IReadOnlyList<string>>(async token => (await wire.RequestAsync(BusOperations.BrowseEntityTypesRequested,
            new BrowseEntityTypesRequest(), cancellation: token).ConfigureAwait(Spawning.Captures)).Response.EntityTypes, out var types, persistence?.Changed(CacheQuery.EntityTypes));
        EntityTypes = types;
        var tagSchemas = Singleton<IReadOnlyList<TagSchema>>(async token => (await wire.RequestAsync(BusOperations.BrowseTagSchemasRequested,
            new BrowseTagSchemasRequest(), cancellation: token).ConfigureAwait(Spawning.Captures)).Response.TagSchemas, out var tags, persistence?.Changed(CacheQuery.TagSchemas));
        TagSchemas = tags;
        var engines = Singleton(token => LoadEnginesAsync(wire, token), out var listed);
        Engines = listed;
        EnginesWithLimits = new CachedPart<IReadOnlyList<EngineEntry>, IReadOnlyList<EngineWithLimits>>(listed, WithLimits);

        caches = [ResourcesById, Resources, Annotations, Annotation, Events, ReferencedBy, MatchedResources, entityTypes, tagSchemas, engines];
        queries = new(StringComparer.Ordinal)
        {
            [CacheQuery.Resource] = new(Refetch(ResourcesById, ResourceMatches)),
            [CacheQuery.Resources] = new(Refetch(Resources, (_, _) => true)),
            [CacheQuery.Annotations] = new(Refetch(Annotations, ResourceMatches), WriteAnnotations),
            [CacheQuery.Annotation] = new(Refetch(Annotation, AnnotationMatches), WriteAnnotation, RemoveAnnotation),
            [CacheQuery.Events] = new(Refetch(Events, ResourceMatches)),
            [CacheQuery.ReferencedBy] = new(Refetch(ReferencedBy, ResourceMatches)),
            [CacheQuery.MatchedResources] = new(Refetch(MatchedResources, (_, _) => true)),
            [CacheQuery.EntityTypes] = new((_, _) => EntityTypes.Refresh()),
            [CacheQuery.TagSchemas] = new((_, _) => TagSchemas.Refresh()),
            [CacheQuery.Engines] = new((_, _) => Engines.Refresh()),
        };

        CheckRefresh();
        var channels = OnChannel.Select(group => group.Key).Where(BusChannels.Readings.ContainsKey);
        if (persistence is not null) channels = channels.Concat(BusChannels.Scoped).Distinct(StringComparer.Ordinal);
        events = bus.Listen(channels.ToArray());
        if (persistence is not null)
        {
            IKeptQuery[] kept =
            [
                persistence.Keep(CacheQuery.Resource, ResourcesById, KeptKeys.ByResource<ResourceDescriptor>()),
                persistence.Keep(CacheQuery.Annotations, Annotations, KeptKeys.ByResource<GetAnnotationsResponse>()),
                persistence.Keep(CacheQuery.Annotation, Annotation, KeptKeys.ByAnnotation),
                persistence.Keep(CacheQuery.EntityTypes, entityTypes, KeptKeys.Whole<IReadOnlyList<string>>()),
                persistence.Keep(CacheQuery.TagSchemas, tagSchemas, KeptKeys.Whole<IReadOnlyList<TagSchema>>()),
            ];
            if (!kept.Select(query => query.Name).ToHashSet(StringComparer.Ordinal).SetEquals(PersistedQueries))
                throw new InvalidOperationException("The live cache does not keep the queries client/refresh.json marks persisted.");
            persistence.Start(kept, transport.RestoreWatermarks);
        }
        _ = ReadEventsAsync();
        _ = ReadReopensAsync(transport);

        Cache<bool, T> Singleton<T>(Func<CancellationToken, Task<T>> fetch, out CacheEntry<T> query, Action? changed = null)
        {
            var cache = new Cache<bool, T>((_, token) => fetch(token), null, clock, window, changed);
            query = cache.Entry(true);
            return cache;
        }
    }

    private bool RefetchOwed() => caches.Any(cache => cache.RefetchOwed);

    /// <summary>Complete once the persistence's closing flush has written what it could; a client that keeps nothing has
    /// nothing to flush.</summary>
    internal Task Flushed => persistence is null ? Task.CompletedTask : persistence.Flushed;

    /// <summary>The engines the knowledge base names, once the services that hold the inference credentials have reported
    /// their limits too; those reports are kept beside them, to be joined as the engines are shown.</summary>
    private async Task<IReadOnlyList<EngineEntry>> LoadEnginesAsync(Bus wire, CancellationToken cancellation)
    {
        var inventory = wire.RequestAsync(BusOperations.BrowseEnginesRequested, new BrowseEnginesRequest(), cancellation: cancellation);
        var reportsTask = Spawning.WhenAll(BusOperations.Limits.Select(ReadLimitsAsync));
        await Spawning.WhenAll(inventory, reportsTask).ConfigureAwait(Spawning.Captures);
        var result = await inventory.ConfigureAwait(Spawning.Captures);
        Volatile.Write(ref reportedLimits, (await reportsTask.ConfigureAwait(Spawning.Captures)).SelectMany(report => report).ToArray());
        return result.Response.Engines;

        async Task<IReadOnlyList<EngineLimits>> ReadLimitsAsync(BusOperation<InferenceLimitsRequest, InferenceLimitsResult, CommandError> operation)
        {
            try
            {
                return (await wire.RequestAsync(operation, new InferenceLimitsRequest(), cancellation: cancellation)
                    .ConfigureAwait(Spawning.Captures)).Response.Limits;
            }
            catch (XynologError) { return []; }
        }
    }

    /// <summary>Each engine with the limits last reported for it; an engine no report names shows none.</summary>
    private IReadOnlyList<EngineWithLimits> WithLimits(IReadOnlyList<EngineEntry> engines)
    {
        var limits = new Dictionary<Engine, InferenceLimits>();
        foreach (var entry in Volatile.Read(ref reportedLimits)) limits[entry.Engine] = entry.Limits;
        return engines.Select(entry => new EngineWithLimits { Engine = entry.Engine, Jobs = entry.Jobs, Limits = limits.GetValueOrDefault(entry.Engine) }).ToArray();
    }

    private static bool ResourceMatches(ResourceId resource, Subject subject) => subject.Resource == resource;

    private static bool AnnotationMatches(AnnotationKey key, Subject subject) =>
        subject.Annotation is { } annotation ? annotation == key.Annotation && (subject.Resource is null || subject.Resource == key.Resource)
            : subject.Resource == key.Resource;

    private static Action<Subject, bool> Refetch<TKey, T>(Cache<TKey, T> cache, Func<TKey, Subject, bool> matches) where TKey : notnull =>
        (subject, all) =>
        {
            foreach (var pair in cache.Snapshot())
                if (all || matches(pair.Key, subject)) pair.Value.Refresh();
        };

    private void WriteAnnotations(Subject subject)
    {
        if (subject.Resource is not { } resource || subject.Written is not { } written) return;
        Annotations.Patch(resource, answer =>
        {
            var values = answer.Annotations.ToList();
            var index = values.FindIndex(item => item.Id == written.Id);
            if (index < 0) values.Add(written);
            else values[index] = written;
            return answer with { Annotations = values.ToArray() };
        });
    }

    private void WriteAnnotation(Subject subject)
    {
        if (subject.Resource is { } resource && subject.Written is { } written)
            Annotation.Find(new AnnotationKey(resource, written.Id))?.Set(written, onlyIfHeld: true);
    }

    private void RemoveAnnotation(Subject subject)
    {
        if (subject.Annotation is null) return;
        foreach (var pair in Annotation.Snapshot())
            if (AnnotationMatches(pair.Key, subject)) pair.Value.Remove(onlyIfHeld: true);
    }

    /// <summary>Every query the table names is one of the cache's, and each it writes or removes has a write or a
    /// removal; LiveCacheTests holds the rest of the table to what the cache reads.</summary>
    private void CheckRefresh()
    {
        var refetched = OnChannel.SelectMany(group => group).SelectMany(row => row.Refetches ?? [])
            .Concat(OnStream.SelectMany(group => group).SelectMany(row => row.Refetches ?? []));
        var written = OnChannel.SelectMany(group => group).SelectMany(row => row.Writes ?? []);
        var removed = OnChannel.SelectMany(group => group).SelectMany(row => row.Removes ?? []);
        if (!queries.Keys.ToHashSet(StringComparer.Ordinal).SetEquals(ProtocolTables.ClientRefresh.Queries.Select(KeptTable.Name)) ||
            !refetched.All(queries.ContainsKey) ||
            !written.All(name => queries.TryGetValue(name, out var query) && query.Write is not null) ||
            !removed.All(name => queries.TryGetValue(name, out var query) && query.Remove is not null))
            throw new InvalidOperationException("The live cache does not cover the refresh table.");
    }

    private async Task ReadEventsAsync()
    {
        await foreach (var carried in Spawning.ReadAll(events.Reader, CancellationToken.None).ConfigureAwait(Spawning.Captures))
        {
            if (persistence is null) Apply(carried);
            else persistence.Apply(carried, () => Apply(carried));
        }
    }

    private void Apply(Carried carried)
    {
        if (!OnChannel.Contains(carried.Channel)) return;
        // A frame that cannot be read could be of anything held.
        if (SubjectOf(carried) is not { } subject)
        {
            Refresh(ClientRefreshRefreshItemStreamStream.Unreadable);
            return;
        }
        Refresh(carried.Channel, subject);
    }

    /// <summary>What a frame on one of the table's channels names, by the ways of its row. None for a frame refused, one
    /// whose payload its channel's typed read refuses, or one where a member a way passes through or ends at is present
    /// and not what the way names.</summary>
    private Subject? SubjectOf(Carried carried)
    {
        if (carried is not ReceivedBusFrame { Frame.Payload: var payload } || !BusChannels.Readings[carried.Channel](carried)) return null;
        try
        {
            var row = RowOf(carried.Channel, payload);
            return new Subject(
                Resource: MemberAt(payload, row.Names?.Resource)?.Deserialize<ResourceId>(),
                Annotation: MemberAt(payload, row.Names?.Annotation)?.Deserialize<AnnotationId>(),
                Written: MemberAt(payload, row.Carries)?.Deserialize<Annotation>(),
                When: row.When);
        }
        catch (JsonException) { return null; }
    }

    /// <summary>A channel's row: of a split channel, the enriched one where the member it carries is present and not
    /// null.</summary>
    private static ClientRefreshRefreshItemOn RowOf(string channel, JsonElement payload)
    {
        var rows = OnChannel[channel];
        if (rows.All(row => row.When is null)) return rows.Single();
        var enriched = rows.Single(row => row.When == ClientRefreshRefreshItemOnWhen.Enriched);
        return MemberAt(payload, enriched.Carries) is null
            ? rows.Single(row => row.When == ClientRefreshRefreshItemOnWhen.Unenriched)
            : enriched;
    }

    /// <summary>The member <paramref name="way"/> ends at: none where the way is absent, or it or a member it passes
    /// through is absent or null. Throws JsonException where a member it passes through is present and no object.</summary>
    private static JsonElement? MemberAt(JsonElement payload, string? way)
    {
        if (way is null) return null;
        var member = payload;
        foreach (var name in way.Split('.'))
        {
            if (member.ValueKind == JsonValueKind.Null) return null;
            if (member.ValueKind != JsonValueKind.Object) throw new JsonException("The event's " + way + " passes through a member that is no object.");
            if (!member.TryGetProperty(name, out var within)) return null;
            member = within;
        }
        return member.ValueKind == JsonValueKind.Null ? null : member;
    }

    private async Task ReadReopensAsync(HttpTransport transport)
    {
        var opened = false;
        var left = false;
        await foreach (var state in transport.States().ConfigureAwait(Spawning.Captures))
        {
            if (state != ConnectionState.Open) { left = opened; continue; }
            if (left) Refresh(ClientRefreshRefreshItemStreamStream.Reopened);
            opened = true;
            left = false;
        }
    }

    private void Refresh(string channel, Subject subject)
    {
        foreach (var row in OnChannel[channel])
        {
            if (row.When != subject.When) continue;
            foreach (var name in row.Writes ?? []) queries[name].Write?.Invoke(subject);
            foreach (var name in row.Removes ?? []) queries[name].Remove?.Invoke(subject);
            foreach (var name in row.Refetches ?? []) queries[name].Refetch(subject, row.Reach == ClientRefreshRefreshItemOnReach.Held);
        }
    }

    private void Refresh(ClientRefreshRefreshItemStreamStream befell)
    {
        foreach (var row in OnStream[befell])
            foreach (var name in row.Refetches ?? []) queries[name].Refetch(new Subject(), row.Reach == ClientRefreshRefreshItemOnReach.Held);
    }

    public void Dispose()
    {
        events.Dispose();
        persistence?.Dispose();
        foreach (var cache in caches) cache.Dispose();
    }

    private sealed record Subject(ResourceId? Resource = null, AnnotationId? Annotation = null, Annotation? Written = null, ClientRefreshRefreshItemOnWhen? When = null);
    private sealed record Query(Action<Subject, bool> Refetch, Action<Subject>? Write = null, Action<Subject>? Remove = null);
}
