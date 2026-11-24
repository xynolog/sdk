using System.Text.Json;

namespace Xynolog.Protocol;

internal static class ProtocolFacts
{
    private static readonly JsonDocument Registry = JsonDocument.Parse(ProtocolTables.Registry);
    private static readonly JsonDocument RetryRules = JsonDocument.Parse(ProtocolTables.RetryRules);

    internal static string TraceField => Registry.RootElement.GetProperty("trace").GetProperty("field").GetString()
        ?? throw new InvalidOperationException("No trace field");

    /// <summary>The members a rule of retry/rules.json may state, each of which <see cref="Retries"/> reads.</summary>
    internal static IReadOnlyList<string> RetryRuleMembers { get; } = ["statuses", "statusFrom", "idempotentMethods", "noResponse"];

    private static bool Retries(string rule, int? status, string? method = null, bool keyed = false)
    {
        var stated = RetryRules.RootElement.GetProperty(rule);
        if (status is not int answered) return stated.TryGetProperty("noResponse", out var unanswered) && unanswered.GetBoolean();
        if (!keyed && stated.TryGetProperty("idempotentMethods", out var methods) &&
            !methods.EnumerateArray().Any(idempotent => string.Equals(idempotent.GetString(), method, StringComparison.OrdinalIgnoreCase)))
            return false;
        return stated.GetProperty("statuses").EnumerateArray().Any(retried => retried.GetInt32() == answered) ||
            (stated.TryGetProperty("statusFrom", out var from) && answered >= from.GetInt32());
    }

    internal static bool RetryEmit(int status) => Retries("boot", status);

    internal static bool RetryTransport(int? status, string? method, bool keyed) => Retries("transport", status, method, keyed);

    internal static bool RetryRefresh(int? status) => Retries("refresh", status);

    internal static long? RetryAfterMilliseconds(string? header)
    {
        var seconds = header.AsSpan().Trim();
        if (seconds.IsEmpty || seconds.ContainsAnyExceptInRange('0', '9')) return null;
        return long.TryParse(seconds, System.Globalization.NumberStyles.None, System.Globalization.CultureInfo.InvariantCulture, out var value)
            && value <= long.MaxValue / 1000 ? value * 1000 : null;
    }
}
