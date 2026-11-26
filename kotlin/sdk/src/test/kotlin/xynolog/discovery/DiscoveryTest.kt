@file:OptIn(kotlinx.coroutines.ExperimentalCoroutinesApi::class)

package xynolog.discovery

import com.sun.net.httpserver.HttpServer
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.test.TestScope
import kotlinx.coroutines.test.advanceTimeBy
import kotlinx.coroutines.test.runCurrent
import kotlinx.coroutines.test.runTest
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.buildJsonObject
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import kotlinx.serialization.json.put
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertInstanceOf
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.DynamicTest
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.TestFactory
import xynolog.Spec
import xynolog.http.CallersHttp
import xynolog.http.httpDiscovery
import xynolog.types.DiscoveredKB
import xynolog.types.DiscoveryAbsent
import xynolog.types.DiscoveryAbsentReason
import xynolog.types.DiscoveryDiff
import xynolog.types.DiscoveryManaged
import xynolog.types.DiscoveryRead
import xynolog.types.DiscoveryState
import xynolog.types.DiscoveryUnchanged
import xynolog.types.wireJson
import java.net.InetAddress
import java.net.InetSocketAddress
import java.nio.file.AccessDeniedException
import java.nio.file.NoSuchFileException
import java.util.concurrent.CopyOnWriteArrayList
import java.util.concurrent.CountDownLatch
import java.util.concurrent.Executors

private const val A = "did:web:example.org:kb-a"
private const val B = "did:web:example.org:kb-b"

private fun entry(host: String, port: Int, did: String): JsonObject = buildJsonObject {
    put("host", host)
    put("port", port)
    put("placement", "local")
    put("managedBy", "xynolog-launcher")
    put("did", did)
}

private fun document(vararg kbs: JsonElement): String = buildJsonObject {
    put("version", 1)
    put("kbs", JsonArray(kbs.toList()))
}.toString()

private fun kb(value: JsonObject): DiscoveredKB = wireJson.decodeFromJsonElement(DiscoveredKB.serializer(), value)

private val CODESPACE = buildJsonObject {
    put("host", "localhost")
    put("port", 4100)
    put("placement", "codespace")
    put("managedBy", "xynolog-launcher")
    put("did", B)
    put("repo", "owner/name")
    put("siteName", "A site")
}

private fun with(value: JsonObject, name: String, member: JsonElement) = JsonObject(value + (name to member))

/** A transport that gives what it was scripted to, in order, and then says nothing has changed. */
private class Script(vararg reads: DiscoveryRead) : DiscoveryTransport {
    private val reads = reads.toMutableList()
    var asked = 0

    override suspend fun read(): DiscoveryRead {
        asked += 1
        return if (reads.isEmpty()) DiscoveryUnchanged() else reads.removeAt(0)
    }
}

/** The text read as the document, as every reader reads it. */
private fun parsed(text: String): DiscoveryRead = readOf(parseDiscoveryDocument(text))

/** Every change told of in `polls` readings. */
private fun TestScope.changes(script: Script, polls: Int): List<DiscoveryDiff> {
    val told = mutableListOf<DiscoveryDiff>()
    val listening = launch { subscribeDiscovery(script, DISCOVERY_INTERVAL).collect { told += it } }
    advanceTimeBy(DISCOVERY_INTERVAL * polls - 1)
    runCurrent()
    listening.cancel()
    return told
}

private fun addresses(kbs: List<DiscoveredKB>) = kbs.map { "${it.host}:${it.port}" }

/** A diff as what it added, changed and removed, by address. */
private typealias Summary = Triple<List<String>, List<String>, List<String>>

private fun summary(diff: DiscoveryDiff): Summary = Triple(addresses(diff.added), addresses(diff.updated), addresses(diff.removed))

private fun reasonOf(state: DiscoveryState): DiscoveryAbsentReason? = (state as? DiscoveryAbsent)?.reason

/** What the launcher's stand-in answers a read with: a status, its headers and a body, or no answer at all. */
private class Served(val status: Int = 200, val body: String = "", val headers: Map<String, String> = mapOf("Content-Type" to "application/json"), val hold: Boolean = false)

private fun served(body: String, contentType: String = "application/json", etag: String? = null, status: Int = 200) =
    Served(status, body, listOfNotNull("Content-Type" to contentType, etag?.let { "ETag" to it }).toMap())

/** A launcher's stand-in, serving the discovery document as it is scripted to, and keeping each read's If-None-Match. */
private class Launcher(vararg answers: Served) : AutoCloseable {
    private val answers = answers.toMutableList()
    private val released = CountDownLatch(1)
    private val handling = Executors.newCachedThreadPool()
    private val server = HttpServer.create(InetSocketAddress(InetAddress.getLoopbackAddress(), 0), 0)
    val tags = CopyOnWriteArrayList<String?>()

