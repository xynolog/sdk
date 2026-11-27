using System.Reflection;
using System.Text.Json;
using Xunit;
using Xynolog.State;

namespace Xynolog.Tests;

// SearchState, JobEvent and CacheState, generic and written by hand, held to their schemas in
// protocol/specs/src/client/types: a member or a branch either side gains or loses fails.
public sealed partial class TransportTests
{
    private static string[] Members(Type type) =>
        type.GetProperties(BindingFlags.Public | BindingFlags.Instance | BindingFlags.DeclaredOnly)
            .Select(property => JsonNamingPolicy.CamelCase.ConvertName(property.Name)).Order().ToArray();

    private static string[] Properties(JsonElement schema) =>
        schema.GetProperty("properties").EnumerateObject().Select(property => property.Name).Order().ToArray();

    [Fact]
    public void SearchStateHasTheSchemasMembers()
    {
        using var schema = ReadSpec("client/types/SearchState.json");
        Assert.Equal(Properties(schema.RootElement), Members(typeof(SearchState<>)));
    }

    private static Dictionary<string, JsonElement> Branches(JsonDocument schema, string tag) =>
        schema.RootElement.GetProperty("oneOf").EnumerateArray().ToDictionary(
            branch => branch.GetProperty("properties").GetProperty(tag).GetProperty("enum")[0].GetString()
                ?? throw new InvalidOperationException($"A branch's {tag} is no string."));

    private static Dictionary<string, Type> Cases(Type union) =>
        union.GetNestedTypes().ToDictionary(type => JsonNamingPolicy.CamelCase.ConvertName(type.Name));

    [Fact]
    public void JobEventHasTheSchemasBranchesEachOfOneDatum()
    {
        using var schema = ReadSpec("client/types/JobEvent.json");
        var branches = Branches(schema, "kind");
        var cases = Cases(typeof(JobEvent<>));
        Assert.Equal(branches.Keys.Order(), cases.Keys.Order());
        foreach (var (kind, branch) in branches)
        {
            Assert.Equal(["data", "kind"], Properties(branch));
            var data = branch.GetProperty("properties").GetProperty("data");
            if (kind == "refused") Assert.Equal(Properties(data), Members(cases[kind]));
            else Assert.Equal(["value"], Members(cases[kind]));
        }
    }

    [Fact]
    public void CacheStateHasTheSchemasBranchesEachOfItsMembers()
    {
        using var schema = ReadSpec("client/types/CacheState.json");
        var branches = Branches(schema, "status");
        var cases = Cases(typeof(CacheState<>));
        Assert.Equal(branches.Keys.Order(), cases.Keys.Order());
        foreach (var (status, branch) in branches)
            Assert.Equal(Properties(branch).Where(member => member != "status"), Members(cases[status]));
    }
}
