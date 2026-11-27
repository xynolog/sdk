package xynolog.namespaces

import xynolog.bus.LIMITS_OPERATIONS
import xynolog.bus.Operations
import xynolog.cache.Cache
import xynolog.cache.CacheQuery
import xynolog.cache.CacheRefreshWhen
import xynolog.cache.Cached
import xynolog.cache.KeptCaches
import xynolog.cache.PERSISTED_QUERIES
import xynolog.cache.Source
import xynolog.errors.BusRequestError
import xynolog.errors.BusRequestErrorCode
import xynolog.errors.XynologError
import xynolog.identifiers.AnnotationId
import xynolog.identifiers.ResourceId
import xynolog.registry.WHOLE_KEY
import xynolog.storage.CachePersistence
import xynolog.transport.ContentTransport
import xynolog.types.Annotation
import xynolog.types.AttributedEvent
import xynolog.types.BrowseAnnotationRequest
import xynolog.types.BrowseEnginesRequest
import xynolog.types.BrowseEntityTypesRequest
import xynolog.types.BrowseEventsRequest
import xynolog.types.BrowseResourceRequest
import xynolog.types.BrowseResourcesRequest
import xynolog.types.BrowseTagSchemasRequest
import xynolog.types.EngineLimits
import xynolog.types.GatherReferencedByRequest
import xynolog.types.GetAnnotationsResponse
import xynolog.types.GetReferencedByResponseReferencedByItem
import xynolog.types.InferenceLimitsRequest
import xynolog.types.ListResourcesResponse
import xynolog.types.MatchResourcesRequest
import xynolog.types.MatchResourcesResponse
import xynolog.types.ResourceDescriptor
import java.util.concurrent.ConcurrentHashMap

/** The key of each key holder's report of its engines' limits: the name of the operation that asks it. */
internal val LIMITS_HOLDERS: List<String> = LIMITS_OPERATIONS.map { it.request.name }

private val HOLDERS = LIMITS_OPERATIONS.associateBy { it.request.name }

/** What an event names: which of a split channel's rows it is, the keys a row that reaches its subject acts on, and the value an enriched event carries. */
internal data class Subject(
    val whenIs: CacheRefreshWhen? = null,
    val resource: ResourceId? = null,
    val annotation: AnnotationId? = null,
    val written: Annotation? = null,
)

/**
 * The caches a client's queries answer from, and what an event does to them.
 * One of these is a client's: `browse`, `gather` and `match` make their
 * queries over it, and the client's refresher keeps it true.
 */
internal class Live(private val links: Links, private val content: ContentTransport, persistence: CachePersistence?) : KeptCaches {
    /** The resource each annotation that was asked for is of: an annotation is kept by its own id, and a request for it names its resource too. */
    val annotationOf = ConcurrentHashMap<AnnotationId, ResourceId>()

    // Each query's cache by the query's name (client/refresh.json), apart from `limits`, which `engines` shows beside it.
    override val resource = Cache(::resourceOf, links.scope)
    val resources = Cache(::resourcesOf, links.scope)
    override val annotations = Cache(content::getAnnotations, links.scope)
    override val annotation = Cache(::annotationOf, links.scope)
    override val entityTypes = Cache({ _: String -> links.request(Operations.BROWSE_ENTITY_TYPES_REQUESTED, BrowseEntityTypesRequest).response.entityTypes }, links.scope)
    override val tagSchemas = Cache({ _: String -> links.request(Operations.BROWSE_TAG_SCHEMAS_REQUESTED, BrowseTagSchemasRequest).response.tagSchemas }, links.scope)
    val engines = Cache({ _: String -> links.request(Operations.BROWSE_ENGINES_REQUESTED, BrowseEnginesRequest).response.engines }, links.scope)

    /** Each key holder's report of its engines' limits, by the operation that asks it. */
    val limits = Cache(::limitsOf, links.scope)
    val events = Cache(::eventsOf, links.scope)
    val referencedBy = Cache(::referencedByOf, links.scope)
    val matchedResources = Cache(::searchOf, links.scope)

    private val caches: List<Cache<*, *>> = listOf(resource, resources, annotations, annotation, entityTypes, tagSchemas, engines, limits, events, referencedBy, matchedResources)

    /** The caches of the queries a client with a storage keeps. */
    private val keptCaches: List<Cache<*, *>> = PERSISTED_QUERIES.map { it.cacheIn(this) }

    init {
        persistence?.let(::attach)
    }

