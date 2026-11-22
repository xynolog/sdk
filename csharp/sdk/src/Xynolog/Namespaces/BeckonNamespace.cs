using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog.Namespaces;

/// <summary>Attention: driving the other participants' viewers, and this viewer's own signals.</summary>
public sealed class BeckonNamespace
{
    private readonly Bus wire;
    private readonly EventBus bus;

    internal BeckonNamespace(Bus wire, EventBus bus)
    {
        this.wire = wire;
        this.bus = bus;
    }

    /// <summary>Draws the other participants' viewers to the resource, or to one of its annotations; resolves with how many
    /// the gateway reached, or null when it kept no count.</summary>
    public Task<int?> AttentionAsync(ResourceId resourceId, AnnotationId? annotationId = null,
        CancellationToken cancellation = default) =>
        CountAsync(BusChannels.BeckonFocus, new BeckonFocusEvent { ResourceId = resourceId, AnnotationId = annotationId }, cancellation);

    /// <summary>Opens the annotation on the other participants' viewers; resolves with how many the gateway reached, or null
    /// when it kept no count.</summary>
    public Task<int?> ClickAsync(AnnotationId annotationId, CancellationToken cancellation = default) =>
        CountAsync(BusChannels.BrowseClick, new BrowseClickEvent { AnnotationId = annotationId }, cancellation);

    /// <summary>Opens the resource on the other participants' viewers; resolves with how many the gateway reached, or null
    /// when it kept no count.</summary>
    public Task<int?> OpenResourceAsync(ResourceId resourceId, CancellationToken cancellation = default) =>
        CountAsync(BusChannels.BrowseResourceOpen, new BrowseResourceOpenEvent { ResourceId = resourceId }, cancellation);

    /// <summary>Sparkles the annotation on the other participants' viewers; resolves with how many the gateway reached, or
    /// null when it kept no count.</summary>
    public Task<int?> SparkleAllAsync(AnnotationId annotationId, CancellationToken cancellation = default) =>
        CountAsync(BusChannels.BeckonSparkle, new BeckonSparkleEvent { AnnotationId = annotationId }, cancellation);

    /// <summary>Tells this client's own bus that the pointer rests on the annotation, or on none.</summary>
    public void Hover(AnnotationId? annotationId) =>
        bus.Emit(BusChannels.BeckonHover, new BeckonHoverEvent { AnnotationId = annotationId });

    /// <summary>Sparkles the annotation in this client's own viewers.</summary>
    public void Sparkle(AnnotationId annotationId) =>
        bus.Emit(BusChannels.BeckonSparkle, new BeckonSparkleEvent { AnnotationId = annotationId });

    private async Task<int?> CountAsync<T>(BusChannel<T> channel, T payload, CancellationToken cancellation) where T : class =>
        checked((int?)await wire.EmitAsync(channel, payload, cancellation: cancellation).ConfigureAwait(Spawning.Captures));
}
