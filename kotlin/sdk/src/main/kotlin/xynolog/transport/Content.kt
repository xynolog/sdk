@file:OptIn(kotlin.ExperimentalStdlibApi::class)

package xynolog.transport

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.future.asCompletableFuture
import kotlinx.coroutines.jdk9.asPublisher
import xynolog.identifiers.AnnotationId
import xynolog.identifiers.JobId
import xynolog.identifiers.ResourceId
import xynolog.types.Agent
import xynolog.types.AnchoredTextAnswer
import xynolog.types.CreateResourceResponse
import xynolog.types.GetAnnotationsResponse
import xynolog.types.GetResourceResponse
import xynolog.types.HealthResponse
import xynolog.types.MediaTokenResponse
import xynolog.types.ProtectedResourceMetadata
import xynolog.types.ResourceRepresentation
import xynolog.types.StatusResponse
import xynolog.types.UploadProgress
import xynolog.types.UserResponse
import java.util.concurrent.CompletableFuture
import java.util.concurrent.Flow.Publisher

/** An upload: the bytes, and each field the resource is created with. */
public data class PutBinaryRequest(
    public val name: String,
    public val file: ByteArray,
    /** The media type of the bytes. */
    public val format: String,
    public val storageUri: String,
    public val entityTypes: List<String> = emptyList(),
    public val language: String? = null,
    @get:JvmExposeBoxed
    public val sourceAnnotationId: AnnotationId? = null,
    @get:JvmExposeBoxed
    public val sourceResourceId: ResourceId? = null,
    public val generationPrompt: String? = null,
    /** Who made it, when it was made for someone. */
    public val generator: List<Agent> = emptyList(),
    /** The job this resource fulfils, when a worker is creating it. */
    @get:JvmExposeBoxed
    public val jobId: JobId? = null,
    public val isDraft: Boolean? = null,
    /** The token a clone's source was read by, when this resource is that clone. */
    public val cloneToken: String? = null,
    /** Whether the clone's source is archived once the clone exists. */
    public val archiveOriginal: Boolean? = null,
) {
    // Bytes are compared by what they hold, not by which array holds them.
    override fun equals(other: Any?): Boolean =
        other is PutBinaryRequest && name == other.name && file.contentEquals(other.file) && format == other.format && storageUri == other.storageUri &&
            entityTypes == other.entityTypes && language == other.language && sourceAnnotationId == other.sourceAnnotationId &&
            sourceResourceId == other.sourceResourceId && generationPrompt == other.generationPrompt && generator == other.generator && jobId == other.jobId &&
            isDraft == other.isDraft && cloneToken == other.cloneToken && archiveOriginal == other.archiveOriginal

    override fun hashCode(): Int =
        listOf(name, file.contentHashCode(), format, storageUri, entityTypes, language, sourceAnnotationId, sourceResourceId, generationPrompt, generator, jobId, isDraft, cloneToken, archiveOriginal)
            .hashCode()

    /** How Java makes a `PutBinaryRequest`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val file: ByteArray,
        private val format: String,
        private val storageUri: String,
    ) {
        private var entityTypes: List<String> = emptyList()
        private var language: String? = null
        private var sourceAnnotationId: AnnotationId? = null
        private var sourceResourceId: ResourceId? = null
        private var generationPrompt: String? = null
        private var generator: List<Agent> = emptyList()
        private var jobId: JobId? = null
        private var isDraft: Boolean? = null
        private var cloneToken: String? = null
        private var archiveOriginal: Boolean? = null

        public fun entityTypes(entityTypes: List<String>): Builder = apply { this.entityTypes = entityTypes }

        public fun language(language: String?): Builder = apply { this.language = language }

        @JvmExposeBoxed
        public fun sourceAnnotationId(sourceAnnotationId: AnnotationId?): Builder = apply { this.sourceAnnotationId = sourceAnnotationId }

        @JvmExposeBoxed
        public fun sourceResourceId(sourceResourceId: ResourceId?): Builder = apply { this.sourceResourceId = sourceResourceId }

        public fun generationPrompt(generationPrompt: String?): Builder = apply { this.generationPrompt = generationPrompt }

        @JvmExposeBoxed
        public fun jobId(jobId: JobId?): Builder = apply { this.jobId = jobId }

        public fun isDraft(isDraft: Boolean?): Builder = apply { this.isDraft = isDraft }

        public fun generator(generator: List<Agent>): Builder = apply { this.generator = generator }

        public fun cloneToken(cloneToken: String?): Builder = apply { this.cloneToken = cloneToken }

        public fun archiveOriginal(archiveOriginal: Boolean?): Builder = apply { this.archiveOriginal = archiveOriginal }

        public fun build(): PutBinaryRequest = PutBinaryRequest(
            name, file, format, storageUri, entityTypes, language, sourceAnnotationId, sourceResourceId, generationPrompt, generator, jobId, isDraft, cloneToken, archiveOriginal,
        )
    }

    public companion object {
        /** A builder of a `PutBinaryRequest` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, file: ByteArray, format: String, storageUri: String): Builder = Builder(name, file, format, storageUri)
    }
}

/**
 * An upload under way: what it reports as it goes, and the resource it
 * created. It began when it was made. Its reports are read once: `started`
 * with its size before any bytes are sent, `progress` as they are sent, and
 * `finished` with the resource made, once the knowledge base has answered.
 * Its size is every byte sent for it: over HTTP, the whole request. An upload
 * that fails throws to its awaiter, and its reports end without `finished`.
 * Closing it gives up the upload, which then reports nothing more.
 */
public class Upload internal constructor(
    private val sending: Deferred<CreateResourceResponse>,
    /** What it reports, the bytes sent never less than it last said, ending when it has ended. */
    public val progress: Events<UploadProgress>,
) : AutoCloseable {
    /** The resource the upload created. */
    public suspend fun await(): CreateResourceResponse = sending.await()

    /** `await`, for Java. */
    public fun awaitFuture(): CompletableFuture<CreateResourceResponse> = sending.asCompletableFuture()

    /** Give the upload up: its connection is closed, and it reports nothing more. */
    override fun close(): Unit = sending.cancel()
}

/** A resource's bytes as they arrive, with their media type: read once. Closing it before its end gives up the read. */
public class ContentStream internal constructor(
    public val contentType: String,
    private val arriving: Flow<ByteArray>,
    private val reading: CoroutineScope,
) {
    /** The bytes, a piece at a time, read once. */
    public val bytes: Events<ByteArray> get() = Events(arriving) {}

    /** The bytes, for Java. */
    public fun asPublisher(): Publisher<ByteArray> = arriving.asPublisher(reading.coroutineContext)
}

/** Content over whatever carries it: bytes, which never ride the bus, and a resource's description, annotations and anchored text. */
public interface ContentTransport : AutoCloseable {
    /** Upload a resource. */
    public fun putBinary(request: PutBinaryRequest): Upload

    /** A resource's bytes, whole. */
    public suspend fun getBinary(resourceId: ResourceId): ResourceRepresentation

    /** `getBinary`, for Java. */
    public fun getBinaryFuture(resourceId: ResourceId): CompletableFuture<ResourceRepresentation>

    /** A resource's bytes, as they arrive. */
    public suspend fun getBinaryStream(resourceId: ResourceId): ContentStream

    /** `getBinaryStream`, for Java. */
    public fun getBinaryStreamFuture(resourceId: ResourceId): CompletableFuture<ContentStream>

    /** A resource's description, with its annotations, as the gateway answers it. */
    public suspend fun getResourceGraph(resourceId: ResourceId): GetResourceResponse

    /** `getResourceGraph`, for Java. */
    public fun getResourceGraphFuture(resourceId: ResourceId): CompletableFuture<GetResourceResponse>

    /** A resource's annotations, as the gateway answers them. */
    public suspend fun getAnnotations(resourceId: ResourceId): GetAnnotationsResponse

    /** `getAnnotations`, for Java. */
    public fun getAnnotationsFuture(resourceId: ResourceId): CompletableFuture<GetAnnotationsResponse>

    /** A resource's anchored text, or why there is none: an answer, never a failure. */
    public suspend fun getAnchoredText(resourceId: ResourceId): AnchoredTextAnswer

    /** `getAnchoredText`, for Java. */
    public fun getAnchoredTextFuture(resourceId: ResourceId): CompletableFuture<AnchoredTextAnswer>
}

/** What a gateway answers of itself. A transport with no gateway behind it does not implement this. */
public interface GatewayOperations {
    public suspend fun getCurrentUser(): UserResponse

    /** `getCurrentUser`, for Java. */
    public fun getCurrentUserFuture(): CompletableFuture<UserResponse>

    public suspend fun getMediaToken(resourceId: ResourceId): MediaTokenResponse

    /** `getMediaToken`, for Java. */
    public fun getMediaTokenFuture(resourceId: ResourceId): CompletableFuture<MediaTokenResponse>

    public suspend fun getProtectedResourceMetadata(): ProtectedResourceMetadata

    /** `getProtectedResourceMetadata`, for Java. */
    public fun getProtectedResourceMetadataFuture(): CompletableFuture<ProtectedResourceMetadata>

    public suspend fun healthCheck(): HealthResponse

    /** `healthCheck`, for Java. */
    public fun healthCheckFuture(): CompletableFuture<HealthResponse>

    public suspend fun getStatus(): StatusResponse

    /** `getStatus`, for Java. */
    public fun getStatusFuture(): CompletableFuture<StatusResponse>
}
