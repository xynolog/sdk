using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Text.Json;
using System.Text.Json.Nodes;
using Xynolog.Identifiers;
using Xynolog.Types;

namespace Xynolog.Serialization;

/// <summary>The first thing wrong with a value: the way to the member it is at (the names of the members it is within,
/// and its own, joined by dots; empty for the value itself), and why.</summary>
internal sealed record Fault(string Member, FrameRefusalReason Reason)
{
    /// <summary>The fault of a value its decoder refuses that has no fault the table states: the value itself is
    /// malformed.</summary>
    internal static readonly Fault Undecoded = new("", FrameRefusalReason.Malformed);

    /// <summary>What every SDK says of the fault.</summary>
    public override string ToString() =>
        Reason == FrameRefusalReason.Lacks ? "it has no `" + Member + "`"
        : Member.Length == 0 ? "it is malformed"
        : "its `" + Member + "` is malformed";
}

// The first fault of a value as one of the protocol's component schemas, and what a reader reads of it. Every SDK holds
// what it reads to the table of what each schema requires, and names the first fault it finds the same way. The table is
// Generated/RequiredSchemas.g.cs, written by the rules of codegen/lib/required/shape.ml, which states what each part of a
// shape means and the order a reader walks them in, with what each payload type the bus registry makes requires (an
// envelope of a schema's response, and the empty payload) beside it, by the same rules.
internal static partial class Required
{
    private static readonly Dictionary<string, Shape> Schemas = ParseTable();

    /// <summary>The first fault <paramref name="value"/> has as the component schema <paramref name="schema"/>, by the
    /// rules every SDK reads the table by; null when it has none, and then <paramref name="read"/> is what a reader
    /// decodes: <paramref name="value"/> without each member that holds a text none of its recognized ones, or that
    /// holds null where its shape does not allow null and the object does not require it.</summary>
    internal static Fault? FaultOf(string schema, JsonElement value, out JsonElement read)
    {
        var unread = new List<Place>();
        var fault = FaultAt(Component(schema), value, "", Place.Value, unread);
        read = fault is null && unread.Count > 0 ? Without(value, unread) : value;
        return fault;
    }

    /// <summary><paramref name="value"/> as <typeparamref name="T"/>, held to the table before it is decoded and decoded
    /// as the table reads it; or its first fault. A value the table passes that <typeparamref name="T"/>'s decoder still
    /// refuses is malformed.</summary>
    internal static bool TryRead<T>(JsonElement value, [NotNullWhen(true)] out T? decoded,
        [NotNullWhen(false)] out Fault? fault) where T : class
    {
        decoded = null;
        fault = FaultOf(typeof(T).Name, value, out var read);
        if (fault is not null) return false;
        try { decoded = read.Deserialize<T>() ?? throw new JsonException(typeof(T).Name + " is null."); }
        catch (JsonException)
        {
            fault = Fault.Undecoded;
            return false;
        }
        return true;
    }

    /// <summary>Whether <see cref="LastEventIds"/> holds <paramref name="id"/> as the place reached in
    /// <paramref name="scope"/>: the one decider of what a stream's place is.</summary>
    internal static bool IsPlace(ResourceId scope, string id) =>
        FaultOf(nameof(LastEventIds), JsonSerializer.SerializeToElement(new Dictionary<string, string> { [scope.Value] = id }), out _) is null;

    /// <summary>The first fault <paramref name="value"/> has as <paramref name="shape"/>, a shape as the table writes
    /// one; null when it has none.</summary>
    internal static Fault? FaultAs(string shape, JsonElement value)
    {
        using var written = JsonDocument.Parse(shape);
        return FaultAt(ParseShape(written.RootElement), value, "", Place.Value, []);
    }

    /// <summary><paramref name="schema"/>, once the table is read and found to state it.</summary>
    internal static string Stated(string schema)
    {
        Component(schema);
        return schema;
    }

    private enum Kind { Object, Array, String, Integer, Number, Boolean, Null }

