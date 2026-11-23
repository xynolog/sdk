namespace Xynolog.Testing;

/// <summary>Outputs finish on a value or refusal. Settlements finish when awaited paths return or fail. Disposing it
/// disposes <see cref="End"/>, what ends the composition.</summary>
public sealed partial record LivenessScenario : IDisposable
{
    /// <summary>What ends the composition the scenario runs.</summary>
    public IDisposable? End { get; init; }

    /// <summary>Disposes <see cref="End"/>.</summary>
    public void Dispose() => End?.Dispose();
}

/// <summary>A spec's cases wait on <see cref="TimeProvider"/>, and its <see cref="LivenessSpec.Cases"/> schedules
/// are drawn from <see cref="Random"/>, each the system's or a fixed seed's when it gives none.</summary>
public sealed partial record LivenessSpec
{
    /// <summary>The clock the spec's cases wait on; the system's when null.</summary>
    public TimeProvider? TimeProvider { get; init; }
    /// <summary>What the spec's schedules are drawn from; a fixed seed's when null.</summary>
    public Random? Random { get; init; }
}

/// <summary>A connection model or real connection whose transitions can interleave with writes.</summary>
public interface DeliverySubject : IDisposable
{
    /// <summary>Writes an event with the id <paramref name="eventId"/>.</summary>
    public void Write(string eventId);
    /// <summary>Moves the connection through a transition, such as a reconnect or a handoff.</summary>
    public void Transition();
    /// <summary>The ids of the events delivered, each as often as it was delivered.</summary>
    public Task<IReadOnlyList<string>> DeliveredAsync(CancellationToken cancellation = default);
}

/// <summary>Checks a composition under drawn fault schedules: that its outputs speak and its awaited paths settle (L1,
/// L2), and that each write is delivered once (L3).</summary>
public static class Liveness
{
    /// <summary>The seed a spec's schedules are drawn from when it gives no Random, so a drawn run is the same run each
    /// time.</summary>
    private const int DrawnSeed = 7;

    /// <summary>Draws one of the protocol's faults, a delay's length drawn within its bounds.</summary>
    public static FaultAction FaultActions(Random random) => TestingKit.Faults[random.Next(TestingKit.Faults.Count)] switch
    {
        FaultAction.Delay => new FaultAction.Delay(
            TimeSpan.FromMilliseconds(random.Next(TestingKit.DelayMsMinimum, TestingKit.DelayMsMaximum + 1))),
        var fault => fault,
    };

    /// <summary>Draws <paramref name="count"/> fault schedules, each of a drawn length.</summary>
    public static IReadOnlyList<IReadOnlyList<FaultAction>> FaultSchedules(int count, Random random) =>
        Enumerable.Range(0, count).Select(_ => (IReadOnlyList<FaultAction>)Enumerable
            .Range(0, random.Next(TestingKit.ScheduleLengthMinimum, TestingKit.ScheduleLengthMaximum + 1))
            .Select(_ => FaultActions(random)).ToArray()).ToArray();

