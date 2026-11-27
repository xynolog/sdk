using Xynolog.Protocol;
using System.Diagnostics;
using System.Diagnostics.Metrics;
using Xynolog.Identifiers;
using Xynolog.Serialization;
using Xynolog.Types;

namespace Xynolog.Http;

internal static class SdkTelemetry
{
    private static readonly SdkTelemetryTelemetry Table = ProtocolTables.SdkTelemetryTelemetry;
    private static readonly ActivitySource Activities = new("xynolog");
    private static readonly Meter Meter = new("xynolog");
    private static readonly Dictionary<string, Counter<long>> Counters = Table.Metrics.ToDictionary(
        row => row.Name,
        row => row.Instrument == ServiceTelemetryTelemetryMetricsItemInstrument.Counter
            ? Meter.CreateCounter<long>(row.Name)
            : throw new InvalidOperationException("Unsupported metric instrument"));

    internal static Activity? Start(string name, ActivityTagsCollection attributes, string? channel = null, ActivityContext parent = default)
    {
        var row = Table.Spans.Single(row => row.Name == name);
        Validate(row.Attributes.ToDictionary(attribute => attribute.Key, attribute => attribute.Only is not null), attributes);
        var kind = Enum.Parse<ActivityKind>(WireEnumConverter<ServiceTelemetryTelemetrySpansItemKind>.Wire(row.Kind), ignoreCase: true);
        return Activities.StartActivity(name.Replace(TelemetrySpans.Channel, channel ?? "", StringComparison.Ordinal), kind, parent, attributes);
    }

    internal static ActivityTagsCollection BusTags(string channel, ResourceId? scope)
    {
        var tags = new ActivityTagsCollection { { TelemetryKeys.BusChannel, channel } };
        if (scope is ResourceId resource) tags.Add(TelemetryKeys.BusScope, resource.Value);
        return tags;
    }

    internal static void Sent(string channel, ResourceId? scope)
    {
        const string name = TelemetryMetrics.XynologBusSent;
        var tags = BusTags(channel, scope);
        Validate(Table.Metrics.Single(row => row.Name == name).Attributes.ToDictionary(attribute => attribute.Key, attribute => attribute.Only is not null), tags);
        Counters[name].Add(1, tags.ToArray());
    }

    /// <summary>Holds <paramref name="attributes"/> to the attributes a row states, each by its key and whether it is stated
    /// only in some case.</summary>
    private static void Validate(Dictionary<string, bool> stated, ActivityTagsCollection attributes)
    {
        foreach (var attribute in attributes)
        {
            if (!stated.ContainsKey(attribute.Key)) throw new InvalidOperationException("Unstated telemetry attribute " + attribute.Key);
        }
        foreach (var (key, only) in stated)
        {
            if (!only && !attributes.Any(tag => tag.Key == key)) throw new InvalidOperationException("Missing telemetry attribute " + key);
        }
    }
}
