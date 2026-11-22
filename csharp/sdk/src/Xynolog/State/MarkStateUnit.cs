using Xynolog.Errors;
using Xynolog.Identifiers;
using Xynolog.Protocol;
using Xynolog.Types;

namespace Xynolog.State;

/// <summary>A resource's annotating: the annotation being composed from a request on this client's own bus, its creation
/// on submit, and a delegated annotating job's progress.</summary>
public sealed class MarkStateUnit : IStateUnit
{
    private readonly XynologClient client;
    private readonly ResourceId resourceId;
    private readonly UnitWork work;
    private readonly EventBus.Subscription events;
    private readonly TimeProvider clock;
    private static readonly TimeSpan Silence = TimeSpan.FromMilliseconds(ProtocolFacts.Timing("delegateSilenceMs").GetInt32());
    private long revision;

    /// <summary>The annotation being composed for the resource, from the selection a request asked for, until it is
    /// created or cancelled.</summary>
    public StateValue<PendingAnnotation?> PendingAnnotation { get; } = new(null);
    /// <summary>The motivation of the annotating job being followed, or null when none is.</summary>
    public StateValue<Motivation?> DelegatingMotivation { get; } = new(null);
    /// <summary>The annotating job's last progress report, kept after it ends until dismissed.</summary>
    public StateValue<JobProgress?> Progress { get; } = new(null);
    /// <summary>The motivation of the job whose progress is shown.</summary>
    public StateValue<Motivation?> ProgressMotivation { get; } = new(null);
    /// <summary>Why the annotating job failed, or null when it did not.</summary>
    public StateValue<XynologError?> Failure { get; } = new(null);
    /// <summary>The id of the annotating job being followed, once the queue has named it.</summary>
    public StateValue<JobId?> JobId { get; } = new(null);

    /// <summary>Starts listening to this client's own bus for requests and submissions of annotations of the resource.</summary>
    public MarkStateUnit(XynologClient client, ResourceId resourceId)
    {
        this.client = client;
        this.resourceId = resourceId;
        clock = client.Transport.Clock;
        work = new UnitWork(client.Transport.Closed);
        events = client.Bus.Listen([BusChannels.MarkRequested.Name, BusChannels.MarkSubmit.Name]);
        work.Run(ReadAsync);
    }

    /// <summary>Delegates the annotating of the resource as a job and follows it, abandoning the job followed before.</summary>
    public void RequestDelegate(MarkJobParams parameters)
    {
        lock (work.Gate)
        {
            if (!work.Active) return;
            var motivation = parameters switch
            {
                MarkJobParams.HighlightingJobParamsCase => Motivation.Highlighting,
                MarkJobParams.CommentingJobParamsCase => Motivation.Commenting,
                MarkJobParams.AssessingJobParamsCase => Motivation.Assessing,
                MarkJobParams.LinkingJobParamsCase => Motivation.Linking,
                MarkJobParams.TaggingJobParamsCase => Motivation.Tagging,
            };
            DelegatingMotivation.Set(motivation);
            Progress.Set(null);
            ProgressMotivation.Set(motivation);
            Failure.Set(null);
            JobId.Set(null);
            var run = client.Mark.Delegate(resourceId, parameters);
            var selected = ++revision;
            work.Run(token => FollowAsync(run, motivation, selected, token));
        }
    }

    /// <summary>Drops the annotation being composed.</summary>
    public void CancelPending()
    {
        lock (work.Gate)
            if (work.Active) PendingAnnotation.Set(null);
    }

