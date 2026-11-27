package xynolog.discovery

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.longOrNull
import xynolog.Timings
import xynolog.bus.faultOf
import xynolog.bus.said
import xynolog.bus.valuesOf
import xynolog.telemetry.futureOf
import xynolog.transport.Events
import xynolog.types.DiscoveredKB
import xynolog.types.DiscoveryAbsent
import xynolog.types.DiscoveryAbsentReason
import xynolog.types.DiscoveryDiff
import xynolog.types.DiscoveryDocument
import xynolog.types.DiscoveryManaged
import xynolog.types.DiscoveryRead
import xynolog.types.DiscoveryState
import xynolog.types.DiscoveryUnchanged
import xynolog.types.wireJson
import java.io.FileNotFoundException
import java.io.IOException
import java.nio.file.NoSuchFileException
import java.util.concurrent.CompletableFuture
import java.util.concurrent.atomic.AtomicBoolean

// The knowledge bases a launcher manages, as the launcher publishes them (protocol/specs/src/discovery): what the
// document says, read whole or not at all, and what changed since it was last read.

/** How often a launcher's document is read again, in milliseconds, unless a caller says otherwise. */
public const val DISCOVERY_INTERVAL: Long = Timings.DISCOVERY_INTERVAL_MS

/** The versions of the document this client reads: those DiscoveryDocument allows. */
private val VERSIONS: List<JsonPrimitive> = valuesOf("DiscoveryDocument", "version")

/** The read that found `state`. */
internal fun readOf(state: DiscoveryState): DiscoveryRead = when (state) {
    is DiscoveryAbsent -> state
    is DiscoveryManaged -> state
}

/** The state `read` found; null when it found nothing changed. */
private fun stateOf(read: DiscoveryRead): DiscoveryState? = when (read) {
    is DiscoveryAbsent -> read
    is DiscoveryManaged -> read
    is DiscoveryUnchanged -> null
}

/** Where the document is read from. */
public interface DiscoveryTransport {
    /** Read the document once. */
    public suspend fun read(): DiscoveryRead

    /** `read`, for Java: run where `read` runs it, a transport that keeps a context running it there. */
    public fun readFuture(): CompletableFuture<DiscoveryRead> = CoroutineScope(Dispatchers.Unconfined).futureOf { read() }
}

/**
 * The document's text as a state. Every reader goes through this. A document
 * is read whole: one of a version this client does not speak, or with an entry
 * that is not what the schema says, is absent, since a partial reading would
 * hide a running knowledge base without a trace. Absent is not empty:
 * `DiscoveryAbsent` is "no launcher was found", with why; `DiscoveryManaged`
 * with no knowledge bases is "the launcher is here and manages nothing".
 */
public fun parseDiscoveryDocument(text: String): DiscoveryState {
    val parsed = try {
        wireJson.parseToJsonElement(text)
    } catch (notJson: IllegalArgumentException) {
        return DiscoveryAbsent(reason = DiscoveryAbsentReason.NotJson, diagnostic = notJson.message ?: "the document is not JSON")
    }
    val document = parsed as? JsonObject ?: return DiscoveryAbsent(reason = DiscoveryAbsentReason.Invalid, diagnostic = "document is not an object")
    val version = (document["version"] as? JsonPrimitive)?.takeIf { !it.isString }?.longOrNull
    if (version != null && VERSIONS.none { it.longOrNull == version }) {
        return DiscoveryAbsent(
            reason = DiscoveryAbsentReason.UnsupportedVersion,
            diagnostic = "discovery document version $version is not one this client speaks (${VERSIONS.joinToString()}); it is not read in part",
        )
    }
    faultOf(DiscoveryDocument.serializer().descriptor, document)?.let { return DiscoveryAbsent(reason = DiscoveryAbsentReason.Invalid, diagnostic = "the document is no discovery document: ${it.said()}") }
    val read = try {
        wireJson.decodeFromJsonElement(DiscoveryDocument.serializer(), document)
    } catch (invalid: IllegalArgumentException) {
        return DiscoveryAbsent(reason = DiscoveryAbsentReason.Invalid, diagnostic = invalid.message ?: "not a discovery document")
    }
    return DiscoveryManaged(kbs = read.kbs)
}

