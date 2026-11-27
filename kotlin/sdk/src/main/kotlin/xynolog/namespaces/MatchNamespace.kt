@file:OptIn(kotlin.ExperimentalStdlibApi::class)

package xynolog.namespaces

import xynolog.Running
import xynolog.bus.Operations
import xynolog.cache.Cached
import xynolog.cache.Keyed
import xynolog.identifiers.AnnotationId
import xynolog.identifiers.ResourceId
import xynolog.types.GatheredContext
import xynolog.types.MatchResourcesRequest
import xynolog.types.MatchResourcesResponse
import xynolog.types.MatchSearchOptions
import xynolog.types.MatchSearchRequest
import xynolog.types.MatchSearchResult
import xynolog.types.ResourceSearchFilters

/** How many candidates a search for a reference gives when none is stated. */
internal const val SEARCH_LIMIT: Long = 10

/** Searching: for what a reference could refer to, and for resources by text. */
public class MatchNamespace internal constructor(private val links: Links, private val live: Live) {
    /** Candidates for a reference, given its gathered context: ten when `options` states no limit, scored as the service decides when it does not say how. */
    @JvmOverloads
    @JvmExposeBoxed
    public fun search(
        resourceId: ResourceId,
        referenceId: AnnotationId,
        context: GatheredContext,
        options: MatchSearchOptions = MatchSearchOptions(),
    ): Running<MatchSearchResult> {
        val request = MatchSearchRequest(
            resourceId = resourceId,
            referenceId = referenceId,
            context = context,
            limit = options.limit ?: SEARCH_LIMIT,
            useSemanticScoring = options.useSemanticScoring,
        )
        return Running(links.scope) { links.request(Operations.MATCH_SEARCH_REQUESTED, request) }
    }

    /** Signal: a search is wanted. The client's own state runs it, and answers under `correlationId`. */
    public fun requestSearch(request: MatchSearchRequest, correlationId: String): Unit =
        links.signal(Operations.MATCH_SEARCH_REQUESTED.request, request, correlationId)

    /**
     * The resources a text search finds, among those the filters admit: the
     * page they state, `offset` of them passed over before it begins, and
     * the service's own when they state none. A live query, kept true by the
     * same events as `browse.resources` and no others.
     */
    @JvmOverloads
    public fun resources(search: String, filters: ResourceSearchFilters = ResourceSearchFilters()): Cached<MatchResourcesResponse> {
        val request = MatchResourcesRequest(
            search = search,
            archived = filters.archived,
            entityType = filters.entityType,
            offset = filters.offset,
            limit = filters.limit,
        )
        return live.query(Keyed(live.matchedResources, request, { it }))
    }
}
