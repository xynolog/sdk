package xynolog.registry

import kotlinx.serialization.KSerializer
import kotlinx.serialization.SerializationException
import kotlinx.serialization.descriptors.PrimitiveKind
import kotlinx.serialization.descriptors.PrimitiveSerialDescriptor
import kotlinx.serialization.descriptors.SerialDescriptor
import kotlinx.serialization.encoding.Decoder
import kotlinx.serialization.encoding.Encoder
import kotlinx.serialization.json.JsonDecoder
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import xynolog.Timings
import xynolog.bus.faultOfSchema
import xynolog.cache.Cache
import xynolog.cache.CacheQuery
import xynolog.cache.KeptCaches
import xynolog.cache.PERSISTED_QUERIES
import xynolog.http.codeChallenge
import xynolog.identifiers.ResourceId
import xynolog.storage.CachePersistence
import xynolog.storage.SessionStorage
import xynolog.storage.StoragePersister

// What a registry of knowledge bases keeps in a SessionStorage, and what its sessions keep there of their queries and
// their stream, as protocol/specs/src/session/stored.json states it, under the keys and prefixes generated from it
// (StoredKeys.kt). StoredTest fails when this differs from the table, and CacheCasesTest when what a session keeps
// differs from session/cache-cases.json.

/** The key a knowledge base's session is kept under. */
public fun sessionKey(kbId: String): String = SESSION_KEY_PREFIX + kbId

/** The knowledge base a key is the session of; null when it is no session's key. */
public fun kbOfSessionKey(key: String): String? = if (key.startsWith(SESSION_KEY_PREFIX)) key.removePrefix(SESSION_KEY_PREFIX) else null

/**
 * The key of the person the gateway says a token is, by their did: what names
 * them in the keys their client's caches and stream places are kept under, and
 * in a stored sign-in, in place of the did itself. Unpadded base64url of the
 * SHA-256 of the did's UTF-8.
 */
public fun personKey(did: String): String = codeChallenge(did)

/** The key the stream's places in each scope of knowledge base `kbId` are kept under, as `lastEventIds`, for the person whose key is `personKey`. */
internal fun lastEventIdKey(kbId: String, personKey: String): String = "$LAST_EVENT_ID_KEY_PREFIX$kbId.$personKey"

/** Whether `places` is places `lastEventIds` holds: in each scope, the id of a recorded event delivered on it. */
internal fun holdsPlaces(places: JsonObject): Boolean = faultOfSchema("LastEventIds", places) == null

/** Whether `lastEventIds` holds `eventId` as the place reached in `scope`. */
internal fun isPlace(scope: ResourceId, eventId: String): Boolean = holdsPlaces(JsonObject(mapOf(scope.value to JsonPrimitive(eventId))))

/** The key the query `query` of knowledge base `kbId` is kept under, for the person whose key is `personKey`. */
internal fun cacheKey(kbId: String, personKey: String, query: String): String = "$CACHE_KEY_PREFIX$kbId.$personKey.$query"

/**
 * Delete what a client kept of knowledge base `kbId` for the person whose key
 * is `personKey`: every persisted query's key and the stream's places. What
 * forgetting a saved sign-in that named them deletes, whether it is cleared
 * or a new sign-in is kept in its place.
 */
internal fun forgetKept(storage: SessionStorage, kbId: String, personKey: String) {
    PERSISTED_QUERIES.forEach { storage.delete(cacheKey(kbId, personKey, it.query.wire)) }
    storage.delete(lastEventIdKey(kbId, personKey))
}

/** The form of a kept query's document, `cacheDocument`: `{version, entries}`, each entry a key, a value and its stamp. */
internal const val CACHE_DOCUMENT_VERSION: Long = 1

/** The key of a kept query per nothing, as its document writes it: `WHOLE_KEY`, and no other text. */
internal object WholeKeySerializer : KSerializer<String> {
    override val descriptor: SerialDescriptor = PrimitiveSerialDescriptor("xynolog.registry.WholeKey", PrimitiveKind.STRING)

    override fun serialize(encoder: Encoder, value: String): Unit = encoder.encodeString(value)

    override fun deserialize(decoder: Decoder): String {
        val json = decoder as? JsonDecoder ?: throw SerializationException("the key of a query per nothing is read from JSON alone")
        val key = json.decodeJsonElement()
        if (key !is JsonPrimitive || !key.isString || key.content != WHOLE_KEY) throw SerializationException("$key is not the key of a query per nothing")
        return key.content
    }
}

/**
 * A query a client keeps across a restart (a row client/refresh.json marks
 * `persisted`, as `PERSISTED_QUERIES` has each): its name in that table, what
 * its entries' keys and values are, and which of a client's caches it is.
 */
internal class KeptQuery<K : Any, V : Any>(
    val query: CacheQuery,
    val key: KSerializer<K>,
    val value: KSerializer<V>,
    private val cache: (KeptCaches) -> Cache<K, V>,
) {
    /** What keeps the query's cache in `persistence`: one document, under the query's name, for the persistence's person. */
    fun persister(persistence: CachePersistence): StoragePersister<K, V> =
        StoragePersister(persistence.storage, cacheKey(persistence.kbId, persistence.personKey, query.wire), key, value, CACHE_DOCUMENT_VERSION, Timings.MAX_STORED_BYTES_COUNT)

    /** The query's cache among `caches`. */
    fun cacheIn(caches: KeptCaches): Cache<K, V> = cache(caches)

    /** Keep the query's cache among `caches` in `persistence` from now on. */
    fun attach(caches: KeptCaches, persistence: CachePersistence): Unit = cache(caches).attach(persister(persistence))
}