/**
 * A transport over any way of getting the document's text. `readText` gives
 * the text, and throws `NoSuchFileException` or `FileNotFoundException` when
 * there is no document, and another `IOException` when it could not be read,
 * as reading the launcher's file with `java.nio.file.Files.readString` does.
 * It is called off the caller's thread.
 */
public fun textDiscovery(readText: () -> String): DiscoveryTransport = object : DiscoveryTransport {
    override suspend fun read(): DiscoveryRead {
        val text = try {
            withContext(Dispatchers.IO) { readText() }
        } catch (_: NoSuchFileException) {
            return DiscoveryAbsent(reason = DiscoveryAbsentReason.NotFound)
        } catch (_: FileNotFoundException) {
            return DiscoveryAbsent(reason = DiscoveryAbsentReason.NotFound)
        } catch (unread: IOException) {
            return DiscoveryAbsent(reason = DiscoveryAbsentReason.Unreadable, diagnostic = unread.message ?: unread::class.java.simpleName)
        }
        return readOf(parseDiscoveryDocument(text))
    }
}

/** What an entry is told apart by, which the launcher keeps unique: a did is not, one knowledge base running in two places being two entries with one did. */
private fun addressOf(kb: DiscoveredKB) = "${kb.host}:${kb.port}"

/** The knowledge bases a state lists: none when it is absent, or when there is no state. */
private fun kbsOf(state: DiscoveryState?): List<DiscoveredKB> = (state as? DiscoveryManaged)?.kbs.orEmpty()

/** What changed between `last`, the state last told of (null when none was), and `now`; null when nothing did. */
private fun diffOf(last: DiscoveryState?, now: DiscoveryState): DiscoveryDiff? {
    val before = kbsOf(last).associateBy(::addressOf)
    val after = kbsOf(now).map(::addressOf).toSet()
    val added = mutableListOf<DiscoveredKB>()
    val updated = mutableListOf<DiscoveredKB>()
    val duplicated = mutableListOf<String>()
    val claimed = mutableMapOf<String, Int>()
    for (kb in kbsOf(now)) {
        val at = addressOf(kb)
        val claims = claimed.getOrDefault(at, 0) + 1
        claimed[at] = claims
        if (claims == 2) duplicated += at
        val was = before[at]
        if (was == null) {
            added += kb
        } else if (was != kb) {
            updated += kb
        }
    }
    val removed = kbsOf(last).filter { addressOf(it) !in after }
    val stateChanged = when {
        last is DiscoveryManaged && now is DiscoveryManaged -> false
        last is DiscoveryAbsent && now is DiscoveryAbsent -> last.reason != now.reason
        else -> true
    }
    if (!stateChanged && added.isEmpty() && updated.isEmpty() && removed.isEmpty()) return null
    return DiscoveryDiff(now, added, updated, removed, duplicated)
}

/**
 * Read a launcher's document now and then every `intervalMs`, and tell of each
 * change. The first read is always told of. After it, a read that changed
 * nothing is not: only an entry added, changed or removed, and a change of
 * state, which carries every entry it brought or took away. It reads only
 * while it is collected, by one collector, once; closing it reads no more.
 */
@JvmOverloads
public fun subscribeDiscovery(transport: DiscoveryTransport, intervalMs: Long = Timings.DISCOVERY_INTERVAL_MS): Events<DiscoveryDiff> {
    val closed = AtomicBoolean(false)
    val reading = flow {
        var last: DiscoveryState? = null
        while (!closed.get()) {
            stateOf(transport.read())?.let { read ->
                diffOf(last, read)?.let { change ->
                    last = change.state
                    emit(change)
                }
            }
            delay(intervalMs)
        }
    }
    return Events(reading) { closed.set(true) }
}
