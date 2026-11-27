using System.Reflection;
using System.Runtime.CompilerServices;
using System.Text.Json;
using System.Text.Json.Serialization;
using Xynolog.Types;

namespace Xynolog.Serialization;

/// <summary>The member of the wire a model's property is.</summary>
[AttributeUsage(AttributeTargets.Property)]
internal sealed class WireAttribute(string name) : Attribute
{
    internal string Name { get; } = name;
}

/// <summary>The property that holds every member of the wire an open model's schema does not name.</summary>
[AttributeUsage(AttributeTargets.Property)]
internal sealed class WireRestAttribute : Attribute;

/// <summary>A model read and written by <see cref="WireObjectConverter{T}"/>.</summary>
[AttributeUsage(AttributeTargets.Class)]
internal sealed class WireObjectAttribute : JsonConverterAttribute
{
    public override JsonConverter CreateConverter(Type type) =>
        Activator.CreateInstance(typeof(WireObjectConverter<>).MakeGenericType(type)) as JsonConverter
        ?? throw new InvalidOperationException("No converter of " + type.Name + ".");
}

/// <summary>A union read and written by <see cref="WireUnionConverter{T}"/>, whose cases are its schema's members in order.</summary>
[AttributeUsage(AttributeTargets.Class)]
internal sealed class WireUnionAttribute(params Type[] cases) : JsonConverterAttribute
{
    public override JsonConverter CreateConverter(Type type) =>
        Activator.CreateInstance(typeof(WireUnionConverter<>).MakeGenericType(type), [cases]) as JsonConverter
        ?? throw new InvalidOperationException("No converter of " + type.Name + ".");
}

/// <summary>An enumeration read and written by <see cref="WireEnumConverter{T}"/>.</summary>
[AttributeUsage(AttributeTargets.Enum)]
internal sealed class WireEnumAttribute : JsonConverterAttribute
{
    public override JsonConverter CreateConverter(Type type) =>
        Activator.CreateInstance(typeof(WireEnumConverter<>).MakeGenericType(type)) as JsonConverter
        ?? throw new InvalidOperationException("No converter of " + type.Name + ".");
}

/// <summary>A schema of one integer or boolean, read and written by <see cref="WireConstantConverter{T}"/> as <paramref name="value"/>.</summary>
[AttributeUsage(AttributeTargets.Class)]
internal sealed class WireConstantAttribute(object value) : JsonConverterAttribute
{
    public override JsonConverter CreateConverter(Type type) =>
        Activator.CreateInstance(typeof(WireConstantConverter<>).MakeGenericType(type), [value]) as JsonConverter
        ?? throw new InvalidOperationException("No converter of " + type.Name + ".");
}