    /// <summary>One term of a pattern, repeated at least <c>Min</c> times and at most <c>Max</c> (null: any number): a
    /// step or a group.</summary>
    private abstract record Term(int Min, int? Max);

    /// <summary>A step of a pattern: a text's next code point, in one of the ranges <c>Of</c>.</summary>
    private sealed record Step(IReadOnlyList<(int From, int To)> Of, int Min, int? Max) : Term(Min, Max);

    /// <summary>A group of a pattern: the text's next code points, of one of the series <c>Either</c>.</summary>
    private sealed record Group(IReadOnlyList<IReadOnlyList<Term>> Either, int Min, int? Max) : Term(Min, Max);

    /// <summary>The member whose value names the variant of a union a value is.</summary>
    private sealed record Discriminator(string Property, IReadOnlyDictionary<string, int> Mapping);

    /// <summary>Where a value is within the one walked: the member <c>Member</c>, or else the item <c>Item</c>, of the
    /// value at <c>Within</c>; the walked value itself when it is within none.</summary>
    private sealed record Place(Place? Within, string? Member, int Item)
    {
        internal static readonly Place Value = new(null, null, 0);

        internal Place Of(string member) => new(this, member, 0);

        internal Place At(int item) => new(this, null, item);
    }

    /// <summary>What a value must be. A part that is null is one the table does not state.</summary>
    private sealed record Shape
    {
        public string? Ref { get; init; }
        public IReadOnlyList<Kind>? Kinds { get; init; }
        public IReadOnlyList<string>? Recognized { get; init; }
        public IReadOnlyList<JsonElement>? Enum { get; init; }
        public IReadOnlyList<Term>? Pattern { get; init; }
        public int? MinLength { get; init; }
        public int? MaxLength { get; init; }
        public double? Minimum { get; init; }
        public double? Maximum { get; init; }
        public int? MinItems { get; init; }
        public int? MaxItems { get; init; }
        public IReadOnlyList<string>? Required { get; init; }
        public IReadOnlyDictionary<string, Shape>? Members { get; init; }
        public IReadOnlyList<string>? Closed { get; init; }
        public Shape? Items { get; init; }
        public Shape? Values { get; init; }
        public IReadOnlyList<Shape>? OneOf { get; init; }
        public Discriminator? Discriminator { get; init; }
        public IReadOnlyList<Shape>? AllOf { get; init; }
        /// <summary>Sets of members an object does not carry all of.</summary>
        public IReadOnlyList<IReadOnlyList<string>>? NotAll { get; init; }
        public int? MinMembers { get; init; }
        /// <summary>What each of an object's members' names must be.</summary>
        public Shape? Names { get; init; }
    }

    private static Dictionary<string, Shape> ParseTable()
    {
        using var table = JsonDocument.Parse(Table);
        var schemas = table.RootElement.GetProperty("schemas").EnumerateObject()
            .ToDictionary(schema => schema.Name, schema => ParseShape(schema.Value), StringComparer.Ordinal);
        if (schemas.Count == 0) throw new InvalidOperationException("The table of what each schema requires holds none.");
        return schemas;
    }