    /// <summary>Clears the shown progress and failure of the last annotating job.</summary>
    public void DismissProgress()
    {
        lock (work.Gate)
        {
            if (!work.Active) return;
            Progress.Set(null);
            ProgressMotivation.Set(null);
            Failure.Set(null);
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
                if (carried.Channel == BusChannels.MarkRequested.Name)
                {
                    if (Bus.HeardOf<MarkRequestedEvent>(carried) is Heard<MarkRequestedEvent>.Delivered { Payload: var request } && request.Source == resourceId)
                        PendingAnnotation.Set(new PendingAnnotation { Selector = request.Selector, Motivation = request.Motivation });
                }
                else if (Bus.HeardOf<MarkSubmitEvent>(carried) is Heard<MarkSubmitEvent>.Delivered { Payload: var submission } && submission.Source == resourceId)
                {
                    var composed = PendingAnnotation.Value;
                    work.Run(token => CreateAsync(submission, composed, token));
                }
            }
        }
    }

    private async Task CreateAsync(MarkSubmitEvent submission, PendingAnnotation? composed, CancellationToken cancellation)
    {
        var target = new AnnotationTarget { Source = resourceId, Selector = submission.Selector };
        try
        {
            await client.Mark.AnnotationAsync(new CreateAnnotationRequest
            {
                Target = target,
                Motivation = submission.Motivation,
                Body = submission.Body,
            }, cancellation).ConfigureAwait(Spawning.Captures);
            lock (work.Gate)
                if (work.Active && ReferenceEquals(PendingAnnotation.Value, composed)) PendingAnnotation.Set(null);
        }
        catch (XynologError failure)
        {
            lock (work.Gate)
                if (work.Active) client.Bus.Emit(BusChannels.MarkCreateError,
                    new ResourceErrorEvent { ResourceId = resourceId, Message = failure.Message });
        }
    }

    private async Task FollowAsync(Delegation<MarkJobCompleteCommand> run, Motivation motivation, long selected, CancellationToken token)
    {
        try
        {
            var reader = run.GetAsyncEnumerator(token);
            await using var disposing = reader.ConfigureAwait(Spawning.Captures);
            // The silence is counted from the follower's last word of the job, and said once until the next.
            var heardAt = clock.GetTimestamp();
            var said = false;
            while (true)
            {
                var next = Spawning.AsTask(reader.MoveNextAsync());
                if (!said)
                {
                    using var waiting = CancellationTokenSource.CreateLinkedTokenSource(token);
                    var left = Silence - clock.GetElapsedTime(heardAt);
                    var quiet = Task.Delay(left > TimeSpan.Zero ? left : TimeSpan.Zero, clock, waiting.Token);
                    if (await Spawning.WhenAny(next, quiet).ConfigureAwait(Spawning.Captures) == quiet && !token.IsCancellationRequested && !next.IsCompleted)
                    {
                        said = true;
                        lock (work.Gate)
                        {
                            if (work.Active && revision == selected)
                            {
                                if (Progress.Value is null) Progress.Set(new JobProgress { Percentage = 0 });
                                client.Bus.Emit(BusChannels.MarkDelegateTimeout,
                                    new MarkDelegateTimeoutEvent { ResourceId = resourceId, Motivation = motivation });
                            }
                        }
                    }
                    waiting.Cancel();
                }
                if (!await next.ConfigureAwait(Spawning.Captures)) return;
                lock (work.Gate)
                {
                    if (!work.Active || revision != selected) return;
                    switch (reader.Current)
                    {
                        case JobEvent<MarkJobCompleteCommand>.Created(var created): JobId.Set(created.JobId); break;
                        case JobEvent<MarkJobCompleteCommand>.Progress(var progress): Progress.Set(progress); break;
                    }
                }
                // A refused frame is no word of the job: the silence goes on being counted through it.
                if (reader.Current is JobEvent<MarkJobCompleteCommand>.Refused) continue;
                heardAt = clock.GetTimestamp();
                said = false;
            }
        }
        catch (XynologError failure)
        {
            lock (work.Gate)
            {
                if (!work.Active || revision != selected) return;
                Failure.Set(failure);
                if (!DisplayFailure.WasCancelled(failure))
                {
                    Progress.Set(null);
                    ProgressMotivation.Set(null);
                }
            }
        }
        finally
        {
            lock (work.Gate)
            {
                if (work.Active && revision == selected)
                {
                    DelegatingMotivation.Set(null);
                    JobId.Set(null);
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
            PendingAnnotation.Close();
            DelegatingMotivation.Close();
            Progress.Close();
            ProgressMotivation.Close();
            Failure.Close();
            JobId.Close();
        }
    }
}