/// <summary>
/// A model read from and written to its schema's object. What each property is comes from its declaration:
/// one with no setter is the schema's constant, a <c>required</c> one must be present (and is null only where its type admits null), and any other is absent when null.
/// The model is validated against its schema, named as the type is, and its members are written in the order they are declared, its schema's order.
/// </summary>
internal sealed class WireObjectConverter<T> : JsonConverter<T>
    where T : class
{
    private static readonly string Schema = typeof(T).Name;
    private static readonly Member[] Members = typeof(T)
        .GetProperties(BindingFlags.Public | BindingFlags.Instance)
        .Select(Member.Of)
        .OfType<Member>()
        .OrderBy(member => member.Property.MetadataToken)
        .ToArray();
    private static readonly string[] Named = Members.Select(member => member.Wire).ToArray();
    private static readonly PropertyInfo? Rest = typeof(T)
        .GetProperties(BindingFlags.Public | BindingFlags.Instance)
        .SingleOrDefault(property => property.IsDefined(typeof(WireRestAttribute))) is not { } rest
        ? null
        : rest.PropertyType.IsGenericType && rest.PropertyType.GetGenericTypeDefinition() == typeof(IReadOnlyDictionary<,>)
            ? rest
            : throw new InvalidOperationException(Schema + "." + rest.Name + " is no IReadOnlyDictionary.");
    private static readonly Type? RestRead = Rest is null ? null : typeof(Dictionary<,>).MakeGenericType(Rest.PropertyType.GetGenericArguments());

    public override T Read(ref Utf8JsonReader reader, Type type, JsonSerializerOptions options)
    {
        using var document = JsonDocument.ParseValue(ref reader);
        var root = document.RootElement;
        WireJson.Validate(Schema, root);
        var model = Activator.CreateInstance(typeof(T)) as T ?? throw new JsonException("Cannot make a " + Schema + ".");
        foreach (var member in Members)
        {
            member.Read(root, model, options);
        }
        if (Rest is not null && RestRead is not null)
        {
            Rest.SetValue(model, WireJson.Read(JsonSerializer.SerializeToElement(WireJson.Extra(root, Named)), RestRead, options));
        }
        return model;
    }

    public override void Write(Utf8JsonWriter writer, T value, JsonSerializerOptions options)
    {
        var fields = new Dictionary<string, JsonElement>();
        foreach (var member in Members)
        {
            member.Write(value, fields, options);
        }
        if (Rest is not null)
        {
            var rest = Rest.GetValue(value) ?? throw new JsonException(Schema + "." + Rest.Name + " is null.");
            foreach (var pair in JsonSerializer.SerializeToElement(rest, Rest.PropertyType, options).EnumerateObject())
            {
                fields.Add(pair.Name, pair.Value);
            }
        }
        WireJson.WriteObject(writer, Schema, fields);
    }

    private enum Kind
    {
        Constant,
        Required,
        RequiredNullable,
        Optional,
    }

    private sealed record Member(string Wire, PropertyInfo Property, Kind Kind, Type Value)
    {
        private static readonly NullabilityInfoContext Nullability = new();

        internal static Member? Of(PropertyInfo property)
        {
            if (property.GetCustomAttribute<WireAttribute>() is not { } wire)
            {
                return null;
            }
            var type = property.PropertyType;
            var underlying = Nullable.GetUnderlyingType(type);
            if (!property.CanWrite)
            {
                return new(wire.Name, property, Kind.Constant, type);
            }
            if (property.IsDefined(typeof(RequiredMemberAttribute)))
            {
                var nullable = underlying is not null || Nullability.Create(property).WriteState == NullabilityState.Nullable;
                return new(wire.Name, property, nullable ? Kind.RequiredNullable : Kind.Required, underlying ?? type);
            }
            return new(wire.Name, property, Kind.Optional, underlying ?? type);
        }

        internal void Read(JsonElement root, object model, JsonSerializerOptions options)
        {
            switch (Kind)
            {
                case Kind.Required:
                    Property.SetValue(model, WireJson.ReadMember(root, Wire, Value, options));
                    break;
                case Kind.RequiredNullable:
                    Property.SetValue(model, root.GetProperty(Wire).ValueKind == JsonValueKind.Null ? null : WireJson.ReadMember(root, Wire, Value, options));
                    break;
                case Kind.Optional:
                    if (root.TryGetProperty(Wire, out var optional))
                    {
                        Property.SetValue(model, WireJson.Read(optional, Value, options));
                    }
                    break;
                case Kind.Constant:
                    break;
            }
        }

        internal void Write(object model, Dictionary<string, JsonElement> fields, JsonSerializerOptions options)
        {
            var value = Property.GetValue(model);
            if (value is JsonElement { ValueKind: JsonValueKind.Undefined })
            {
                throw new JsonException(Schema + "." + Wire + " is unset.");
            }
            switch (Kind)
            {
                case Kind.Constant:
                case Kind.Required:
                case Kind.RequiredNullable:
                    fields.Add(Wire, JsonSerializer.SerializeToElement(value, Property.PropertyType, options));
                    break;
                case Kind.Optional:
                    if (value is not null)
                    {
                        fields.Add(Wire, JsonSerializer.SerializeToElement(value, Property.PropertyType, options));
                    }
                    break;
            }
        }
    }
}

