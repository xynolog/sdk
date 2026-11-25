using System.Reflection;
using System.Text.Json;
using Xynolog.Serialization;
using Xynolog.Types;
using Xunit;

namespace Xynolog.Tests;

/// <summary>A member of one value is a type of its own: an enumeration of one constant, or a record of one <c>Value</c>.</summary>
public sealed class ConstantTests
{
    private static readonly Type[] Models = typeof(ConformanceDriverLineReady).Assembly.GetTypes()
        .Where(type => type.Namespace == "Xynolog.Types")
        .ToArray();

    [Fact]
    public void EveryMemberOfOneValueIsATypeOfItsOwn()
    {
        var constants = Models
            .Where(type => type.GetCustomAttribute<WireObjectAttribute>() is not null)
            .SelectMany(type => type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
            .Where(property => property.GetCustomAttribute<WireAttribute>() is not null && !property.CanWrite)
            .ToArray();
        Assert.True(constants.Length > 50, constants.Length + " constant members");
        Assert.All(constants, property => Assert.True(
            property.PropertyType.GetCustomAttribute<WireEnumAttribute>() is not null
            || property.PropertyType.GetCustomAttribute<WireConstantAttribute>() is not null,
            property.DeclaringType?.Name + "." + property.Name + " is a " + property.PropertyType.Name));
    }

    [Fact]
    public void AConstantIsReadFromItsValueAloneAndWrittenAsIt()
    {
        var constants = Models.Where(type => type.GetCustomAttribute<WireConstantAttribute>() is not null).ToArray();
        Assert.True(constants.Length > 5, constants.Length + " constants");
        foreach (var constant in constants)
        {
            var value = constant.GetField("Value", BindingFlags.Public | BindingFlags.Static)?.GetValue(null);
            Assert.NotNull(value);
            var wire = JsonSerializer.SerializeToElement(value, constant);
            Assert.Same(value, JsonSerializer.Deserialize(wire, constant));
            var other = wire.ValueKind switch
            {
                JsonValueKind.True => "false",
                JsonValueKind.False => "true",
                _ => (wire.GetInt64() + 1).ToString(System.Globalization.CultureInfo.InvariantCulture),
            };
            Assert.Equal(
                "a " + constant.Name + " is " + wire.GetRawText(),
                Assert.Throws<JsonException>(() => JsonSerializer.Deserialize(other, constant)).Message);
        }
    }

    [Fact]
    public void AModelWritesItsConstantsAndReadsNoOtherValue()
    {
        Assert.Equal("{\"ready\":true}", JsonSerializer.Serialize(new ConformanceDriverLineReady()));
        Assert.Throws<JsonException>(() => JsonSerializer.Deserialize<ConformanceDriverLineReady>("{\"ready\":false}"));
        Assert.Equal(ExtractionDeclinedKind.Declined, new ExtractionDeclined { Declined = ExtractionDeclinedReason.Encrypted }.Kind);
        Assert.Equal("bus-event", WireEnumConverter<BusEventMessageEvent>.Wire(BusEventMessageEvent.BusEvent));
    }
}
