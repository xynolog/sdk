using System.Globalization;
using System.Text.Json;
using System.Text.Json.Nodes;
using Xynolog.Annotations;
using Xynolog.Identifiers;
using Xynolog.Types;
using Xunit;
using static Xynolog.Annotations.AnnotationTools;

namespace Xynolog.Tests;

public sealed partial class TransportTests
{
    [Fact]
    public void AnnotationReadersRunTheSharedCases()
    {
        using var table = ReadSpec("annotations/reader-cases.json");
        foreach (var row in table.RootElement.GetProperty("cases").EnumerateArray())
        {
            var annotation = Required<Annotation>(row.GetProperty("annotation"));
            var selector = TargetSelector(annotation.Target);
            var actual = JsonSerializer.SerializeToElement(new
            {
                bodySource = BodySource(annotation.Body),
                isBodyResolved = IsBodyResolved(annotation.Body),
                targetSource = TargetSource(annotation.Target),
                targetSelector = selector,
                isHighlight = IsHighlight(annotation),
                isReference = IsReference(annotation),
                isAssessment = IsAssessment(annotation),
                isComment = IsComment(annotation),
                isTag = IsTag(annotation),
                commentText = CommentText(annotation),
                isStubReference = IsStubReference(annotation),
                isResolvedReference = IsResolvedReference(annotation),
                exactText = ExactText(selector),
                annotationExactText = AnnotationExactText(annotation),
                textQuoteSelector = TextQuoteSelector(selector),
                entityTypes = EntityTypes(annotation),
                tagCategory = TagCategory(annotation),
                tagSchemaId = TagSchemaId(annotation),
            });
            Assert.Equal(table.RootElement.GetProperty("readers").EnumerateArray().Select(value => value.GetString()).Order(),
                actual.EnumerateObject().Select(property => property.Name).Order());
            foreach (var property in row.GetProperty("reads").EnumerateObject())
                Assert.True(JsonElement.DeepEquals(property.Value, actual.GetProperty(property.Name)), Text(row, "why") + ": " + property.Name);
        }
    }

    [Fact]
    public void AnnotationIdsRunTheSharedCases()
    {
        using var table = ReadSpec("annotations/id-cases.json");
        foreach (var row in table.RootElement.GetProperty("cases").EnumerateArray())
        {
            var id = AnnotationIdentity.Derive(row.GetProperty("resourceId").Deserialize<ResourceId>(),
                row.GetProperty("motivation").Deserialize<Motivation>(), Text(row, "anchor"),
                row.TryGetProperty("body", out var body) ? body : null);
            Assert.Equal(Text(row, "id"), id.Value);
        }
    }

    [Theory]
    [InlineData("cases")]
    [InlineData("resources")]
    public void AnnotationBuildersRunTheSharedCases(string section)
    {
        using var table = ReadSpec("annotations/builder-cases.json");
        var clock = new TestClock();
        foreach (var row in table.RootElement.GetProperty(section).EnumerateArray())
        {
            var resource = row.GetProperty("resourceId").Deserialize<ResourceId>();
            var motivation = row.GetProperty("motivation").Deserialize<Motivation>();
            var generator = row.TryGetProperty("generator", out var agent) ? Required<Agent>(agent) : null;
            var body = row.TryGetProperty("body", out var bodies) ? Required<AnnotationBodies>(bodies) : null;
            if (section == "resources")
            {
                ExpectAnnotation(AnnotationOfResource(new OfResource(resource, motivation, generator, body), clock), row, clock);
                continue;
            }

            var source = row.TryGetProperty("text", out var plain)
                ? (Spanned)new Spanned.Text(plain.GetString() ?? throw new InvalidOperationException("Missing source text"))
                : new Spanned.Anchored(Required<AnchoredText>(row.GetProperty("anchored")));
            TextSpan span;
            try { span = Required<TextSpan>(row.GetProperty("span")); }
            catch (JsonException)
            {
                // TextSpan's offsets are whole and not negative, so a fraction or a negative offset is refused as it is read,
                // before any builder is called: that refusal is the table's refusal of a span out of range.
                Assert.Equal("span-out-of-range", Text(row, "refused"));
                continue;
            }

            var input = new OfSpan(resource, motivation, generator ?? throw new InvalidOperationException("Missing generator"), span, source, body);
            if (row.TryGetProperty("refused", out var code))
            {
                var error = Assert.Throws<SpanRefusedError>(() => AnnotationOfSpan(input, clock));
                Assert.Equal(code.GetString(), error.Code);
            }
            else ExpectAnnotation(AnnotationOfSpan(input, clock), row, clock);
        }

        static void ExpectAnnotation(Annotation annotation, JsonElement row, TimeProvider clock)
        {
            Assert.Equal(clock.GetUtcNow(), DateTimeOffset.Parse(annotation.Created, CultureInfo.InvariantCulture));
            var actual = JsonSerializer.SerializeToNode(annotation)?.AsObject() ?? throw new InvalidOperationException("No annotation");
            Assert.True(actual.Remove("created"));
            Assert.True(JsonElement.DeepEquals(row.GetProperty("annotation"), JsonSerializer.SerializeToElement(actual)),
                Text(row, "why") + ": " + actual.ToJsonString());
        }
    }

