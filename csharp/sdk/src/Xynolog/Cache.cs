using Xynolog.Protocol;
using Xynolog.State;

namespace Xynolog;

/// <summary>A client or host owned cache. Equal keys share a live query and its pending fetch.</summary>
public sealed class Cache<TKey, T> : IStateUnit, IRefreshedCache where TKey : notnull
{
    private readonly object gate = new();
    private readonly Dictionary<TKey, CacheEntry<T>> entries = [];
    private readonly Func<TKey, CancellationToken, Task<T>> fetch;
    private readonly Func<TKey, IDisposable?>? hold;
    private readonly TimeProvider clock;
    private readonly TimeSpan window;
    private readonly Action? changed;
    private IKeptQuery? keeper;
    private bool closed;

    /// <summary>Makes an empty cache that fetches a key's value with <paramref name="fetch"/> when it is first observed or
    /// is invalidated.</summary>
    /// <param name="fetch">Fetches a key's current value.</param>
    /// <param name="timeProvider">The clock that times the Protocol's invalidation window; the system's when null.</param>
    public Cache(Func<TKey, CancellationToken, Task<T>> fetch, TimeProvider? timeProvider = null)
        : this(fetch, null, timeProvider ?? TimeProvider.System,
            TimeSpan.FromMilliseconds(Timings.InvalidationWindowMs))
    { }

    internal Cache(Func<TKey, CancellationToken, Task<T>> fetch, Func<TKey, IDisposable?>? hold, TimeProvider clock, TimeSpan window, Action? changed = null)
    {
        this.fetch = fetch;
        this.hold = hold;
        this.clock = clock;
        this.window = window;
        this.changed = changed;
    }

    /// <summary>The key's live view, which every caller observing an equal key shares.</summary>
    public Cached<T> Observe(TKey key) => Entry(key);

    internal CacheEntry<T> Entry(TKey key)
    {
        lock (gate)
        {
            if (entries.TryGetValue(key, out var found)) return found;
            var query = new CacheEntry<T>(cancellation => fetch(key, cancellation), () => hold?.Invoke(key), clock, window, changed);
            if (closed) query.Close();
            else entries.Add(key, query);
            return query;
        }
    }

    /// <summary>Asks the source for the key's current value, joining a fetch already in flight.</summary>
    public Task<T> FetchAsync(TKey key, CancellationToken cancellation = default) => Observe(key).FreshAsync(cancellation);
    /// <summary>The value the cache holds for the key now, or null when it holds none; fetches nothing.</summary>
    public CacheState<T>.Ready? Get(TKey key) => Find(key)?.CurrentValue;
    /// <summary>Whether the cache holds a value for the key or is fetching one.</summary>
    public bool Known(TKey key) => Find(key)?.IsKnown == true;
    /// <summary>The keys the cache holds a value for or is fetching.</summary>
    public IReadOnlyList<TKey> Keys() => Array.AsReadOnly(Snapshot().Where(pair => pair.Value.IsKnown).Select(pair => pair.Key).ToArray());

    /// <summary>A cache that keeps its values has not yet kept what it knows: a fetch is in flight, or a save is owed.</summary>
    public bool PersistencePending => keeper is { Pending: true };

    internal void KeptBy(IKeptQuery query) => keeper = query;

    internal bool Fetching => Snapshot().Any(pair => pair.Value.Fetching);
    bool IRefreshedCache.RefetchOwed => Snapshot().Any(pair => pair.Value.RefetchOwed);

    /// <summary>Marks the key's value stale and fetches it again.</summary>
    public void Invalidate(TKey key) => Observe(key).Invalidate();
    /// <summary>Fetches every key the cache holds again, at once.</summary>
    public void InvalidateAll()
    {
        foreach (var pair in Snapshot()) pair.Value.Refresh(coalesce: false);
    }

    /// <summary>Stores a value for the key in place of its fetch, letting go of any fetch in flight.</summary>
    public void Set(TKey key, T value) => Entry(key).Set(value);

    /// <summary>
    /// Writes part of <paramref name="key"/>'s value: <paramref name="change"/> takes the value to the patched one. It
    /// applies at once to the value the key holds, and to the reply of the key's fetch in flight when it lands, which
    /// <see cref="Set"/> would let go of. A key the cache does not hold is not changed.
    /// </summary>
    public void Patch(TKey key, Func<T, T> change)
    {
        if (Find(key) is { } entry) entry.Patch(change);
    }

    /// <summary>Drops the key's value, so its observers see it fail as not found.</summary>
    public void Remove(TKey key) => Entry(key).Remove();

    internal KeyValuePair<TKey, CacheEntry<T>>[] Snapshot()
    {
        lock (gate) return entries.ToArray();
    }

    internal CacheEntry<T>? Find(TKey key)
    {
        lock (gate) return entries.GetValueOrDefault(key);
    }

    /// <summary>Closes the cache: every key's live view ends, and fetches in flight are cancelled.</summary>
    public void Dispose()
    {
        CacheEntry<T>[] ending;
        lock (gate)
        {
            if (closed) return;
            closed = true;
            ending = entries.Values.ToArray();
            entries.Clear();
        }
        foreach (var query in ending) query.Close();
    }
}

/// <summary>A cache the refresher refetches through.</summary>
internal interface IRefreshedCache : IDisposable
{
    /// <summary>One of its keys' B19 windows holds an invalidation it has not yet run.</summary>
    public bool RefetchOwed { get; }
}
