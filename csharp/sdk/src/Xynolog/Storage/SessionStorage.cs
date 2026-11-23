namespace Xynolog.Storage;

/// <summary>Caller-owned text storage. Update runs the read, transform and write as one operation.</summary>
public interface ISessionStorage
{
    /// <summary>Reads the value stored under the key, or null when none is.</summary>
    public string? Get(string key);
    /// <summary>Stores the value under the key, replacing any there.</summary>
    public void Set(string key, string value);
    /// <summary>Removes the value stored under the key.</summary>
    public void Delete(string key);
    /// <summary>Replaces the value under the key with what the change makes of it, removing it when the change gives null.</summary>
    public void Update(string key, Func<string?, string?> change);
    /// <summary>Observes writes from other contexts. A store without other contexts returns null.</summary>
    public IDisposable? Subscribe(Action<string, string?> onChange);
}

/// <summary>Storage held in this process's memory, lost when it ends.</summary>
public sealed class MemoryStorage : ISessionStorage
{
    private readonly object gate = new();
    private readonly Dictionary<string, string> values = new(StringComparer.Ordinal);

    /// <inheritdoc/>
    public string? Get(string key) { lock (gate) return values.GetValueOrDefault(key); }
    /// <inheritdoc/>
    public void Set(string key, string value) { lock (gate) values[key] = value; }
    /// <inheritdoc/>
    public void Delete(string key) { lock (gate) values.Remove(key); }

    /// <inheritdoc/>
    public void Update(string key, Func<string?, string?> change)
    {
        lock (gate)
        {
            if (change(values.GetValueOrDefault(key)) is { } next) values[key] = next;
            else values.Remove(key);
        }
    }

    /// <inheritdoc/>
    public IDisposable? Subscribe(Action<string, string?> onChange) => null;
}