    init {
        server.createContext(DISCOVERY_URL_PATH) { exchange ->
            tags += exchange.requestHeaders.getFirst("If-None-Match")
            val served = synchronized(this.answers) { this.answers.removeAt(0) }
            if (served.hold) released.await()
            served.headers.forEach { (name, value) -> exchange.responseHeaders.add(name, value) }
            val bytes = served.body.toByteArray()
            exchange.sendResponseHeaders(served.status, if (served.status == 304 || bytes.isEmpty()) -1 else bytes.size.toLong())
            if (bytes.isNotEmpty() && served.status != 304) exchange.responseBody.use { it.write(bytes) }
            exchange.close()
        }
        server.executor = handling
        server.start()
    }

    val url: String get() = "http://127.0.0.1:${server.address.port}$DISCOVERY_URL_PATH"

    override fun close() {
        released.countDown()
        server.stop(0)
        handling.shutdownNow()
    }
}

/** The knowledge bases a launcher manages: what its document says, what changed between two readings of it, and reading it over HTTP. */
class DiscoveryTest {
    // What the document says.

    @Test
    fun aDocumentOfKnowledgeBasesIsManagedAndOneOfNoneIsManagedToo() {
        assertEquals(DiscoveryManaged(kbs = listOf(kb(entry("localhost", 4000, A)), kb(CODESPACE))), parseDiscoveryDocument(document(entry("localhost", 4000, A), CODESPACE)))
        // A launcher that manages nothing is there. It is not absent.
        assertEquals(DiscoveryManaged(kbs = emptyList()), parseDiscoveryDocument(document()))
    }

    @TestFactory
    fun whatIsNotADocumentIsAbsentAndSaysWhy(): List<DynamicTest> = listOf(
        "<!doctype html><html></html>" to DiscoveryAbsentReason.NotJson,
        "[]" to DiscoveryAbsentReason.Invalid,
        """{"kbs":[]}""" to DiscoveryAbsentReason.Invalid,
        """{"version":"1","kbs":[]}""" to DiscoveryAbsentReason.Invalid,
        """{"version":true,"kbs":[]}""" to DiscoveryAbsentReason.Invalid,
        """{"version":1.5,"kbs":[]}""" to DiscoveryAbsentReason.Invalid,
        """{"version":2,"kbs":[]}""" to DiscoveryAbsentReason.UnsupportedVersion,
        """{"version":1}""" to DiscoveryAbsentReason.Invalid,
        """{"version":1,"kbs":["localhost"]}""" to DiscoveryAbsentReason.Invalid,
        document(with(entry("localhost", 4000, A), "placement", JsonPrimitive("elsewhere"))) to DiscoveryAbsentReason.Invalid,
        document(with(entry("localhost", 4000, A), "port", JsonPrimitive("4000"))) to DiscoveryAbsentReason.Invalid,
        document(with(entry("localhost", 4000, A), "host", JsonPrimitive(4000))) to DiscoveryAbsentReason.Invalid,
        document(entry("localhost", 0, A)) to DiscoveryAbsentReason.Invalid,
        document(entry("localhost", 70000, A)) to DiscoveryAbsentReason.Invalid,
    ).map { (text, expected) ->
        DynamicTest.dynamicTest(text) {
            val state = assertInstanceOf(DiscoveryAbsent::class.java, parseDiscoveryDocument(text))
            assertEquals(expected, state.reason)
            assertTrue(!state.diagnostic.isNullOrEmpty(), "no diagnostic")
        }
    }

    @Test
    fun aDocumentOfAnotherVersionIsNotReadInPart() {
        val state = assertInstanceOf(DiscoveryAbsent::class.java, parseDiscoveryDocument("""{"version":2,"kbs":[${entry("localhost", 4000, A)}]}"""))
        assertEquals(DiscoveryAbsentReason.UnsupportedVersion, state.reason)
        assertTrue(checkNotNull(state.diagnostic).contains("version 2"), state.diagnostic)
    }

    @Test
    fun oneEntryThatIsNotOneMakesTheWholeDocumentAbsent() {
        // A reading of the good entry alone would hide a running knowledge base.
        val withoutADid = JsonObject(entry("localhost", 4100, A) - "did")
        val state = assertInstanceOf(DiscoveryAbsent::class.java, parseDiscoveryDocument(document(entry("localhost", 4000, A), withoutADid)))
        assertEquals(DiscoveryAbsentReason.Invalid, state.reason)
        assertTrue(checkNotNull(state.diagnostic).contains("did"), state.diagnostic)
    }

