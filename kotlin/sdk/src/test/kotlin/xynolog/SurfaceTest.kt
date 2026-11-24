package xynolog

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancelAndJoin
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withTimeout
import kotlinx.serialization.KSerializer
import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.json.JsonArray
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import kotlinx.serialization.json.long
import kotlinx.serialization.serializer
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.DynamicTest
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.TestFactory
import xynolog.bus.Typed
import xynolog.bus.decoded
import xynolog.channels.Channel
import xynolog.channels.Channels
import xynolog.identifiers.AnnotationId
import xynolog.identifiers.JobId
import xynolog.identifiers.ResourceId
import xynolog.transport.Delivered
import xynolog.transport.FrameRefusal
import xynolog.transport.PutBinaryRequest
import xynolog.types.AnchorRect
import xynolog.types.AnnotationSelector
import xynolog.types.BindBodyOperation
import xynolog.types.BindInitiateCommand
import xynolog.types.BrowseDirectoryRequestSort
import xynolog.types.BrowseResourcesRequest
import xynolog.types.ClaimOptions
import xynolog.types.CreateAnnotationRequest
import xynolog.types.CreateFromTokenOptions
import xynolog.types.GatherAnnotationOptions
import xynolog.types.GatherResourceOptions
import xynolog.types.GatheredContext
import xynolog.types.GenerationJobParams
import xynolog.types.JobPollOptions
import xynolog.types.MarkJobParams
import xynolog.types.MarkSubmitEvent
import xynolog.types.MatchSearchOptions
import xynolog.types.MatchSearchRequest
import xynolog.types.Motivation
import xynolog.types.ResourceErrorEvent
import xynolog.types.ResourceSearchFilters
import xynolog.types.TagSchema
import xynolog.types.wireJson

/** `value` with every `{"$fixture": name}` in it the table's fixture of that name. */
private fun resolved(value: JsonElement, fixtures: JsonObject): JsonElement = when (value) {
    is JsonObject -> value["\$fixture"]?.let { fixtures.getValue(it.jsonPrimitive.content) } ?: JsonObject(value.mapValues { resolved(it.value, fixtures) })
    is JsonArray -> JsonArray(value.map { resolved(it, fixtures) })
    else -> value
}

/** A case's arguments, read as the method takes them. */
private class Args(private val stated: JsonObject, private val fixtures: JsonObject) {
    operator fun get(name: String): JsonElement? = stated[name]?.let { resolved(it, fixtures) }

    fun getValue(name: String): JsonElement = get(name) ?: error("the case states no $name")

    fun text(name: String): String = getValue(name).jsonPrimitive.content

    fun texts(name: String): List<String> = getValue(name).jsonArray.map { it.jsonPrimitive.content }

    fun <T> read(name: String, serializer: KSerializer<T>): T = wireJson.decodeFromJsonElement(serializer, getValue(name))

    /** An object argument the case may leave out: one left out is the object that states nothing. */
    fun <T> stated(name: String, serializer: KSerializer<T>): T = wireJson.decodeFromJsonElement(serializer, get(name) ?: JsonObject(emptyMap()))

    fun resource(name: String = "resourceId"): ResourceId = ResourceId(text(name))

    fun annotation(name: String = "annotationId"): AnnotationId = AnnotationId(text(name))

    fun job(): JobId = JobId(text("jobId"))
}

/** A method as a case calls it. */
private typealias Call = suspend (XynologClient, Args) -> Any?

private fun <T> list(of: KSerializer<T>) = ListSerializer(of)

