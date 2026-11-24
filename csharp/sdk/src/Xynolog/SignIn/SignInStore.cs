using Xynolog.Errors;
using System.Globalization;
using System.Text.Json;
using System.Text.Json.Nodes;
using Xynolog.Protocol;
using Xynolog.Session;
using Xynolog.Types;

namespace Xynolog.SignIn;

/// <summary>The sign-in store file <c>xynolog login</c> keeps, holding a sign-in for each key, which processes share
/// under a file lock.</summary>
public sealed partial class SignInStore
{
    private readonly string directory;
    private readonly TimeProvider clock;
    private readonly Random random;
    private static readonly JsonSerializerOptions Pretty = new() { WriteIndented = true };

    /// <summary>Opens the store in a directory, which is created when the store is first changed.</summary>
    public SignInStore(string directory, TimeProvider? timeProvider = null, Random? random = null)
    {
        this.directory = Path.GetFullPath(directory);
        clock = timeProvider ?? TimeProvider.System;
        this.random = random ?? Random.Shared;
        FilePath = Path.Combine(this.directory, ProtocolTables.StoreFileName);
    }

    /// <summary>The full path of the store's file.</summary>
    public string FilePath { get; }
    /// <summary>The sign-in kept under one key of the store.</summary>
    public ISignInKept Entry(string key) => new EntryKept(this, key);

    /// <summary>Reads the whole store, as an empty object when its file does not exist yet.</summary>
    public async Task<JsonObject> ReadAsync(CancellationToken cancellation = default)
    {
        try
        {
            using var file = new FileStream(FilePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite | FileShare.Delete, 4096, FileOptions.Asynchronous);
            return (await JsonNode.ParseAsync(file, cancellationToken: cancellation).ConfigureAwait(Spawning.Captures))?.AsObject() ?? throw new JsonException("The sign-in store holds no JSON object");
        }
        catch (FileNotFoundException) { return new JsonObject(); }
        catch (DirectoryNotFoundException) { return new JsonObject(); }
    }

    /// <summary>Changes the store under its lock: <paramref name="change"/> edits the document read, and the file is
    /// replaced with it whole when it answers true.</summary>
    public async Task ChangeAsync(Func<JsonObject, bool> change, CancellationToken cancellation = default)
    {
        StorePermissions.CreateDirectory(directory);
        using var held = await NativeStoreLock.HoldAsync(Path.Combine(directory, ProtocolTables.StoreLockName), StorePermissions.FileMode, clock, random, cancellation).ConfigureAwait(Spawning.Captures);
        StorePermissions.Keep(directory);
        var document = await ReadAsync(cancellation).ConfigureAwait(Spawning.Captures);
        if (!change(document)) return;
        var beside = FilePath + ".tmp";
        try
        {
            File.Delete(beside);
            var options = new FileStreamOptions { Mode = FileMode.CreateNew, Access = FileAccess.Write, Share = FileShare.None, Options = FileOptions.Asynchronous };
            if (!OperatingSystem.IsWindows()) options.UnixCreateMode = StorePermissions.FileMode;
            using (var file = new FileStream(beside, options))
            {
                await JsonSerializer.SerializeAsync(file, document, Pretty, cancellation).ConfigureAwait(Spawning.Captures);
                await file.WriteAsync(new byte[] { (byte)'\n' }, cancellation).ConfigureAwait(Spawning.Captures);
                await file.FlushAsync(cancellation).ConfigureAwait(Spawning.Captures);
            }
            File.Move(beside, FilePath, overwrite: true);
        }
        catch { File.Delete(beside); throw; }
    }

    private string Now() => clock.GetUtcNow().ToString("yyyy-MM-dd'T'HH:mm:ss'Z'", CultureInfo.InvariantCulture);
    private static string? Expires(string access) => Tokens.TokenExpiry(access) is double exp ? DateTimeOffset.UnixEpoch.AddSeconds(exp).ToString("yyyy-MM-dd'T'HH:mm:ss'Z'", CultureInfo.InvariantCulture) : null;
    private static global::Xynolog.Types.SignIn? ReadSignIn(JsonNode? node)
    {
        if (node is null) return null;
        try { return node.Deserialize<global::Xynolog.Types.SignIn>(); }
        catch (JsonException) { return null; }
    }

