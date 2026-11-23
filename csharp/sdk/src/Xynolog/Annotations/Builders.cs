using System.Globalization;
using System.Text.Json;
using Xynolog.Errors;
using Xynolog.Identifiers;
using Xynolog.Protocol;
using Xynolog.Types;

namespace Xynolog.Annotations;

/// <summary>Thrown when a span does not fit the text it claims to select, so no annotation can be built from it.</summary>
public sealed class SpanRefusedError : XynologError
{
    internal SpanRefusedError(string code) : base(code, code) { }
}

/// <summary>The text a span selects from: plain text, or a PDF's text with the page locations of its items.</summary>
public closed record Spanned
{
    /// <summary>Plain text.</summary>
    /// <param name="Value">The text.</param>
    public sealed record Text(string Value) : Spanned;
    /// <summary>A PDF's text, whose items carry their page locations.</summary>
    /// <param name="Value">The text and its located items.</param>
    public sealed record Anchored(AnchoredText Value) : Spanned;
}

/// <summary>What <see cref="AnnotationTools.AnnotationOfSpan"/> builds an annotation of a span of a resource's text from.</summary>
/// <param name="ResourceId">The resource the annotation targets.</param>
/// <param name="Motivation">Why the annotation is made.</param>
/// <param name="Generator">The agent that made it.</param>
/// <param name="Span">The span of the text it selects.</param>
/// <param name="Text">The resource's text the span is checked against.</param>
/// <param name="Body">The annotation's body, if it has one.</param>
public sealed record OfSpan(ResourceId ResourceId, Motivation Motivation, Agent Generator, TextSpan Span, Spanned Text,
    AnnotationBodies? Body = null)
{
    /// <summary>Selects the span a reconciliation found in the text.</summary>
    /// <param name="resourceId">The resource the annotation targets.</param>
    /// <param name="motivation">Why the annotation is made.</param>
    /// <param name="generator">The agent that made it.</param>
    /// <param name="span">The reconciled span of the text it selects.</param>
    /// <param name="text">The resource's text the span is checked against.</param>
    /// <param name="body">The annotation's body, if it has one.</param>
    public OfSpan(ResourceId resourceId, Motivation motivation, Agent generator, ReconciledSpan span, Spanned text,
        AnnotationBodies? body = null) : this(resourceId, motivation, generator, SpanOf(span), text, body) { }

    private static TextSpan SpanOf(ReconciledSpan reconciled) => reconciled switch
    {
        ReconciledSpan.UniqueMatchCase(var span) =>
            new TextSpan { Start = span.Start, End = span.End, Exact = span.Exact, Prefix = span.Prefix, Suffix = span.Suffix },
        ReconciledSpan.ContextRecoveredCase(var span) =>
            new TextSpan { Start = span.Start, End = span.End, Exact = span.Exact, Prefix = span.Prefix, Suffix = span.Suffix },
        ReconciledSpan.FirstOfManyCase(var span) =>
            new TextSpan { Start = span.Start, End = span.End, Exact = span.Exact, Prefix = span.Prefix, Suffix = span.Suffix },
        ReconciledSpan.FuzzyMatchCase(var span) =>
            new TextSpan { Start = span.Start, End = span.End, Exact = span.Exact, Prefix = span.Prefix, Suffix = span.Suffix },
    };
}

/// <summary>What <see cref="AnnotationTools.AnnotationOfResource"/> builds an annotation of a whole resource from.</summary>
/// <param name="ResourceId">The resource the annotation targets.</param>
/// <param name="Motivation">Why the annotation is made.</param>
/// <param name="Generator">The agent that made it, if one is named.</param>
/// <param name="Body">The annotation's body, if it has one.</param>
public sealed record OfResource(ResourceId ResourceId, Motivation Motivation, Agent? Generator = null, AnnotationBodies? Body = null);

