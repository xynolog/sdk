using System.Text.Json;
using Xynolog;
using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Identifiers;
using Xynolog.Types;

/// <summary>Each line the driver writes, as the suite reads it (ConformanceDriverLine).</summary>
internal static class Lines
{
    internal static ConformanceDriverLine Ready { get; } = new ConformanceDriverLine.Ready(new());

    internal static ConformanceDriverLine Ok(long id, JsonElement answer) =>
        new ConformanceDriverLine.Ok(new() { Id = id, Ok = answer });

    internal static ConformanceDriverLine Failed(long id, Exception error) =>
        new ConformanceDriverLine.Failed(new() { Id = id, Error = Failure(error) });

    internal static ConformanceDriverLine Abandoned(long id) =>
        new ConformanceDriverLine.Abandoned(new() { Id = id });

    internal static ConformanceDriverLine Unsupported(long id) =>
        new ConformanceDriverLine.Unsupported(new() { Id = id });

    internal static ConformanceDriverLine Misuse(long id, Exception error) =>
        new ConformanceDriverLine.Misuse(new() { Id = id, Misuse = error.Message });

    // ConnectionState names the suite's states but its initial one, which TransportTests holds.
    internal static ConformanceDriverLine State(ConnectionState state) =>
        new ConformanceDriverLine.State(new()
        {
            State = JsonSerializer.SerializeToElement(Enum.Parse<ConformanceStepStateState>(state.ToString())).GetString()
                ?? throw new InvalidOperationException("A state is null"),
        });

    internal static ConformanceDriverLine Frame(BusFrame frame) =>
        new ConformanceDriverLine.Frame(new()
        {
            Frame = new() { Channel = frame.Channel, CorrelationId = frame.CorrelationId, Payload = frame.Payload, Scope = frame.Scope },
        });

    internal static ConformanceDriverLine ErrorStream(Exception error) =>
        new ConformanceDriverLine.ErrorStream(new() { Error = Failure(error) });

    internal static ConformanceDriverLine Progress(long upload, long bytesUploaded, long totalBytes) =>
        new ConformanceDriverLine.Progress(new() { Progress = new() { Upload = upload, BytesUploaded = bytesUploaded, TotalBytes = totalBytes } });

    internal static ConformanceDriverLine Pending(string observer) =>
        Emission(observer, new ConformanceDriverLineEmissionEmissionState.Pending(new()));

    internal static ConformanceDriverLine Value(string observer, JsonElement value) =>
        Emission(observer, new ConformanceDriverLineEmissionEmissionState.Ready(new() { Value = value }));

    internal static ConformanceDriverLine Unread(string observer, Exception error) =>
        Emission(observer, new ConformanceDriverLineEmissionEmissionState.Failed(new() { Error = Failure(error) }));

    internal static ConformanceDriverLine Completed(string observer) =>
        new ConformanceDriverLine.Completed(new() { Completed = observer });

    internal static ConformanceDriverLine Claimed(JsonElement job) =>
        new ConformanceDriverLine.Claimed(new() { Claimed = job.EnumerateObject().ToDictionary(member => member.Name, member => member.Value.Clone()) });

    internal static ConformanceDriverLine Refused(ClaimRefusal refusal) =>
        new ConformanceDriverLine.Refused(new() { Refused = new() { Code = refusal.Code, Detail = refusal.Detail } });

    internal static ConformanceDriverLine Signalled(JobId job) =>
        new ConformanceDriverLine.Signalled(new() { Signalled = job.Value });

    internal static ConformanceDriverLine Stalled(JobId job) =>
        new ConformanceDriverLine.Stalled(new() { Stalled = job.Value });

    internal static ConformanceFailure Failure(Exception error) => new()
    {
        Code = (error as XynologError)?.Code,
        Status = (error as XynologError)?.Status,
        Detail = error.Message,
        FailureClass = (error as JobError)?.FailureClass,
    };

    private static ConformanceDriverLine Emission(string observer, ConformanceDriverLineEmissionEmissionState state) =>
        new ConformanceDriverLine.Emission(new() { Emission = new() { Observer = observer, State = state } });
}
