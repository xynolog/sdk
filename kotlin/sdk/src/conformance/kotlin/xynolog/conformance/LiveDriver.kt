package xynolog.conformance

import kotlinx.coroutines.CompletableDeferred
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.map
import kotlinx.coroutines.joinAll
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import kotlinx.serialization.KSerializer
import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.builtins.serializer
import kotlinx.serialization.descriptors.elementNames
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.booleanOrNull
import kotlinx.serialization.json.longOrNull
import xynolog.ClientTiming
import xynolog.JobAttemptFailed
import xynolog.JobCompleted
import xynolog.JobCreated
import xynolog.JobEvent
import xynolog.JobProgressed
import xynolog.JobRefused
import xynolog.XynologClient
import xynolog.cache.CacheState
import xynolog.cache.Cached
import xynolog.channels.BRIDGED_CHANNELS
import xynolog.errors.XynologError
import xynolog.http.HttpContentTransport
import xynolog.http.HttpTransport
import xynolog.http.Timing
import xynolog.identifiers.AnnotationId
import xynolog.identifiers.ResourceId
import xynolog.registry.personKey
import xynolog.storage.CachePersistence
import xynolog.storage.MemoryStorage
import xynolog.transport.ConnectionState
import xynolog.types.Annotation
import xynolog.types.AttributedEvent
import xynolog.types.BrowseResourcesRequest
import xynolog.types.EngineWithLimits
import xynolog.types.GenerationJobParams
import xynolog.types.GetReferencedByResponseReferencedByItem
import xynolog.types.JobCompleteCommand
import xynolog.types.JobCreatedResultResponse
import xynolog.types.JobFailCommand
import xynolog.types.JobProgress
import xynolog.types.ListResourcesResponse
import xynolog.types.MarkJobParams
import xynolog.types.MatchResourcesResponse
import xynolog.types.ResourceDescriptor
import xynolog.types.ResourceSearchFilters
import xynolog.types.TagSchema

/**
 * The Kotlin SDK's live driver: the program the SDK conformance suite talks to
 * in the Kotlin SDK's place for the live layer (protocol/conformance/sdk/README.md,
 * The live driver). It holds a client, and reaches it only as an application
 * does, through what the SDK makes public.
 */
public fun main() {
    exporting().use { serve { LiveDriver() } }
}

/** A live query as the suite names it, and how its values are written. */
private class Query<T : Any>(val cached: Cached<T>, private val serializer: KSerializer<T>) {
    fun written(value: T): JsonElement = wire.encodeToJsonElement(serializer, value)

    /** Its states, each written as the suite reads one. */
    fun states(): Flow<JsonObject> = cached.map { state(it, ::written) }
}

/** A state as the suite reads one: pending, ready with its value, or failed with its error. */
private fun <T> state(state: CacheState<T>, written: (T) -> JsonElement): JsonObject = when (state) {
    is CacheState.Pending -> Say.of("status" to JsonPrimitive("pending"))
    is CacheState.Ready -> Say.of("status" to JsonPrimitive("ready"), "value" to written(state.value))
    is CacheState.Failed -> Say.of("status" to JsonPrimitive("failed"), "error" to failure(state.error))
}

/** A job event as the suite reads one: its kind, and what it carries. */
private fun event(event: JobEvent<JobCompleteCommand>): JsonObject = Say.of(
    "kind" to JsonPrimitive(event.kind),
    "data" to when (event) {
        is JobCreated -> wire.encodeToJsonElement(JobCreatedResultResponse.serializer(), event.data)
        is JobProgressed -> wire.encodeToJsonElement(JobProgress.serializer(), event.data)
        is JobAttemptFailed -> wire.encodeToJsonElement(JobFailCommand.serializer(), event.data)
        is JobRefused -> Say.of(
            "channel" to JsonPrimitive(event.data.channel),
            "member" to JsonPrimitive(event.data.member),
            "reason" to JsonPrimitive(event.data.reason.value),
        )
        is JobCompleted -> wire.encodeToJsonElement(JobCompleteCommand.serializer(), event.data)
    },
)

private class Opened(val client: XynologClient, val transport: HttpTransport, val content: HttpContentTransport)

private class LiveDriver : Driver {
    override val operations = setOf("open", "close", "observe", "unobserve", "fresh", "invalidate", "delete", "markDelegate", "yieldDelegate", "sync")

    // `fresh` and `delete` wait on the knowledge base, and run beside what follows them; every other operation settles before the next is read.
    override val inTurn = operations - setOf("fresh", "delete")

    /** What a client given `persist` keeps, across the `close` and the `open` that follows, as storage keeps it across a reload. */
    private val storage = MemoryStorage()