/// <summary>
/// A union read as the one member whose signature admits the value (<see cref="Signature.Member"/>), validated against
/// that member's schema, and written as the member it holds. A value one member names but does not admit is refused as
/// that member says, and one none names is refused. Its cases are the records nested in it, one per member, each
/// holding its member as <c>Value</c>, given in the members' order, and its <c>Members</c> each one's signatures.
/// </summary>
internal sealed class WireUnionConverter<T> : JsonConverter<T>
    where T : class
{
    private static readonly string Schema = typeof(T).Name;
    private static readonly Signature[][] Members =
        typeof(T).GetField("Members", BindingFlags.NonPublic | BindingFlags.Static)?.GetValue(null) as Signature[][]
        ?? throw new InvalidOperationException(Schema + " states no Members.");
    private readonly Type[] cases;

    public WireUnionConverter(Type[] cases)
    {
        var nested = typeof(T).GetNestedTypes().Where(type => type.BaseType == typeof(T)).ToHashSet();
        if (!nested.SetEquals(cases) || nested.Count != cases.Length)
        {
            throw new InvalidOperationException("The cases of " + Schema + " are not the records nested in it.");
        }
        if (Members.Length != cases.Length)
        {
            throw new InvalidOperationException(Schema + " states a signature of " + Members.Length + " members, and has " + cases.Length + " cases.");
        }
        this.cases = cases;
    }

    public override T Read(ref Utf8JsonReader reader, Type type, JsonSerializerOptions options)
    {
        using var document = JsonDocument.ParseValue(ref reader);
        var root = document.RootElement;
        var (at, admitted) = Signature.Member(root, Members) ?? throw new JsonException(Signature.NoneOf(Schema, Members));
        WireJson.ValidateMember(Schema, at, root);
        var held = cases[at];
        var value = WireJson.Read(root, ValueOf(held).PropertyType, options);
        if (!admitted)
        {
            throw new JsonException("a " + Schema + " its member " + held.Name + " does not admit");
        }
        return Activator.CreateInstance(held, value) as T ?? throw new JsonException("Cannot make a " + Schema + ".");
    }

    public override void Write(Utf8JsonWriter writer, T value, JsonSerializerOptions options)
    {
        var held = value.GetType();
        if (Array.IndexOf(cases, held) < 0)
        {
            throw new JsonException("Unknown union variant.");
        }
        var property = ValueOf(held);
        JsonSerializer.Serialize(writer, property.GetValue(value), property.PropertyType, options);
    }

    private static PropertyInfo ValueOf(Type held) =>
        held.GetProperty("Value") ?? throw new JsonException(held.Name + " holds no Value.");
}

/// <summary>
/// A type of one value, read from that value alone and written as it. Its one instance is its <c>Value</c>.
/// </summary>
internal sealed class WireConstantConverter<T>(object value) : JsonConverter<T>
    where T : class
{
    private static readonly string Schema = typeof(T).Name;
    private static readonly T Instance =
        typeof(T).GetField("Value", BindingFlags.Public | BindingFlags.Static)?.GetValue(null) as T
        ?? throw new InvalidOperationException(Schema + " holds no Value.");
    private readonly JsonElement wire = JsonSerializer.SerializeToElement(value);

    public override T Read(ref Utf8JsonReader reader, Type type, JsonSerializerOptions options)
    {
        using var document = JsonDocument.ParseValue(ref reader);
        return JsonElement.DeepEquals(document.RootElement, wire)
            ? Instance
            : throw new JsonException("a " + Schema + " is " + wire.GetRawText());
    }

    public override void Write(Utf8JsonWriter writer, T value, JsonSerializerOptions options) => wire.WriteTo(writer);
}

/// <summary>An enumeration read from and written as the string each constant's <see cref="JsonStringEnumMemberNameAttribute"/> names.</summary>
internal sealed class WireEnumConverter<T> : JsonConverter<T>
    where T : struct, Enum
{
    private static readonly string Schema = typeof(T).Name;
    private static readonly (T Constant, string Wire)[] Constants = typeof(T)
        .GetFields(BindingFlags.Public | BindingFlags.Static)
        .Select(field => (
            field.GetValue(null) is T constant ? constant : throw new InvalidOperationException(field.Name + " is no " + Schema + "."),
            field.GetCustomAttribute<JsonStringEnumMemberNameAttribute>()?.Name ?? throw new InvalidOperationException(field.Name + " names no wire value.")))
        .ToArray();

    public override T Read(ref Utf8JsonReader reader, Type type, JsonSerializerOptions options)
    {
        using var document = JsonDocument.ParseValue(ref reader);
        var root = document.RootElement;
        WireJson.Validate(Schema, root);
        return Constant(root.GetString());
    }

    public override void Write(Utf8JsonWriter writer, T value, JsonSerializerOptions options) => writer.WriteStringValue(Wire(value));

    /// <summary>A member's name of a map keyed by the enumeration, which the map's schema validates.</summary>
    public override T ReadAsPropertyName(ref Utf8JsonReader reader, Type type, JsonSerializerOptions options) => Constant(reader.GetString());

    public override void WriteAsPropertyName(Utf8JsonWriter writer, T value, JsonSerializerOptions options) => writer.WritePropertyName(Wire(value));

    private static T Constant(string? text)
    {
        foreach (var (constant, wire) in Constants)
        {
            if (wire == text)
            {
                return constant;
            }
        }
        throw new JsonException("Unknown enumeration value.");
    }

    /// <summary>The string <paramref name="value"/> is on the wire.</summary>
    internal static string Wire(T value)
    {
        foreach (var (constant, wire) in Constants)
        {
            if (EqualityComparer<T>.Default.Equals(constant, value))
            {
                return wire;
            }
        }
        throw new JsonException("Unknown enumeration value.");
    }
}
