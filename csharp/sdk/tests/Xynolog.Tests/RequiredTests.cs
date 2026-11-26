using System.Text.Json;
using Xynolog.Serialization;
using Xynolog.Types;
using Xunit;
using static Xynolog.Serialization.Required;

namespace Xynolog.Tests;

// The walk of the table of what each schema requires, held to shapes written as codegen/lib/required/shape.ml writes
// them: each part, and the order the walk finds faults in.
public sealed class RequiredTests
{
    private const string Letter = """{"of":[[97,122]],"min":1,"max":1}""";
    private const string Anything = """{"of":[[0,1114111]],"min":0}""";
    private const string Lower = """{"kinds":["string"],"pattern":[{"of":[[97,122]],"min":1}]}""";

    // A pattern's group is one of its alternatives, repeated as often as it says; a text is of the pattern when some
    // reading of it takes all of it.
    [Fact]
    public void APatternsGroupIsOneOfItsAlternatives()
    {
        const string get = """[{"of":[[71,71]],"min":1,"max":1},{"of":[[69,69]],"min":1,"max":1},{"of":[[84,84]],"min":1,"max":1}]""";
        const string post = """[{"of":[[80,80]],"min":1,"max":1},{"of":[[79,79]],"min":1,"max":1},{"of":[[83,83]],"min":1,"max":1},{"of":[[84,84]],"min":1,"max":1}]""";
        var method = """{"kinds":["string"],"pattern":[{"either":[""" + get + "," + post
            + """],"min":1,"max":1},{"of":[[32,32]],"min":1,"max":1},{"of":[[47,47]],"min":1,"max":1},""" + Anything + "]}";
        FaultsAs(method, "\"GET /\"", null);
        FaultsAs(method, "\"POST /kb/x\"", null);
        FaultsAs(method, "\"PUT /\"", Malformed(""));
        FaultsAs(method, "\"GET\"", Malformed(""));

        const string kebab = """{"kinds":["string"],"pattern":[{"of":[[97,122]],"min":1},{"either":[[{"of":[[45,45]],"min":1,"max":1},{"of":[[97,122]],"min":1}]],"min":0}]}""";
        FaultsAs(kebab, "\"a\"", null);
        FaultsAs(kebab, "\"one-two-three\"", null);
        FaultsAs(kebab, "\"one--two\"", Malformed(""));
        FaultsAs(kebab, "\"one-\"", Malformed(""));

        var twoOrThreeLetters = """{"kinds":["string"],"pattern":[{"either":[[""" + Letter + """]],"min":2,"max":3}]}""";
        FaultsAs(twoOrThreeLetters, "\"ab\"", null);
        FaultsAs(twoOrThreeLetters, "\"abc\"", null);
        FaultsAs(twoOrThreeLetters, "\"a\"", Malformed(""));
        FaultsAs(twoOrThreeLetters, "\"abcd\"", Malformed(""));
    }

    // A pattern's end the schema does not anchor is a step of any code points: the text goes on as it will.
    [Fact]
    public void AnEndThePatternDoesNotAnchorTakesAnyText()
    {
        var prefixed = """{"kinds":["string"],"pattern":[{"of":[[47,47]],"min":1,"max":1},""" + Anything + "]}";
        FaultsAs(prefixed, "\"/\"", null);
        FaultsAs(prefixed, "\"/kb/é\"", null);
        FaultsAs(prefixed, "\"kb/\"", Malformed(""));
    }

    // A term the table writes is a step or a group, never both, and states no part the walk does not read.
    [Fact]
    public void ATermOfNoKnownFormIsRefused()
    {
        Assert.Throws<InvalidOperationException>(() => FaultAs("""{"pattern":[{"of":[[97,97]],"either":[],"min":1}]}""", Value("\"a\"")));
        Assert.Throws<InvalidOperationException>(() => FaultAs("""{"pattern":[{"of":[[97,97]],"min":1,"times":2}]}""", Value("\"a\"")));
    }

    // An object carries no set of notAll whole, a member that holds null being carried; carries at least minMembers
    // members; and names each of its members as names says.
    [Fact]
    public void AnObjectsMembersAreHeldTogether()
    {
        const string either = """{"kinds":["object"],"notAll":[["port","external"]]}""";
        FaultsAs(either, """{"port":1}""", null);
        FaultsAs(either, """{"external":"x"}""", null);
        FaultsAs(either, """{"port":1,"external":"x"}""", Malformed(""));
        FaultsAs(either, """{"port":1,"external":null}""", Malformed(""));

        const string some = """{"kinds":["object"],"minMembers":1}""";
        FaultsAs(some, """{"a":1}""", null);
        FaultsAs(some, "{}", Malformed(""));

        const string lower = """{"kinds":["object"],"names":""" + Lower + "}";
        FaultsAs(lower, """{"ab":1,"cd":2}""", null);
        FaultsAs(lower, """{"ab":1,"Cd":2,"X":3}""", Malformed("Cd"));
        FaultsAs("""{"kinds":["object"],"members":{"within":""" + lower + "}}", """{"within":{"Ab":1}}""", Malformed("within.Ab"));
    }

    // Of an object, what it requires comes before its members' names, and its names before the sets it may not carry
    // all of; its bounds come before them all.
    [Fact]
    public void AnObjectsFaultsAreFoundInTheirOrder()
    {
        const string ordered = """{"kinds":["object"],"required":["a"],"names":""" + Lower + ""","notAll":[["a","b"]]}""";
        FaultsAs(ordered, """{"B":1}""", Lacks("a"));
        FaultsAs(ordered, """{"a":1,"B":1}""", Malformed("B"));
        FaultsAs(ordered, """{"a":1,"b":1}""", Malformed(""));
        FaultsAs("""{"kinds":["object"],"required":["a"],"minMembers":1}""", "{}", Malformed(""));
    }

    private static Fault Lacks(string member) => At(member, FrameRefusalReason.Lacks);

    private static Fault Malformed(string member) => At(member, FrameRefusalReason.Malformed);

    private static JsonElement Value(string text)
    {
        using var document = JsonDocument.Parse(text);
        return document.RootElement.Clone();
    }

    private static void FaultsAs(string shape, string text, Fault? expected) => Assert.Equal(expected, FaultAs(shape, Value(text)));
}