    /// <summary>A shape of the table. A part this does not know is refused, so the walk cannot fall behind the table
    /// unseen.</summary>
    private static Shape ParseShape(JsonElement raw)
    {
        var shape = new Shape();
        foreach (var part in raw.EnumerateObject())
        {
            var value = part.Value;
            shape = part.Name switch
            {
                "ref" => shape with { Ref = Text(value) },
                "kinds" => shape with { Kinds = value.EnumerateArray().Select(ParseKind).ToArray() },
                "recognized" => shape with { Recognized = value.EnumerateArray().Select(Text).ToArray() },
                "enum" => shape with { Enum = value.EnumerateArray().Select(listed => listed.Clone()).ToArray() },
                "pattern" => shape with { Pattern = value.EnumerateArray().Select(ParseTerm).ToArray() },
                "minLength" => shape with { MinLength = value.GetInt32() },
                "maxLength" => shape with { MaxLength = value.GetInt32() },
                "minimum" => shape with { Minimum = value.GetDouble() },
                "maximum" => shape with { Maximum = value.GetDouble() },
                "minItems" => shape with { MinItems = value.GetInt32() },
                "maxItems" => shape with { MaxItems = value.GetInt32() },
                "required" => shape with { Required = value.EnumerateArray().Select(Text).ToArray() },
                "members" => shape with
                {
                    Members = value.EnumerateObject().ToDictionary(member => member.Name, member => ParseShape(member.Value), StringComparer.Ordinal),
                },
                "closed" => shape with { Closed = value.EnumerateArray().Select(Text).ToArray() },
                "items" => shape with { Items = ParseShape(value) },
                "values" => shape with { Values = ParseShape(value) },
                "oneOf" => shape with { OneOf = value.EnumerateArray().Select(ParseShape).ToArray() },
                "discriminator" => shape with
                {
                    Discriminator = new Discriminator(Text(value.GetProperty("property")), value.GetProperty("mapping").EnumerateObject()
                        .ToDictionary(named => named.Name, named => named.Value.GetInt32(), StringComparer.Ordinal)),
                },
                "allOf" => shape with { AllOf = value.EnumerateArray().Select(ParseShape).ToArray() },
                "notAll" => shape with { NotAll = value.EnumerateArray().Select(set => set.EnumerateArray().Select(Text).ToArray()).ToArray() },
                "minMembers" => shape with { MinMembers = value.GetInt32() },
                "names" => shape with { Names = ParseShape(value) },
                _ => throw new InvalidOperationException("A shape states " + part.Name + ", which the walk does not read."),
            };
        }
        return shape;
    }

    private static Kind ParseKind(JsonElement value) => Text(value) switch
    {
        "object" => Kind.Object,
        "array" => Kind.Array,
        "string" => Kind.String,
        "integer" => Kind.Integer,
        "number" => Kind.Number,
        "boolean" => Kind.Boolean,
        "null" => Kind.Null,
        var other => throw new InvalidOperationException(other + " is no kind of value."),
    };

    /// <summary>A term of a pattern: a step or a group, never both. A part this does not know is refused.</summary>
    private static Term ParseTerm(JsonElement value)
    {
        IReadOnlyList<(int From, int To)>? of = null;
        IReadOnlyList<IReadOnlyList<Term>>? either = null;
        int? least = null;
        int? most = null;
        foreach (var part in value.EnumerateObject())
        {
            switch (part.Name)
            {
                case "of":
                    of = part.Value.EnumerateArray().Select(range => (range[0].GetInt32(), range[1].GetInt32())).ToArray();
                    break;
                case "either":
                    either = part.Value.EnumerateArray().Select(series => series.EnumerateArray().Select(ParseTerm).ToArray()).ToArray();
                    break;
                case "min":
                    least = part.Value.GetInt32();
                    break;
                case "max":
                    most = part.Value.GetInt32();
                    break;
                default:
                    throw new InvalidOperationException("A pattern's term states " + part.Name + ", which the walk does not read.");
            }
        }
        var min = least ?? throw new InvalidOperationException("A pattern's term states no min: " + value.GetRawText());
        return (of, either) switch
        {
            ({ } ranges, null) => new Step(ranges, min, most),
            (null, { } alternatives) => new Group(alternatives, min, most),
            _ => throw new InvalidOperationException("A pattern's term is a step or a group: " + value.GetRawText()),
        };
    }

    private static string Text(JsonElement value) => value.GetString() ?? throw new InvalidOperationException("A text is null.");

    private static Shape Component(string name) =>
        Schemas.TryGetValue(name, out var shape) ? shape : throw new InvalidOperationException(name + " is no component schema of the spec.");

