using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog.Namespaces;

/// <summary>Searching: for what a reference could refer to, and for resources by text.</summary>
public sealed class MatchNamespace
{
    private readonly Bus wire;
    private readonly LiveQueries live;
    private readonly EventBus bus;

    internal MatchNamespace(Bus wire, EventBus bus, LiveQueries live)
    {
        this.wire = wire;
        this.bus = bus;
        this.live = live;
    }

    /// <summary>A live query of the resources whose text matches the search, a page at a time.</summary>
    public Cached<MatchResourcesResponse> Resources(string search, long limit = 100, long offset = 0,
        bool? archived = null, string? entityType = null) =>
        live.MatchedResources.Observe(new LiveQueries.Search(search, new LiveQueries.Filters(limit, offset, archived, entityType)));

    /// <summary>Searches for the resources the reference could refer to, scored by its gathered context.</summary>
    public Running<MatchSearchResult> Search(ResourceId resourceId, AnnotationId referenceId, GatheredContext context,
        long limit = 10, bool useSemanticScoring = true)
    {
        var request = new MatchSearchRequest
        {
            ResourceId = resourceId,
            ReferenceId = referenceId,
            Context = context,
            Limit = limit,
            UseSemanticScoring = useSemanticScoring,
        };
        return new((_, cancellation) => wire.RequestAsync(BusOperations.MatchSearchRequested, request, cancellation: cancellation));
    }

    /// <summary>Asks, on this client's own bus, for a search of what a reference could refer to, its answer paired with the
    /// correlation id.</summary>
    public void RequestSearch(MatchSearchRequest input, string correlationId) =>
        bus.Emit(BusChannels.MatchSearchRequested, input, correlationId: correlationId);
}
