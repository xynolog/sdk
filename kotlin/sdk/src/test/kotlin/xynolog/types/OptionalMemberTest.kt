package xynolog.types

import kotlinx.serialization.json.JsonElement
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNull
import org.junit.jupiter.api.Test
import xynolog.bus.faultOfSchema
import xynolog.types.Fault

/** A member the spec says is optional, and not nullable, is absent or a value, each written as it was read; a null for it is refused. */
class OptionalMemberTest {
    private fun read(json: String) = wireJson.decodeFromString(GetAnnotationsResponse.serializer(), json)
    private fun written(response: GetAnnotationsResponse) = wireJson.encodeToString(GetAnnotationsResponse.serializer(), response)
    private fun fault(json: String) = faultOfSchema("GetAnnotationsResponse", wireJson.decodeFromString(JsonElement.serializer(), json))

    @Test
    fun absentIsAbsent() {
        val wire = """{"annotations":[],"total":0}"""
        assertNull(fault(wire))
        val response = read(wire)
        assertNull(response.motivation)
        assertEquals("""{"annotations":[],"total":0.0}""", written(response))
    }

    @Test
    fun aValueIsThatValue() {
        val wire = """{"annotations":[],"total":0,"motivation":"linking"}"""
        assertNull(fault(wire))
        val response = read(wire)
        assertEquals(Motivation.Linking, response.motivation)
        assertEquals("""{"annotations":[],"total":0.0,"motivation":"linking"}""", written(response))
    }

    @Test
    fun nullIsRefused() {
        assertEquals(Fault("motivation", FrameRefusalReason.Malformed), fault("""{"annotations":[],"total":0,"motivation":null}"""))
    }
}
