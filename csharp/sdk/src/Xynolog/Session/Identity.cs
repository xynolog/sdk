using System.Text.Json;
using Xynolog.Identifiers;
using Xynolog.Protocol;

namespace Xynolog.Session;

/// <summary>The DIDs and addresses that name knowledge bases and the people and agents signed in to them.</summary>
public static class Identity
{
    private static readonly JsonElement Principals = JsonSerializer.Deserialize<JsonElement>(ProtocolTables.Principals);

    /// <summary>A knowledge base's <c>did:web:</c> DID, from its domain.</summary>
    public static UserId KbDid(string domain) => UserId.Parse("did:web:" + domain);

    /// <summary>The HTTPS address a knowledge base's did:web domain names, its colons read as path separators.</summary>
    public static string KbResource(string domain) => "https://" + domain.Replace(':', '/');

    /// <summary>The DID of the person an issuer names <paramref name="subject"/>, in the knowledge base at
    /// <paramref name="domain"/>.</summary>
    public static UserId PersonDid(string domain, string subject) => PrincipalDid("person", domain, subject);

    /// <summary>The DID of the agent an issuer names <paramref name="subject"/>, in the knowledge base at
    /// <paramref name="domain"/>.</summary>
    public static UserId AgentDid(string domain, string subject) => PrincipalDid("agent", domain, subject);

    private static UserId PrincipalDid(string kind, string domain, string subject)
    {
        var pattern = Principals.GetProperty(kind).GetString() ?? throw new InvalidOperationException("Missing principal DID pattern");
        var escaped = Uri.EscapeDataString(subject)
            .Replace("%21", "!", StringComparison.Ordinal)
            .Replace("%27", "'", StringComparison.Ordinal)
            .Replace("%28", "(", StringComparison.Ordinal)
            .Replace("%29", ")", StringComparison.Ordinal)
            .Replace("%2A", "*", StringComparison.Ordinal);
        return UserId.Parse(pattern.Replace("{subject}", escaped, StringComparison.Ordinal)
            .Replace("{domain}", domain, StringComparison.Ordinal));
    }
}
