package xynolog

import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import xynolog.state.SearchState
import xynolog.types.FrameRefusalReason
import xynolog.types.JobCompleteCommand
import xynolog.types.JobCreatedResultResponse
import xynolog.types.JobFailCommand
import xynolog.types.JobProgress
import xynolog.types.wireJson
import java.lang.reflect.Modifier

private fun properties(schema: JsonElement): Set<String> = schema.jsonObject.getValue("properties").jsonObject.keys

private fun schema(name: String): JsonElement = Spec.read("client/types/$name.json")

/** What a class holds: the members of its constructor, each a field. */
private fun held(type: Class<*>): Set<String> = type.declaredFields.filterNot { Modifier.isStatic(it.modifiers) }.map { it.name }.toSet()

private val JOB = """"jobId":"job-1","resourceId":"res-1","jobType":"mark""""

/** One event of each kind; the `when` fails to compile on a kind JobEvent gains, for a sample of it. */
private fun events(): List<JobEvent<JobCompleteCommand>> {
    val samples = listOf(
        JobCreated(wireJson.decodeFromString(JobCreatedResultResponse.serializer(), """{"jobId":"job-1"}""")),
        JobProgressed(JobProgress(percentage = 50.0)),
        JobAttemptFailed(wireJson.decodeFromString(JobFailCommand.serializer(), """{$JOB,"error":"failed"}""")),
        JobRefused(RefusedFrame("", "", FrameRefusalReason.Lacks)),
        JobCompleted(wireJson.decodeFromString(JobCompleteCommand.serializer(), """{$JOB}""")),
    )
    for (sample in samples) {
        when (sample) {
            is JobCreated, is JobProgressed, is JobAttemptFailed, is JobRefused, is JobCompleted -> {}
        }
    }
    return samples
}

/**
 * The client types written by hand, each held to what states it: SearchState
 * and JobEvent, generic, to their schemas in protocol/specs/src/client/types.
 * A member or a branch either side gains or loses fails.
 */
class ClientTypesCensusTest {
    @Test
    fun searchStateHasTheSchemasMembers() {
        assertEquals(properties(schema("SearchState")), held(SearchState::class.java))
    }

    @Test
    fun jobEventHasTheSchemasBranchesEachOfItsMembers() {
        val branches = schema("JobEvent").jsonObject.getValue("oneOf").jsonArray.associateBy {
            it.jsonObject.getValue("properties").jsonObject.getValue("kind").jsonObject.getValue("enum").jsonArray[0].jsonPrimitive.content
        }
        val written = events().associate { it.kind to held(it.javaClass) + "kind" }
        assertEquals(branches.keys, written.keys)
        for ((kind, members) in written) assertEquals(properties(branches.getValue(kind)), members, kind)
        val refused = branches.getValue("refused").jsonObject.getValue("properties").jsonObject.getValue("data")
        assertEquals(properties(refused), held(RefusedFrame::class.java))
    }
}
