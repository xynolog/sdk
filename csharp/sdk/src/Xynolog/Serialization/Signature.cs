using System.Text.Json;

namespace Xynolog.Serialization;

/// <summary>The kind of JSON value a <see cref="Signature"/> admits.</summary>
internal enum Kind
{
    Text,
    Integer,
    Number,
    Boolean,
    List,
    Object,
    Null,
    Any,
}

/// <summary>One value a schema states.</summary>
internal abstract record Literal
{
    internal abstract bool Is(JsonElement value);

    /// <summary>A string.</summary>
    internal sealed record Text(string Value) : Literal
    {
        internal override bool Is(JsonElement value) => value.ValueKind == JsonValueKind.String && value.GetString() == Value;

        public override string ToString() => "`" + Value + "`";
    }

    /// <summary>An integer.</summary>
    internal sealed record Integer(long Value) : Literal
    {
        internal override bool Is(JsonElement value) => value.ValueKind == JsonValueKind.Number && value.TryGetInt64(out var number) && number == Value;

        public override string ToString() => "`" + Value + "`";
    }

    /// <summary>A boolean.</summary>
    internal sealed record Boolean(bool Value) : Literal
    {
        internal override bool Is(JsonElement value) => value.ValueKind is JsonValueKind.True or JsonValueKind.False && value.GetBoolean() == Value;

        public override string ToString() => Value ? "`true`" : "`false`";
    }
}

/// <summary>The values a member of an object may take.</summary>
internal sealed record Fixed(string Property, Literal[] Values);

/// <summary>
/// What a member of a union admits, as its schema states it: what tells it from the union's other members.
/// Each generated union states its members' (<c>Members</c>), and is read as the one member that admits a value.
/// </summary>
/// <param name="Kind">The kind of JSON value it admits.</param>
/// <param name="Required">The members an object must carry.</param>
/// <param name="Allowed">Every member an object may carry, where its schema says.</param>
/// <param name="Fixed">The values each of these members may take.</param>
/// <param name="Values">Every value it admits, where its schema says.</param>
internal sealed record Signature(Kind Kind, string[] Required, string[]? Allowed, Fixed[] Fixed, Literal[]? Values)
{
    private static bool Of(Kind kind, JsonElement value) => kind switch
    {
        Kind.Text => value.ValueKind == JsonValueKind.String,
        Kind.Integer => value.ValueKind == JsonValueKind.Number && value.TryGetInt64(out _),
        Kind.Number => value.ValueKind == JsonValueKind.Number,
        Kind.Boolean => value.ValueKind is JsonValueKind.True or JsonValueKind.False,
        Kind.List => value.ValueKind == JsonValueKind.Array,
        Kind.Object => value.ValueKind == JsonValueKind.Object,
        Kind.Null => value.ValueKind == JsonValueKind.Null,
        _ => true,
    };

    /// <summary>Whether <paramref name="value"/> is of its kind, and states only the values it admits.</summary>
    internal bool Names(JsonElement value) =>
        Of(Kind, value)
        && (Values is null || Values.Any(literal => literal.Is(value)))
        && (value.ValueKind != JsonValueKind.Object
            || Fixed.All(stated => !value.TryGetProperty(stated.Property, out var member) || stated.Values.Any(literal => literal.Is(member))));

    /// <summary>Whether it admits <paramref name="value"/>: it names it, and an object carries every member it requires and none it does not allow.</summary>
    internal bool Admits(JsonElement value) =>
        Names(value)
        && (value.ValueKind != JsonValueKind.Object
            || (Required.All(property => value.TryGetProperty(property, out _))
                && (Allowed is null || value.EnumerateObject().All(member => Allowed.Contains(member.Name, StringComparer.Ordinal)))));

    /// <summary>
    /// The one of a union's <paramref name="members"/>, each its signatures, that admits <paramref name="value"/>;
    /// or, none admitting it, the one that names it, whose reading says what is wrong with it.
    /// </summary>
    internal static (int At, bool Admitted)? Member(JsonElement value, Signature[][] members)
    {
        int? Only(Func<Signature, bool> test)
        {
            var found = Enumerable.Range(0, members.Length).Where(at => members[at].Any(test)).ToArray();
            return found.Length == 1 ? found[0] : null;
        }
        if (Only(signature => signature.Admits(value)) is { } admitted) return (admitted, true);
        if (Only(signature => signature.Names(value)) is { } named) return (named, false);
        return null;
    }

    /// <summary>
    /// What is wrong with a value of <paramref name="union"/> that none of its <paramref name="members"/> names:
    /// where each states its values of one property, that the value's is none of them.
    /// </summary>
    internal static string NoneOf(string union, Signature[][] members)
    {
        var signatures = members.SelectMany(signatures => signatures).ToArray();
        var first = members.FirstOrDefault()?.FirstOrDefault();
        foreach (var stated in first?.Fixed ?? [])
        {
            var values = signatures.Select(signature => signature.Fixed.FirstOrDefault(other => other.Property == stated.Property)?.Values).ToArray();
            if (values.All(of => of is not null))
            {
                return "a " + union + " states a `" + stated.Property + "` that is one of " + string.Join(", ", values.OfType<Literal[]>().SelectMany(of => of));
            }
        }
        return "a " + union + " that is none of its members";
    }
}