/** Each method this SDK has, as its cases call it, by `namespace.method`. */
private val calls: Map<String, Call> = mapOf(
    "frame.addEntityType" to { c, a -> c.frame.addEntityType(a.text("type")) },
    "frame.addEntityTypes" to { c, a -> c.frame.addEntityTypes(a.texts("types")) },
    "frame.addTagSchema" to { c, a -> c.frame.addTagSchema(a.read("schema", TagSchema.serializer())) },
    "browse.resource" to { c, a -> c.browse.resource(a.resource()).fresh() },
    "browse.resources" to { c, a -> c.browse.resources(a.stated("filters", BrowseResourcesRequest.serializer())).fresh() },
    "browse.annotations" to { c, a -> c.browse.annotations(a.resource()).fresh() },
    "browse.annotation" to { c, a -> c.browse.annotation(a.resource(), a.annotation()).fresh() },
    "browse.entityTypes" to { c, _ -> c.browse.entityTypes().fresh() },
    "browse.tagSchemas" to { c, _ -> c.browse.tagSchemas().fresh() },
    "browse.engines" to { c, _ -> c.browse.engines().fresh() },
    "browse.events" to { c, a -> c.browse.events(a.resource()).fresh() },
    "browse.resourceGraph" to { c, a -> c.browse.resourceGraph(a.resource()) },
    "browse.resourceAnchoredText" to { c, a -> c.browse.resourceAnchoredText(a.resource()) },
    "browse.resourceContent" to { c, a -> c.browse.resourceContent(a.resource()) },
    "browse.resourceRepresentation" to { c, a -> c.browse.resourceRepresentation(a.resource()) },
    "browse.resourceRepresentationStream" to { c, a -> c.browse.resourceRepresentationStream(a.resource()) },
    "browse.resourceEvents" to { c, a -> c.browse.resourceEvents(a.resource()) },
    "browse.annotationHistory" to { c, a -> c.browse.annotationHistory(a.resource(), a.annotation()) },
    "browse.files" to { c, a ->
        if (a["dirPath"] == null) c.browse.files() else c.browse.files(a.text("dirPath"), a.read("sort", BrowseDirectoryRequestSort.serializer()))
    },
    "browse.kb" to { c, _ -> c.browse.kb() },
    "browse.click" to { c, a -> c.browse.click(a.annotation(), a["anchorRect"]?.let { a.read("anchorRect", AnchorRect.serializer()) }) },
    "browse.openResource" to { c, a -> c.browse.openResource(a.resource()) },
    "browse.resourceViewed" to { c, a -> c.browse.resourceViewed(a.resource()) },
    "mark.annotation" to { c, a -> c.mark.annotation(a.read("input", CreateAnnotationRequest.serializer())) },
    "mark.delete" to { c, a -> c.mark.delete(a.resource(), a.annotation()) },
    "mark.archive" to { c, a -> c.mark.archive(a.resource()) },
    "mark.unarchive" to { c, a -> c.mark.unarchive(a.resource()) },
    "mark.updateEntityTypes" to { c, a -> c.mark.updateEntityTypes(a.resource(), a.texts("current"), a.texts("updated")) },
    "mark.delegate" to { c, a -> c.mark.delegate(a.resource(), a.read("params", MarkJobParams.serializer())).await() },
    "mark.request" to { c, a ->
        c.mark.request(a.resource("source"), a.read("selector", AnnotationSelector.serializer()), a.read("motivation", Motivation.serializer()))
    },
    "mark.submit" to { c, a -> c.mark.submit(a.read("input", MarkSubmitEvent.serializer())) },
    "mark.reportDeleteError" to { c, a -> c.mark.reportDeleteError(a.read("input", ResourceErrorEvent.serializer())) },
    "bind.body" to { c, a -> c.bind.body(a.resource(), a.annotation(), a.read("operations", list(BindBodyOperation.serializer()))) },
    "bind.initiate" to { c, a -> c.bind.initiate(a.read("input", BindInitiateCommand.serializer())) },
    "bind.reportBodyError" to { c, a -> c.bind.reportBodyError(a.read("input", ResourceErrorEvent.serializer())) },
    "gather.resource" to { c, a -> c.gather.resource(a.resource(), a.stated("options", GatherResourceOptions.serializer())) },
    "gather.referencedBy" to { c, a -> c.gather.referencedBy(a.resource()).fresh() },
    "gather.annotation" to { c, a -> c.gather.annotation(a.resource(), a.annotation(), a.stated("options", GatherAnnotationOptions.serializer())).await() },
    "match.search" to { c, a ->
        c.match.search(
            a.resource(),
            a.annotation("referenceId"),
            a.read("context", GatheredContext.serializer()),
            a.stated("options", MatchSearchOptions.serializer()),
        ).await()
    },
    "match.resources" to { c, a -> c.match.resources(a.text("search"), a.stated("filters", ResourceSearchFilters.serializer())).fresh() },
    "match.requestSearch" to { c, a -> c.match.requestSearch(a.read("input", MatchSearchRequest.serializer()), a.text("correlationId")) },
    "yield.resource" to { c, a ->
        val data = a.getValue("data").jsonObject
        fun text(name: String) = data.getValue(name).jsonPrimitive.content
        c.yield.resource(PutBinaryRequest(name = text("name"), file = text("file").toByteArray(), format = text("format"), storageUri = text("storageUri")))
    },
    "yield.delegate" to { c, a -> c.yield.delegate(a.read("params", GenerationJobParams.serializer()), a["stallDeadlineMs"]?.jsonPrimitive?.long).await() },
    "yield.createFromToken" to { c, a -> c.yield.createFromToken(a.read("options", CreateFromTokenOptions.serializer())) },
    "yield.cloneToken" to { c, a -> c.yield.cloneToken(a.resource()) },
    "yield.fromToken" to { c, a -> c.yield.fromToken(a.text("token")) },
    "yield.clone" to { c, _ -> c.yield.clone() },
    "beckon.attention" to { c, a -> c.beckon.attention(a.resource(), a["annotationId"]?.let { AnnotationId(it.jsonPrimitive.content) }) },
    "beckon.click" to { c, a -> c.beckon.click(a.annotation()) },
    "beckon.openResource" to { c, a -> c.beckon.openResource(a.resource()) },
    "beckon.sparkleAll" to { c, a -> c.beckon.sparkleAll(a.annotation()) },
    "beckon.hover" to { c, a -> c.beckon.hover(a["annotationId"]?.takeUnless { it is JsonNull }?.let { AnnotationId(it.jsonPrimitive.content) }) },
    "beckon.sparkle" to { c, a -> c.beckon.sparkle(a.annotation()) },
    "job.queued" to { c, _ -> c.job.queued() },
    "job.progress" to { c, _ -> c.job.progress() },
    "job.complete" to { c, _ -> c.job.complete() },
    "job.fail" to { c, _ -> c.job.fail() },
    "job.status" to { c, a -> c.job.status(a.job()) },
    "job.pollUntilComplete" to { c, a -> c.job.pollUntilComplete(a.job(), a.stated("options", JobPollOptions.serializer())) },
    "job.cancel" to { c, a -> c.job.cancel(a.job()) },
    // Read, the claims claim: the first claim is what the row holds.
    "job.claim" to { c, a -> c.job.claim(a.read("options", ClaimOptions.serializer())).next() },
    "auth.me" to { c, _ -> c.auth.me() },
    "auth.mediaToken" to { c, a -> c.auth.mediaToken(a.resource()) },
    "auth.protectedResourceMetadata" to { c, _ -> c.auth.protectedResourceMetadata() },
    "system.healthCheck" to { c, _ -> c.system.healthCheck() },
    "system.status" to { c, _ -> c.system.status() },
)

