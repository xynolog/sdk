using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog.Namespaces;

/// <summary>Reads: live queries, one-shot reads, and this viewer's own signals.</summary>
public sealed class BrowseNamespace
{
    private readonly Bus wire;
    private readonly EventBus bus;
    private readonly HttpContentTransport content;
    private readonly CancellationToken closed;
    private readonly LiveQueries live;

    internal BrowseNamespace(Bus wire, EventBus bus, HttpContentTransport content, CancellationToken closed, LiveQueries live)
    {
        this.wire = wire;
        this.bus = bus;
        this.content = content;
        this.closed = closed;
        this.live = live;
    }

    /// <summary>A live query of the resource's descriptor.</summary>
    public Cached<ResourceDescriptor> Resource(ResourceId resourceId) => live.ResourcesById.Observe(resourceId);

    /// <summary>A live query of a page of the knowledge base's resources, narrowed to archived or unarchived ones and to an
    /// entity type when the filters say so: the page they name, and the service's own when they name none.</summary>
    public Cached<ListResourcesResponse> Resources(BrowseResourcesRequest? filters = null) =>
        live.Resources.Observe(filters ?? new BrowseResourcesRequest());

    /// <summary>A live query of the resource's annotations.</summary>
    public Cached<IReadOnlyList<Annotation>> Annotations(ResourceId resourceId) =>
        new CachedPart<GetAnnotationsResponse, IReadOnlyList<Annotation>>(live.Annotations.Observe(resourceId), answer => answer.Annotations);

    /// <summary>A live query of one annotation of the resource.</summary>
    public Cached<Annotation> Annotation(ResourceId resourceId, AnnotationId annotationId) =>
        live.Annotation.Observe(new LiveQueries.AnnotationKey(resourceId, annotationId));

    /// <summary>A live query of the entity types the knowledge base's vocabulary holds.</summary>
    public Cached<IReadOnlyList<string>> EntityTypes() => live.EntityTypes;
    /// <summary>A live query of the tag schemas the knowledge base's vocabulary holds.</summary>
    public Cached<IReadOnlyList<TagSchema>> TagSchemas() => live.TagSchemas;
    /// <summary>A live query of the engines the knowledge base runs jobs with, and their limits.</summary>
    public Cached<IReadOnlyList<EngineWithLimits>> Engines() => live.EnginesWithLimits;
    /// <summary>A live query of the events recorded against the resource.</summary>
    public Cached<IReadOnlyList<AttributedEvent>> Events(ResourceId resourceId) => live.Events.Observe(resourceId);

    /// <summary>Fetches the resource's representation and decodes it as text, by the charset it was served with.</summary>
    public async Task<string> ResourceContentAsync(ResourceId resourceId, CancellationToken cancellation = default)
    {
        var representation = await content.GetBinaryAsync(resourceId, cancellation).ConfigureAwait(Spawning.Captures);
        return RepresentationText.Decode(representation.Data, representation.ContentType);
    }

    /// <summary>Fetches the resource with all of its annotations.</summary>
    public Task<GetResourceResponse> ResourceGraphAsync(ResourceId resourceId, CancellationToken cancellation = default) =>
        content.GetResourceGraphAsync(resourceId, cancellation);

    /// <summary>Fetches the resource's text with the page locations of its items, as a PDF has them.</summary>
    public Task<AnchoredTextAnswer> ResourceAnchoredTextAsync(ResourceId resourceId, CancellationToken cancellation = default) =>
        content.GetAnchoredTextAsync(resourceId, cancellation);

    /// <summary>Fetches the resource's representation whole: its bytes and media type.</summary>
    public Task<ResourceRepresentation> ResourceRepresentationAsync(ResourceId resourceId, CancellationToken cancellation = default) =>
        content.GetBinaryAsync(resourceId, cancellation);

    /// <summary>Opens the resource's representation as a stream, for content too large to hold in memory.</summary>
    public Task<BinaryStream> ResourceRepresentationStreamAsync(ResourceId resourceId, CancellationToken cancellation = default) =>
        content.GetBinaryStreamAsync(resourceId, cancellation);

    /// <summary>Asks once for the events recorded against the resource.</summary>
    public async Task<IReadOnlyList<AttributedEvent>> ResourceEventsAsync(ResourceId resourceId, CancellationToken cancellation = default) =>
        (await wire.RequestAsync(BusOperations.BrowseEventsRequested, new BrowseEventsRequest { ResourceId = resourceId },
            cancellation: cancellation).ConfigureAwait(Spawning.Captures)).Response.Events;

    /// <summary>Asks for the events that made and changed the annotation.</summary>
    public async Task<GetAnnotationHistoryResponse> AnnotationHistoryAsync(ResourceId resourceId, AnnotationId annotationId,
        CancellationToken cancellation = default) =>
        (await wire.RequestAsync(BusOperations.BrowseAnnotationHistoryRequested,
            new BrowseAnnotationHistoryRequest { ResourceId = resourceId, AnnotationId = annotationId },
            cancellation: cancellation).ConfigureAwait(Spawning.Captures)).Response;

    /// <summary>Lists a directory of the knowledge base's working tree, in the order asked for.</summary>
    public async Task<BrowseDirectoryResultResponse> FilesAsync(string dirPath = ".", BrowseDirectoryRequestSort sort = BrowseDirectoryRequestSort.Name,
        CancellationToken cancellation = default) =>
        (await wire.RequestAsync(BusOperations.BrowseDirectoryRequested, new BrowseDirectoryRequest { Path = dirPath, Sort = sort },
            cancellation: cancellation).ConfigureAwait(Spawning.Captures)).Response;

    /// <summary>Asks the knowledge base for its name and domain.</summary>
    public async Task<KbDescription> KbAsync(CancellationToken cancellation = default) =>
        (await wire.RequestAsync(BusOperations.BrowseKbRequested, new BrowseKbRequest(), cancellation: cancellation)
            .ConfigureAwait(Spawning.Captures)).Response;

    /// <summary>Opens the annotation in this client's own viewers, as clicking it would.</summary>
    public void Click(AnnotationId annotationId, AnchorRect? anchorRect = null) =>
        bus.Emit(BusChannels.BrowseClick, new BrowseClickEvent { AnnotationId = annotationId, AnchorRect = anchorRect });

    /// <summary>Opens the resource in this client's own viewer.</summary>
    public void OpenResource(ResourceId resourceId) =>
        bus.Emit(BusChannels.BrowseResourceOpen, new BrowseResourceOpenEvent { ResourceId = resourceId });

    /// <summary>Reports over the wire, without waiting, that the resource has loaded in this viewer.</summary>
    public void ResourceViewed(ResourceId resourceId) => _ = ReportViewedAsync(resourceId);

    private async Task ReportViewedAsync(ResourceId resourceId)
    {
        if (closed.IsCancellationRequested) return;
        try
        {
            await wire.EmitAsync(BusChannels.BrowseResourceViewed, new BrowseResourceViewedEvent { ResourceId = resourceId },
                cancellation: closed).ConfigureAwait(Spawning.Captures);
        }
        catch (TransportError) { /* The transport reports the refusal on its error stream. */ }
        catch (OperationCanceledException) when (closed.IsCancellationRequested) { /* Closing abandons pending navigation reports. */ }
    }
}
