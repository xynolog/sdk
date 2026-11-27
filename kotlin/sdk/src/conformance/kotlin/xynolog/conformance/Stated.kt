package xynolog.conformance

import kotlinx.serialization.KSerializer
import kotlinx.serialization.SerializationException
import kotlinx.serialization.builtins.ListSerializer
import kotlinx.serialization.builtins.MapSerializer
import kotlinx.serialization.builtins.serializer
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.serializer
import xynolog.ClientTiming
import xynolog.TransportTiming
import xynolog.types.Annotation
import xynolog.types.ConformanceDriverLineClaimed
import xynolog.types.FailureClass
import xynolog.types.JobFilter
import xynolog.types.JobProgress
import xynolog.types.MarkJobResult
import xynolog.types.RetryBudget
import xynolog.types.UnitCursor
import xynolog.types.WorkerVitals
import xynolog.types.YieldJobResult

/** The timing of a client and of its transport, as a case has them. */
public data class ClientAndTransportTiming(public val client: ClientTiming, public val transport: TransportTiming)

/**
 * What a case states, read as the SDK's types, and what the SDK holds,
 * written as the wire writes it: the drivers' timing, and the worker driver's
 * JSON, which it reads here so that every call it makes of the SDK is Java's.
 * A value the type refuses is the suite's mistake.
 */
public object Stated {
    private fun <T> read(name: String, serializer: KSerializer<T>, value: JsonElement): T = try {
        wire.decodeFromJsonElement(serializer, value)
    } catch (refused: SerializationException) {
        throw Misuse("$name: ${refused.message}")
    } catch (refused: IllegalArgumentException) {
        throw Misuse("$name: ${refused.message}")
    }

    /** The client's and its transport's timing with each row `stated` names, as it states it: a name neither holds is the suite's mistake. */
    @JvmStatic
    public fun timings(stated: JsonObject): ClientAndTransportTiming =
        stated.keys.fold(ClientAndTransportTiming(ClientTiming(), TransportTiming())) { timing, name ->
            timing.client.stating(stated, name)?.let { timing.copy(client = it) }
                ?: timing.copy(transport = timing.transport.stating(stated, name) ?: throw cannotOverride(name))
        }

    /** The transport's timing with each row `stated` names, as it states it: a name it does not hold is the suite's mistake. */
    public fun transportTiming(stated: JsonObject): TransportTiming =
        stated.keys.fold(TransportTiming()) { timing, name -> timing.stating(stated, name) ?: throw cannotOverride(name) }

    private fun cannotOverride(name: String): Misuse = Misuse("this driver cannot override $name")

    /** This with the row `name` as `stated` states it; null when it holds no such row. */
    private fun ClientTiming.stating(stated: JsonObject, name: String): ClientTiming? = when (name) {
        "busRequestTimeoutMs" -> copy(busRequestTimeoutMs = stated.count(name))
        "invalidationWindowMs" -> copy(invalidationWindowMs = stated.count(name))
        "jobSilenceMs" -> copy(jobSilenceMs = stated.count(name))
        "jobStatusPollMs" -> copy(jobStatusPollMs = stated.count(name))
        else -> null
    }

    /** This with the row `name` as `stated` states it; null when it holds no such row. */
    private fun TransportTiming.stating(stated: JsonObject, name: String): TransportTiming? = when (name) {
        "emitRetry" -> {
            val budget = stated.obj(name)
            copy(emitRetry = RetryBudget(budget.count("attempts"), budget.count("initialDelayMs"), budget.count("maxDelayMs")))
        }
        "httpRequestTimeoutMs" -> copy(httpRequestTimeoutMs = stated.count(name))
        "streamOpenTimeoutMs" -> copy(streamOpenTimeoutMs = stated.count(name))
        "reconnectMs" -> copy(reconnectMs = stated.count(name))
        "lingerMs" -> copy(lingerMs = stated.count(name))
        "seenEventIdsCount" -> copy(seenEventIdsCount = stated.count(name).toInt())
        "lazyRemoveMs" -> copy(lazyRemoveMs = stated.count(name))
        else -> null
    }

    @JvmStatic
    public fun filters(value: JsonElement): List<JobFilter> = read("accepts", ListSerializer(serializer<JobFilter>()), value)

    @JvmStatic
    public fun progress(value: JsonElement): JobProgress = read("progress", JobProgress.serializer(), value)

    @JvmStatic
    public fun cursors(value: JsonElement): Map<String, UnitCursor> = read("unitCursors", MapSerializer(String.serializer(), UnitCursor.serializer()), value)

    @JvmStatic
    public fun annotations(value: JsonElement): List<Annotation> = read("annotations", ListSerializer(Annotation.serializer()), value)

    @JvmStatic
    public fun markResult(value: JsonElement): MarkJobResult = read("result", serializer<MarkJobResult>(), value)

    @JvmStatic
    public fun yieldResult(value: JsonElement): YieldJobResult = read("result", serializer<YieldJobResult>(), value)

    @JvmStatic
    public fun failureClass(value: JsonElement): FailureClass = read("failureClass", FailureClass.serializer(), value)

    @JvmStatic
    public fun written(claimed: ConformanceDriverLineClaimed): JsonElement = wire.encodeToJsonElement(ConformanceDriverLineClaimed.serializer(), claimed)

    @JvmStatic
    public fun written(vitals: WorkerVitals): JsonElement = wire.encodeToJsonElement(WorkerVitals.serializer(), vitals)
}