    // Reading it as text.

    @Test
    fun textIsReadThroughTheOneValidator() = runBlocking {
        assertEquals(DiscoveryManaged(kbs = listOf(kb(entry("localhost", 4000, A)))), textDiscovery { document(entry("localhost", 4000, A)) }.read())
        assertEquals(DiscoveryAbsent(reason = DiscoveryAbsentReason.NotFound), textDiscovery { throw NoSuchFileException("/state/discovery/kbs.json") }.read())
        val refused = assertInstanceOf(DiscoveryAbsent::class.java, textDiscovery { throw AccessDeniedException("/state/discovery/kbs.json", null, "permission denied") }.read())
        assertEquals(DiscoveryAbsentReason.Unreadable, refused.reason)
        assertTrue(checkNotNull(refused.diagnostic).contains("permission denied"), refused.diagnostic)
    }

    // What changed.

    @Test
    fun theFirstReadingIsToldWholeAndEachOneAfterByWhatChanged() = runTest {
        val renamed = with(entry("localhost", 4000, A), "siteName", JsonPrimitive("Renamed"))
        val script = Script(
            parsed(document(entry("localhost", 4000, A))),
            parsed(document(renamed, entry("localhost", 4100, B))),
            parsed(document(entry("localhost", 4100, B))),
        )
        val told = changes(script, 4)
        assertEquals(
            listOf<Summary>(
                Triple(listOf("localhost:4000"), emptyList(), emptyList()),
                Triple(listOf("localhost:4100"), listOf("localhost:4000"), emptyList()),
                Triple(emptyList(), emptyList(), listOf("localhost:4000")),
            ),
            told.map(::summary),
        )
        assertEquals("Renamed", told[1].updated[0].siteName)
        assertEquals(4, script.asked)
    }

    @Test
    fun aKnowledgeBaseThatMovesPortIsRemovedAndAdded() = runTest {
        val script = Script(parsed(document(entry("localhost", 4000, A))), parsed(document(entry("localhost", 4001, A))))
        val told = changes(script, 2)
        assertEquals(2, told.size)
        assertEquals(Summary(listOf("localhost:4001"), emptyList(), listOf("localhost:4000")), summary(told[1]))
    }

    @Test
    fun aReadingThatChangedNothingIsNotTold() = runTest {
        val same = parsed(document(entry("localhost", 4000, A)))
        val script = Script(same, DiscoveryUnchanged(), same, parsed(document(entry("localhost", 4000, A))))
        assertEquals(1, changes(script, 5).size)
        assertEquals(5, script.asked)
    }

    @Test
    fun anEntryWithOptionalMembersReadAgainUnchangedIsNotTold() = runTest {
        val script = Script(parsed(document(CODESPACE)), parsed(document(CODESPACE)))
        assertEquals(1, changes(script, 2).size)
    }

    @Test
    fun aLauncherThatGoesAndComesBackIsToldWithWhatItTookAndBrought() = runTest {
        val script = Script(
            parsed("not json"),
            parsed(document(entry("localhost", 4000, A))),
            parsed("not json"),
            // Absent for another reason is a change too; for the same one it is not.
            parsed("[]"),
            parsed("{}"),
        )
        assertEquals(
            listOf<Pair<DiscoveryAbsentReason?, Summary>>(
                DiscoveryAbsentReason.NotJson to Triple(emptyList<String>(), emptyList<String>(), emptyList<String>()),
                null to Triple(listOf("localhost:4000"), emptyList(), emptyList()),
                DiscoveryAbsentReason.NotJson to Triple(emptyList(), emptyList(), listOf("localhost:4000")),
                DiscoveryAbsentReason.Invalid to Triple(emptyList(), emptyList(), emptyList()),
            ),
            changes(script, 6).map { reasonOf(it.state) to summary(it) },
        )
    }

    @Test
    fun oneKnowledgeBaseInTwoPlacesIsTwoEntriesAndEachIsItsOwn() = runTest {
        val both = parsed(document(entry("localhost", 4000, A), entry("localhost", 4100, A)))
        val told = changes(Script(both, both, parsed(document(entry("localhost", 4100, A)))), 4)
        // No change while both are there, and the one that stops is not hidden by the one that goes on.
        assertEquals(
            listOf<Summary>(
                Triple(listOf("localhost:4000", "localhost:4100"), emptyList(), emptyList()),
                Triple(emptyList(), emptyList(), listOf("localhost:4000")),
            ),
            told.map(::summary),
        )
        assertEquals(listOf(emptyList<String>(), emptyList()), told.map { it.duplicated })
    }

