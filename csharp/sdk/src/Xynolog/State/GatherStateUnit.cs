using Xynolog.Errors;
using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog.State;

/// <summary>The context last gathered around an annotation of a resource, and around a resource, with whether each is
/// loading and why it failed.</summary>
public sealed class GatherStateUnit : IStateUnit
{
    private readonly XynologClient client;
    private readonly ResourceId annotationResource;
    private readonly UnitWork work;
    private readonly GatherSlot annotation = new();
    private readonly GatherSlot resource = new();

    /// <summary>The context last gathered around the annotation, or null while loading or after a failure.</summary>
    public StateValue<GatheredContext?> Context => annotation.Context;
    /// <summary>Whether a gather around an annotation is in progress.</summary>
    public StateValue<bool> Loading => annotation.Loading;
    /// <summary>Why the last gather around an annotation failed, or null when it did not.</summary>
    public StateValue<XynologError?> Error => annotation.Error;
    /// <summary>The annotation the last gather around an annotation was asked for.</summary>
    public StateValue<AnnotationId?> AnnotationId { get; } = new(null);
    /// <summary>The context last gathered around a resource, or null while loading or after a failure.</summary>
    public StateValue<GatheredContext?> ResourceContext => resource.Context;
    /// <summary>Whether a gather around a resource is in progress.</summary>
    public StateValue<bool> ResourceLoading => resource.Loading;
    /// <summary>Why the last gather around a resource failed, or null when it did not.</summary>
    public StateValue<XynologError?> ResourceError => resource.Error;

    /// <summary>Makes the unit for the annotations of the resource.</summary>
    public GatherStateUnit(XynologClient client, ResourceId resourceId)
    {
        this.client = client;
        annotationResource = resourceId;
        work = new UnitWork(client.Transport.Closed);
    }

    /// <summary>Gathers the context around one of the resource's annotations, replacing what was gathered before.</summary>
    public void GatherAnnotation(AnnotationId annotationId, GatherAnnotationOptions? options = null)
    {
        lock (work.Gate)
        {
            if (!work.Active) return;
            AnnotationId.Set(annotationId);
            Start(annotation, async token => (await client.Gather.Annotation(annotationResource, annotationId, options)
                .CompleteAsync(token).ConfigureAwait(Spawning.Captures)).Response);
        }
    }

    /// <summary>Gathers the context around the resource by following its links, replacing what was gathered before.</summary>
    public void GatherResource(ResourceId resourceId, GatherResourceOptions? options = null)
    {
        lock (work.Gate)
        {
            if (!work.Active) return;
            Start(resource, token => client.Gather.ResourceAsync(resourceId, options, token));
        }
    }

    private void Start(GatherSlot slot, Func<CancellationToken, Task<GatheredContext>> gather)
    {
        slot.Loading.Set(true);
        slot.Context.Set(null);
        slot.Error.Set(null);
        work.Run(token => LandAsync(slot, gather, token));
    }

    private async Task LandAsync(GatherSlot slot, Func<CancellationToken, Task<GatheredContext>> gather, CancellationToken token)
    {
        GatheredContext? context = null;
        XynologError? failure = null;
        try { context = await gather(token).ConfigureAwait(Spawning.Captures); }
        catch (XynologError error) { failure = error; }
        lock (work.Gate)
        {
            if (!work.Active) return;
            slot.Context.Set(context);
            slot.Error.Set(failure);
            slot.Loading.Set(false);
        }
    }

    /// <inheritdoc/>
    public void Dispose()
    {
        lock (work.Gate)
        {
            work.Dispose();
            annotation.Close();
            resource.Close();
            AnnotationId.Close();
        }
    }

    private sealed class GatherSlot
    {
        internal StateValue<GatheredContext?> Context { get; } = new(null);
        internal StateValue<bool> Loading { get; } = new(false);
        internal StateValue<XynologError?> Error { get; } = new(null);

        internal void Close()
        {
            Context.Close();
            Loading.Close();
            Error.Close();
        }
    }
}