/// <summary>Builds W3C annotations and reads their targets, selectors and bodies.</summary>
public static partial class AnnotationTools
{
    /// <summary>Builds an annotation of a span, after checking the span against the text it selects from.</summary>
    /// <exception cref="SpanRefusedError">The span lies outside the text or does not match it.</exception>
    public static Annotation AnnotationOfSpan(OfSpan input, TimeProvider? timeProvider = null)
    {
        var anchored = input.Text is Spanned.Anchored(var pdf) ? pdf : null;
        var source = input.Text switch
        {
            Spanned.Anchored(var value) => value.Text,
            Spanned.Text(var value) => value,
        };
        var text = new ScalarText(source);
        if (anchored is not null && anchored.Items.Any(item => !ValidSpan(item.Start, item.End, text.Length)))
            throw Refused("item-out-of-range");

        var span = input.Span;
        if (!ValidSpan(span.Start, span.End, text.Length)) throw Refused("span-out-of-range");
        var selectors = anchored is null ? TextSelectors(text, span) : PdfSelectors(text, anchored, span);
        if (span.Prefix is string prefix && !text.Slice(0, (int)span.Start).EndsWith(prefix, StringComparison.Ordinal))
            throw Refused("prefix-mismatch");
        if (span.Suffix is string suffix && !text.Slice((int)span.End, text.Length).StartsWith(suffix, StringComparison.Ordinal))
            throw Refused("suffix-mismatch");
        selectors.Add(new Selector.TextQuoteSelectorCase(new TextQuoteSelector
        {
            Exact = span.Exact,
            Prefix = span.Prefix is { Length: > 0 } ? span.Prefix : null,
            Suffix = span.Suffix is { Length: > 0 } ? span.Suffix : null,
        }));
        var target = new AnnotationTarget
        {
            Source = input.ResourceId,
            Type = AnnotationTargetType.SpecificResource,
            Selector = new AnnotationSelector.ArrayCase(selectors.ToArray()),
        };
        return Build(target, input.Motivation, FormattableString.Invariant($"{span.Start}:{span.End}:{span.Exact}"),
            input.Generator, input.Body, timeProvider);
    }

    /// <summary>Builds an annotation of a whole resource.</summary>
    public static Annotation AnnotationOfResource(OfResource input, TimeProvider? timeProvider = null) =>
        Build(new AnnotationTarget { Source = input.ResourceId }, input.Motivation, "", input.Generator, input.Body, timeProvider);

    private static List<Selector> TextSelectors(ScalarText text, TextSpan span)
    {
        if (!string.Equals(text.Slice((int)span.Start, (int)span.End), span.Exact, StringComparison.Ordinal))
            throw Refused("exact-mismatch");
        return [new Selector.TextPositionSelectorCase(new TextPositionSelector { Start = span.Start, End = span.End })];
    }

    private static List<Selector> PdfSelectors(ScalarText text, AnchoredText anchored, TextSpan span)
    {
        var (items, rectangles) = PdfLocation.Locate(anchored, span.Start, span.End);
        if (rectangles.Count == 0) throw Refused("nothing-located");
        var covered = text.Slice(checked((int)items.Min(item => item.Start)), checked((int)items.Max(item => item.End)));
        var words = ScalarText.Collapse(span.Exact);
        if (words.Length == 0 || !ScalarText.Collapse(covered).Contains(words, StringComparison.Ordinal))
            throw Refused("exact-not-covered");
        return rectangles.Select(rectangle => (Selector)new Selector.FragmentSelectorCase(new FragmentSelector
        {
            ConformsTo = "http://tools.ietf.org/rfc/rfc3778",
            Value = PdfLocation.Fragment(rectangle),
        })).ToList();
    }

    private static Annotation Build(AnnotationTarget target, Motivation motivation, string anchor, Agent? generator, AnnotationBodies? body,
        TimeProvider? timeProvider) =>
        new()
        {
            Id = AnnotationIdentity.Derive(target.Source, motivation, anchor, body is null ? null : JsonSerializer.SerializeToElement(body)),
            Created = (timeProvider ?? TimeProvider.System).GetUtcNow().ToString("O", CultureInfo.InvariantCulture),
            Target = new AnnotationTargetValue.AnnotationTargetCase(target),
            Motivation = motivation,
            Generator = generator is null ? null : new OneOrMoreAgents.AgentCase(generator),
            Body = body,
        };

    private static bool ValidSpan(long start, long end, int length) => start >= 0 && start <= end && end <= length;

    private static SpanRefusedError Refused(string name) => new(ProtocolFacts.SpanRefusal(name));
}
