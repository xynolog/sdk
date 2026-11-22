using Xynolog.Types;

namespace Xynolog.SignIn;

/// <summary>Where a person's sign-in is kept between uses, and renewed and forgotten.</summary>
public interface ISignInKept
{
    /// <summary>The sign-in kept, or null when none is.</summary>
    public Task<StoredSession?> HeldAsync(CancellationToken cancellation = default);
    /// <summary>Keeps a sign-in, in place of any kept before.</summary>
    public Task KeepAsync(StoredSession signIn, CancellationToken cancellation = default);
    /// <summary>Keeps renewed tokens only while the kept sign-in still holds those of <paramref name="read"/>, giving the
    /// access token kept after: the renewed one, the one that replaced <paramref name="read"/>'s, or null when no sign-in
    /// is kept.</summary>
    public Task<string?> RenewedAsync(StoredSession read, string access, string refresh, CancellationToken cancellation = default);
    /// <summary>Forgets the kept sign-in.</summary>
    public Task ForgetAsync(CancellationToken cancellation = default);

    /// <summary>
    /// Records, as one step, the key of the person the gateway named for <paramref name="access"/>: only while the kept
    /// sign-in still holds that access token and names no other person. True when the sign-in then names
    /// <paramref name="personKey"/>; a store that keeps no person answers false.
    /// </summary>
    public Task<bool> RecordPersonKeyAsync(string access, string personKey, CancellationToken cancellation = default);
}

/// <summary>Keeps a sign-in in memory alone, for the life of the process.</summary>
/// <param name="signIn">The sign-in kept at the start, if any.</param>
public sealed class MemorySignIn(StoredSession? signIn = null) : ISignInKept
{
    private readonly object gate = new();
    private StoredSession? kept = signIn;
    /// <inheritdoc/>
    public Task<StoredSession?> HeldAsync(CancellationToken cancellation = default) { cancellation.ThrowIfCancellationRequested(); lock (gate) { return Task.FromResult(kept); } }
    /// <inheritdoc/>
    public Task KeepAsync(StoredSession signIn, CancellationToken cancellation = default) { cancellation.ThrowIfCancellationRequested(); lock (gate) { kept = signIn; } return Task.CompletedTask; }
    /// <inheritdoc/>
    public Task ForgetAsync(CancellationToken cancellation = default) { cancellation.ThrowIfCancellationRequested(); lock (gate) { kept = null; } return Task.CompletedTask; }
    /// <inheritdoc/>
    public Task<string?> RenewedAsync(StoredSession read, string access, string refresh, CancellationToken cancellation = default)
    {
        cancellation.ThrowIfCancellationRequested();
        lock (gate)
        {
            if (kept is null) return Task.FromResult<string?>(null);
            if (kept.Access != read.Access || kept.Refresh != read.Refresh) return Task.FromResult<string?>(kept.Access);
            kept = kept with { Access = access, Refresh = refresh };
            return Task.FromResult<string?>(access);
        }
    }

    /// <inheritdoc/>
    public Task<bool> RecordPersonKeyAsync(string access, string personKey, CancellationToken cancellation = default)
    {
        cancellation.ThrowIfCancellationRequested();
        lock (gate)
        {
            if (kept is null || kept.Access != access) return Task.FromResult(false);
            if (kept.PersonKey is { } named) return Task.FromResult(named == personKey);
            kept = kept with { PersonKey = personKey };
            return Task.FromResult(true);
        }
    }
}
