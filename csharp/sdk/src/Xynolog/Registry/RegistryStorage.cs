using System.Buffers.Text;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.Json.Serialization;
using Xynolog.Identifiers;
using Xynolog.SignIn;
using Xynolog.Storage;
using Xynolog.Types;

namespace Xynolog.Registry;

/// <summary>The storage keys and records under which a registry keeps its knowledge bases, their sign-ins and their
/// open resources.</summary>
public static partial class RegistryStorage
{
    internal static readonly JsonSerializerOptions Json = new()
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull,
    };


    /// <summary>
    /// The key what a client keeps for a person is kept under, never their did: the unpadded base64url SHA-256 of the
    /// UTF-8 of <paramref name="did"/>, as the gateway answers who a token is.
    /// </summary>
    public static string PersonKey(UserId did) => Base64Url.EncodeToString(SHA256.HashData(Encoding.UTF8.GetBytes(did.Value)));
    internal static string LastEventIdKey(string kbId, string personKey) => LastEventIdKeyPrefix + kbId + "." + personKey;
    internal static string CacheKey(string kbId, string personKey, string query) => CacheKeyPrefix + kbId + "." + personKey + "." + query;

    /// <summary>The storage key of a knowledge base's stored sign-in.</summary>
    public static string SessionKey(string kbId) => SessionKeyPrefix + kbId;
    /// <summary>The knowledge base whose stored sign-in a storage key holds, or null for a key that holds none.</summary>
    public static string? KbOfSessionKey(string key) => key.StartsWith(SessionKeyPrefix, StringComparison.Ordinal) ? key[SessionKeyPrefix.Length..] : null;
    /// <summary>A knowledge base's stored sign-in, or null when none is stored or it cannot be read.</summary>
    public static StoredSession? StoredSession(ISessionStorage storage, string kbId) => Read<StoredSession>(storage.Get(SessionKey(kbId)));

    /// <summary>
    /// Saves a new sign-in for <paramref name="kbId"/> in place of the stored one, forgetting what is kept for the person
    /// the replaced one named: a new sign-in names nobody until its gateway names them, even when they are that person.
    /// </summary>
    public static void StoreSession(ISessionStorage storage, string kbId, StoredSession session) =>
        ForgetKept(storage, kbId, SwapStoredSession(storage, kbId, session));

    /// <summary>Forgets <paramref name="kbId"/>'s stored sign-in, and with it what is kept for the person it names.</summary>
    public static void ClearStoredSession(ISessionStorage storage, string kbId) => ForgetKept(storage, kbId, SwapStoredSession(storage, kbId, null));

    /// <summary>
    /// Puts <paramref name="replacement"/> in place of <paramref name="kbId"/>'s stored sign-in as one step, storing
    /// nothing for none, and gives back the sign-in it replaced.
    /// </summary>
    internal static StoredSession? SwapStoredSession(ISessionStorage storage, string kbId, StoredSession? replacement)
    {
        StoredSession? replaced = null;
        storage.Update(SessionKey(kbId), value =>
        {
            replaced = Read<StoredSession>(value);
            return replacement is null ? null : Write(replacement);
        });
        return replaced;
    }

    /// <summary>
    /// Deletes what is kept on one knowledge base for the person a forgotten saved sign-in named, as forgetting it does:
    /// the key of every persisted query and the stream's. A sign-in that named nobody, or none, deletes nothing.
    /// </summary>
    internal static void ForgetKept(ISessionStorage storage, string kbId, StoredSession? forgotten)
    {
        if (forgotten is not { PersonKey: { } personKey }) return;
        foreach (var query in LiveQueries.PersistedQueries) storage.Delete(CacheKey(kbId, personKey, query));
        storage.Delete(LastEventIdKey(kbId, personKey));
    }

    /// <summary>The registered knowledge bases, leaving out any stored entry that cannot be read.</summary>
    public static IReadOnlyList<KnowledgeBase> LoadKnowledgeBases(ISessionStorage storage) => ReadKnowledgeBases(storage.Get(KnowledgeBasesKey));
    /// <summary>Stores the registered knowledge bases in place of those stored.</summary>
    public static void SaveKnowledgeBases(ISessionStorage storage, IReadOnlyList<KnowledgeBase> kbs) => storage.Set(KnowledgeBasesKey, Write(kbs));
    /// <summary>What holds a knowledge base's sign-in in the storage, for a session to read, renew and forget.</summary>
    public static ISignInKept KeptIn(ISessionStorage storage, string kbId) => new RegistrySignIn(storage, kbId, () => ClearStoredSession(storage, kbId));

    /// <summary>
    /// What holds a registry session's sign-in in the storage its client keeps in: forgetting it waits for a save of the
    /// client's persistence already being written, and ends its saves.
    /// </summary>
    internal static ISignInKept KeptFor(CachePersistence persistence) =>
        new RegistrySignIn(persistence.Storage, persistence.KbId, persistence.Forget);

    internal static IReadOnlyList<KnowledgeBase> ReadKnowledgeBases(string? json)
    {
        var values = Read<JsonElement[]>(json) ?? [];
        var kbs = new List<KnowledgeBase>();
        foreach (var value in values)
        {
            try { if (value.Deserialize<KnowledgeBase>() is { } kb) kbs.Add(kb); }
            catch (JsonException) { /* Other entries still belong to the registry. */ }
        }
        return kbs.AsReadOnly();
    }

    internal static T? Read<T>(string? json) where T : class
    {
        if (json is null) return null;
        try { return JsonSerializer.Deserialize<T>(json, Json); }
        catch (JsonException) { return null; }
    }

    internal static string Write<T>(T value) => JsonSerializer.Serialize(value, Json);

    /// <summary><paramref name="forget"/> forgets the stored sign-in and what is kept for the person it names.</summary>
    private sealed class RegistrySignIn(ISessionStorage storage, string kbId, Action forget) : ISignInKept
    {
        public Task<StoredSession?> HeldAsync(CancellationToken cancellation = default)
        {
            cancellation.ThrowIfCancellationRequested();
            return Task.FromResult(StoredSession(storage, kbId));
        }

        public Task KeepAsync(StoredSession signIn, CancellationToken cancellation = default)
        {
            cancellation.ThrowIfCancellationRequested();
            StoreSession(storage, kbId, signIn);
            return Task.CompletedTask;
        }

        public Task ForgetAsync(CancellationToken cancellation = default)
        {
            cancellation.ThrowIfCancellationRequested();
            forget();
            return Task.CompletedTask;
        }

        public Task<string?> RenewedAsync(StoredSession read, string access, string refresh, CancellationToken cancellation = default)
        {
            cancellation.ThrowIfCancellationRequested();
            string? adopted = null;
            storage.Update(SessionKey(kbId), value =>
            {
                if (Read<StoredSession>(value) is not { } stored) return value;
                if (stored.Access != read.Access || stored.Refresh != read.Refresh) { adopted = stored.Access; return value; }
                adopted = access;
                return Write(stored with { Access = access, Refresh = refresh });
            });
            return Task.FromResult(adopted);
        }

        public Task<bool> RecordPersonKeyAsync(string access, string personKey, CancellationToken cancellation = default)
        {
            cancellation.ThrowIfCancellationRequested();
            var recorded = false;
            storage.Update(SessionKey(kbId), value =>
            {
                if (Read<StoredSession>(value) is not { } stored || stored.Access != access) return value;
                if (stored.PersonKey is { } named) { recorded = named == personKey; return value; }
                recorded = true;
                return Write(stored with { PersonKey = personKey });
            });
            return Task.FromResult(recorded);
        }
    }
}

/// <summary>Orders a knowledge base's tabs, and brings them up to date with what checking their resources found.</summary>
public static class OpenResources
{
    /// <summary>The tabs in their tab order, the earlier opened first among tabs of equal place.</summary>
    public static IReadOnlyList<OpenResource> SortOpenResources(IReadOnlyList<OpenResource> resources) =>
        Array.AsReadOnly(resources.OrderBy(tab => tab.Order).ThenBy(tab => tab.OpenedAt).ToArray());

    /// <summary>Drops the tabs whose resource is gone, and takes the name and media type of each resource found
    /// ready.</summary>
    public static IReadOnlyList<OpenResource> ApplyTabChecks(IReadOnlyList<OpenResource> opened, IReadOnlyDictionary<ResourceId, TabCheck> checks)
    {
        var tabs = new List<OpenResource>();
        foreach (var tab in opened)
        {
            var check = checks.GetValueOrDefault(tab.Id);
            if (check is TabCheck.Gone) continue;
            tabs.Add(check is TabCheck.Ready(var ready)
                ? tab with { Name = ready.Name, MediaType = ready.MediaType ?? tab.MediaType } : tab);
        }
        return tabs.AsReadOnly();
    }
}