    /// <summary>Checks that awaited paths settle (L2) and every output says something (L1) within the derived bound.</summary>
    public static async Task AssertLivenessAxiomsAsync(LivenessSpec spec, CancellationToken cancellation = default)
    {
        ArgumentOutOfRangeException.ThrowIfLessThanOrEqual(spec.Timeout, TimeSpan.Zero);
        ArgumentOutOfRangeException.ThrowIfNegative(spec.RetryBudget);
        var clock = spec.TimeProvider ?? TimeProvider.System;
        var schedules = spec.Schedules.Count > 0 ? spec.Schedules
            : FaultSchedules(spec.Cases, spec.Random ?? new Random(DrawnSeed));
        foreach (var schedule in schedules)
        {
            cancellation.ThrowIfCancellationRequested();
            var delays = schedule.OfType<FaultAction.Delay>().Sum(action => action.Duration.Ticks);
            var bound = TimeSpan.FromTicks(checked((spec.Timeout.Ticks * (1L + spec.RetryBudget) + delays) * TestingKit.Slack));
            using var transport = new FaultyTransport(schedule, spec.MakeResponse, clock);
            using var scenario = spec.Setup(transport);
            await Task.Delay(bound, clock, cancellation).ConfigureAwait(Spawning.Captures);
            var under = $"under [{string.Join(", ", schedule)}] within {bound.TotalMilliseconds}ms";
            var outputs = scenario.Outputs.Select(Observe).ToArray();
            var settlements = scenario.Settlements.Select(Observe).ToArray();
            var unsettled = Array.IndexOf(settlements, false);
            if (unsettled >= 0) throw new InvalidOperationException($"L2: settlement #{unsettled} remained pending {under}.");

            foreach (var requests in transport.RequestLog.Where(entry => entry.CorrelationId is not null)
                         .GroupBy(entry => entry.RetryKey))
            {
                var count = requests.Count();
                if (count > 1L + spec.RetryBudget)
                    throw new InvalidOperationException($"L2: '{requests.First().Channel}' exceeded its retry budget with {count} sends {under}.");
                if (requests.Last().Action is FaultAction.DropReply or FaultAction.RejectEmit &&
                    count <= spec.RetryBudget && outputs.Length > 0 && !outputs.Contains(true))
                    throw new InvalidOperationException($"L2: '{requests.First().Channel}' swallowed a failure {under}.");
            }

            var silent = Array.IndexOf(outputs, false);
            if (silent >= 0) throw new InvalidOperationException($"L1: output #{silent} said nothing {under}.");
        }
    }

    /// <summary>Draws <paramref name="count"/> interleavings of writes and transitions, each of at most
    /// <paramref name="longest"/> steps and at least one write.</summary>
    public static IReadOnlyList<IReadOnlyList<DeliveryOp>> DeliveryOps(int count, int longest, Random random)
    {
        ArgumentOutOfRangeException.ThrowIfNegativeOrZero(longest);
        return Enumerable.Range(0, count).Select(_ =>
        {
            var steps = Enumerable.Range(0, 1 + random.Next(longest))
                .Select(_ => Enum.GetValues<DeliveryOp>()[random.Next(Enum.GetValues<DeliveryOp>().Length)]).ToArray();
            if (!steps.Contains(DeliveryOp.Write)) steps[random.Next(steps.Length)] = DeliveryOp.Write;
            return (IReadOnlyList<DeliveryOp>)steps;
        }).ToArray();
    }

    /// <summary>Checks that every write is delivered exactly once across transitions (L3).</summary>
    public static async Task AssertExactlyOnceDeliveryAsync(Func<DeliverySubject> setup,
        IReadOnlyList<IReadOnlyList<DeliveryOp>> interleavings, CancellationToken cancellation = default)
    {
        foreach (var steps in interleavings)
        {
            cancellation.ThrowIfCancellationRequested();
            using var subject = setup();
            var written = new List<string>();
            for (var step = 0; step < steps.Count; step++)
            {
                switch (steps[step])
                {
                    case DeliveryOp.Write:
                        var id = $"e{step}";
                        subject.Write(id);
                        written.Add(id);
                        break;
                    case DeliveryOp.Transition:
                        subject.Transition();
                        break;
                    default:
                        throw new ArgumentOutOfRangeException(nameof(interleavings), steps[step], "Unknown delivery operation");
                }
            }
            var counts = (await subject.DeliveredAsync(cancellation).ConfigureAwait(Spawning.Captures)).CountBy(id => id)
                .ToDictionary(entry => entry.Key, entry => entry.Value);
            foreach (var id in written)
                if (counts.GetValueOrDefault(id) is var times && times != 1)
                    throw new InvalidOperationException($"L3: event '{id}' was delivered {times} times under [{string.Join(", ", steps)}].");
        }
    }

    private static bool Observe(Task path)
    {
        if (!path.IsCompleted) return false;
        _ = path.Exception;
        return true;
    }
}
