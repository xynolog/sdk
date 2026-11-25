using System.Reflection;
using System.Text.Json;
using Xynolog.Serialization;
using Xynolog.Types;
using Xunit;

namespace Xynolog.Tests;

/// <summary>A union's value is read as the one member whose signature admits it, as Typing states each member's.</summary>
public sealed class UnionTests
{
    private static AnchoredTextAnswer Answer(string wire) =>
        JsonSerializer.Deserialize<AnchoredTextAnswer>(wire) ?? throw new InvalidOperationException("null");

    private static JsonElement Json(string wire) => JsonDocument.Parse(wire).RootElement;

    [Fact]
    public void EveryUnionStatesASignatureOfEachOfItsCases()
    {
        var unions = typeof(AnchoredTextAnswer).Assembly.GetTypes()
            .Where(type => type.Namespace == "Xynolog.Types" && type.GetCustomAttribute<WireUnionAttribute>(inherit: false) is not null)
            .ToArray();
        Assert.True(unions.Length > 10, unions.Length + " unions");
        foreach (var union in unions)
        {
            var members = union.GetField("Members", BindingFlags.NonPublic | BindingFlags.Static)?.GetValue(null) as Signature[][];
            Assert.NotNull(members);
            Assert.Equal(union.GetNestedTypes().Count(type => type.BaseType == union), members.Length);
            Assert.All(members, signatures => Assert.NotEmpty(signatures));
        }
    }

    [Fact]
    public void AUnionIsReadAsTheOneMemberThatAdmitsAValue()
    {
        Assert.IsType<AnchoredTextAnswer.AnchoredTextAbsent>(Answer("{\"kind\":\"no-map\"}"));
        Assert.IsType<AnchoredTextAnswer.ExtractionDeclined>(Answer("{\"kind\":\"declined\",\"declined\":\"encrypted\"}"));
        Assert.Contains("declined", Assert.Throws<JsonException>(() => Answer("{\"kind\":\"declined\"}")).Message);
        Assert.Equal(
            "a AnchoredTextAnswer states a `kind` that is one of `extracted`, `declined`, `not-yet`, `no-map`, `unknown`",
            Assert.Throws<JsonException>(() => Answer("{\"kind\":\"later\"}")).Message);
    }

    [Fact]
    public void AValueNoMemberNamesIsNoneOfThem()
    {
        Assert.Null(Signature.Member(Json("\"text\""), AnchoredTextAnswer.Members));
        Assert.Equal(
            "a JobStoredProgress that is none of its members",
            Assert.Throws<JsonException>(() => JsonSerializer.Deserialize<JobStoredProgress>("\"text\"")).Message);
    }

    [Fact]
    public void EachKindIsTheJsonItNames()
    {
        string[] values = ["\"a\"", "1", "1.5", "true", "[]", "{}", "null"];
        var admitted = new Dictionary<Kind, int[]>
        {
            [Kind.Text] = [0],
            [Kind.Integer] = [1],
            [Kind.Number] = [1, 2],
            [Kind.Boolean] = [3],
            [Kind.List] = [4],
            [Kind.Object] = [5],
            [Kind.Null] = [6],
            [Kind.Any] = [0, 1, 2, 3, 4, 5, 6],
        };
        Assert.Equal(Enum.GetValues<Kind>().Length, admitted.Count);
        foreach (var (kind, indices) in admitted)
        {
            var signature = new Signature(kind, [], null, [], null);
            Assert.Equal(indices, Enumerable.Range(0, values.Length).Where(at => signature.Names(Json(values[at]))).ToArray());
        }
    }

    [Fact]
    public void ALiteralIsTheOneValueItStates()
    {
        Assert.True(new Literal.Integer(3).Is(Json("3")));
        Assert.False(new Literal.Integer(3).Is(Json("\"3\"")));
        Assert.True(new Literal.Boolean(false).Is(Json("false")));
        Assert.False(new Literal.Boolean(false).Is(Json("true")));
        Assert.True(new Literal.Text("x").Is(Json("\"x\"")));
        Assert.Equal("`3`, `false`, `true`, `x`", string.Join(", ", new Literal[] { new Literal.Integer(3), new Literal.Boolean(false), new Literal.Boolean(true), new Literal.Text("x") }));
    }

    [Fact]
    public void AMemberThatOnlyNamesAValueIsFoundAsNamed()
    {
        Signature[][] members =
        [
            [new(Kind.Object, ["kind", "a"], null, [new("kind", [new Literal.Text("open")])], null)],
            [new(Kind.Object, ["kind", "b"], ["kind", "b"], [new("kind", [new Literal.Text("shut")])], null)],
        ];
        Assert.Equal<(int, bool)?>((1, true), Signature.Member(Json("{\"kind\":\"shut\",\"b\":1}"), members));
        Assert.Equal<(int, bool)?>((1, false), Signature.Member(Json("{\"kind\":\"shut\",\"b\":1,\"c\":2}"), members));
        Assert.Equal<(int, bool)?>((1, false), Signature.Member(Json("{\"kind\":\"shut\"}"), members));
        Assert.Null(Signature.Member(Json("{\"kind\":\"other\"}"), members));
        Assert.Equal("a Closed states a `kind` that is one of `open`, `shut`", Signature.NoneOf("Closed", members));
    }
}
