using System.Text.Json;

namespace Xynolog.Protocol;

internal static class ProtocolTable
{
    internal static T Read<T>(string table) where T : class =>
        JsonSerializer.Deserialize<T>(table) ?? throw new InvalidOperationException("A Protocol table is null.");
}
