package xynolog.bus

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.take
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withTimeout
import kotlinx.serialization.SerializationException
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.jsonObject
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNull
import org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import xynolog.channels.CHANNEL_NAMES
import xynolog.channels.Channel
import xynolog.channels.Channels
import xynolog.channels.ScopedChannel
import xynolog.channels.TRACE_FIELD
import xynolog.errors.BusRequestError
import xynolog.errors.BusRequestErrorCode
import xynolog.errors.TransportError
import xynolog.errors.TransportErrorCode
import xynolog.errors.XynologError
import xynolog.identifiers.ResourceId
import xynolog.identifiers.UserId
import xynolog.transport.Broadcast
import xynolog.transport.Carried
import xynolog.transport.Delivered
import xynolog.transport.Events
import xynolog.transport.Frame
import xynolog.transport.FrameRefusal
import xynolog.transport.FrameSink
import xynolog.transport.Heard
import xynolog.transport.PendingReply
import xynolog.transport.ReplyRouter
import xynolog.transport.ResourceHold
import xynolog.transport.Transport
import xynolog.transport.Watched
import xynolog.types.AnchoredTextAnswer
import xynolog.types.BrowseProfilesRequest
import xynolog.types.BusPingMessage
import xynolog.types.ConnectionState
import xynolog.types.EmptyObject
import xynolog.types.Fault
import xynolog.types.FrameAddEntityTypeCommand
import xynolog.types.FrameRefusalReason
import xynolog.types.GatherAnnotationOptions
import xynolog.types.JobCompleteCommand
import xynolog.types.TraceCarrier
import xynolog.types.wireJson
import java.util.concurrent.CompletableFuture

private fun json(text: String): JsonObject = Json.parseToJsonElement(text).jsonObject

/** The shape the table writes as the JSON `written`. */
private fun shape(written: String): Shape = wireJson.decodeFromString(Shape.serializer(), written)

/** The first fault of the JSON `text` as the shape the table writes as `written`. */
private fun faultAs(written: String, text: String): Fault? = readAt(shape(written), Json.parseToJsonElement(text), "").fault

/** A step of one code point, `code`. */
private fun point(code: Int): String = """{"of":[[$code,$code]],"min":1,"max":1}"""

private val ALICE = "did:web:kb.example:users:alice"
private val ONE = ResourceId.parse("res-one")!!
private val TWO = ResourceId.parse("res-two")!!

/** What an emit was given. */
private data class Emitted(val channel: String, val payload: JsonObject, val scope: ResourceId?, val correlationId: String?)

/** A transport that delivers what a test gives it, and answers an emit as the test says. */
private class Wire(private val subscribed: Set<String>) : Transport {
    override val baseUrl: String = "http://kb.test"
    private val now = MutableStateFlow(ConnectionState.Open)
    override val state: Watched<ConnectionState> = Watched(now) { it == ConnectionState.Closed }
    val emitted = mutableListOf<Emitted>()
    var answer: (Emitted) -> Unit = {}
    private val channels = mutableMapOf<String, Broadcast<Carried>>()
    private val router = ReplyRouter(Dispatchers.Unconfined)
    val holds = mutableMapOf<ResourceId, Int>()

    override suspend fun emit(channel: String, payload: JsonObject, scope: ResourceId?, correlationId: String?): Long? {
        val sent = Emitted(channel, payload, scope, correlationId)
        emitted += sent
        answer(sent)
        return 1
    }

    override fun emitFuture(channel: String, payload: JsonObject, scope: ResourceId?, correlationId: String?): CompletableFuture<Long?> =
        throw UnsupportedOperationException("the bus emits by its own future")

    override fun frames(channel: String): Events<Carried> = synchronized(channels) { channels.getOrPut(channel) { Broadcast() } }.listen()

    fun deliver(carried: Carried) {
        synchronized(channels) { channels[carried.channel] }?.deliver(carried)
        router.route(carried)
    }

    override fun isSubscribed(channel: String): Boolean = channel in subscribed

    override fun subscribeToResource(resourceId: ResourceId): ResourceHold {
        synchronized(holds) { holds[resourceId] = (holds[resourceId] ?: 0) + 1 }
        return ResourceHold { synchronized(holds) { holds[resourceId] = holds.getValue(resourceId) - 1 } }
    }

