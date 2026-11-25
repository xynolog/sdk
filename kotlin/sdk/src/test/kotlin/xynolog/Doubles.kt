package xynolog

import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.awaitCancellation
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.emptyFlow
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import xynolog.bus.OPERATIONS
import xynolog.errors.XynologError
import xynolog.identifiers.ResourceId
import xynolog.transport.Broadcast
import xynolog.transport.Carried
import xynolog.transport.ConnectionState
import xynolog.transport.ContentStream
import xynolog.transport.ContentTransport
import xynolog.transport.Events
import xynolog.transport.Frame
import xynolog.transport.FrameRefusal
import xynolog.transport.FrameSink
import xynolog.transport.GatewayOperations
import xynolog.transport.PendingReply
import xynolog.transport.PutBinaryRequest
import xynolog.transport.ReplyRouter
import xynolog.transport.ResourceHold
import xynolog.transport.Transport
import xynolog.transport.Upload
import xynolog.transport.Watched
import xynolog.types.AnchoredTextAnswer
import xynolog.types.GetAnnotationsResponse
import xynolog.types.GetResourceResponse
import xynolog.types.HealthResponse
import xynolog.types.MediaTokenResponse
import xynolog.types.ProtectedResourceMetadata
import xynolog.types.ResourceRepresentation
import xynolog.types.StatusResponse
import xynolog.types.UserResponse
import java.util.concurrent.CompletableFuture
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.CopyOnWriteArrayList

/** What a call did: on which route, to what, with what. */
internal data class Did(val route: String, val name: String, val sends: JsonObject)

internal fun obj(vararg pairs: Pair<String, JsonElement>) = JsonObject(mapOf(*pairs))

/** This as the frame it is; a test that reads a frame's refusal here fails. */
internal fun Carried.frame(): Frame = when (this) {
    is Frame -> this
    is FrameRefusal -> throw AssertionError("refused: $this")
}

/**
 * A transport, a content transport and a gateway in one, which keep what each
 * call did and answer none but the requests a case answers, and the bytes a
 * test serves: a case holds what a call did, step by step, and not what it was
 * answered.
 */
internal class Recording :
    Transport,
    GatewayOperations,
    ContentTransport {
    val did = CopyOnWriteArrayList<Did>()
    private val router = ReplyRouter(Dispatchers.Unconfined)
    private val answers = ConcurrentHashMap<String, JsonElement>()

    /** A resource's bytes, served to whoever reads any resource's: nothing is served when it is none. */
    var serves: ResourceRepresentation? = null

    private fun saw(route: String, name: String, sends: JsonObject) {
        did += Did(route, name, sends)
    }

    /** Answer the next request on `channel` with `response` on its operation's result channel, once: a reply that carries none when it is `JsonNull`. */
    fun answer(channel: String, response: JsonElement) {
        answers[channel] = response
    }

    override val baseUrl: String = "http://kb.test"
    override val state: Watched<ConnectionState> = Watched(MutableStateFlow(ConnectionState.Open)) { it == ConnectionState.Closed }

    override suspend fun emit(channel: String, payload: JsonObject, scope: ResourceId?, correlationId: String?): Long? {
        saw("emit", channel, payload)
        answers.remove(channel)?.let { response ->
            val reply = if (response is JsonNull) obj() else obj("response" to response)
            router.route(Frame(OPERATIONS.getValue(channel).result.name, reply, correlationId))
        }
        return 1
    }

    override fun emitFuture(channel: String, payload: JsonObject, scope: ResourceId?, correlationId: String?): CompletableFuture<Long?> =
        throw UnsupportedOperationException("the client emits by its own future")

    override fun frames(channel: String): Events<Carried> = Broadcast<Carried>().listen()

    override fun isSubscribed(channel: String): Boolean = true

    override fun subscribeToResource(resourceId: ResourceId): ResourceHold = ResourceHold {}

    override fun failures(): Events<XynologError> = Broadcast<XynologError>().listen()

    override fun bridgeInto(bus: FrameSink) = Unit

    override fun trackReply(correlationId: String, replyChannels: Collection<String>): PendingReply = router.track(correlationId, replyChannels)

    override fun close() = router.close()

    private suspend fun <T> asked(route: String, name: String, sends: JsonObject = obj()): T {
        saw(route, name, sends)
        awaitCancellation()
    }

    private fun resource(resourceId: ResourceId) = obj("resourceId" to JsonPrimitive(resourceId.value))

    private fun unasked(): Nothing = throw UnsupportedOperationException("the client asks by its suspending call")

    override suspend fun getCurrentUser(): UserResponse = asked("gateway", "getCurrentUser")

    override fun getCurrentUserFuture(): CompletableFuture<UserResponse> = unasked()

    override suspend fun getMediaToken(resourceId: ResourceId): MediaTokenResponse = asked("gateway", "getMediaToken", resource(resourceId))

    override fun getMediaTokenFuture(resourceId: ResourceId): CompletableFuture<MediaTokenResponse> = unasked()

    override suspend fun getProtectedResourceMetadata(): ProtectedResourceMetadata = asked("gateway", "getProtectedResourceMetadata")

    override fun getProtectedResourceMetadataFuture(): CompletableFuture<ProtectedResourceMetadata> = unasked()

    override suspend fun healthCheck(): HealthResponse = asked("gateway", "healthCheck")

    override fun healthCheckFuture(): CompletableFuture<HealthResponse> = unasked()

    override suspend fun getStatus(): StatusResponse = asked("gateway", "getStatus")

    override fun getStatusFuture(): CompletableFuture<StatusResponse> = unasked()

    override fun putBinary(request: PutBinaryRequest): Upload {
        saw(
            "content",
            "putBinary",
            obj(
                "name" to JsonPrimitive(request.name),
                "content" to JsonPrimitive(request.file.toString(Charsets.UTF_8)),
                "format" to JsonPrimitive(request.format),
                "storageUri" to JsonPrimitive(request.storageUri),
                *listOfNotNull(request.cloneToken?.let { "cloneToken" to JsonPrimitive(it) }, request.archiveOriginal?.let { "archiveOriginal" to JsonPrimitive(it) }).toTypedArray(),
            ),
        )
        return Upload(CompletableDeferred(), Events(emptyFlow()) {})
    }

    override suspend fun getBinary(resourceId: ResourceId): ResourceRepresentation = serves ?: asked("content", "getBinary", resource(resourceId))

    override fun getBinaryFuture(resourceId: ResourceId): CompletableFuture<ResourceRepresentation> = unasked()

    override suspend fun getBinaryStream(resourceId: ResourceId): ContentStream = asked("content", "getBinaryStream", resource(resourceId))

    override fun getBinaryStreamFuture(resourceId: ResourceId): CompletableFuture<ContentStream> = unasked()

    override suspend fun getResourceGraph(resourceId: ResourceId): GetResourceResponse = asked("content", "getResourceGraph", resource(resourceId))

    override fun getResourceGraphFuture(resourceId: ResourceId): CompletableFuture<GetResourceResponse> = unasked()

    override suspend fun getAnnotations(resourceId: ResourceId): GetAnnotationsResponse = asked("content", "getAnnotations", resource(resourceId))

    override fun getAnnotationsFuture(resourceId: ResourceId): CompletableFuture<GetAnnotationsResponse> = unasked()

    override suspend fun getAnchoredText(resourceId: ResourceId): AnchoredTextAnswer = asked("content", "getAnchoredText", resource(resourceId))

    override fun getAnchoredTextFuture(resourceId: ResourceId): CompletableFuture<AnchoredTextAnswer> = unasked()
}
