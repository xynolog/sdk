@file:OptIn(kotlin.ExperimentalStdlibApi::class)

package xynolog.namespaces

import xynolog.Delegation
import xynolog.Timings
import xynolog.bus.Operations
import xynolog.channels.Channels
import xynolog.identifiers.ResourceId
import xynolog.mediatypes.cloneFormat
import xynolog.mediatypes.storageUri
import xynolog.resources.primaryMediaType
import xynolog.transport.ContentTransport
import xynolog.transport.Upload
import xynolog.types.CloneResourceWithTokenResponse
import xynolog.types.CreateFromTokenOptions
import xynolog.types.CreateResourceResponse
import xynolog.types.EmptyObject
import xynolog.types.GatheredContextFocusAnnotation
import xynolog.types.GatheredContextFocusResource
import xynolog.types.GenerationJobParams
import xynolog.types.PutBinaryRequest
import xynolog.types.ResourceDescriptor
import xynolog.types.YieldCloneResourceRequest
import xynolog.types.YieldCloneTokenRequest
import xynolog.types.YieldJobCompleteCommand
import xynolog.types.YieldJobCreateCommand
import java.util.concurrent.CompletableFuture

/**
 * How long a followed generation may say nothing before its follower gives up
 * on it: a floor, and a wait that grows with the length asked for. A
 * generation says nothing while its model writes, so the silence it is
 * allowed depends on how much it was asked to write.
 */
internal fun generationStallDeadlineMs(maxTokens: Double?): Long {
    val tokens = maxTokens?.coerceAtLeast(0.0) ?: Timings.GENERATION_STALL_ASSUMED_TOKENS_COUNT.toDouble()
    return maxOf(Timings.GENERATION_STALL_FLOOR_MS, Math.round(Timings.GENERATION_STALL_PER_TOKEN_MS * tokens))
}

/** Creating resources: by upload, by a generation delegated as a job, by cloning. */
public class YieldNamespace internal constructor(private val links: Links, private val content: ContentTransport) {
    /** Upload a resource: it began when this returns, and reports its size, what it has sent as it sends it, and the resource made. */
    public fun resource(data: PutBinaryRequest): Upload = content.putBinary(data)

    /**
     * Delegate the making of a resource from a gathered context, as a `yield`
     * job: its progress and its completion. The context's focus says what the
     * job is about, so the job names no resource. A follower that hears
     * nothing for `stallDeadlineMs`, or for a wait that grows with
     * `params.maxTokens` when none is stated, asks for that job to be
     * cancelled and ends as stalled.
     */
    @JvmOverloads
    public fun delegate(params: GenerationJobParams, stallDeadlineMs: Long? = null): Delegation<YieldJobCompleteCommand> {
        val about = when (val focus = params.context.focus) {
            is GatheredContextFocusResource -> focus.resource.id
            is GatheredContextFocusAnnotation -> focus.sourceResource.id
        }
        val within = stallDeadlineMs ?: generationStallDeadlineMs(params.maxTokens)
        return follow(links, YieldJobCreateCommand(params = params), YieldJobCompleteCommand::class.java, about, within)
    }

    /** A token another knowledge base, or this one, clones a resource by. */
    public suspend fun cloneToken(resourceId: ResourceId): CloneResourceWithTokenResponse =
        links.request(Operations.YIELD_CLONE_TOKEN_REQUESTED, YieldCloneTokenRequest(resourceId = resourceId)).response

    /** `cloneToken`, for Java. */
    @JvmExposeBoxed
    public fun cloneTokenFuture(resourceId: ResourceId): CompletableFuture<CloneResourceWithTokenResponse> = links.future { cloneToken(resourceId) }

    /** The resource a clone token reads. */
    public suspend fun fromToken(token: String): ResourceDescriptor =
        links.request(Operations.YIELD_CLONE_RESOURCE_REQUESTED, YieldCloneResourceRequest(token = token)).response.sourceResource

    /** `fromToken`, for Java. */
    public fun fromTokenFuture(token: String): CompletableFuture<ResourceDescriptor> = links.future { fromToken(token) }

    /**
     * Create a resource as a clone of the one `options.token` was made from.
     * The source is read first; the clone's content then goes by the upload
     * path, in the format its source's allows and under a name made from its
     * own. `archiveOriginal` archives the source once the clone exists.
     */
    public suspend fun createFromToken(options: CreateFromTokenOptions): CreateResourceResponse {
        val format = cloneFormat(primaryMediaType(fromToken(options.token)))
        val clone = PutBinaryRequest(
            name = options.name,
            file = options.content.toByteArray(),
            format = format.mediaType,
            storageUri = storageUri(options.name, format),
            cloneToken = options.token,
            archiveOriginal = options.archiveOriginal,
        )
        return content.putBinary(clone).use { it.await() }
    }

    /** `createFromToken`, for Java. */
    public fun createFromTokenFuture(options: CreateFromTokenOptions): CompletableFuture<CreateResourceResponse> =
        links.future { createFromToken(options) }

    /** Signal: a clone is begun in this viewer. */
    public fun clone(): Unit = links.signal(Channels.YIELD_CLONE, EmptyObject)
}
