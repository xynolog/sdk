using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.Json.Serialization;

/// <summary>A case's <c>timing</c>, whose rows a driver reads by name into what it builds. A name none of that holds is
/// the suite's mistake.</summary>
internal static class StatedTiming
{
    private static readonly JsonSerializerOptions Strict = new()
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        UnmappedMemberHandling = JsonUnmappedMemberHandling.Disallow,
    };

    /// <summary>The rows <paramref name="args"/> states: none when it states no timing.</summary>
    internal static JsonObject Rows(JsonElement args) => !args.TryGetProperty("timing", out var stated)
        ? new JsonObject()
        : JsonObject.Create(stated) ?? throw new InvalidOperationException("Null timing");

    /// <summary>Takes out of <paramref name="rows"/> those that name a member of <typeparamref name="T"/>.</summary>
    internal static JsonObject Take<T>(JsonObject rows)
    {
        var taken = new JsonObject();
        foreach (var property in typeof(T).GetProperties())
        {
            var name = JsonNamingPolicy.CamelCase.ConvertName(property.Name);
            if (!rows.TryGetPropertyValue(name, out var value)) continue;
            rows.Remove(name);
            taken.Add(name, value);
        }
        return taken;
    }

    /// <summary><paramref name="rows"/> as <typeparamref name="T"/>, which must hold every one of them.</summary>
    internal static T Read<T>(JsonObject rows) where T : class =>
        rows.Deserialize<T>(Strict) ?? throw new InvalidOperationException("Null " + typeof(T).Name);
}
