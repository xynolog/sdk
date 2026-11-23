using Xynolog.Errors;
using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog.State;

/// <summary>A delegated generation's progress: whether it is generating, its last report, the resource it made, and why
/// it failed.</summary>
public sealed class YieldStateUnit : IStateUnit
{
    private readonly XynologClient client;
    private readonly string locale;
    private readonly UnitWork work;
    private long revision;

    /// <summary>Whether the generation followed has reported progress and not yet ended.</summary>
    public StateValue<bool> IsGenerating { get; } = new(false);
    /// <summary>The generation's last progress report, kept after it ends until dismissed.</summary>
    public StateValue<JobProgress?> Progress { get; } = new(null);
    /// <summary>The resource the generation made, once it completes.</summary>
    public StateValue<YieldJobDone?> Outcome { get; } = new(null);
    /// <summary>Why the generation failed, or null when it did not.</summary>
    public StateValue<XynologError?> Failure { get; } = new(null);
    /// <summary>The id of the generation job being followed, once the queue has named it.</summary>
    public StateValue<JobId?> JobId { get; } = new(null);

    /// <summary>Makes the unit, whose generations are written in the locale unless their parameters name a language.</summary>
    public YieldStateUnit(XynologClient client, string locale)
    {
        this.client = client;
        this.locale = locale;
        work = new UnitWork(client.Transport.Closed);
    }

    /// <summary>Delegates the generation as a job and follows it, abandoning the generation followed before.</summary>
    public void Generate(GenerationJobParams parameters, int? stallDeadlineMs = null)
    {
        lock (work.Gate)
        {
            if (!work.Active) return;
            IsGenerating.Set(false);
            Progress.Set(null);
            Outcome.Set(null);
            Failure.Set(null);
            JobId.Set(null);
            var written = string.IsNullOrEmpty(parameters.Language) ? parameters with { Language = locale } : parameters;
            var run = client.Yield.Delegate(written, stallDeadlineMs);
            var selected = ++revision;
            work.Run(token => FollowAsync(run, selected, token));
        }
    }

    /// <summary>Clears the shown progress, outcome and failure of the last generation.</summary>
    public void DismissProgress()
    {
        lock (work.Gate)
        {
            if (!work.Active) return;
            Progress.Set(null);
            Outcome.Set(null);
            Failure.Set(null);
        }
    }

    private async Task FollowAsync(Delegation<YieldJobCompleteCommand> run, long selected, CancellationToken cancellation)
    {
        try
        {
            await foreach (var update in run.WithCancellation(cancellation).ConfigureAwait(Spawning.Captures))
            {
                lock (work.Gate)
                {
                    if (!work.Active || revision != selected) return;
                    switch (update)
                    {
                        case JobEvent<YieldJobCompleteCommand>.Created(var created): JobId.Set(created.JobId); break;
                        case JobEvent<YieldJobCompleteCommand>.Progress(var progress):
                            Progress.Set(progress);
                            IsGenerating.Set(true);
                            break;
                        case JobEvent<YieldJobCompleteCommand>.Complete({ Result: YieldJobResult.YieldJobDoneCase(var outcome) }):
                            Outcome.Set(outcome);
                            break;
                    }
                }
            }
        }
        catch (XynologError failure)
        {
            lock (work.Gate)
            {
                if (!work.Active || revision != selected) return;
                Failure.Set(failure);
                if (!DisplayFailure.WasCancelled(failure)) Progress.Set(null);
            }
        }
        finally
        {
            lock (work.Gate)
            {
                if (work.Active && revision == selected)
                {
                    JobId.Set(null);
                    IsGenerating.Set(false);
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
            IsGenerating.Close();
            Progress.Close();
            Outcome.Close();
            Failure.Close();
            JobId.Close();
        }
    }
}

internal static class DisplayFailure
{
    internal static bool WasCancelled(XynologError error) => error is JobError && error.Code == Protocol.ProtocolFacts.JobError("cancelled");
}
