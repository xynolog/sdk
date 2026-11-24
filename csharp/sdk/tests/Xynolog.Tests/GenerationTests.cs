using System.Reflection;
using System.Text.Json;
using Xunit;

namespace Xynolog.Tests;

public sealed class GenerationTests
{
    [Fact]
    public void EveryIdentifierKindRunsItsSharedCases()
    {
        var assembly = Assembly.Load("Xynolog");
        using var document = JsonDocument.Parse(File.ReadAllText(Path.Combine(AppContext.BaseDirectory, "specs/identifiers/kinds.json")));
        foreach (var kind in document.RootElement.GetProperty("kinds").EnumerateArray())
        {
            var name = kind.GetProperty("schema").GetString() ?? throw new InvalidOperationException("An identifier kind has no name.");
            var type = assembly.GetType("Xynolog.Identifiers." + name);
            Assert.NotNull(type);
            var parse = type.GetMethod("Parse", [typeof(string)]);
            Assert.NotNull(parse);
            var keyed = typeof(Dictionary<,>).MakeGenericType(type, typeof(string));
            foreach (var accepted in kind.GetProperty("accepts").EnumerateArray())
            {
                var text = accepted.GetProperty("id").GetString();
                var value = parse.Invoke(null, [text]);
                Assert.Equal(text, value?.ToString());
                Assert.Equal(JsonSerializer.Serialize(text), JsonSerializer.Serialize(value, type));
                Assert.Equal(value, JsonSerializer.Deserialize(JsonSerializer.Serialize(text), type));
                var map = "{" + JsonSerializer.Serialize(text) + ":\"x\"}";
                Assert.Equal(map, JsonSerializer.Serialize(JsonSerializer.Deserialize(map, keyed), keyed));
            }
            foreach (var refused in kind.GetProperty("refuses").EnumerateArray())
            {
                var text = refused.GetProperty("id").GetString();
                var error = Assert.Throws<TargetInvocationException>(() => parse.Invoke(null, [text]));
                Assert.IsType<FormatException>(error.InnerException);
                Assert.Throws<JsonException>(() => JsonSerializer.Deserialize(JsonSerializer.Serialize(text), type));
                Assert.Throws<JsonException>(() => JsonSerializer.Deserialize("{" + JsonSerializer.Serialize(text) + ":\"x\"}", keyed));
            }
        }
    }

    [Fact]
    public void AGeneratedCommandRoundTripsAndKeepsTypedIds()
    {
        var type = Assembly.Load("Xynolog").GetType("Xynolog.Types.MarkDeleteCommand");
        Assert.NotNull(type);
        Assert.Equal("Xynolog.Identifiers.ResourceId", Nullable.GetUnderlyingType(type.GetProperty("ResourceId")?.PropertyType ?? throw new InvalidOperationException())?.FullName);
        const string source = "{\"annotationId\":\"a-1\",\"resourceId\":\"res-1\"}";
        var value = JsonSerializer.Deserialize(source, type);
        Assert.True(System.Text.Json.Nodes.JsonNode.DeepEquals(
            System.Text.Json.Nodes.JsonNode.Parse(source), JsonSerializer.SerializeToNode(value, type)));
        var error = Assert.Throws<JsonException>(() => JsonSerializer.Deserialize("{\"resourceId\":\"res-1\"}", type));
        Assert.Contains("annotationId", error.Message);
    }

    [Theory]
    [InlineData("{\"annotations\":[],\"total\":0}")]
    [InlineData("{\"annotations\":[],\"total\":0,\"motivation\":null}")]
    [InlineData("{\"annotations\":[],\"total\":0,\"motivation\":\"highlighting\"}")]
    public void AnOptionalNullableMemberKeepsAllThreeStates(string source)
    {
        var type = Assembly.Load("Xynolog").GetType("Xynolog.Types.GetAnnotationsResponse");
        Assert.NotNull(type);
        var value = JsonSerializer.Deserialize(source, type);
        Assert.True(System.Text.Json.Nodes.JsonNode.DeepEquals(
            System.Text.Json.Nodes.JsonNode.Parse(source), JsonSerializer.SerializeToNode(value, type)));
    }

    [Fact]
    public void EveryRootSchemaHasItsExpectedPublicType()
    {
        var assembly = Assembly.Load("Xynolog");
        foreach (var path in Directory.GetFiles(Path.Combine(AppContext.BaseDirectory, "specs/components/schemas"), "*.json"))
        {
            using var document = JsonDocument.Parse(File.ReadAllText(path));
            var schema = document.RootElement;
            var name = Path.GetFileNameWithoutExtension(path);
            var plainString = schema.TryGetProperty("type", out var type) && type.GetString() == "string" && !schema.TryGetProperty("enum", out _);
            var identifier = assembly.GetType("Xynolog.Identifiers." + name);
            if (!plainString || identifier is not null)
            {
                Assert.NotNull(identifier ?? assembly.GetType("Xynolog.Types." + name));
            }
        }
    }
}
