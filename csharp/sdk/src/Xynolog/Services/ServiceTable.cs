using System.Text.Json;

namespace Xynolog.Services;

internal static class ServiceTable
{
    internal static T Read<T>(string table) where T : class =>
        JsonSerializer.Deserialize<T>(table) ?? throw new InvalidOperationException("A service table is null.");
}
