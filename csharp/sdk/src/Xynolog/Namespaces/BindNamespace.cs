using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog.Namespaces;

/// <summary>Linking a reference to what it refers to.</summary>
public sealed class BindNamespace
{
    private readonly Bus wire;
    private readonly EventBus bus;

    internal BindNamespace(Bus wire, EventBus bus)
    {
        this.wire = wire;
        this.bus = bus;
    }

    /// <summary>Applies the operations to the annotation's body, completing when the knowledge base has applied them.</summary>
    public async Task BodyAsync(ResourceId resourceId, AnnotationId annotationId,
        IReadOnlyList<BindBodyOperation> operations, CancellationToken cancellation = default)
    {
        await wire.RequestAsync(BusOperations.BindUpdateBody, new BindUpdateBodyCommand
        {
            ResourceId = resourceId,
            AnnotationId = annotationId,
            Operations = operations,
        }, cancellation: cancellation).ConfigureAwait(Spawning.Captures);
    }

    /// <summary>Starts a bind flow on this client's own bus, for a viewer to link the reference.</summary>
    public void Initiate(BindInitiateCommand input) => bus.Emit(BusChannels.BindInitiate, input);

    /// <summary>Tells this client's own bus that updating an annotation's body failed, for a viewer to show.</summary>
    public void ReportBodyError(ResourceErrorEvent input) => bus.Emit(BusChannels.BindBodyError, input);
}
