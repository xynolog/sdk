@file:OptIn(kotlin.ExperimentalStdlibApi::class)

package xynolog.namespaces

import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.flowOf
import kotlinx.coroutines.flow.runningFold
import xynolog.bus.Operations
import xynolog.cache.Cache
import xynolog.cache.CacheState
import xynolog.cache.Cached
import xynolog.cache.Keyed
import xynolog.cache.Source
import xynolog.cache.shown
import xynolog.channels.Channels
import xynolog.identifiers.AnnotationId
import xynolog.identifiers.ResourceId
import xynolog.registry.WHOLE_KEY
import xynolog.resources.decodeRepresentation
import xynolog.transport.ContentStream
import xynolog.transport.ContentTransport
import xynolog.transport.ResourceHold
import xynolog.types.AnchorRect
import xynolog.types.AnchoredTextAnswer
import xynolog.types.Annotation
import xynolog.types.AttributedEvent
import xynolog.types.BrowseAnnotationHistoryRequest
import xynolog.types.BrowseClickEvent
import xynolog.types.BrowseDirectoryRequest
import xynolog.types.BrowseDirectoryRequestSort
import xynolog.types.BrowseDirectoryResultResponse
import xynolog.types.BrowseEventsRequest
import xynolog.types.BrowseKbRequest
import xynolog.types.BrowseResourceOpenEvent
import xynolog.types.BrowseResourceViewedEvent
import xynolog.types.BrowseResourcesRequest
import xynolog.types.EngineEntry
import xynolog.types.EngineLimits
import xynolog.types.EngineWithLimits
import xynolog.types.EnginesWithLimits
import xynolog.types.GetAnnotationHistoryResponse
import xynolog.types.GetResourceResponse
import xynolog.types.KbDescription
import xynolog.types.ListResourcesResponse
import xynolog.types.ResourceDescriptor
import xynolog.types.ResourceRepresentation
import xynolog.types.TagSchema
import java.util.concurrent.CompletableFuture

/** The engines with each reported engine's limits on its entries. */
private fun joined(engines: List<EngineEntry>, reported: List<EngineLimits>): EnginesWithLimits {
    val byEngine = reported.reversed().associate { it.engine to it.limits }
    return engines.map { entry -> EngineWithLimits(engine = entry.engine, jobs = entry.jobs, limits = byEngine[entry.engine]) }
}

/**
 * The engines with each key holder's limits joined on. The engines are asked
 * for first; a holder that has not answered delays only its own engines'
 * limits, and one that answered nothing reports none.
 */
private class Engines(private val live: Live) : Source<EnginesWithLimits> {
    override suspend fun fresh(): EnginesWithLimits = coroutineScope {
        val engines = async(start = CoroutineStart.UNDISPATCHED) { live.engines.fetch(WHOLE_KEY) }
        val reports = LIMITS_HOLDERS.map { async(start = CoroutineStart.UNDISPATCHED) { live.limits.fetch(it) } }
        joined(engines.await(), reports.awaitAll().flatten())
    }

    override fun watch(): Flow<CacheState<EnginesWithLimits>> {
        val engines = live.engines.observe(WHOLE_KEY)
        // A holder's report is pending, then what it reported: it never fails (`Live`).
        val reports = LIMITS_HOLDERS.map { holder ->
            live.limits.observe(holder).runningFold(emptyList<EngineLimits>()) { reported, state -> (state as? CacheState.Ready)?.value ?: reported }
        }
        val reported = if (reports.isEmpty()) flowOf(emptyList()) else combine(reports) { it.toList().flatten() }
        // A report that changes nothing a collector is shown is not a state.
        return combine(engines, reported) { entries, limits -> entries.shown { joined(it, limits) } }.distinctUntilChanged()
    }

    override fun invalidate(): Unit = live.invalidateEngines()

    override fun hold(): ResourceHold? = null
}

