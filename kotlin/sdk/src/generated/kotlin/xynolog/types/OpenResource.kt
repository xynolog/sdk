// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class, kotlin.ExperimentalStdlibApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonIgnoreUnknownKeys
import xynolog.identifiers.ResourceId

/** A resource open in a knowledge base: which resource, the name it is shown by, when it was opened and its place among the others open there. A registry shows them by their places, and two in one place by when each was opened, first first. */
@Serializable
@JsonIgnoreUnknownKeys
public data class OpenResource(
    /** The resource. */
    @get:JvmExposeBoxed
    public val id: ResourceId,
    /** The name the resource is shown by. */
    public val name: String,
    /** When the resource was opened, in milliseconds since the Unix epoch. Opening it again while it is open changes neither this nor its place. */
    public val openedAt: Long,
    /** The resource's place among those open in the knowledge base. One opened is given the place after the last taken, so a place freed by closing one is not given twice; a move gives each its place in the new order, counted from 0. */
    public val order: Long,
    /** The resource's media type, which its icon is chosen by. Absent when it is not known. */
    public val mediaType: String? = null,
    /** Where the resource is in the knowledge base's working tree, as a URI (file://docs/overview.md). Absent when it is not known. */
    public val storageUri: String? = null,
) {
    /** How Java makes a `OpenResource`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val id: ResourceId,
        private val name: String,
        private val openedAt: Long,
        private val order: Long,
    ) {
        private var mediaType: String? = null
        private var storageUri: String? = null

        public fun mediaType(mediaType: String?): Builder = apply { this.mediaType = mediaType }
        public fun storageUri(storageUri: String?): Builder = apply { this.storageUri = storageUri }

        public fun build(): OpenResource = OpenResource(id = id, name = name, openedAt = openedAt, order = order, mediaType = mediaType, storageUri = storageUri)
    }

    public companion object {
        /** A builder of a `OpenResource` that states these, and what its setters add. */
        @JvmStatic
        @JvmExposeBoxed
        public fun builder(id: ResourceId, name: String, openedAt: Long, order: Long): Builder = Builder(id, name, openedAt, order)
    }
}
