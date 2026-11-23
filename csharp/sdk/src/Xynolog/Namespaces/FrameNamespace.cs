using Xynolog.Types;

namespace Xynolog.Namespaces;

/// <summary>The knowledge base's vocabulary: what kinds of things exist.</summary>
public sealed class FrameNamespace
{
    private readonly Bus wire;

    internal FrameNamespace(Bus wire) => this.wire = wire;

    /// <summary>Adds the entity type to the knowledge base's vocabulary.</summary>
    public async Task AddEntityTypeAsync(string type, CancellationToken cancellation = default)
    {
        await wire.RequestAsync(BusOperations.FrameAddEntityType, new FrameAddEntityTypeCommand { Tag = type }, cancellation: cancellation).ConfigureAwait(Spawning.Captures);
    }

    /// <summary>Adds each entity type to the knowledge base's vocabulary, one after another.</summary>
    public async Task AddEntityTypesAsync(IEnumerable<string> types, CancellationToken cancellation = default)
    {
        foreach (var type in types)
            await AddEntityTypeAsync(type, cancellation).ConfigureAwait(Spawning.Captures);
    }

    /// <summary>Adds the tag schema to the knowledge base's vocabulary.</summary>
    public async Task AddTagSchemaAsync(TagSchema schema, CancellationToken cancellation = default)
    {
        await wire.RequestAsync(BusOperations.FrameAddTagSchema, new FrameAddTagSchemaCommand { Schema = schema }, cancellation: cancellation).ConfigureAwait(Spawning.Captures);
    }
}
