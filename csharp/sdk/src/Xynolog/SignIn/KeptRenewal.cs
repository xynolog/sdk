using Xynolog.Session;
using Xynolog.Types;

namespace Xynolog.SignIn;

internal static class KeptRenewal
{
    internal static async Task<string?> RenewAsync(ISignInKept kept, string? holding,
        Func<StoredSession, CancellationToken, Task<IssuedTokens>> grant,
        TimeProvider clock, CancellationToken cancellation = default)
    {
        var read = await kept.HeldAsync(cancellation).ConfigureAwait(Spawning.Captures);
        if (read is null) return null;
        if (read.Access != holding && !Tokens.IsTokenExpired(read.Access, clock.GetUtcNow().ToUnixTimeMilliseconds() / 1000d)) return read.Access;
        var issued = await grant(read, cancellation).ConfigureAwait(Spawning.Captures);
        return await kept.RenewedAsync(read, issued.Access, issued.Refresh, cancellation).ConfigureAwait(Spawning.Captures);
    }
}
