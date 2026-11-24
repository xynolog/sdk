using System.Text.Json;
using Xynolog;
using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Identifiers;
using Xynolog.Types;

/// <summary>Each line the driver writes, as the suite reads it (ConformanceDriverLine).</summary>
internal static class Lines
{
    internal static ConformanceDriverLine Ready { get; } = new ConformanceDriverLine.ReadyCase(new() { Ready = true });

    internal static ConformanceDriverLine Ok(long id, JsonElement answer) =>
        new ConformanceDriverLine.OkCase(new() { Id = id, Ok = answer });

    internal static ConformanceDriverLine Failed(long id, Exception error) =>
        new ConformanceDriverLine.FailedCase(new() { Id = id, Error = Failure(error) });

    internal static ConformanceDriverLine Abandoned(long id) =>
        new ConformanceDriverLine.AbandonedCase(new() { Id = id, Abandoned = true });

    internal static ConformanceDriverLine Unsupported(long id) =>
        new ConformanceDriverLine.UnsupportedCase(new() { Id = id, Unsupported = true });

    internal static ConformanceDriverLine Misuse(long id, Exception error) =>
        new ConformanceDriverLine.MisuseCase(new() { Id = id, Misuse = error.Message });

    // ConnectionState names the suite's states but its initial one, which TransportTests holds.
    internal static ConformanceDriverLine State(ConnectionState state) =>
        new ConformanceDriverLine.StateCase(new()
        {
            State = JsonSerializer.SerializeToElement(Enum.Parse<ConformanceStepStateState>(state.ToString())).GetString()
                ?? throw new InvalidOperationException("A state is null"),
        });

    internal static ConformanceDriverLine Frame(BusFrame frame) =>
        new ConformanceDriverLine.FrameCase(new()
        {
            Frame = new() { Channel = frame.Channel, CorrelationId = frame.CorrelationId, Payload = frame.Payload, Scope = frame.Scope },
        });

    internal static ConformanceDriverLine ErrorStream(Exception error) =>
        new ConformanceDriverLine.ErrorStreamCase(new() { Error = Failure(error) });

    internal static ConformanceDriverLine Progress(long upload, long bytesUploaded, long totalBytes) =>
        new ConformanceDriverLine.ProgressCase(new() { Progress = new() { Upload = upload, BytesUploaded = bytesUploaded, TotalBytes = totalBytes } });

    internal static ConformanceDriverLine Pending(string observer) =>
        Emission(observer, new ConformanceDriverLineEmissionEmissionState.PendingCase(new()));

    internal static ConformanceDriverLine Value(string observer, JsonElement value) =>
        Emission(observer, new ConformanceDriverLineEmissionEmissionState.ReadyCase(new() { Value = value }));

    internal static ConformanceDriverLine Unread(string observer, Exception error) =>
        Emission(observer, new ConformanceDriverLineEmissionEmissionState.FailedCase(new() { Error = Failure(error) }));

    internal static ConformanceDriverLine Completed(string observer) =>
        new ConformanceDriverLine.CompletedCase(new() { Completed = observer });

    internal static ConformanceDriverLine Claimed(JsonElement job) =>
        new ConformanceDriverLine.ClaimedCase(new() { Claimed = job.EnumerateObject().ToDictionary(member => member.Name, member => member.Value.Clone()) });

    internal static ConformanceDriverLine Refused(ClaimRefusal refusal) =>
        new ConformanceDriverLine.RefusedCase(new() { Refused = new() { Code = refusal.Code, Detail = refusal.Detail } });

    internal static ConformanceDriverLine Signalled(JobId job) =>
        new ConformanceDriverLine.SignalledCase(new() { Signalled = job.Value });

    internal static ConformanceDriverLine Stalled(JobId job) =>
        new ConformanceDriverLine.StalledCase(new() { Stalled = job.Value });

    internal static ConformanceFailure Failure(Exception error) => new()
    {
        Code = (error as XynologError)?.Code,
        Status = (error as XynologError)?.Status,
        Detail = error.Message,
        FailureClass = (error as JobError)?.FailureClass,
    };

    private static ConformanceDriverLine Emission(string observer, ConformanceDriverLineEmissionEmissionState state) =>
        new ConformanceDriverLine.EmissionCase(new() { Emission = new() { Observer = observer, State = state } });
}
