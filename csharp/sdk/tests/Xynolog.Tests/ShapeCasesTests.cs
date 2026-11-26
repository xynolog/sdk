using System.Text.Json;
using Xynolog.Serialization;
using Xynolog.Types;
using Xunit;
using static Xynolog.Serialization.Required;

namespace Xynolog.Tests;

// protocol/specs/src/client/shape-cases.json: the table every SDK's reading of a value runs. Each case's value is held to
// the schema it names, and its first fault is the one the case states, or none.
public sealed partial class TransportTests
{
    [Fact]
    public void ShapesRunTheSharedCases()
    {
        using var table = ReadSpec("client/shape-cases.json");
        var cases = table.RootElement.GetProperty("cases").EnumerateArray().ToArray();
        Assert.NotEmpty(cases);
        foreach (var row in cases)
        {
            var why = Text(row, "why");
            var schema = Text(row, "schema");
            var value = row.GetProperty("value");
            var expected = row.TryGetProperty("refused", out var refused) && refused.GetBoolean()
                ? At(Text(row, "member"), row.GetProperty("reason").Deserialize<FrameRefusalReason>())
                : null;
            var fault = FaultOf(schema, value, out _);
            Assert.True(fault == expected, why + ": " + value.GetRawText() + " as " + schema + " has the fault " + fault?.Said() + ", not " + expected?.Said());
        }
    }
}