    override fun failures(): Events<XynologError> = Broadcast<XynologError>().listen()

    override fun bridgeInto(bus: FrameSink): Unit = throw UnsupportedOperationException("nothing here bridges")

    override fun trackReply(correlationId: String, replyChannels: Collection<String>): PendingReply = router.track(correlationId, replyChannels)

    override fun close() {
        now.value = ConnectionState.Closed
        router.close()
    }
}

private val ADD = Operations.FRAME_ADD_ENTITY_TYPE

private fun added(tag: String): FrameAddEntityTypeCommand = decoded(Channels.FRAME_ADD_ENTITY_TYPE, json("""{"tag":"$tag"}"""))

/** This as the frame it is; a test that reads a refusal here fails. */
private fun <P> Heard<P>.delivered(): Delivered<P> = when (this) {
    is Delivered -> this
    is FrameRefusal -> throw AssertionError("refused: $this")
}

class BusTest {
    @Test
    fun anEmitSendsThePayloadAsTheWireCarriesIt() = runBlocking {
        val wire = Wire(emptySet())
        val reached = Bus(wire).emit(Channels.FRAME_ADD_ENTITY_TYPE, added("Person"), scope = ONE, correlationId = "c-1")
        assertEquals(1L, reached)
        assertEquals(listOf(Emitted("frame:add-entity-type", json("""{"tag":"Person"}"""), ONE, "c-1")), wire.emitted)
    }

    @Test
    fun aFrameIsGivenDecodedWithWhoEmittedItAndItsTrace() = runBlocking {
        val wire = Wire(emptySet())
        val frames = Bus(wire).frames(Channels.FRAME_ADD_ENTITY_TYPE)
        val trace = TraceCarrier("00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01")
        wire.deliver(Frame("frame:add-entity-type", json("""{"tag":"Person","_userId":"$ALICE","$TRACE_FIELD":{"traceparent":"${trace.traceparent}"}}"""), "c-1", null, trace))
        val delivered = withTimeout(5_000) { frames.first() }.delivered()
        assertEquals("delivered", delivered.status)
        assertEquals("Person", delivered.payload.tag)
        // A stamp its payload declares is the payload's own, and kept.
        assertEquals(UserId.parse(ALICE), delivered.payload.userId)
        assertEquals(UserId.parse(ALICE), delivered.userId)
        assertEquals("c-1", delivered.correlationId)
        assertEquals(trace, delivered.trace)
        assertNull(delivered.scope)
    }

    @Test
    fun aStampItsPayloadDoesNotDeclareIsLeftOutBeforeItIsRead() = runBlocking {
        val wire = Wire(emptySet())
        val frames = Bus(wire).frames(Channels.PANEL_CLOSE)
        wire.deliver(Frame("panel:close", json("""{"_userId":"$ALICE","$TRACE_FIELD":{"traceparent":"00-0af7651916cd43dd8448eb211c80319c-b7ad6b7169203331-01"}}""")))
        val delivered = withTimeout(5_000) { frames.first() }.delivered()
        assertEquals(EmptyObject, delivered.payload)
        assertEquals(UserId.parse(ALICE), delivered.userId)
    }

    @Test
    fun aFrameThatIsNotTheChannelsIsToldTheReaderInItsPlaceAndTheNextFollows() = runBlocking {
        val wire = Wire(emptySet())
        val frames = Bus(wire).frames(Channels.FRAME_ADD_ENTITY_TYPE)
        val lacking = json("""{"_userId":"$ALICE"}""")
        val malformed = json("""{"tag":{"not":"a tag"}}""")
        wire.deliver(Frame("frame:add-entity-type", lacking))
        wire.deliver(Frame("frame:add-entity-type", malformed))
        wire.deliver(Frame("frame:add-entity-type", json("""{"tag":"Person"}""")))
        val (refused, unread, next) = withTimeout(5_000) { frames.take(3).toList() }
        // The way from the frame to its first fault, why, and the payload as it came.
        assertEquals(FrameRefusal("frame:add-entity-type", "payload.tag", FrameRefusalReason.Lacks, lacking, null, null), refused)
        assertEquals("refused", refused.status)
        // One that holds a member of a kind its schema does not allow is malformed there.
        assertEquals(FrameRefusal("frame:add-entity-type", "payload.tag", FrameRefusalReason.Malformed, malformed, null, null), unread)
        assertEquals("Person", next.delivered().payload.tag)
    }