    private static Shape Resolved(Shape shape) => shape.Ref is { } reference ? Resolved(Component(reference)) : shape;

    private static string Within(string way, string name) => way.Length == 0 ? name : way + "." + name;

    private static Kind KindOf(JsonElement value) => value.ValueKind switch
    {
        JsonValueKind.Null => Kind.Null,
        JsonValueKind.True or JsonValueKind.False => Kind.Boolean,
        JsonValueKind.Number => Kind.Number,
        JsonValueKind.String => Kind.String,
        JsonValueKind.Array => Kind.Array,
        JsonValueKind.Object => Kind.Object,
        var other => throw new InvalidOperationException("JSON carries no " + other + " value."),
    };

    /// <summary>A number as JSON states it, where one too great for a double is infinite.</summary>
    internal static double NumberOf(JsonElement value) => double.Parse(value.GetRawText(), NumberStyles.Float, CultureInfo.InvariantCulture);

    /// <summary>Whether <paramref name="kinds"/> allow <paramref name="value"/>: none allow any, and an integer is a
    /// number with no fractional part.</summary>
    private static bool Allows(IReadOnlyList<Kind>? kinds, JsonElement value) =>
        kinds is null || kinds.Contains(KindOf(value)) || kinds.Contains(Kind.Integer) && IsInteger(value);

    /// <summary>Whether <paramref name="value"/> is an integer: a number with no fractional part, however it is
    /// written.</summary>
    internal static bool IsInteger(JsonElement value)
    {
        if (value.ValueKind != JsonValueKind.Number) return false;
        var number = NumberOf(value);
        return double.IsFinite(number) && Math.Truncate(number) == number;
    }

    private static bool AllowsNull(IReadOnlyList<Kind>? kinds) => kinds is null || kinds.Contains(Kind.Null);

    /// <summary>Whether <paramref name="count"/> is at least <paramref name="least"/> and at most
    /// <paramref name="most"/>, where each is stated.</summary>
    private static bool Counted(double? least, double count, double? most) =>
        (least is not { } floor || count >= floor) && (most is not { } ceiling || count <= ceiling);

    /// <summary>Whether the code points from <paramref name="at"/> are of <paramref name="terms"/> from
    /// <paramref name="term"/>, with <paramref name="rest"/> taking what is left after them: a step takes as many code
    /// points as it may and gives them back one by one, and a group repeats as often as it may and gives repetitions back
    /// the same way, until <paramref name="rest"/> takes what is left.</summary>
    private static bool Series(IReadOnlyList<Term> terms, int term, int[] points, int at, Func<int, bool> rest)
    {
        if (term == terms.Count) return rest(at);
        bool Next(int after) => Series(terms, term + 1, points, after, rest);
        if (terms[term] is Group group) return Repeated(group, points, at, 0, Next);
        var step = (Step)terms[term];
        var taken = 0;
        while (at + taken < points.Length && (step.Max is not { } most || taken < most)
            && step.Of.Any(range => range.From <= points[at + taken] && points[at + taken] <= range.To))
        {
            taken++;
        }
        for (; taken >= step.Min; taken--)
        {
            if (Next(at + taken)) return true;
        }
        return false;
    }

    /// <summary>Whether the code points from <paramref name="at"/> are of <paramref name="group"/> repeated once more
    /// than <paramref name="count"/> times or more, then of <paramref name="next"/>: a repetition past the group's
    /// <c>Min</c> takes at least one code point.</summary>
    private static bool Repeated(Group group, int[] points, int at, int count, Func<int, bool> next)
    {
        if (group.Max is not { } most || count < most)
        {
            foreach (var alternative in group.Either)
            {
                if (Series(alternative, 0, points, at,
                    after => (count < group.Min || after > at) && Repeated(group, points, after, count + 1, next)))
                {
                    return true;
                }
            }
        }
        return count >= group.Min && next(at);
    }