    private sealed class EntryKept(SignInStore store, string key) : ISignInKept
    {
        public async Task<StoredSession?> HeldAsync(CancellationToken cancellation = default)
        {
            var document = await store.ReadAsync(cancellation).ConfigureAwait(Spawning.Captures);
            var found = ReadSignIn(document[key]);
            if (found is null || string.IsNullOrEmpty(found.RefreshToken)) return null;
            return new StoredSession { Access = found.Token, Refresh = found.RefreshToken, ClientId = SignInPolicy.ScriptClientId, TokenEndpoint = found.TokenEndpoint, RevocationEndpoint = found.RevocationEndpoint };
        }

        public Task KeepAsync(StoredSession signIn, CancellationToken cancellation = default)
        {
            if (signIn.ClientId != SignInPolicy.ScriptClientId) throw new ArgumentException("The store keeps only the script client's sign-ins", nameof(signIn));
            var issuer = Tokens.TextClaim(signIn.Access, "iss") ?? throw new Xynolog.Errors.SignInError(SignInErrorCode.Exchange, "A sign-in names no issuer");
            var learned = new global::Xynolog.Types.SignIn
            {
                Token = signIn.Access,
                RefreshToken = signIn.Refresh,
                ObtainedAt = store.Now(),
                ExpiresAt = Expires(signIn.Access),
                Issuer = issuer,
                Email = Tokens.TextClaim(signIn.Access, "email"),
                TokenEndpoint = signIn.TokenEndpoint,
                RevocationEndpoint = signIn.RevocationEndpoint,
            };
            return store.ChangeAsync(document => { document[key] = JsonSerializer.SerializeToNode(learned); return true; }, cancellation);
        }

        public async Task<string?> RenewedAsync(StoredSession read, string access, string refresh, CancellationToken cancellation = default)
        {
            string? given = null;
            await store.ChangeAsync(document =>
            {
                var found = ReadSignIn(document[key]);
                if (found is null) return false;
                if (found.Token != read.Access || found.RefreshToken != read.Refresh) { given = found.Token; return false; }
                var renewed = found with { Token = access, RefreshToken = refresh, ObtainedAt = store.Now(), ExpiresAt = Expires(access) };
                document[key] = JsonSerializer.SerializeToNode(renewed);
                given = access;
                return true;
            }, cancellation).ConfigureAwait(Spawning.Captures);
            return given;
        }

        public Task ForgetAsync(CancellationToken cancellation = default) => store.ChangeAsync(document => document.Remove(key), cancellation);

        public Task<bool> RecordPersonKeyAsync(string access, string personKey, CancellationToken cancellation = default)
        {
            cancellation.ThrowIfCancellationRequested();
            // What `xynolog login` keeps (protocol/specs/src/sign-in-store/SignIn.json) has no member for a person.
            return Task.FromResult(false);
        }
    }

    /// <summary>Where the store lives on an operating system (<c>macos</c>, <c>windows</c> or any other, which follows the
    /// XDG layout), or null when no home directory is known.</summary>
    public static string? StateDirectory(string os, string? home, string? xdgStateHome = null, string? localAppData = null)
    {
        if (string.IsNullOrEmpty(home)) return null;
        return os switch
        {
            "macos" => home.TrimEnd('/') + "/Library/Application Support/xynolog",
            "windows" => (string.IsNullOrEmpty(localAppData) ? home.TrimEnd('\\') + "\\AppData\\Local" : localAppData.TrimEnd('\\')) + "\\xynolog",
            _ => (string.IsNullOrEmpty(xdgStateHome) ? home.TrimEnd('/') + "/.local/state" : xdgStateHome.TrimEnd('/')) + "/xynolog",
        };
    }
}
