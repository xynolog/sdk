using System.Diagnostics;
using System.Text.Json;
using System.Text.Json.Nodes;
using Xynolog;
using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Identifiers;
using Xynolog.Jobs;
using Xynolog.Types;

internal sealed class WorkerDriver : IDisposable
{
    private static readonly ActivitySource Activities = new("xynolog");
    private readonly object gate = new();
    private readonly List<IDisposable> scopes = [];
    private XynologClient? client;
    private Claims? claims;
    /// <summary>The waits <c>open</c> stated of those its claims keep, as <see cref="ClaimOptions"/> names them.</summary>
    private JsonObject claimWaits = new();
    private Held? held;

    internal async Task RunAsync(JsonElement args)
    {
        var id = args.GetProperty("id").GetInt64();
        try
        {
            object? answer = null;
            switch (Text(args, "op"))
            {
                case "open":
                    if (client is not null) throw new InvalidOperationException("A client is already open.");
                    var rows = StatedTiming.Rows(args);
                    var clientTiming = StatedTiming.Read<ClientTiming>(StatedTiming.Take<ClientTiming>(rows));
                    claimWaits = StatedTiming.Take<ClaimOptions>(rows);
                    var timing = StatedTiming.Read<TransportTiming>(rows);
                    var commits = args.TryGetProperty("commits", out var enabled) && enabled.GetBoolean();
                    var channels = commits ? WorkerRules.JobClaimChannels.Concat(WorkerRules.JobCommitChannels) : WorkerRules.JobClaimChannels;
                    var transport = new HttpTransport(Text(args, "baseUrl"), Text(args, "token"), channels, timing);
                    client = new XynologClient(transport, timing: clientTiming);
                    _ = ReportStatesAsync(transport);
                    _ = ReportErrorsAsync(transport);
                    break;
                case "close":
                    if (claims is not null) await claims.StopAsync().ConfigureAwait(false);
                    Dispose();
                    break;
                case "claim":
                    if (claims is not null) throw new InvalidOperationException("This worker already claims.");
                    var options = claimWaits.DeepClone().AsObject();
                    options.Add("accepts", JsonSerializer.SerializeToNode(Required<JobFilter[]>(args, "accepts")));
                    claims = (client ?? throw new InvalidOperationException("No client is open.")).Job.Claim(StatedTiming.Read<ClaimOptions>(options));
                    _ = ReportJobsAsync(claims);
                    _ = ReportRefusalsAsync(claims);
                    _ = ReportStallsAsync(claims);
                    break;
                case "vitals":
                    answer = (claims ?? throw new InvalidOperationException("No claims have started.")).Vitals();
                    break;
                case "subscribe-resource":
                    var active = client ?? throw new InvalidOperationException("No client is open.");
                    scopes.Add(active.Transport.SubscribeToResource(ResourceId.Parse(Text(args, "resource"))));
                    break;
                case "sync": break;
                default: await SayForJobAsync(args).ConfigureAwait(false); break;
            }
            WireDriver.Say(Lines.Ok(id, JsonSerializer.SerializeToElement(answer)));
        }
        catch (XynologError error) { WireDriver.Say(Lines.Failed(id, error)); }
        catch (Exception error) { WireDriver.Say(Lines.Misuse(id, error)); }
    }

    private async Task ReportJobsAsync(Claims worker)
    {
        while (await worker.NextAsync().ConfigureAwait(false) is { } job)
        {
            var previous = Activity.Current;
            var verb = JsonSerializer.SerializeToElement(job.JobType).GetString();
            var span = Activities.StartActivity("job:" + verb, ActivityKind.Internal, job.Trace,
                new ActivityTagsCollection { ["job.id"] = job.JobId.Value });
            Activity.Current = previous;
            var cancellation = job.Cancelled.Register(() => WireDriver.Say(Lines.Signalled(job.JobId)));
            lock (gate)
            {
                held?.Dispose();
                held = new Held(job, span, cancellation);
                WireDriver.Say(Lines.Claimed(job.Record));
            }
        }
    }

    private static async Task ReportRefusalsAsync(Claims worker)
    {
        await foreach (var refusal in worker.Refused().ConfigureAwait(false))
            WireDriver.Say(Lines.Refused(refusal));
    }

