package xynolog.transport

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.future.asCompletableFuture
import kotlinx.coroutines.jdk9.asPublisher
import xynolog.identifiers.ResourceId
import xynolog.types.AnchoredTextAnswer
import xynolog.types.CreateResourceResponse
import xynolog.types.GetAnnotationsResponse
import xynolog.types.GetResourceResponse
import xynolog.types.HealthResponse
import xynolog.types.MediaTokenResponse
import xynolog.types.ProtectedResourceMetadata
import xynolog.types.PutBinaryRequest
import xynolog.types.ResourceRepresentation
import xynolog.types.StatusResponse
import xynolog.types.UploadProgress
import xynolog.types.UserResponse
import java.util.concurrent.CompletableFuture
import java.util.concurrent.Flow.Publisher

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