    @Test
    fun aFrameTheTransportRefusedIsToldTheReaderOfItsChannelAndScopeAsItCame() = runBlocking {
        val wire = Wire(emptySet())
        val frames = Bus(wire).frames(Channels.JOB_STARTED, ONE)
        fun refused(resource: ResourceId) = FrameRefusal("job:started", "correlationId", FrameRefusalReason.Malformed, json("{}"), null, resource)
        wire.deliver(refused(TWO))
        wire.deliver(refused(ONE))
        assertEquals(refused(ONE), withTimeout(5_000) { frames.first() })
    }

    @Test
    fun everyChannelsPayloadAndEveryUnionIsHeldToTheTableByItsSchemasName() {
        val payloads = Channels::class.java.fields.mapNotNull { field ->
            when (val channel = field.get(Channels)) {
                is Channel<*> -> channel.payload
                is ScopedChannel<*> -> channel.payload
                else -> null
            }
        }
        assertEquals(CHANNEL_NAMES.size, payloads.size)
        // What is held to the table is found there: a type the table does not name is refused.
        for (payload in payloads) faultOf(payload.descriptor, json("{}"))
        assertEquals(Fault("", FrameRefusalReason.Malformed), faultOf(AnchoredTextAnswer.serializer().descriptor, Json.parseToJsonElement("[]")))
        assertEquals(Fault("resourceId", FrameRefusalReason.Lacks), faultOf(JobCompleteCommand.serializer().descriptor, json("""{"jobType":"mark"}""")))
    }

    @Test
    fun aValueIsHeldToItsValuesItsFormItsSizeAndTheMembersAClosedObjectNames() {
        fun malformed(member: String) = Fault(member, FrameRefusalReason.Malformed)
        val ping = BusPingMessage.serializer().descriptor
        val profiles = BrowseProfilesRequest.serializer().descriptor
        val options = GatherAnnotationOptions.serializer().descriptor
        for ((descriptor, text, fault) in listOf(
            Triple(ping, """{"event":"ping","data":""}""", null),
            Triple(ping, """{"event":"pong","data":""}""", malformed("event")),
            Triple(ping, """{"event":"ping","data":"x"}""", malformed("data")),
            Triple(profiles, """{"dids":["did:web:example.org"]}""", null),
            Triple(profiles, """{"dids":["did:\ud83d\ude00"]}""", null),
            Triple(profiles, """{"dids":[]}""", malformed("dids")),
            Triple(profiles, """{"dids":["web:example.org"]}""", malformed("dids")),
            Triple(profiles, """{"dids":["did:web:a b"]}""", malformed("dids")),
            Triple(options, """{"contextWindow":100.0}""", null),
            Triple(options, """{"contextWindow":5000}""", null),
            Triple(options, """{"contextWindow":99}""", malformed("contextWindow")),
            Triple(options, """{"contextWindow":5001}""", malformed("contextWindow")),
            // A closed object: what it describes first, then the first member it does not name, by code point.
            Triple(profiles, """{"dids":["did:web:example.org"],"more":1}""", malformed("more")),
            Triple(profiles, """{"dids":[],"more":1}""", malformed("dids")),
            Triple(profiles, """{"more":1}""", Fault("dids", FrameRefusalReason.Lacks)),
            Triple(profiles, """{"dids":["did:web:example.org"],"\ud83d\ude00":1,"\uff61":1}""", malformed("\uff61")),
        )) {
            assertEquals(fault, faultOf(descriptor, Json.parseToJsonElement(text)), text)
        }
    }

