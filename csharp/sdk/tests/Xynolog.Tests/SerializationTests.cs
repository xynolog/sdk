using System.Reflection;
using System.Text.Json;
using System.Text.Json.Nodes;
using Xynolog.Identifiers;
using Xunit;

namespace Xynolog.Tests;

public sealed class SerializationTests
{
    [Theory]
    [InlineData("AgentSoftware", "{\"@type\":\"Software\",\"parameters\":{\"nested\":[1,null,true,{\"x\":\"y\"}]},\"extension\":{\"value\":null}}")]
    [InlineData("Representation", "{\"mediaType\":\"text/plain\",\"storageUri\":\"s3://bucket/a%2Fb\",\"extension\":[null,3]}")]
    [InlineData("JobStoredResult", "{}")]
    [InlineData("CommandError", "{\"message\":\"no\",\"code\":\"not-found\"}")]
    public void OpenTreesAndWireSpellingRoundTrip(string schema, string source)
    {
        var type = Model(schema);
        var value = JsonSerializer.Deserialize(source, type);
        Assert.True(JsonNode.DeepEquals(JsonNode.Parse(source), JsonSerializer.SerializeToNode(value, type)));
    }

    [Theory]
    [InlineData("JobStoredResultEmpty", "{\"unexpected\":1}", "maxProperties")]
    [InlineData("CommandError", "{}", "message")]
    [InlineData("CommandError", "{\"message\":null}", "message")]
    [InlineData("CommandError", "{\"message\":3}", "message")]
    [InlineData("CommandError", "{\"message\":\"no\",\"code\":null}", "code")]
    [InlineData("CommandError", "{\"message\":\"no\",\"code\":\"unknown\"}", "code")]
    [InlineData("AgentSoftware", "{\"@type\":\"Person\"}", "@type")]
    [InlineData("BrowseResourceResult", "{\"response\":{\"lastSequence\":1}}", "resource")]
    [InlineData("GetAnnotationsResponse", "{\"annotations\":[{}],\"total\":1}", "annotations[0]")]
    public void MalformedMembersReportTheirPath(string schema, string source, string member)
    {
        var error = Assert.Throws<JsonException>(() => JsonSerializer.Deserialize(source, Model(schema)));
        Assert.Contains(member, error.Message);
    }

    [Fact]
    public void DefaultIdentifiersCannotBeReadOrWritten()
    {
        Assert.Throws<InvalidOperationException>(() => default(ResourceId).Value);
        Assert.Throws<InvalidOperationException>(() => default(ResourceId).ToString());
        Assert.Throws<JsonException>(() => JsonSerializer.Serialize(default(ResourceId)));
        Assert.False(ResourceId.TryParse(null, out var refused));
        Assert.Equal(default, refused);
        Assert.Throws<JsonException>(() => JsonSerializer.Deserialize<ResourceId>("42"));
        Assert.Throws<JsonException>(() => JsonSerializer.Deserialize<ResourceId>("null"));
        Assert.DoesNotContain(typeof(ResourceId).GetConstructors(), constructor => constructor.GetParameters().Length > 0);
    }

    private static Type Model(string name) => Assembly.Load("Xynolog").GetType("Xynolog.Types." + name)
        ?? throw new InvalidOperationException("Missing generated model " + name);
}
