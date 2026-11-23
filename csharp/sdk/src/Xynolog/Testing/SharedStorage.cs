using Xynolog.Storage;

namespace Xynolog.Testing;

/// <summary>Contexts share atomic updates and observe writes from the other contexts.</summary>
public sealed class SharedStorage : ISessionStorage
{
    private readonly Shared shared;

    /// <summary>A storage with one context; <see cref="Context"/> adds more that share its values.</summary>
    public SharedStorage() : this(new Shared()) { }
    private SharedStorage(Shared shared) => this.shared = shared;

    /// <summary>Another context on the same values.</summary>
    public SharedStorage Context() => new(shared);
    /// <summary>The value kept under <paramref name="key"/>, or null.</summary>
    public string? Get(string key) { lock (shared) return shared.Values.GetValueOrDefault(key); }
    /// <summary>Keeps <paramref name="value"/> under <paramref name="key"/>, notifying the other contexts'
    /// subscribers.</summary>
    public void Set(string key, string value) => Update(key, _ => value);
    /// <summary>Removes the value under <paramref name="key"/>, notifying the other contexts' subscribers.</summary>
    public void Delete(string key) => Update(key, _ => null);

    /// <summary>Replaces the value under <paramref name="key"/> with what <paramref name="change"/> makes of it,
    /// atomically across contexts, and notifies the other contexts' subscribers when it changed; null removes
    /// it.</summary>
    public void Update(string key, Func<string?, string?> change)
    {
        string? next;
        Subscription[] notify;
        lock (shared)
        {
            var previous = shared.Values.GetValueOrDefault(key);
            next = change(previous);
            if (next == previous) return;
            if (next is null) shared.Values.Remove(key);
            else shared.Values[key] = next;
            notify = shared.Listeners.Where(listener => listener.Context != this).ToArray();
        }
        foreach (var listener in notify) listener.Notify(key, next);
    }

    /// <summary>Hands <paramref name="onChange"/> each key and new value another context writes, until the returned
    /// handle is disposed.</summary>
    public IDisposable Subscribe(Action<string, string?> onChange)
    {
        var subscription = new Subscription(this, onChange);
        lock (shared) shared.Listeners.Add(subscription);
        return subscription;
    }

    private sealed class Shared
    {
        internal Dictionary<string, string> Values { get; } = new(StringComparer.Ordinal);
        internal List<Subscription> Listeners { get; } = [];
    }

    private sealed class Subscription(SharedStorage context, Action<string, string?> notify) : IDisposable
    {
        internal SharedStorage Context { get; } = context;
        internal void Notify(string key, string? value) => notify(key, value);
        public void Dispose() { lock (Context.shared) Context.shared.Listeners.Remove(this); }
    }
}
