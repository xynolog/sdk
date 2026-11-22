using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog.Namespaces;

/// <summary>Annotations: their creation and removal, a resource's own metadata, and the annotating of a resource
/// delegated as a job.</summary>
public sealed class MarkNamespace
{
    private readonly Bus wire;
    private readonly EventBus bus;

    private readonly JobFollower follower;

    internal MarkNamespace(Bus wire, EventBus bus, JobFollower follower)
    {
        this.wire = wire;
        this.bus = bus;
        this.follower = follower;
    }

    /// <summary>Creates the annotation on the resource its target names.</summary>
    public async Task<MarkCreateOkResponse> AnnotationAsync(CreateAnnotationRequest input, CancellationToken cancellation = default) =>
        (await wire.RequestAsync(BusOperations.MarkCreateRequest, new MarkCreateRequest
        {
            Request = input,
            ResourceId = input.Target.Source,
        }, cancellation: cancellation).ConfigureAwait(Spawning.Captures)).Response;

    /// <summary>Deletes the annotation from the resource.</summary>
    public Task DeleteAsync(ResourceId resourceId, AnnotationId annotationId, CancellationToken cancellation = default) =>
        wire.RequestAsync(BusOperations.MarkDelete, new MarkDeleteCommand
        {
            ResourceId = resourceId,
            AnnotationId = annotationId,
        }, cancellation: cancellation);

    /// <summary>Archives the resource.</summary>
    public Task ArchiveAsync(ResourceId resourceId, CancellationToken cancellation = default) =>
        wire.RequestAsync(BusOperations.MarkArchive, new MarkArchiveCommand { ResourceId = resourceId }, cancellation: cancellation);

    /// <summary>Brings the resource back from the archive.</summary>
    public Task UnarchiveAsync(ResourceId resourceId, CancellationToken cancellation = default) =>
        wire.RequestAsync(BusOperations.MarkUnarchive, new MarkUnarchiveCommand { ResourceId = resourceId }, cancellation: cancellation);

    /// <summary>Replaces the resource's entity types with the updated list, naming the current list it replaces.</summary>
    public Task UpdateEntityTypesAsync(ResourceId resourceId, IReadOnlyList<string> current, IReadOnlyList<string> updated,
        CancellationToken cancellation = default) =>
        wire.RequestAsync(BusOperations.MarkUpdateEntityTypes, new MarkUpdateEntityTypesCommand
        {
            ResourceId = resourceId,
            CurrentEntityTypes = current,
            UpdatedEntityTypes = updated,
        }, cancellation: cancellation);

    /// <summary>Follows the job that annotates a resource.</summary>
    public Delegation<MarkJobCompleteCommand> Delegate(ResourceId resourceId, MarkJobParams parameters) =>
        follower.Follow(new JobCreateCommand.MarkJobCreateCommandCase(new MarkJobCreateCommand
        {
            ResourceId = resourceId,
            Params = parameters,
        }), resourceId, JobCompletion.Mark);

    /// <summary>Asks, on this client's own bus, for a new annotation of the selection, for the resource's viewer to compose.</summary>
    public void Request(ResourceId source, AnnotationSelector selector, Motivation motivation) =>
        bus.Emit(BusChannels.MarkRequested, new MarkRequestedEvent { Source = source, Selector = selector, Motivation = motivation });

    /// <summary>Submits a composed annotation on this client's own bus, for the resource's state unit to create.</summary>
    public void Submit(MarkSubmitEvent input) => bus.Emit(BusChannels.MarkSubmit, input);

    /// <summary>Tells this client's own bus that deleting an annotation failed, for a viewer to show.</summary>
    public void ReportDeleteError(ResourceErrorEvent input) => bus.Emit(BusChannels.MarkDeleteError, input);
}
