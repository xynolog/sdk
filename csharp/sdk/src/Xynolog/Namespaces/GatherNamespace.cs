using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog.Namespaces;

/// <summary>Assembling the context a model is given, and what refers to a resource.</summary>
public sealed class GatherNamespace
{
    private readonly Bus wire;
    private readonly LiveQueries live;

    internal GatherNamespace(Bus wire, LiveQueries live)
    {
        this.wire = wire;
        this.live = live;
    }

    /// <summary>A live query of the annotations that refer to the resource.</summary>
    public Cached<IReadOnlyList<GetReferencedByResponseReferencedByItem>> ReferencedBy(ResourceId resourceId) =>
        live.ReferencedBy.Observe(resourceId);

    /// <summary>Gathers the context around the annotation: the text on each side of it, as much as the options say and as
    /// the gatherer decides when they do not. Options that state nothing are not sent.</summary>
    public Running<GatherAnnotationComplete> Annotation(ResourceId resourceId, AnnotationId annotationId,
        GatherAnnotationOptions? options = null)
    {
        var request = new GatherAnnotationRequest
        {
            ResourceId = resourceId,
            AnnotationId = annotationId,
            Options = options == new GatherAnnotationOptions() ? null : options,
        };
        return new((_, cancellation) => wire.RequestAsync(BusOperations.GatherRequested, request, cancellation: cancellation));
    }

    /// <summary>Gathers the context of the resource by following its links to related resources, as deep and as many as
    /// asked.</summary>
    public async Task<GatheredContext> ResourceAsync(ResourceId resourceId, GatherResourceOptions? options = null,
        CancellationToken cancellation = default)
    {
        var request = new GatherResourceRequest
        {
            ResourceId = resourceId,
            Options = new GatherResourceRequestOptions
            {
                Depth = options?.Depth ?? 2,
                MaxResources = options?.MaxResources ?? 10,
                IncludeContent = options?.IncludeContent ?? true,
                IncludeSummary = options?.IncludeSummary ?? false,
                ExcludeEntityTypes = options?.ExcludeEntityTypes is { Count: > 0 } excluded ? excluded : null,
            },
        };
        return (await wire.RequestAsync(BusOperations.GatherResourceRequested, request, cancellation: cancellation)
            .ConfigureAwait(Spawning.Captures)).Response;
    }
}
