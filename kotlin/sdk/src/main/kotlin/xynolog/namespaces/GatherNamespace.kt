@file:OptIn(kotlin.ExperimentalStdlibApi::class)

package xynolog.namespaces

import xynolog.OptionDefaults
import xynolog.Running
import xynolog.bus.Operations
import xynolog.cache.Cached
import xynolog.cache.Keyed
import xynolog.identifiers.AnnotationId
import xynolog.identifiers.ResourceId
import xynolog.types.GatherAnnotationComplete
import xynolog.types.GatherAnnotationOptions
import xynolog.types.GatherAnnotationRequest
import xynolog.types.GatherResourceOptions
import xynolog.types.GatherResourceRequest
import xynolog.types.GatherResourceRequestOptions
import xynolog.types.GatheredContext
import xynolog.types.GetReferencedByResponseReferencedByItem
import java.util.concurrent.CompletableFuture

/** Assembling the context a model is given, and what refers to a resource. */
public class GatherNamespace internal constructor(private val links: Links, private val live: Live) {
    /**
     * The context around one annotation, taking `contextWindow` characters of
     * its source, and the source's context and the target's each included or
     * left out, as `options` states, and as the gatherer decides when not.
     * Options that state nothing are not sent.
     */
    @JvmOverloads
    @JvmExposeBoxed
    public fun annotation(
        resourceId: ResourceId,
        annotationId: AnnotationId,
        options: GatherAnnotationOptions = GatherAnnotationOptions(),
    ): Running<GatherAnnotationComplete> {
        val request = GatherAnnotationRequest(
            annotationId = annotationId,
            resourceId = resourceId,
            options = options.takeUnless { it == GatherAnnotationOptions() },
        )
        return Running(links.scope) { links.request(Operations.GATHER_REQUESTED, request) }
    }

    /**
     * The context around a whole resource. An option `options` leaves out is
     * its default of `OptionDefaults`. `depth` is how many links out from the resource the graph reaches, 1 to
     * 3, nearest first. An empty exclusion excludes nothing, and is not sent.
     */
    public suspend fun resource(resourceId: ResourceId, options: GatherResourceOptions = GatherResourceOptions()): GatheredContext {
        val sent = GatherResourceRequestOptions(
            depth = options.depth ?: OptionDefaults.GATHER_RESOURCE_DEPTH,
            maxResources = options.maxResources ?: OptionDefaults.GATHER_RESOURCE_MAX_RESOURCES,
            includeContent = options.includeContent ?: OptionDefaults.GATHER_RESOURCE_INCLUDE_CONTENT,
            includeSummary = options.includeSummary ?: OptionDefaults.GATHER_RESOURCE_INCLUDE_SUMMARY,
            excludeEntityTypes = options.excludeEntityTypes?.takeIf { it.isNotEmpty() },
        )
        return links.request(Operations.GATHER_RESOURCE_REQUESTED, GatherResourceRequest(resourceId = resourceId, options = sent)).response
    }

    /** `resource`, for Java. */
    @JvmOverloads
    @JvmExposeBoxed
    public fun resourceFuture(resourceId: ResourceId, options: GatherResourceOptions = GatherResourceOptions()): CompletableFuture<GatheredContext> =
        links.future { resource(resourceId, options) }

    /** The annotations elsewhere that refer to a resource: a live query. */
    @JvmExposeBoxed
    public fun referencedBy(resourceId: ResourceId): Cached<List<GetReferencedByResponseReferencedByItem>> =
        live.query(Keyed(live.referencedBy, resourceId, { it }, links.transport to resourceId))
}