    @Test
    fun aPatternsGroupIsOneOfItsAlternativesRepeatedAsOftenAsItSaysAndATextIsOfItWhenSomeReadingTakesAllOfIt() {
        fun malformed(member: String) = Fault(member, FrameRefusalReason.Malformed)
        val letter = """{"of":[[97,122]],"min":1,"max":1}"""
        val letters = """{"of":[[97,122]],"min":1}"""
        // ^(GET|POST) /, the end it does not anchor a step of any code points.
        val method = """{"kinds":["string"],"pattern":[{"either":[[${point(71)},${point(69)},${point(84)}],[${point(80)},${point(79)},${point(83)},${point(84)}]],"min":1,"max":1},${point(32)},${point(47)},{"of":[[0,1114111]],"min":0}]}"""
        // ^[a-z]+(-[a-z]+)*$
        val kebab = """{"kinds":["string"],"pattern":[$letters,{"either":[[${point(45)},$letters]],"min":0}]}"""
        // ^[a-z]{2,3}$, as a group
        val twoOrThree = """{"kinds":["string"],"pattern":[{"either":[[$letter]],"min":2,"max":3}]}"""
        // ^(a|ab)c$: the first alternative is given back for the second.
        val givenBack = """{"kinds":["string"],"pattern":[{"either":[[${point(97)}],[${point(97)},${point(98)}]],"min":1,"max":1},${point(99)}]}"""
        for ((written, text, fault) in listOf(
            Triple(method, "\"GET /\"", null),
            Triple(method, "\"POST /kb/x\"", null),
            Triple(method, "\"PUT /\"", malformed("")),
            Triple(method, "\"GET\"", malformed("")),
            Triple(kebab, "\"a\"", null),
            Triple(kebab, "\"one-two-three\"", null),
            Triple(kebab, "\"one--two\"", malformed("")),
            Triple(kebab, "\"one-\"", malformed("")),
            Triple(twoOrThree, "\"ab\"", null),
            Triple(twoOrThree, "\"abc\"", null),
            Triple(twoOrThree, "\"a\"", malformed("")),
            Triple(twoOrThree, "\"abcd\"", malformed("")),
            Triple(givenBack, "\"ac\"", null),
            Triple(givenBack, "\"abc\"", null),
            Triple(givenBack, "\"abac\"", malformed("")),
        )) {
            assertEquals(fault, faultAs(written, text), text)
        }
        // A term is a step or a group, never both, and a table part no reader knows is refused.
        assertThrows(SerializationException::class.java) { shape("""{"pattern":[{"of":[[97,97]],"either":[],"min":1}]}""") }
        assertThrows(SerializationException::class.java) { shape("""{"pattern":[{"of":[[97,97]],"min":1,"times":2}]}""") }
        assertThrows(SerializationException::class.java) { shape("""{"kinds":["object"],"notAny":[["a"]]}""") }
    }

    @Test
    fun anObjectCarriesNoSetOfNotAllWholeAtLeastMinMembersAndNamesItsMembersAsNamesSays() {
        fun malformed(member: String) = Fault(member, FrameRefusalReason.Malformed)
        val lowerNames = """{"kinds":["string"],"pattern":[{"of":[[97,122]],"min":1}]}"""
        val either = """{"kinds":["object"],"notAll":[["port","external"]]}"""
        val some = """{"kinds":["object"],"minMembers":1}"""
        val lower = """{"kinds":["object"],"names":$lowerNames}"""
        val ordered = """{"kinds":["object"],"required":["a"],"names":$lowerNames,"notAll":[["a","b"]]}"""
        val fewest = """{"kinds":["object"],"minMembers":2,"required":["a"]}"""
        for ((written, text, fault) in listOf(
            Triple(either, """{"port":1}""", null),
            Triple(either, """{"external":"x"}""", null),
            Triple(either, """{"port":1,"external":"x"}""", malformed("")),
            // A member that holds null is carried.
            Triple(either, """{"port":1,"external":null}""", malformed("")),
            Triple(some, """{"a":1}""", null),
            Triple(some, "{}", malformed("")),
            Triple(lower, """{"ab":1,"cd":2}""", null),
            // The first name not of names, by code point.
            Triple(lower, """{"ab":1,"X":3,"Cd":2}""", malformed("Cd")),
            // What the object requires first, then its members' names, then the sets it carries whole.
            Triple(ordered, """{"B":1}""", Fault("a", FrameRefusalReason.Lacks)),
            Triple(ordered, """{"a":1,"B":1,"b":1}""", malformed("B")),
            Triple(ordered, """{"a":1,"b":1}""", malformed("")),
            // minMembers is a bound, found before the members it requires.
            Triple(fewest, """{"b":1}""", malformed("")),
            Triple(fewest, """{"b":1,"c":1}""", Fault("a", FrameRefusalReason.Lacks)),
        )) {
            assertEquals(fault, faultAs(written, text), text)
        }
    }