    private static async Task ReportStallsAsync(Claims worker)
    {
        await foreach (var stall in worker.Stalled().ConfigureAwait(false)) WireDriver.Say(Lines.Stalled(stall.JobId));
    }

    private static async Task ReportStatesAsync(HttpTransport transport)
    {
        await foreach (var state in transport.States().ConfigureAwait(false)) WireDriver.Say(Lines.State(state));
    }

    private static async Task ReportErrorsAsync(HttpTransport transport)
    {
        await foreach (var error in transport.Errors().ConfigureAwait(false))
            WireDriver.Say(Lines.ErrorStream(error));
    }

    private async Task SayForJobAsync(JsonElement args)
    {
        Held current;
        lock (gate) current = held ?? throw new InvalidOperationException("No job is held.");
        var job = current.Job;
        var previous = Activity.Current;
        Activity.Current = current.Span;
        try
        {
            switch (Text(args, "op"))
            {
                case "start": await job.StartAsync().ConfigureAwait(false); break;
                case "progress":
                    var message = args.TryGetProperty("message", out var progressMessage) ? progressMessage.Deserialize<JobProgressMessage>() : null;
                    await job.ProgressAsync(new JobProgress { Percentage = args.GetProperty("percentage").GetDouble(), Message = message }).ConfigureAwait(false);
                    break;
                case "checkpoint":
                    await job.CheckpointAsync(new JobCheckpoint
                    {
                        CompletedUnits = Required<string[]>(args, "completedUnits"),
                        UnitCursors = Optional<Dictionary<string, UnitCursor>>(args, "unitCursors"),
                    }).ConfigureAwait(false);
                    break;
                case "commit":
                    await job.CommitAsync(ResourceId.Parse(Text(args, "resourceId")), Required<Annotation[]>(args, "annotations")).ConfigureAwait(false);
                    break;
                case "complete":
                    if (job is HeldMarkJob mark) await mark.CompleteAsync(Required<MarkJobResult>(args, "result")).ConfigureAwait(false);
                    else if (job is HeldYieldJob yield) await yield.CompleteAsync(Required<YieldJobResult>(args, "result")).ConfigureAwait(false);
                    break;
                case "fail":
                    await job.FailAsync(Text(args, "error"), new JobFailure
                    {
                        FailureClass = args.TryGetProperty("failureClass", out var failureClass) ? failureClass.Deserialize<FailureClass>() : null,
                        CompletedUnits = Optional<string[]>(args, "completedUnits"),
                        UnitCursors = Optional<Dictionary<string, UnitCursor>>(args, "unitCursors"),
                    }).ConfigureAwait(false);
                    break;
                case "cancel":
                    await job.CancelAsync(new JobReached
                    {
                        CompletedUnits = Optional<string[]>(args, "completedUnits"),
                        UnitCursors = Optional<Dictionary<string, UnitCursor>>(args, "unitCursors"),
                    }).ConfigureAwait(false);
                    break;
                default: throw new InvalidOperationException("Unknown worker operation.");
            }
        }
        finally
        {
            Activity.Current = previous;
            if (job.Settled)
            {
                lock (gate)
                {
                    if (held == current)
                    {
                        current.Dispose();
                        held = null;
                    }
                }
            }
        }
    }

    // End of input kills the driver. Only an explicit close settles a held job.
    public void Dispose()
    {
        foreach (var scope in scopes) scope.Dispose();
        client?.Dispose();
        lock (gate)
        {
            held?.Dispose();
            held = null;
        }
    }

    private static string Text(JsonElement args, string name) => args.GetProperty(name).GetString() ?? throw new InvalidOperationException("Missing " + name);
    private static T Required<T>(JsonElement args, string name) where T : class =>
        args.GetProperty(name).Deserialize<T>() ?? throw new InvalidOperationException("Missing " + name);
    private static T? Optional<T>(JsonElement args, string name) where T : class =>
        args.TryGetProperty(name, out var value) ? value.Deserialize<T>() : null;

    private sealed record Held(IHeldJob Job, Activity? Span, CancellationTokenRegistration Cancellation) : IDisposable
    {
        public void Dispose()
        {
            Cancellation.Dispose();
            Span?.Dispose();
        }
    }
}