    /** Keep the caches in `persistence` from now on, each beginning with what was kept there. */
    fun attach(persistence: CachePersistence): Unit = PERSISTED_QUERIES.forEach { it.attach(this, persistence) }

    /** Whether every cache the client keeps is at rest: none is fetching, and none owes a save. */
    val persistenceSettled: Boolean
        get() = keptCaches.none { it.persistencePending }

    /** Whether no cache the client keeps has a fetch in flight. */
    val keptFetchesSettled: Boolean
        get() = keptCaches.none { it.keptFetchInFlight }

    /** A live query of this client, answered from `source`. */
    fun <T : Any> query(source: Source<T>): Cached<T> = Cached(source, links.scope)

    // What each cache asks.

    private suspend fun resourceOf(resourceId: ResourceId): ResourceDescriptor =
        links.request(Operations.BROWSE_RESOURCE_REQUESTED, BrowseResourceRequest(resourceId = resourceId)).response.resource

    private suspend fun resourcesOf(request: BrowseResourcesRequest): ListResourcesResponse =
        links.request(Operations.BROWSE_RESOURCES_REQUESTED, request).response

    private suspend fun annotationOf(annotationId: AnnotationId): Annotation {
        val resourceId = annotationOf[annotationId]
            ?: throw BusRequestError(BusRequestErrorCode.Rejected, "Cannot ask for annotation ${annotationId.value}: the resource it is of is not known")
        return links.request(Operations.BROWSE_ANNOTATION_REQUESTED, BrowseAnnotationRequest(resourceId = resourceId, annotationId = annotationId)).response.annotation
    }

    /**
     * The engines one key holder reports the limits of. A holder that is down,
     * silent or mistaken reports none: its engines show no limits, and the
     * engines are not held up by it for longer than a request waits.
     */
    private suspend fun limitsOf(holder: String): List<EngineLimits> = try {
        links.request(HOLDERS.getValue(holder), InferenceLimitsRequest).response.limits
    } catch (_: XynologError) {
        emptyList()
    }

    /** A resource's events, each with who it is attributed to, asked for now. */
    suspend fun eventsOf(resourceId: ResourceId): List<AttributedEvent> =
        links.request(Operations.BROWSE_EVENTS_REQUESTED, BrowseEventsRequest(resourceId = resourceId)).response.events

    private suspend fun referencedByOf(resourceId: ResourceId): List<GetReferencedByResponseReferencedByItem> =
        links.request(Operations.GATHER_REFERENCED_BY_REQUESTED, GatherReferencedByRequest(resourceId = resourceId)).response.referencedBy

    private suspend fun searchOf(request: MatchResourcesRequest): MatchResourcesResponse =
        links.request(Operations.MATCH_RESOURCES_REQUESTED, request).response

    // What an event does.

    /** The event carries the value: it is written, and nothing is asked for. Only an annotation is ever carried. */
    fun write(query: CacheQuery, subject: Subject) {
        val resource = subject.resource ?: return
        val written = subject.written ?: return
        when (query) {
            // Into the resource's list, when the client holds it: where the annotation was, or at its end.
            CacheQuery.Annotations -> annotations.patch(resource) { held ->
                val listed = held.annotations.map { if (it.id == written.id) written else it }
                held.copy(annotations = if (held.annotations.any { it.id == written.id }) listed else listed + written)
            }
            CacheQuery.Annotation -> {
                annotationOf[written.id] = resource
                annotation.set(written.id, written)
            }
            else -> Unit
        }
    }

    /**
     * The event says the entity is gone; only an annotation is ever said to be.
     * One the cache holds is ended as not found. What says which resource it was
     * of is kept: an observer arriving at the ended key asks the service, and
     * that request names the resource.
     */
    fun remove(query: CacheQuery, subject: Subject) {
        val gone = subject.annotation ?: return
        if (query == CacheQuery.Annotation && annotation.known(gone)) {
            annotation.remove(gone, BusRequestError(BusRequestErrorCode.NotFound, "Annotation ${gone.value} was removed"))
        }
    }

    /** The engines are out of date, and so is what each key holder reported. */
    fun invalidateEngines() {
        engines.invalidate(WHOLE_KEY)
        LIMITS_HOLDERS.forEach(limits::invalidate)
    }

    /** End the queries: every collector's states end. */
    fun dispose() {
        caches.forEach { it.close() }
        annotationOf.clear()
    }
}

/** The annotations of a resource's list, as its query shows them. */
internal fun listed(answer: GetAnnotationsResponse): List<Annotation> = answer.annotations