/** The registry's channel of `name`, as the SDK has it. */
private fun channelNamed(name: String): Channel<*> = Channels::class.java.fields.map { it.get(null) }.filterIsInstance<Channel<*>>().single { it.name == name }

/**
 * The client's surface against protocol/specs/src/client/surface.json: every method the
 * table lists is called as each of its cases states, and what the call did
 * first is held to the row. A row with no call here fails, and so does a call
 * here with no row: the table and this SDK list the same methods.
 */
class SurfaceTest {
    private val table = Spec.read("client/surface.json").jsonObject
    private val fixtures = table.getValue("fixtures").jsonObject

    /** Each method the table has, with its row. */
    private val rows: Map<String, JsonObject> = table.getValue("namespaces").jsonArray.map { it.jsonObject }
        .flatMap { namespace ->
            namespace.getValue("methods").jsonArray.map { it.jsonObject }
                .map { row -> "${namespace.getValue("namespace").jsonPrimitive.content}.${row.getValue("method").jsonPrimitive.content}" to row }
        }.toMap()

    @Test
    fun theTableAndThisSdkListTheSameMethods() {
        assertEquals(rows.keys, calls.keys)
    }

    @TestFactory
    fun eachCaseDoesWhatItsRowSays(): List<DynamicTest> = rows.flatMap { (method, row) ->
        val (route, name) = row.getValue("via").jsonObject.entries.single().let { it.key to it.value.jsonPrimitive.content }
        row.getValue("cases").jsonArray.map { it.jsonObject }.mapIndexed { index, case ->
            DynamicTest.dynamicTest("$method ${case["why"]?.jsonPrimitive?.content ?: "#${index + 1}"}") {
                held(method, Step(route, name, resolved(case.getValue("sends"), fixtures).jsonObject), Args(case.getValue("args").jsonObject, fixtures), case)
            }
        }
    }