/** Reads: one-shot reads, and this viewer's own signals. */
public class BrowseNamespace internal constructor(private val links: Links, private val content: ContentTransport, private val live: Live) {
    /** A query of one resource: collecting it holds the resource's scope. */
    private fun <K : Any, V : Any, T : Any> of(resourceId: ResourceId, cache: Cache<K, V>, key: K, view: (V) -> T): Cached<T> =
        live.query(Keyed(cache, key, view, links.transport to resourceId))

    /** A resource's description: a live query. */
    @JvmExposeBoxed
    public fun resource(resourceId: ResourceId): Cached<ResourceDescriptor> = of(resourceId, live.resource, resourceId) { it }

    /**
     * A page of the resources the filters admit, `offset` of them passed over
     * before the page begins, and the service's own page when they state
     * none: a live query. It is kept true by what every client hears and by
     * the events of the resources this client holds the scope of, and by
     * nothing else. Finding resources by text is `match.resources`.
     */
    @JvmOverloads
    public fun resources(filters: BrowseResourcesRequest = BrowseResourcesRequest()): Cached<ListResourcesResponse> =
        live.query(Keyed(live.resources, filters, { it }))

    /** A resource's annotations: a live query. */
    @JvmExposeBoxed
    public fun annotations(resourceId: ResourceId): Cached<List<Annotation>> = of(resourceId, live.annotations, resourceId, ::listed)

    /** One annotation of a resource: a live query. */
    @JvmExposeBoxed
    public fun annotation(resourceId: ResourceId, annotationId: AnnotationId): Cached<Annotation> {
        live.annotationOf[annotationId] = resourceId
        return of(resourceId, live.annotation, annotationId) { it }
    }

    /** The knowledge base's entity types: a live query. */
    public fun entityTypes(): Cached<List<String>> = live.query(Keyed(live.entityTypes, WHOLE_KEY, { it }))

    /** The knowledge base's tag schemas: a live query. */
    public fun tagSchemas(): Cached<List<TagSchema>> = live.query(Keyed(live.tagSchemas, WHOLE_KEY, { it }))

    /** The knowledge base's engines, with each engine's limits as the services holding its provider's credentials report them: a live query. */
    public fun engines(): Cached<EnginesWithLimits> = live.query(Engines(live))

    /** A resource's events, each with who it is attributed to: a live query. */
    @JvmExposeBoxed
    public fun events(resourceId: ResourceId): Cached<List<AttributedEvent>> = of(resourceId, live.events, resourceId) { it }

    /** A resource's description as linked data: itself, its annotations and the references to it. */
    public suspend fun resourceGraph(resourceId: ResourceId): GetResourceResponse = content.getResourceGraph(resourceId)

    /** `resourceGraph`, for Java. */
    @JvmExposeBoxed
    public fun resourceGraphFuture(resourceId: ResourceId): CompletableFuture<GetResourceResponse> = links.future { resourceGraph(resourceId) }

    /** A resource's anchored text: the text of its content with where each run is on a page, a stored decline, or why there is none. */
    public suspend fun resourceAnchoredText(resourceId: ResourceId): AnchoredTextAnswer = content.getAnchoredText(resourceId)

    /** `resourceAnchoredText`, for Java. */
    @JvmExposeBoxed
    public fun resourceAnchoredTextFuture(resourceId: ResourceId): CompletableFuture<AnchoredTextAnswer> = links.future { resourceAnchoredText(resourceId) }

    /**
     * A resource's bytes as the text they are: in the charset their content
     * type states, UTF-8 when it states none, and in the encoding of a
     * byte-order mark where they begin with one. A resource whose text is not
     * its bytes is refused, as a charset that is not decoded is.
     */
    public suspend fun resourceContent(resourceId: ResourceId): String {
        val read = content.getBinary(resourceId)
        return decodeRepresentation(read.data, read.contentType)
    }

    /** `resourceContent`, for Java. */
    @JvmExposeBoxed
    public fun resourceContentFuture(resourceId: ResourceId): CompletableFuture<String> = links.future { resourceContent(resourceId) }