    @Test
    fun twoEntriesAtOneAddressAreNamedAndNeitherIsDroppedFromTheState() = runTest {
        val told = changes(Script(parsed(document(entry("localhost", 4000, A), entry("localhost", 4000, B), entry("localhost", 4100, B)))), 1)
        assertEquals(1, told.size)
        assertEquals(listOf("localhost:4000"), told[0].duplicated)
        assertEquals(3, assertInstanceOf(DiscoveryManaged::class.java, told[0].state).kbs.size)
    }

    @Test
    fun readingStopsWhenNobodyListensOrTheReadingIsClosed() = runTest {
        val script = Script(parsed(document()))
        val listening = launch { subscribeDiscovery(script, DISCOVERY_INTERVAL).collect { } }
        advanceTimeBy(DISCOVERY_INTERVAL * 2)
        runCurrent()
        val asked = script.asked
        assertTrue(asked >= 2, "asked $asked times")
        listening.cancel()
        advanceTimeBy(DISCOVERY_INTERVAL * 5)
        assertEquals(asked, script.asked, "asked after the reader left")

        // Closed, it reads no more, though its reader still waits.
        val again = Script(parsed(document()))
        val reading = subscribeDiscovery(again, DISCOVERY_INTERVAL)
        val waiting = launch { reading.collect { } }
        advanceTimeBy(DISCOVERY_INTERVAL / 2)
        reading.close()
        advanceTimeBy(DISCOVERY_INTERVAL * 5)
        runCurrent()
        assertEquals(1, again.asked)
        assertTrue(waiting.isCompleted, "its reader still waits")
    }

    // Over HTTP.

    @Test
    fun aDocumentThatHasNotChangedIsNotReadAgain() = runBlocking {
        Launcher(
            served(document(entry("localhost", 4000, A)), etag = "\"v1\""),
            Served(status = 304, headers = emptyMap()),
            // A new document has a new tag, and is read.
            served(document(), contentType = "application/json; charset=utf-8", etag = "\"v2\""),
        ).use { launcher ->
            val reader = httpDiscovery(launcher.url)
            assertEquals(DiscoveryManaged(kbs = listOf(kb(entry("localhost", 4000, A)))), reader.read())
            assertEquals(DiscoveryUnchanged(), reader.read())
            assertEquals(DiscoveryManaged(kbs = emptyList()), reader.read())
            assertEquals(listOf(null, "\"v1\"", "\"v1\""), launcher.tags.toList())
        }
    }

    @Test
    fun whatIsNotADocumentAtTheAddressIsAbsent() = runBlocking {
        Launcher(
            // A server that answers every path with its own page.
            served("<!doctype html>", contentType = "text/html", etag = "\"page\""),
            served("<!doctype html>", contentType = "text/html", etag = "\"page\""),
            served("", contentType = "text/plain", status = 404),
            served("{", etag = "\"bad\""),
            served("{", etag = "\"bad\""),
        ).use { launcher ->
            val reader = httpDiscovery(launcher.url)
            val reads = List(5) { reader.read() }
            assertEquals(
                listOf(DiscoveryAbsentReason.NotFound, DiscoveryAbsentReason.NotFound, DiscoveryAbsentReason.NotFound, DiscoveryAbsentReason.NotJson, DiscoveryAbsentReason.NotJson),
                reads.map { (it as DiscoveryAbsent).reason },
            )
            // The tag of a document that did not read was not kept: it is not believed the next time.
            assertEquals(List(5) { null }, launcher.tags.toList())
        }
        assertEquals(DiscoveryAbsentReason.Unreadable, (httpDiscovery("http://127.0.0.1:9$DISCOVERY_URL_PATH").read() as DiscoveryAbsent).reason)
    }

    @Test
    fun aReaderGivenItsCallersClientReadsTheDocumentWithIt() = runBlocking {
        Launcher(served(document(entry("localhost", 4000, A)))).use { launcher ->
            val http = CallersHttp()
            assertEquals(DiscoveryManaged(kbs = listOf(kb(entry("localhost", 4000, A)))), httpDiscovery(launcher.url, http).read())
            assertEquals(listOf(DISCOVERY_URL_PATH), http.made.toList())
        }
    }

    @Test
    fun aLaunchersDocumentThatIsNeverServedIsUnreadableAtTheDeadline() = runBlocking {
        Launcher(Served(hold = true)).use { launcher ->
            val started = System.nanoTime()
            val read = httpDiscovery(launcher.url, 300).read()
            val tookMs = (System.nanoTime() - started) / 1_000_000
            assertTrue(tookMs in 300..2_300, "took ${tookMs}ms")
            assertEquals(DiscoveryAbsent(reason = DiscoveryAbsentReason.Unreadable, diagnostic = "the document was not served within 300ms"), read)
        }
    }
}
