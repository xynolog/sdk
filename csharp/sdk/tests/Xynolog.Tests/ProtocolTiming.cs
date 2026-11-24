using System.Text.Json;
using Xynolog.Protocol;

namespace Xynolog.Tests;

/// <summary>An entry of protocol/specs/src/client/timing.json by its name, for a case that names the entry it waits
/// on.</summary>
internal static class ProtocolTiming
{
    private static readonly JsonDocument Table = JsonDocument.Parse(ProtocolTables.Timing);

    internal static JsonElement Of(string name) => Table.RootElement.GetProperty("timing").EnumerateArray()
        .Single(row => row.GetProperty("name").GetString() == name).GetProperty("value");
}
