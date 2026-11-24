using System.Text;
using Xynolog.Errors;
using Xynolog.Http;
using Xynolog.Identifiers;
using Xynolog.Protocol;
using Xynolog.Types;
using static Xynolog.Resources.ResourceReaders;

namespace Xynolog.Namespaces;

/// <summary>Creating resources: by upload, by a generation delegated as a job, by cloning.</summary>
public sealed class YieldNamespace
{
    private readonly JobFollower follower;

    private readonly Bus wire;
    private readonly EventBus bus;
    private readonly HttpContentTransport content;

    internal YieldNamespace(JobFollower follower, Bus wire, EventBus bus, HttpContentTransport content)
    {
        this.follower = follower;
        this.wire = wire;
        this.bus = bus;
        this.content = content;
    }

    /// <summary>Uploads a new resource, reporting its progress and then the id of the resource created.</summary>
    public Upload Resource(ResourceUpload data, CancellationToken cancellation = default) => new(content, data, cancellation);

    /// <summary>Asks for a token, good until it expires, from which the resource can be cloned.</summary>
    public async Task<CloneResourceWithTokenResponse> CloneTokenAsync(ResourceId resourceId, CancellationToken cancellation = default) =>
        (await wire.RequestAsync(BusOperations.YieldCloneTokenRequested, new YieldCloneTokenRequest { ResourceId = resourceId },
            cancellation: cancellation).ConfigureAwait(Spawning.Captures)).Response;

    /// <summary>Asks for the resource a clone token was made from.</summary>
    public async Task<ResourceDescriptor> FromTokenAsync(string token, CancellationToken cancellation = default) =>
        (await wire.RequestAsync(BusOperations.YieldCloneResourceRequested, new YieldCloneResourceRequest { Token = token },
            cancellation: cancellation).ConfigureAwait(Spawning.Captures)).Response.SourceResource;

    /// <summary>Creates a clone of the token's resource with the name and content given, in the source's format, archiving the
    /// source when asked.</summary>
    public async Task<CreateResourceResponse> CreateFromTokenAsync(CreateFromTokenOptions options, CancellationToken cancellation = default)
    {
        ArgumentNullException.ThrowIfNull(options);
        var source = await FromTokenAsync(options.Token, cancellation).ConfigureAwait(Spawning.Captures);
        var mediaType = PrimaryMediaType(source);
        var format = MediaTypes.CloneFormat(mediaType);
        return await content.UploadAsync(new ResourceUpload
        {
            Name = options.Name,
            File = Encoding.UTF8.GetBytes(options.Content),
            Format = format,
            StorageUri = "file://" + MediaTypes.StorageFileName(options.Name, format),
            CloneToken = options.Token,
            ArchiveOriginal = options.ArchiveOriginal is bool archive ? archive ? "true" : "false" : null,
        }, null, cancellation).ConfigureAwait(Spawning.Captures);
    }

    /// <summary>Emits the clone signal, which carries no payload, on this client's own bus.</summary>
    public void Clone() => bus.Emit(BusChannels.YieldClone, new EmptyBusPayload());

    /// <summary>Follows generation grounded in the supplied context. The stall deadline applies locally.</summary>
    public Delegation<YieldJobCompleteCommand> Delegate(GenerationJobParams parameters, int? stallDeadlineMs = null)
    {
        var resource = parameters.Context.Focus switch
        {
            GatheredContextFocus.ResourceCase(var focus) => focus.Resource.Id,
            GatheredContextFocus.AnnotationCase(var focus) => focus.SourceResource.Id,
        };
        var stall = stallDeadlineMs ?? GenerationStallMs(parameters.MaxTokens);
        ArgumentOutOfRangeException.ThrowIfNegativeOrZero(stall);
        return follower.Follow(new JobCreateCommand.YieldJobCreateCommandCase(new YieldJobCreateCommand
        {
            Params = parameters,
        }), resource, JobCompletion.Yield, stall);
    }

    private static int GenerationStallMs(double? maxTokens)
    {
        var tokens = Math.Max(0, maxTokens ?? Timings.GenerationStallAssumedTokensCount);
        var duration = Math.Round(tokens * Timings.GenerationStallPerTokenMs, MidpointRounding.AwayFromZero);
        if (!double.IsFinite(duration) || duration > int.MaxValue)
            throw new TransportError(TransportErrorCode.Error, "The generation's stall deadline cannot be represented.");
        return Math.Max(Timings.GenerationStallFloorMs, (int)duration);
    }
}