    /** Whom a client given `persist` keeps what it holds for: one fixed person, on a knowledge base the driver calls `conformance`. */
    private val keptFor = CachePersistence(storage, "conformance", personKey("did:web:conformance.example:users:driver"))

    private var opened: Opened? = null
    private val observers = mutableMapOf<String, Job>()
    private val unobserved = mutableSetOf<String>()
    private var reported: ConnectionState? = null

    // Observers are told each state in the thread that changed it, so a state is written before whatever changed it goes on.
    private val observing = CoroutineScope(SupervisorJob() + Dispatchers.Unconfined)
    private val reporting = CoroutineScope(SupervisorJob() + Dispatchers.Default)
    private val reporters = mutableListOf<Job>()

    private fun current(): Opened = synchronized(this) { opened } ?: throw Misuse("no client is open")

    private fun client(): XynologClient = current().client

    /** Report the state the transport is in, unless it is the one last reported. */
    private fun report(state: ConnectionState) {
        synchronized(this) {
            if (reported == state) return
            reported = state
        }
        Say.line(Say.of("state" to JsonPrimitive(state.wire)))
    }

    override suspend fun run(id: Long, op: String, args: JsonObject): JsonElement = when (op) {
        "open" -> open(args)
        "close" -> JsonNull.also { close() }
        "observe" -> observe(args)
        "unobserve" -> JsonNull.also { unobserve(args.text("observer")) }
        "fresh" -> fresh(query(args.obj("query")))
        "invalidate" -> JsonNull.also { query(args.obj("query")).cached.invalidate() }
        "delete" -> JsonNull.also { client().mark.delete(resource(args.text("resource")), annotation(args.text("annotation"))) }
        "markDelegate" -> follow(args.text("observer"), client().mark.delegate(resource(args.text("resource")), wire.decodeFromJsonElement(MarkJobParams.serializer(), args.obj("params"))))
        "yieldDelegate" -> {
            val params = wire.decodeFromJsonElement(GenerationJobParams.serializer(), args.obj("params"))
            val stallDeadlineMs = (args["stallDeadlineMs"] as? JsonPrimitive)?.longOrNull
            follow(args.text("observer"), client().yield.delegate(params, stallDeadlineMs))
        }
        "sync" -> JsonNull.also { synchronized(this) { opened }?.let { report(it.transport.state.value) } }
        else -> throw Misuse("$op is not an operation of this driver")
    }

    private fun resource(text: String): ResourceId = ResourceId.parse(text) ?: throw Misuse("$text is not a resource's id")

    private fun annotation(text: String): AnnotationId = AnnotationId.parse(text) ?: throw Misuse("$text is not an annotation's id")

    /** The client's timing and its transport's, with what the case overrides. */
    private fun timings(args: JsonObject): Pair<ClientTiming, Timing> {
        var client = ClientTiming()
        var transport = Timing()
        val stated = args["timing"] as? JsonObject ?: return client to transport
        for (name in stated.keys) {
            val ms = stated.count(name)
            when (name) {
                "busRequestTimeoutMs" -> client = client.copy(busRequestMs = ms)
                "invalidationWindowMs" -> client = client.copy(invalidationWindowMs = ms)
                "jobSilenceMs" -> client = client.copy(jobSilenceMs = ms)
                "jobStatusPollMs" -> client = client.copy(jobStatusPollMs = ms)
                "reconnectMs" -> transport = transport.copy(reconnectMs = ms)
                "lazyRemoveMs" -> transport = transport.copy(lazyRemoveMs = ms)
                "lingerMs" -> transport = transport.copy(lingerMs = ms)
                else -> throw Misuse("this driver cannot override $name")
            }
        }
        return client to transport
    }

    private fun open(args: JsonObject): JsonElement {
        synchronized(this) {
            if (opened?.client?.let { !it.bus.isDestroyed } == true) throw Misuse("a client is already open")
        }
        val (clientTiming, transportTiming) = timings(args)
        val persist = (args["persist"] as? JsonPrimitive)?.booleanOrNull == true
        val transport = HttpTransport(args.text("baseUrl"), MutableStateFlow(args.text("token")), BRIDGED_CHANNELS, timing = transportTiming)
        // Taken at once, so every failure from the first request on is heard.
        val failures = transport.failures()
        val content = HttpContentTransport(transport)
        val persistence = if (persist) keptFor else null
        val client = XynologClient(transport, content, transport, clientTiming, persistence)
        synchronized(this) {
            opened = Opened(client, transport, content)
            observers.clear()
            unobserved.clear()
            reported = null
        }
        reporters += reporting.launch { transport.state.collect { report(it) } }
        reporters += reporting.launch { failures.collect { Say.line(Say.of("error" to failure(it))) } }
        return JsonNull
    }

    private fun close() {
        val it = current()
        it.client.close()
        it.content.close()
        it.transport.close()
    }