    /** A resource's bytes, unchanged, with their media type. */
    public suspend fun resourceRepresentation(resourceId: ResourceId): ResourceRepresentation = content.getBinary(resourceId)

    /** `resourceRepresentation`, for Java. */
    @JvmExposeBoxed
    public fun resourceRepresentationFuture(resourceId: ResourceId): CompletableFuture<ResourceRepresentation> = links.future { resourceRepresentation(resourceId) }

    /** The same, as they arrive. */
    public suspend fun resourceRepresentationStream(resourceId: ResourceId): ContentStream = content.getBinaryStream(resourceId)

    /** `resourceRepresentationStream`, for Java. */
    @JvmExposeBoxed
    public fun resourceRepresentationStreamFuture(resourceId: ResourceId): CompletableFuture<ContentStream> = links.future { resourceRepresentationStream(resourceId) }

    /** A resource's events, each with who it is attributed to, asked for now. */
    public suspend fun resourceEvents(resourceId: ResourceId): List<AttributedEvent> =
        links.request(Operations.BROWSE_EVENTS_REQUESTED, BrowseEventsRequest(resourceId = resourceId)).response.events

    /** `resourceEvents`, for Java. */
    @JvmExposeBoxed
    public fun resourceEventsFuture(resourceId: ResourceId): CompletableFuture<List<AttributedEvent>> = links.future { resourceEvents(resourceId) }

    /** The events of one annotation. */
    public suspend fun annotationHistory(resourceId: ResourceId, annotationId: AnnotationId): GetAnnotationHistoryResponse =
        links.request(Operations.BROWSE_ANNOTATION_HISTORY_REQUESTED, BrowseAnnotationHistoryRequest(resourceId = resourceId, annotationId = annotationId)).response

    /** `annotationHistory`, for Java. */
    @JvmExposeBoxed
    public fun annotationHistoryFuture(resourceId: ResourceId, annotationId: AnnotationId): CompletableFuture<GetAnnotationHistoryResponse> =
        links.future { annotationHistory(resourceId, annotationId) }

    /** The entries of a directory of the knowledge base's tree: its root when no path is stated, by name when no order is. */
    public suspend fun files(path: String = ".", sort: BrowseDirectoryRequestSort = BrowseDirectoryRequestSort.Name): BrowseDirectoryResultResponse =
        links.request(Operations.BROWSE_DIRECTORY_REQUESTED, BrowseDirectoryRequest(path = path, sort = sort)).response

    /** `files`, for Java. */
    public fun filesFuture(path: String, sort: BrowseDirectoryRequestSort): CompletableFuture<BrowseDirectoryResultResponse> = links.future { files(path, sort) }

    /** What the knowledge base says of itself: its name and domain, and its working tree's branch. Asked every time: a branch changes with no event to say so. */
    public suspend fun kb(): KbDescription = links.request(Operations.BROWSE_KB_REQUESTED, BrowseKbRequest).response

    /** `kb`, for Java. */
    public fun kbFuture(): CompletableFuture<KbDescription> = links.future { kb() }

    /** Signal: open an annotation for this viewer, and where it is on this viewer's screen when that is known. */
    @JvmOverloads
    @JvmExposeBoxed
    public fun click(annotationId: AnnotationId, anchorRect: AnchorRect? = null): Unit =
        links.signal(Channels.BROWSE_CLICK, BrowseClickEvent(anchorRect = anchorRect, annotationId = annotationId))

    /** Signal: open a resource for this viewer. */
    @JvmExposeBoxed
    public fun openResource(resourceId: ResourceId): Unit = links.signal(Channels.BROWSE_RESOURCE_OPEN, BrowseResourceOpenEvent(resourceId = resourceId))

    /** Report that this viewer is looking at a resource. It goes over the wire, and nobody awaits it. */
    @JvmExposeBoxed
    public fun resourceViewed(resourceId: ResourceId): Unit = links.report(Channels.BROWSE_RESOURCE_VIEWED, BrowseResourceViewedEvent(resourceId = resourceId))
}
