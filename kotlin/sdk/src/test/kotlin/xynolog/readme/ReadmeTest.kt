@file:OptIn(kotlinx.coroutines.ExperimentalCoroutinesApi::class)

package xynolog.readme

import kotlinx.coroutines.async
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.test.StandardTestDispatcher
import kotlinx.coroutines.test.runCurrent
import kotlinx.coroutines.test.runTest
import kotlinx.coroutines.withTimeout
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.buildJsonObject
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import kotlinx.serialization.json.put
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import xynolog.http.HttpTransport
import xynolog.http.Realm
import xynolog.identifiers.AnnotationId
import xynolog.identifiers.ResourceId
import xynolog.testing.GetAnnotations
import xynolog.testing.InMemoryContent
import xynolog.testing.TestClient
import xynolog.transport.Frame
import xynolog.types.GetAnnotationsResponse
import xynolog.types.wireJson
import java.io.ByteArrayOutputStream
import java.io.PrintStream
import java.nio.file.Files
import java.nio.file.Path
import kotlin.io.path.extension
import kotlin.io.path.readText
import kotlin.time.Duration.Companion.seconds

private val README: String = Path.of("README.md").readText()

private val MARK = Regex("""<!-- readme: ([\w-]+) -->\n( *)```(kotlin|java)\n(.*?)\n\2```""", RegexOption.DOT_MATCHES_ALL)
private val FENCE = Regex("""(?m)^ *```(kotlin|java)$""")

/** Lines with as much of their indent taken off as all of them share. */
private fun dedented(lines: List<String>): String {
    val indent = lines.filter { it.isNotBlank() }.minOfOrNull { line -> line.takeWhile { it == ' ' }.length } ?: 0
    return lines.joinToString("\n") { it.drop(indent) }.trimEnd()
}

/** The README's Kotlin and Java blocks, by the name each is marked with. */
private fun blocks(): Map<String, String> = MARK.findAll(README).associate { it.groupValues[1] to dedented(it.groupValues[4].lines()) }

/** The regions of the programs' files, by name. */
private fun regions(): Map<String, String> = listOf(Path.of("src/test/kotlin/xynolog/readme"), Path.of("src/javaTest/java/xynolog/readme"))
    .flatMap { directory -> Files.list(directory).use { files -> files.filter { it.extension == "kt" || it.extension == "java" }.toList() } }
    .flatMap { file ->
        val lines = file.readText().lines()
        lines.withIndex().filter { (_, line) -> line.trim().startsWith("// readme: ") && line.trim() != "// readme: end" }.map { (at, line) ->
            val name = line.trim().removePrefix("// readme: ")
            val end = (at + 1 until lines.size).first { lines[it].trim() == "// readme: end" }
            name to dedented(lines.subList(at + 1, end))
        }
    }.toMap()

private val CONTEXT: JsonObject = Json.parseToJsonElement(
    """{"focus": {"kind": "resource", "resource": {"@context": "https://schema.org", "@id": "res-1", "name": "A resource", "representations": []}}, "graph": {"nodes": [], "edges": []}, "metadata": {}}""",
).jsonObject

/** The README's programs: each Kotlin and Java block a region of a file the build compiles, word for word, and each Kotlin program run. */
class ReadmeTest {
    @Test
    fun everyKotlinAndJavaBlockIsAProgramWordForWordAndEveryProgramIsShown() {
        val shown = blocks()
        assertEquals(FENCE.findAll(README).count(), shown.size, "every Kotlin and Java block is marked with the program it is")
        val programs = regions()
        assertEquals(programs.keys.sorted(), shown.keys.sorted())
        for ((name, block) in shown) assertEquals(programs.getValue(name), block, "README's $name")
    }

    @Test
    fun theFirstProgramAsksTheKnowledgeBaseItsNameAndSaysIt() {
        Realm().use { realm ->
            realm.onEmit = { emit ->
                if (emit.getValue("channel").jsonPrimitive.content == "browse:kb-requested") {
                    realm.send(
                        buildJsonObject {
                            put("channel", "browse:kb-result")
                            put("payload", Json.parseToJsonElement("""{"response": {"name": "Papers", "domain": "kb.example"}}"""))
                            put("correlationId", emit.getValue("correlationId"))
                        },
                    )
                }
            }
            val shown = ByteArrayOutputStream()
            val standard = System.out
            System.setOut(PrintStream(shown, true))
            try {
                runBlocking { withTimeout(10.seconds) { main(arrayOf(realm.origin, "a-token")) } }
            } finally {
                System.setOut(standard)
            }
            assertEquals("Papers", shown.toString().trim())
            assertEquals(listOf("Bearer a-token"), realm.of("/bus/emit").map { it.authorization })
        }
    }

    @Test
    fun connectingMakesAClientOverHttp() {
        val client = connect("http://127.0.0.1:9", "a-token")
        assertTrue(client.transport is HttpTransport)
        client.close()
        client.transport.close()
    }

    @Test
    fun gatheringThenDelegatingFollowsTheJobToItsCompletion() = runTest(timeout = 10.seconds) {
        val made = TestClient(StandardTestDispatcher(testScheduler), testScheduler.timeSource)
        val transport = made.transport
        transport.queueReply("gather:requested", listOf(CONTEXT))
        transport.queueReply("job:create", listOf(Json.parseToJsonElement("""{"jobId": "job-1"}""")))
        val running = async { gatherThenDelegate(made.client, ResourceId("res-1"), AnnotationId("ann-1")) }
        runCurrent()
        assertEquals(listOf("gather:requested", "job:create"), transport.requestLog.map { it.channel })
        transport.deliver(Frame("job:report-progress", Json.parseToJsonElement("""{"resourceId": "res-1", "jobId": "job-1", "jobType": "yield", "percentage": 50, "progress": {"percentage": 50}}""").jsonObject))
        transport.deliver(
            Frame("job:complete", Json.parseToJsonElement("""{"resourceId": "res-1", "jobId": "job-1", "jobType": "yield", "result": {"resourceId": "res-2", "resourceName": "A summary", "truncated": false}}""").jsonObject),
        )
        runCurrent()
        running.await()
        made.client.close()
        transport.close()
    }

    @Test
    fun watchingLiveShowsEachStateOfTheQuery() = runTest(timeout = 10.seconds) {
        val content = InMemoryContent()
        content.seedAnnotations(ResourceId("res-1"), wireJson.decodeFromJsonElement(GetAnnotationsResponse.serializer(), Json.parseToJsonElement("""{"annotations": [], "total": 0}""")))
        val made = TestClient(StandardTestDispatcher(testScheduler), testScheduler.timeSource, content = content)
        val watching = launch { watchingLive(made.client, ResourceId("res-1")) }
        runCurrent()
        assertEquals(listOf(GetAnnotations(ResourceId("res-1"))), content.calls)
        watching.cancel()
        made.client.close()
        made.transport.close()
    }
}