    /** A query, by the suite's description of it. */
    private fun query(stated: JsonObject): Query<*> {
        val client = client()
        fun of() = resource(stated.text("resource"))
        return when (val name = stated.text("query")) {
            "resource" -> Query(client.browse.resource(of()), ResourceDescriptor.serializer())
            "annotations" -> Query(client.browse.annotations(of()), ListSerializer(Annotation.serializer()))
            "annotation" -> Query(client.browse.annotation(of(), annotation(stated.text("annotation"))), Annotation.serializer())
            "events" -> Query(client.browse.events(of()), ListSerializer(AttributedEvent.serializer()))
            "referencedBy" -> Query(client.gather.referencedBy(of()), ListSerializer(GetReferencedByResponseReferencedByItem.serializer()))
            "entityTypes" -> Query(client.browse.entityTypes(), ListSerializer(String.serializer()))
            "tagSchemas" -> Query(client.browse.tagSchemas(), ListSerializer(TagSchema.serializer()))
            "engines" -> Query(client.browse.engines(), ListSerializer(EngineWithLimits.serializer()))
            "resources" -> Query(client.browse.resources(filters(stated, BrowseResourcesRequest.serializer())), ListResourcesResponse.serializer())
            "matchedResources" -> Query(client.match.resources(stated.text("search"), filters(stated, ResourceSearchFilters.serializer())), MatchResourcesResponse.serializer())
            else -> throw Misuse("$name is no query of client/refresh.json")
        }
    }

    /** The filters of a list or a search, as the suite states them: none stated is a list's first page. */
    private fun <T> filters(stated: JsonObject, serializer: KSerializer<T>): T {
        val filters = stated["filters"] as? JsonObject ?: JsonObject(emptyMap())
        filters.keys.firstOrNull { it !in serializer.descriptor.elementNames }?.let { throw Misuse("$it is no filter of a list") }
        return try {
            wire.decodeFromJsonElement(serializer, filters)
        } catch (refused: IllegalArgumentException) {
            throw Misuse("filters: ${refused.message}")
        }
    }

    private suspend fun fresh(query: Query<*>): JsonElement = Say.of("value" to written(query))

    private suspend fun <T : Any> written(query: Query<T>): JsonElement = query.written(query.cached.fresh())

    /** Report each state `states` gives under the observer's name, and its end, once the first is written: what it holds at once is written before `observe` is answered. */
    private suspend fun observed(name: String, states: Flow<JsonObject>) {
        synchronized(this) {
            if (name in observers) throw Misuse("$name already observes")
        }
        val first = CompletableDeferred<Unit>()
        val job = observing.launch {
            try {
                states.collect { state ->
                    Say.line(Say.of("emission" to Say.of("observer" to JsonPrimitive(name), "state" to state)))
                    first.complete(Unit)
                }
            } finally {
                first.complete(Unit)
                if (synchronized(this@LiveDriver) { name !in unobserved }) Say.line(Say.of("completed" to JsonPrimitive(name)))
            }
        }
        synchronized(this) { observers[name] = job }
        first.await()
    }

    private suspend fun observe(args: JsonObject): JsonElement {
        observed(args.text("observer"), query(args.obj("query")).states())
        return JsonNull
    }

    private fun unobserve(name: String) {
        val job = synchronized(this) {
            val job = observers[name] ?: throw Misuse("$name observes nothing")
            unobserved += name
            job
        }
        job.cancel()
    }

    /** A job's follower, reported as an observer is: each event a ready state, its failure a failed state, and its end a completion. */
    private fun follow(name: String, events: Flow<JobEvent<JobCompleteCommand>>): JsonElement {
        synchronized(this) {
            if (name in observers) throw Misuse("$name already observes")
        }
        val job = observing.launch {
            try {
                events.collect { Say.line(Say.of("emission" to Say.of("observer" to JsonPrimitive(name), "state" to Say.of("status" to JsonPrimitive("ready"), "value" to event(it))))) }
            } catch (failed: XynologError) {
                Say.line(Say.of("emission" to Say.of("observer" to JsonPrimitive(name), "state" to Say.of("status" to JsonPrimitive("failed"), "error" to failure(failed)))))
            } finally {
                if (synchronized(this@LiveDriver) { name !in unobserved }) Say.line(Say.of("completed" to JsonPrimitive(name)))
            }
        }
        synchronized(this) { observers[name] = job }
        return JsonNull
    }

    override fun finish() {
        synchronized(this) { opened }?.let {
            it.client.close()
            it.content.close()
            it.transport.close()
        }
        runBlocking {
            synchronized(this@LiveDriver) { observers.values.toList() }.joinAll()
            reporters.toList().joinAll()
        }
        observing.cancel()
        reporting.cancel()
    }
}