    @Test
    fun aFrameThatLacksAMemberDeepInsideItIsRefusedByTheWayToIt() = runBlocking {
        val wire = Wire(emptySet())
        val frames = Bus(wire).frames(Channels.JOB_STARTED, ONE)
        val unsequenced = json(
            """{"id":"e-1","type":"job:started","timestamp":"2026-10-29T00:00:00Z","userId":"$ALICE","resourceId":"${ONE.value}","version":1,"payload":{},"metadata":{}}""",
        )
        wire.deliver(Frame("job:started", unsequenced, null, ONE))
        assertEquals(FrameRefusal("job:started", "payload.metadata.sequenceNumber", FrameRefusalReason.Lacks, unsequenced, null, ONE), withTimeout(5_000) { frames.first() })
    }

    @Test
    fun aScopedChannelIsReadForOneResourceAndHoldsItsScopeWhileItIsRead() = runBlocking {
        val wire = Wire(emptySet())
        val frames = Bus(wire).frames(Channels.JOB_STARTED, ONE)
        assertEquals(1, wire.holds[ONE])
        fun stored(resource: ResourceId) = json(
            """{"id":"e-1","type":"job:started","timestamp":"2026-10-29T00:00:00Z","userId":"$ALICE","resourceId":"${resource.value}","version":1,"payload":{},"metadata":{"sequenceNumber":1}}""",
        )
        wire.deliver(Frame("job:started", stored(TWO), null, TWO))
        wire.deliver(Frame("job:started", stored(ONE), null, ONE))
        val delivered = withTimeout(5_000) { frames.first() }.delivered()
        assertEquals(ONE, delivered.scope)
        assertEquals("job:started", delivered.payload.type)
        // Its reading is over, and with it the hold.
        assertEquals(0, wire.holds[ONE])
    }

    @Test
    fun closingAReadEndsItAndLetsGoOfItsScope() = runBlocking {
        val wire = Wire(emptySet())
        val frames = Bus(wire).frames(Channels.JOB_STARTED, ONE)
        frames.close()
        assertEquals(0, wire.holds[ONE])
        assertEquals(emptyList<Heard<*>>(), withTimeout(5_000) { frames.toList() })
    }

    @Test
    fun aTypedRequestGivesItsOperationsResult() = runBlocking {
        val wire = Wire(replyChannelsFor(ADD).toSet())
        wire.answer = { sent -> wire.deliver(Frame("frame:entity-type-add-ok", json("{}"), sent.correlationId)) }
        assertEquals(EmptyObject, Bus(wire).request(ADD, added("Person"), timeoutMs = 5_000))
        assertEquals("frame:add-entity-type", wire.emitted.single().channel)
        assertEquals(json("""{"tag":"Person"}"""), wire.emitted.single().payload)
    }

    @Test
    fun aFailureReplyIsTheRequestsError() = runBlocking {
        val wire = Wire(replyChannelsFor(ADD).toSet())
        wire.answer = { sent -> wire.deliver(Frame("frame:entity-type-add-failed", json("""{"message":"no such thing"}"""), sent.correlationId)) }
        val error = assertThrows(BusRequestError::class.java) { runBlocking { Bus(wire).request(ADD, added("Person"), timeoutMs = 5_000) } }
        assertEquals("no such thing", error.message)
    }

    @Test
    fun aFailureWhoseCodeTheWireDoesNotListIsRejectedInItsOwnWords() = runBlocking {
        val wire = Wire(replyChannelsFor(ADD).toSet())
        wire.answer = { sent -> wire.deliver(Frame("frame:entity-type-add-failed", json("""{"message":"a code from a later peer","code":"not-a-code-yet"}"""), sent.correlationId)) }
        val error = assertThrows(BusRequestError::class.java) { runBlocking { Bus(wire).request(ADD, added("Person"), timeoutMs = 5_000) } }
        assertEquals(BusRequestErrorCode.Rejected, error.reason)
        assertEquals("a code from a later peer", error.message)
        // It fails with the failure as read: the code the wire does not list is no part of it.
        assertEquals(json("""{"message":"a code from a later peer"}"""), error.failure)
    }

