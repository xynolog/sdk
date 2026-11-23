using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog.Annotations;

public static partial class AnnotationTools
{
    /// <summary>The resource the first of the bodies links to, or null when none links to one.</summary>
    public static ResourceId? BodySource(AnnotationBodies? body) => Bodies(body)
        .OfType<AnnotationBody.SpecificResourceCase>().Select(item => (ResourceId?)item.Value.Source).FirstOrDefault();

    /// <summary>The resource the target is on.</summary>
    public static ResourceId TargetSource(AnnotationTargetValue target) => target switch
    {
        AnnotationTargetValue.ResourceIdCase(var resource) => resource,
        AnnotationTargetValue.AnnotationTargetCase(var specific) => specific.Source,
    };

    /// <summary>The selector of a target that selects part of a resource, or null for a target that is a whole
    /// resource.</summary>
    public static AnnotationSelector? TargetSelector(AnnotationTargetValue target) =>
        target is AnnotationTargetValue.AnnotationTargetCase(var specific) ? specific.Selector : null;

    /// <summary>Whether one of the bodies links to a resource.</summary>
    public static bool IsBodyResolved(AnnotationBodies? body) => BodySource(body).HasValue;
    /// <summary>Whether the annotation is made for highlighting.</summary>
    public static bool IsHighlight(Annotation annotation) => annotation.Motivation == Motivation.Highlighting;
    /// <summary>Whether the annotation is made for linking.</summary>
    public static bool IsReference(Annotation annotation) => annotation.Motivation == Motivation.Linking;
    /// <summary>Whether the annotation is made for assessing.</summary>
    public static bool IsAssessment(Annotation annotation) => annotation.Motivation == Motivation.Assessing;
    /// <summary>Whether the annotation is made for commenting.</summary>
    public static bool IsComment(Annotation annotation) => annotation.Motivation == Motivation.Commenting;
    /// <summary>Whether the annotation is made for tagging.</summary>
    public static bool IsTag(Annotation annotation) => annotation.Motivation == Motivation.Tagging;
    /// <summary>Whether the annotation is a reference whose body links to no resource yet.</summary>
    public static bool IsStubReference(Annotation annotation) => IsReference(annotation) && !IsBodyResolved(annotation.Body);
    /// <summary>Whether the annotation is a reference whose body links to a resource.</summary>
    public static bool IsResolvedReference(Annotation annotation) => IsReference(annotation) && IsBodyResolved(annotation.Body);

    /// <summary>The text of a comment's first body, or null when the annotation is no comment or that body is not
    /// text.</summary>
    public static string? CommentText(Annotation annotation) =>
        IsComment(annotation) && Bodies(annotation.Body).FirstOrDefault() is AnnotationBody.TextualBodyCase(var body) ? body.Value : null;

    /// <summary>The first selector that quotes the selected text, or null when there is none.</summary>
    public static TextQuoteSelector? TextQuoteSelector(AnnotationSelector? selector) =>
        Selectors(selector).OfType<Selector.TextQuoteSelectorCase>().FirstOrDefault()?.Value;

    /// <summary>The first selector that gives the selected text's position, or null when there is none.</summary>
    public static TextPositionSelector? TextPositionSelector(AnnotationSelector? selector) =>
        Selectors(selector).OfType<Selector.TextPositionSelectorCase>().FirstOrDefault()?.Value;

    /// <summary>The first selector that outlines the selection as an SVG shape, or null when there is none.</summary>
    public static SvgSelector? SvgSelector(AnnotationSelector? selector) =>
        Selectors(selector).OfType<Selector.SvgSelectorCase>().FirstOrDefault()?.Value;

    /// <summary>The first selector that names the selection as a fragment, or null when there is none.</summary>
    public static FragmentSelector? FragmentSelector(AnnotationSelector? selector) =>
        Selectors(selector).OfType<Selector.FragmentSelectorCase>().FirstOrDefault()?.Value;

    /// <summary>The text the first quoting selector quotes, or an empty string when none does.</summary>
    public static string ExactText(AnnotationSelector? selector) => TextQuoteSelector(selector)?.Exact ?? "";
    /// <summary>The text the annotation's target quotes, or an empty string when it quotes none.</summary>
    public static string AnnotationExactText(Annotation annotation) => ExactText(TargetSelector(annotation.Target));
    /// <summary>The entity types the annotation's tagging bodies name, leaving out empty ones.</summary>
    public static IReadOnlyList<string> EntityTypes(Annotation annotation) => Texts(annotation, BodyPurpose.Tagging)
        .Where(value => value.Length > 0).ToArray();
    /// <summary>A tag's category, from its first tagging body, or null when the annotation is no tag or names
    /// none.</summary>
    public static string? TagCategory(Annotation annotation) => IsTag(annotation) ? Texts(annotation, BodyPurpose.Tagging).FirstOrDefault() : null;
    /// <summary>The schema a tag's category belongs to, from its first classifying body, or null when the annotation is
    /// no tag or names none.</summary>
    public static string? TagSchemaId(Annotation annotation) => IsTag(annotation) ? Texts(annotation, BodyPurpose.Classifying).FirstOrDefault() : null;

    private static IEnumerable<string> Texts(Annotation annotation, BodyPurpose purpose) => Bodies(annotation.Body)
        .OfType<AnnotationBody.TextualBodyCase>().Where(item => item.Value.Purpose == purpose).Select(item => item.Value.Value);

    private static IReadOnlyList<AnnotationBody> Bodies(AnnotationBodies? body) => body switch
    {
        null => [],
        AnnotationBodies.AnnotationBodyCase(var single) => [single],
        AnnotationBodies.ArrayCase(var list) => list,
    };

    private static IReadOnlyList<Selector> Selectors(AnnotationSelector? selector) => selector switch
    {
        null => [],
        AnnotationSelector.SelectorCase(var single) => [single],
        AnnotationSelector.ArrayCase(var list) => list,
    };
}
