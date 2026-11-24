package xynolog.bus

import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.boolean
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.DynamicTest
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.TestFactory
import xynolog.Spec
import xynolog.types.FrameRefusalReason
import xynolog.types.wireJson

/** The first fault of a value as a schema Protocol states, held to protocol/specs/src/client/shape-cases.json. */
class ShapeCasesTest {
    private val cases: List<JsonObject> = Spec.read("client/shape-cases.json").jsonObject.getValue("cases").jsonArray.map { it.jsonObject }

    private fun JsonObject.text(name: String) = getValue(name).jsonPrimitive.content

    /** The fault a case states: none for a value that is read, and its `member` and `reason` for one that is refused. */
    private fun stated(case: JsonObject): Fault? =
        if (case["refused"]?.jsonPrimitive?.boolean == true) {
            Fault(case.text("member"), wireJson.decodeFromJsonElement(FrameRefusalReason.serializer(), case.getValue("reason")))
        } else {
            null
        }

    @Test
    fun theRunnerFoundTheTablesCases() {
        assertTrue(cases.isNotEmpty(), "shape-cases.json states no case")
    }

    @TestFactory
    fun aValuesFirstFaultIsTheOneTheTableStates(): List<DynamicTest> = cases.map { case ->
        DynamicTest.dynamicTest(case.text("why")) {
            val schema = case.text("schema")
            assertTrue(schema in REQUIRED_SCHEMAS, "the table has no schema $schema")
            assertEquals(stated(case), faultOfSchema(schema, case.getValue("value")), "${case.getValue("value")} as $schema")
        }
    }
}