    /// <summary>Whether <paramref name="value"/> is one of the shape's values, a text is of its pattern and has as many
    /// code points as it allows, a number is within its bounds, and an array has as many items and an object as many
    /// members as it allows.</summary>
    private static bool IsAsStated(Shape shape, JsonElement value)
    {
        if (shape.Enum is { } listed && !listed.Any(one => JsonElement.DeepEquals(one, value))) return false;
        switch (value.ValueKind)
        {
            case JsonValueKind.String:
                var points = Text(value).EnumerateRunes().Select(rune => rune.Value).ToArray();
                return Counted(shape.MinLength, points.Length, shape.MaxLength)
                    && (shape.Pattern is not { } pattern || Series(pattern, 0, points, 0, end => end == points.Length));
            case JsonValueKind.Number:
                return Counted(shape.Minimum, NumberOf(value), shape.Maximum);
            case JsonValueKind.Array:
                return Counted(shape.MinItems, value.GetArrayLength(), shape.MaxItems);
            case JsonValueKind.Object:
                return Counted(shape.MinMembers, value.EnumerateObject().Select(member => member.Name).Distinct(StringComparer.Ordinal).Count(), null);
            default:
                return true;
        }
    }

    /// <summary>The first fault <paramref name="value"/> has as a value of <paramref name="shape"/>, from
    /// <paramref name="way"/>. Each member a reader reads as absent is added to <paramref name="unread"/>, by its place
    /// from <paramref name="at"/>, the value's own.</summary>
    private static Fault? FaultAt(Shape shape, JsonElement value, string way, Place at, List<Place> unread)
    {
        var own = Resolved(shape);
        if (!Allows(own.Kinds, value) || !IsAsStated(own, value)) return new Fault(way, FrameRefusalReason.Malformed);
        if (value.ValueKind == JsonValueKind.Object && FaultOfMembers(own, value, way, at, unread) is { } inMembers) return inMembers;
        if (value.ValueKind == JsonValueKind.Array && own.Items is { } items)
        {
            var index = 0;
            foreach (var item in value.EnumerateArray())
            {
                if (FaultAt(items, item, way, at.At(index++), unread) is { } inItem) return inItem;
            }
        }
        if (own.OneOf is { } variants && FaultOfOneOf(variants, own.Discriminator, value, way, at, unread) is { } inVariant) return inVariant;
        if (own.AllOf is { } parts)
        {
            foreach (var part in parts)
            {
                if (FaultAt(part, value, way, at, unread) is { } inPart) return inPart;
            }
        }
        return null;
    }

    /// <summary>Whether a reader reads <paramref name="held"/>, a member of shape <paramref name="shape"/>, as absent: a
    /// text none of the shape's recognized ones.</summary>
    private static bool IsUnrecognized(Shape shape, JsonElement held) =>
        Resolved(shape).Recognized is { } recognized && held.ValueKind == JsonValueKind.String
        && !recognized.Contains(Text(held), StringComparer.Ordinal);

    /// <summary><paramref name="value"/> without the member at each of <paramref name="unread"/>.</summary>
    private static JsonElement Without(JsonElement value, List<Place> unread)
    {
        var read = JsonNode.Parse(value.GetRawText()) ?? throw new InvalidOperationException("A value with members is null.");
        foreach (var place in unread)
        {
            var within = place.Within ?? throw new InvalidOperationException("A member is within no value.");
            var member = place.Member ?? throw new InvalidOperationException("An item is read as absent.");
            NodeAt(read, within).AsObject().Remove(member);
        }
        return JsonSerializer.SerializeToElement(read);
    }

    private static JsonNode NodeAt(JsonNode value, Place place) =>
        (place.Within is not { } within ? value
            : place.Member is { } member ? NodeAt(value, within)[member]
            : NodeAt(value, within)[place.Item])
        ?? throw new InvalidOperationException("A place holds no value.");

