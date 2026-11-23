using Xynolog.Identifiers;
using Xynolog.Protocol;
using Xynolog.Types;

namespace Xynolog.State;

/// <summary>Says which annotation the pointer rests on, once it has stayed there for the hover delay, and says none as
/// soon as it leaves.</summary>
public sealed class HoverDwell : IStateUnit
{
    private readonly UnitWork work = new();
    private readonly Action<AnnotationId?> say;
    private readonly TimeProvider clock;
    private readonly TimeSpan delay;
    private CancellationTokenSource? resting;
    private AnnotationId? hovered;

    /// <summary>Makes a dwell that calls <paramref name="say"/> with each settled hover, after <paramref name="delay"/>
    /// (the protocol's hoverDelayMs when none is given) by <paramref name="timeProvider"/>'s clock.</summary>
    /// <param name="say">Called with the annotation hovered, or null when the pointer leaves it.</param>
    /// <param name="delay">How long the pointer must rest on an annotation before it counts as hovered.</param>
    /// <param name="timeProvider">The clock the delay is counted by; the system's when none is given.</param>
    public HoverDwell(Action<AnnotationId?> say, TimeSpan? delay = null, TimeProvider? timeProvider = null)
    {
        this.say = say;
        this.delay = delay ?? TimeSpan.FromMilliseconds(ProtocolFacts.Timing("hoverDelayMs").GetInt32());
        ArgumentOutOfRangeException.ThrowIfLessThan(this.delay, TimeSpan.Zero);
        clock = timeProvider ?? TimeProvider.System;
    }

    /// <summary>Starts counting the delay for the annotation the pointer has moved onto, abandoning any count in progress.</summary>
    public void Enter(AnnotationId annotationId)
    {
        lock (work.Gate)
        {
            if (!work.Active) return;
            CancelRest();
            if (hovered == annotationId) return;
            var next = CancellationTokenSource.CreateLinkedTokenSource(work.Token);
            resting = next;
            work.Run(_ => RestAsync(annotationId, next));
        }
    }

    /// <summary>Abandons any count in progress and says the pointer rests on no annotation.</summary>
    public void Leave()
    {
        lock (work.Gate)
        {
            if (!work.Active) return;
            CancelRest();
            if (hovered is null) return;
            hovered = null;
            say(null);
        }
    }

    private async Task RestAsync(AnnotationId annotation, CancellationTokenSource rest)
    {
        try
        {
            await Task.Delay(delay, clock, rest.Token).ConfigureAwait(Spawning.Captures);
            lock (work.Gate)
            {
                if (!work.Active || resting != rest) return;
                hovered = annotation;
                resting = null;
                say(annotation);
            }
        }
        finally
        {
            lock (work.Gate)
            {
                if (resting == rest) resting = null;
                rest.Dispose();
            }
        }
    }

    private void CancelRest()
    {
        var current = resting;
        resting = null;
        current?.Cancel();
    }

    /// <inheritdoc/>
    public void Dispose() => work.Dispose();
}

/// <summary>A resource's viewer's share of attention: the annotation hovered on this client's own bus, a sparkle for each
/// one hovered, and a focus for each one clicked.</summary>
public sealed class BeckonStateUnit : IStateUnit
{
    private readonly XynologClient client;
    private readonly ResourceId resourceId;
    private readonly UnitWork work;
    private readonly EventBus.Subscription events;
    /// <summary>The annotation last said to be hovered on this client's own bus, or null when none is.</summary>
    public StateValue<AnnotationId?> HoveredAnnotationId { get; } = new(null);

    /// <summary>Starts listening to this client's own bus for hovers and clicks on the resource's annotations.</summary>
    public BeckonStateUnit(XynologClient client, ResourceId resourceId)
    {
        this.client = client;
        this.resourceId = resourceId;
        work = new UnitWork(client.Transport.Closed);
        events = client.Bus.Listen([BusChannels.BeckonHover.Name, BusChannels.BrowseClick.Name]);
        work.Run(ReadAsync);
    }

    /// <summary>Draws this client's own viewers to the annotation of the resource, or to the resource as a whole.</summary>
    public void Focus(AnnotationId? annotationId = null)
    {
        lock (work.Gate)
        {
            if (work.Active) client.Bus.Emit(BusChannels.BeckonFocus, new BeckonFocusEvent { ResourceId = resourceId, AnnotationId = annotationId });
        }
    }

    private async Task ReadAsync(CancellationToken cancellation)
    {
        await foreach (var carried in Spawning.ReadAll(events.Reader, cancellation).ConfigureAwait(Spawning.Captures))
        {
            lock (work.Gate)
            {
                if (!work.Active) return;
                // A frame refused, or one whose payload is not its channel's, is nobody's to act on.
                if (carried.Channel == BusChannels.BrowseClick.Name)
                {
                    if (Bus.HeardOf<BrowseClickEvent>(carried) is Heard<BrowseClickEvent>.Delivered click) Focus(click.Payload.AnnotationId);
                }
                else if (Bus.HeardOf<BeckonHoverEvent>(carried) is Heard<BeckonHoverEvent>.Delivered hover)
                {
                    var annotation = hover.Payload.AnnotationId;
                    HoveredAnnotationId.Set(annotation);
                    if (annotation is { } id)
                        client.Bus.Emit(BusChannels.BeckonSparkle, new BeckonSparkleEvent { AnnotationId = id });
                }
            }
        }
    }

    /// <inheritdoc/>
    public void Dispose()
    {
        lock (work.Gate)
        {
            work.Dispose();
            events.Dispose();
            HoveredAnnotationId.Close();
        }
    }
}
