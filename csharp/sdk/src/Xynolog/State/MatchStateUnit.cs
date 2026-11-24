using Xynolog.Errors;
using Xynolog.Types;

namespace Xynolog.State;

/// <summary>Answers each search request on this client's own bus with its results, or its failure, under the request's
/// correlation id.</summary>
public sealed class MatchStateUnit : IStateUnit
{
    private readonly XynologClient client;
    private readonly UnitWork work;
    private readonly EventBus.Subscription events;

    /// <summary>Starts answering the search requests on the client's own bus.</summary>
    public MatchStateUnit(XynologClient client)
    {
        this.client = client;
        work = new UnitWork(client.Transport.Closed);
        events = client.Bus.Listen([BusChannels.MatchSearchRequested.Name]);
        work.Run(ReadAsync);
    }

    private async Task ReadAsync(CancellationToken cancellation)
    {
        await foreach (var carried in Spawning.ReadAll(events.Reader, cancellation).ConfigureAwait(Spawning.Captures))
        {
            lock (work.Gate)
            {
                if (!work.Active) return;
                // A request that is not a search's names nothing to search for.
                if (Bus.HeardOf<MatchSearchRequest>(carried) is Heard<MatchSearchRequest>.Delivered asked)
                    work.Run(token => SearchAsync(asked.Payload, asked.Received.CorrelationId, token));
            }
        }
    }

    private async Task SearchAsync(MatchSearchRequest request, string? correlationId, CancellationToken cancellation)
    {
        try
        {
            var found = await client.Match.Search(request.ResourceId, request.ReferenceId, request.Context,
                new MatchSearchOptions { Limit = request.Limit, UseSemanticScoring = request.UseSemanticScoring }).CompleteAsync(cancellation).ConfigureAwait(Spawning.Captures);
            lock (work.Gate)
                if (work.Active) client.Bus.Emit(BusChannels.MatchSearchResults, found, correlationId: correlationId);
        }
        catch (XynologError error)
        {
            lock (work.Gate)
                if (work.Active) client.Bus.Emit(BusChannels.MatchSearchFailed,
                    new MatchSearchFailed { ReferenceId = request.ReferenceId, Message = error.Message }, correlationId: correlationId);
        }
    }

    /// <inheritdoc/>
    public void Dispose()
    {
        lock (work.Gate) { work.Dispose(); events.Dispose(); }
    }
}
