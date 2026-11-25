using System.Reflection;
using System.Text.Json;
using Xynolog.Serialization;
using Xynolog.Types;
using Xunit;

namespace Xynolog.Tests;

/// <summary>A model's members are declared, and written, in its schema's order.</summary>
public sealed class MemberOrderTests
{
    [Fact]
    public void EveryModelDeclaresTheMembersItsSchemaStatesInTheirOrder()
    {
        var models = typeof(HttpEndpoint).Assembly.GetTypes()
            .Where(type => type.Namespace == "Xynolog.Types" && type.GetCustomAttribute<WireObjectAttribute>() is not null)
            .Select(type => (Type: type, Schema: WireJson.Definition(type.Name)))
            .Where(model => model.Schema.TryGetProperty("properties", out _))
            .ToArray();
        Assert.True(models.Length > 100, models.Length + " models");
        Assert.All(models, model =>
        {
            var declared = model.Type.GetProperties(BindingFlags.Public | BindingFlags.Instance)
                .OrderBy(property => property.MetadataToken)
                .Select(property => property.GetCustomAttribute<WireAttribute>()?.Name)
                .OfType<string>()
                .ToArray();
            var stated = model.Schema.GetProperty("properties").EnumerateObject().Select(member => member.Name).ToArray();
            Assert.Equal(stated.Where(declared.Contains), declared.Where(stated.Contains));
        });
    }

    [Fact]
    public void AModelIsWrittenInItsSchemasOrder()
    {
        const string wire = "{\"kind\":\"http\",\"host\":\"kb.example\",\"port\":443,\"protocol\":\"https\"}";
        Assert.Equal(wire, JsonSerializer.Serialize(JsonSerializer.Deserialize<HttpEndpoint>(wire)));
    }
}