    // A failure is held to its channel's schema as a result is: one with no
    // words, or with a code that is no text, is not its channel's, and is
    // refused naming its first fault. It is given no words.
    @Test
    fun aFailureThatIsNotItsChannelsIsRefusedNamingItsFault() = runBlocking {
        for ((failure, said) in listOf(
            "{}" to "it has no `message`",
            """{"code":"not-found"}""" to "it has no `message`",
            """{"message":"refused","code":7}""" to "its `code` is malformed",
        )) {
            val wire = Wire(replyChannelsFor(ADD).toSet())
            wire.answer = { sent -> wire.deliver(Frame("frame:entity-type-add-failed", json(failure), sent.correlationId)) }
            val error = assertThrows(TransportError::class.java) { runBlocking { Bus(wire).request(ADD, added("Person"), timeoutMs = 5_000) } }
            assertEquals(TransportErrorCode.Error, error.reason)
            assertEquals("a payload on frame:entity-type-add-failed is not that channel's: $said", error.message)
        }
    }

    @Test
    fun aResultThatIsNotTheOperationsIsATransportFailure() = runBlocking {
        val wire = Wire(replyChannelsFor(ADD).toSet())
        wire.answer = { sent -> wire.deliver(Frame("frame:entity-type-add-ok", json("""{"unasked":true,"_userId":"$ALICE"}"""), sent.correlationId)) }
        val error = assertThrows(TransportError::class.java) { runBlocking { Bus(wire).request(ADD, added("Person"), timeoutMs = 5_000) } }
        assertEquals(TransportErrorCode.Error, error.reason)
        // What it says names the channel, and none of what the payload held.
        assertTrue(error.message.contains("frame:entity-type-add-ok"), error.message)
        assertTrue(!error.message.contains("unasked") && !error.message.contains(ALICE), error.message)
    }

    @Test
    fun aReplyRefusedWithTheRequestsCorrelationIdFailsTheRequestAtOnce() = runBlocking {
        val wire = Wire(replyChannelsFor(ADD).toSet())
        wire.answer = { sent ->
            wire.deliver(FrameRefusal("frame:entity-type-add-ok", "addedByALaterGateway", FrameRefusalReason.Malformed, json("{}"), sent.correlationId, null))
        }
        // Long before the request's own timeout.
        val error = assertThrows(TransportError::class.java) {
            runBlocking { withTimeout(5_000) { Bus(wire).request(ADD, added("Person"), timeoutMs = 60_000) } }
        }
        assertEquals(TransportErrorCode.Error, error.reason)
        assertEquals("a frame on frame:entity-type-add-ok is not that channel's: its `addedByALaterGateway` is malformed", error.message)
    }

    @Test
    fun aRequestWhoseRepliesCannotArriveIsRefusedAndSendsNothing() = runBlocking {
        val wire = Wire(emptySet())
        val error = assertThrows(BusRequestError::class.java) { runBlocking { Bus(wire).request(ADD, added("Person"), timeoutMs = 5_000) } }
        assertEquals(BusRequestErrorCode.Unsubscribed, error.reason)
        assertTrue(wire.emitted.isEmpty())
    }

    @Test
    fun theFreeRequestGivesTheReplyAsItCame() = runBlocking {
        val wire = Wire(replyChannelsFor(ADD).toSet())
        wire.answer = { sent -> wire.deliver(Frame("frame:entity-type-add-ok", json("""{"_userId":"$ALICE"}"""), sent.correlationId)) }
        assertEquals(json("""{"_userId":"$ALICE"}"""), request(wire, OPERATIONS.getValue("frame:add-entity-type"), json("""{"tag":"Person"}"""), 5_000))
    }

    @Test
    fun replyChannelsForNamesEachChannelOnce() {
        assertEquals(listOf("frame:entity-type-add-ok", "frame:entity-type-add-failed"), replyChannelsFor(ADD, ADD))
    }
}
