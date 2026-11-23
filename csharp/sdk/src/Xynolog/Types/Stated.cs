using System.Text.Json;
using System.Text.Json.Serialization;

namespace Xynolog.Types;

/// <summary>A member a wire object may leave out: absent, the default, or present with a value that may itself be
/// null.</summary>
[JsonConverter(typeof(StatedJsonConverterFactory))]
public readonly struct Stated<T>
{
    private readonly T? value;

    /// <summary>A member present with <paramref name="value"/>.</summary>
    public Stated(T? value)
    {
        this.value = value;
        IsPresent = true;
    }

    /// <summary>Whether the member is present.</summary>
    public bool IsPresent { get; }

    /// <summary>The present member's value; reading it from an absent member throws
    /// <see cref="InvalidOperationException"/>.</summary>
    public T? Value => IsPresent ? value : throw new InvalidOperationException("An absent member has no value.");
}

internal sealed class StatedJsonConverterFactory : JsonConverterFactory
{
    public override bool CanConvert(Type type) => type.IsGenericType && type.GetGenericTypeDefinition() == typeof(Stated<>);

    public override JsonConverter CreateConverter(Type type, JsonSerializerOptions options) =>
        Activator.CreateInstance(typeof(StatedJsonConverter<>).MakeGenericType(type.GetGenericArguments())) is JsonConverter converter
            ? converter
            : throw new InvalidOperationException("Cannot construct a stated-member converter.");
}

internal sealed class StatedJsonConverter<T> : JsonConverter<Stated<T>>
{
    public override Stated<T> Read(ref Utf8JsonReader reader, Type type, JsonSerializerOptions options) =>
        new(JsonSerializer.Deserialize<T>(ref reader, options));

    public override void Write(Utf8JsonWriter writer, Stated<T> value, JsonSerializerOptions options)
    {
        if (!value.IsPresent)
        {
            throw new JsonException("An absent member must be omitted by its containing object.");
        }
        JsonSerializer.Serialize(writer, value.Value, options);
    }
}