    /// <summary>The first fault of an object in the members the shape requires, in what its members are, in the
    /// members it may not carry, in its members' names, in the sets of members it may not carry all of, and in its
    /// values. A member that holds a text none of its recognized ones is no fault:
    /// it is unread. So is a member the object does not require that holds null where its shape does not allow null:
    /// the table states what a member must be only where it is not null.</summary>
    private static Fault? FaultOfMembers(Shape shape, JsonElement value, string way, Place at, List<Place> unread)
    {
        if (shape.Required is { } required)
        {
            foreach (var name in required)
            {
                if (!value.TryGetProperty(name, out var held)
                    || (held.ValueKind == JsonValueKind.Null && shape.Members is { } stated && stated.TryGetValue(name, out var member)
                        && !AllowsNull(Resolved(member).Kinds)))
                {
                    return new Fault(Within(way, name), FrameRefusalReason.Lacks);
                }
            }
        }
        if (shape.Members is { } members)
        {
            foreach (var (name, member) in members.OrderBy(pair => pair.Key, CodePoints.Order))
            {
                if (!value.TryGetProperty(name, out var held)) continue;
                if (held.ValueKind == JsonValueKind.Null)
                {
                    if (!AllowsNull(Resolved(member).Kinds)) unread.Add(at.Of(name));
                    continue;
                }
                if (IsUnrecognized(member, held))
                {
                    unread.Add(at.Of(name));
                    continue;
                }
                if (FaultAt(member, held, Within(way, name), at.Of(name), unread) is { } inMember) return inMember;
            }
        }
        var names = value.EnumerateObject().Select(property => property.Name).Order(CodePoints.Order).ToArray();
        if (shape.Closed is { } closed && names.FirstOrDefault(name => !closed.Contains(name, StringComparer.Ordinal)) is { } unnamed)
        {
            return new Fault(Within(way, unnamed), FrameRefusalReason.Malformed);
        }
        if (shape.Names is { } named
            && names.FirstOrDefault(name => FaultAt(named, JsonSerializer.SerializeToElement(name), "", Place.Value, []) is not null) is { } misnamed)
        {
            return new Fault(Within(way, misnamed), FrameRefusalReason.Malformed);
        }
        if (shape.NotAll is { } notAll && notAll.Any(set => set.All(name => value.TryGetProperty(name, out _))))
        {
            return new Fault(way, FrameRefusalReason.Malformed);
        }
        if (shape.Values is { } values)
        {
            foreach (var name in names)
            {
                if (FaultAt(values, value.GetProperty(name), way, at.Of(name), unread) is { } inValue) return inValue;
            }
        }
        return null;
    }

    /// <summary>The fault <paramref name="value"/> has as one of a union's <paramref name="variants"/>: the variant its
    /// discriminator names, or else each variant whose kinds allow it. None when one of them has none, and what that one
    /// leaves unread is unread; the first one's when each has one; and a value no variant allows is malformed.</summary>
    private static Fault? FaultOfOneOf(IReadOnlyList<Shape> variants, Discriminator? discriminator, JsonElement value, string way,
        Place at, List<Place> unread)
    {
        IReadOnlyList<Shape> candidates = variants.Where(variant => Allows(Resolved(variant).Kinds, value)).ToArray();
        if (value.ValueKind == JsonValueKind.Object && discriminator is not null
            && value.TryGetProperty(discriminator.Property, out var named) && named.ValueKind == JsonValueKind.String
            && named.GetString() is { } variantName && discriminator.Mapping.TryGetValue(variantName, out var variantAt)
            && variantAt >= 0 && variantAt < variants.Count)
        {
            candidates = [variants[variantAt]];
        }
        if (candidates.Count == 0) return new Fault(way, FrameRefusalReason.Malformed);
        Fault? first = null;
        foreach (var candidate in candidates)
        {
            var unreadByIt = new List<Place>();
            if (FaultAt(candidate, value, way, at, unreadByIt) is not { } fault)
            {
                unread.AddRange(unreadByIt);
                return null;
            }
            if (first is null) first = fault;
        }
        return first;
    }
}