    [Fact]
    public void QuoteRecoveryRunsTheSharedCases()
    {
        using var table = ReadSpec("annotations/reconcile-cases.json");
        var methods = new HashSet<string>();
        var qualities = new HashSet<string>();
        foreach (var row in table.RootElement.GetProperty("cases").EnumerateArray())
        {
            var result = Reconcile(Text(row, "text"), Required<QuotedText>(row.GetProperty("quoted")));
            var expected = row.GetProperty("reconciled");
            if (expected.ValueKind == JsonValueKind.Null)
            {
                Assert.Null(result);
                continue;
            }
            Assert.NotNull(result);
            Assert.Equal(Required<ReconciledSpan>(expected), result);
            Assert.True(JsonElement.DeepEquals(expected, JsonSerializer.SerializeToElement(result)), Text(row, "why"));
            methods.Add(Text(expected, "anchorMethod"));
            if (expected.TryGetProperty("matchQuality", out var quality))
                qualities.Add(quality.GetString() ?? throw new InvalidOperationException("Missing quality"));

            // A reconciled span is one the builder takes as it is.
            var built = AnnotationOfSpan(new OfSpan(ResourceId.Parse("res-1"), Motivation.Highlighting,
                new Agent.AgentSoftware(new AgentSoftware { Provider = "ollama", Model = "gemma3" }), result, new Spanned.Text(Text(row, "text"))));
            var quote = TextQuoteSelector(TargetSelector(built.Target)) ?? throw new InvalidOperationException("No quote selector");
            Assert.Equal(Text(expected, "exact"), quote.Exact);
            Assert.Equal(expected.TryGetProperty("prefix", out var prefix) ? prefix.GetString() : null, quote.Prefix);
            Assert.Equal(expected.TryGetProperty("suffix", out var suffix) ? suffix.GetString() : null, quote.Suffix);
        }
        Assert.Equal(Enum.GetNames<AnchorMethod>().Select(JsonNamingPolicy.KebabCaseLower.ConvertName).Order(), methods.Order());
        Assert.Equal(Enum.GetNames<MatchQuality>().Select(JsonNamingPolicy.KebabCaseLower.ConvertName).Order(), qualities.Order());
    }

    [Fact]
    public void PdfLocationRunsTheSharedCases()
    {
        using var table = ReadSpec("annotations/pdf-locate-cases.json");
        foreach (var row in table.RootElement.GetProperty("cases").EnumerateArray())
        {
            var span = row.GetProperty("span");
            var (items, rectangles) = PdfLocation.Locate(Required<AnchoredText>(row.GetProperty("anchored")),
                span.GetProperty("start").GetInt32(), span.GetProperty("end").GetInt32());
            Assert.True(JsonElement.DeepEquals(row.GetProperty("overlapping"), JsonSerializer.SerializeToElement(items)), Text(row, "why"));
            Assert.True(JsonElement.DeepEquals(row.GetProperty("rects"), JsonSerializer.SerializeToElement(rectangles)), Text(row, "why"));
            Assert.Equal(Required<string[]>(row.GetProperty("fragments")), rectangles.Select(PdfLocation.Fragment));
        }
    }

    [Fact]
    public void TextOffsetsRunTheSharedCasesInBothDirections()
    {
        using var table = ReadSpec("text/offset-cases.json");
        foreach (var row in table.RootElement.GetProperty("cases").EnumerateArray())
        {
            var text = new ScalarText(Text(row, "text"));
            Assert.Equal(row.GetProperty("codePoints").GetInt32(), text.Length);
            foreach (var span in row.GetProperty("spans").EnumerateArray())
            {
                var quote = new ScalarText(Text(span, "exact"));
                var found = text.Places(quote).ElementAt(span.GetProperty("occurrence").GetInt32() - 1);
                var start = span.GetProperty("start").GetInt32();
                var end = span.GetProperty("end").GetInt32();
                Assert.Equal(start, found);
                Assert.Equal(end, found + quote.Length);
                Assert.Equal(Text(span, "exact"), text.Slice(start, end));
            }
        }
    }
}