    /** One thing a call does: through which route, to what, with what. */
    private data class Step(val route: String, val name: String, val sends: JsonObject)

    /** The steps a case states after its first, each as its row's `via` is stated. */
    private fun thenOf(case: JsonObject): List<Step> = case["then"]?.jsonArray.orEmpty().map { it.jsonObject }.map { step ->
        val (route, name) = step.entries.single { it.key != "sends" }.let { it.key to it.value.jsonPrimitive.content }
        Step(route, name, resolved(step.getValue("sends"), fixtures).jsonObject)
    }

    private fun held(method: String, first: Step, args: Args, case: JsonObject) = runBlocking {
        val (route, name, sends) = first
        val recording = Recording()
        XynologClient(recording, recording, recording).use { client ->
            val call = calls.getValue(method)
            when (route) {
                "local" -> {
                    val heard = client.bus.framesOn(name, null)
                    call(client, args)
                    val frame = withTimeout(5_000) { heard.first() }.frame()
                    assertTrue(sameJson(sends, frame.payload), "published ${frame.payload}, not $sends")
                }
                "observes" -> {
                    val reading = call(client, args) as Typed<*>
                    client.bus.emit(name, sends, null, null)
                    val delivered = when (val heard = withTimeout(5_000) { reading.first() }) {
                        is Delivered<*> -> heard
                        is FrameRefusal -> throw AssertionError("a payload on ${heard.channel} was refused: its `${heard.member}` ${heard.reason.value}")
                    }
                    // What the reader handed over is what the case's payload is as its channel's type.
                    assertEquals(decoded(channelNamed(name), sends), delivered.payload)
                }
                else -> {
                    case["answers"]?.let { recording.answer(name, resolved(it, fixtures)) }
                    val running = launch(Dispatchers.Default) { call(client, args) }
                    for ((at, step) in (listOf(first) + thenOf(case)).withIndex()) {
                        withTimeout(5_000) { while (recording.did.size <= at) delay(5) }
                        val did = recording.did[at]
                        // A request is an emit on its operation's request channel, as a drive is on its own.
                        val expected = if (step.route == "request" || step.route == "emit") "emit" else step.route
                        assertEquals(expected to step.name, did.route to did.name)
                        assertTrue(sameJson(step.sends, did.sends), "sent ${did.sends}, not ${step.sends}")
                    }
                    running.cancelAndJoin()
                }
            }
        }
    }
}
