package xynolog.control

import kotlinx.serialization.json.JsonObject
import kotlinx.serialization.json.boolean
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import xynolog.Spec

/** ControlMethods against protocol/specs/src/control/methods.json: every notification and method, in the table's order, with what each carries, and ControlSender against the table schema's sides. */
class ControlMethodsTest {
    private val table = Spec.read("control/methods.json").jsonObject

    private fun rows(member: String): List<JsonObject> = table.getValue(member).jsonArray.map { it.jsonObject }

    private fun text(row: JsonObject, member: String): String = row.getValue(member).jsonPrimitive.content

    /** The type a row names by its `$id`: xynolog.types names it by its file's stem. */
    private fun named(id: String): String = id.substringAfterLast('/').removeSuffix(".json")

    @Test
    fun everyNotificationIsARow() {
        val stated = rows("notifications").map { row -> listOf(text(row, "name"), text(row, "from"), named(text(row, "params"))) }
        val held = ControlMethods.NOTIFICATIONS.map { (name, n) -> listOf(name, n.sentBy.value, n.params.descriptor.serialName.substringAfterLast('.')) }
        assertEquals(stated, held)
        ControlMethods.NOTIFICATIONS.forEach { (name, n) -> assertEquals(name, n.name) }
    }

    @Test
    fun everyMethodIsARow() {
        val stated = rows("methods").map { row ->
            listOf(text(row, "name"), named(text(row, "params")), named(text(row, "result")), row.getValue("exclusive").jsonPrimitive.boolean.toString(), row.getValue("sends").jsonArray.map { it.jsonPrimitive.content }.toString())
        }
        val held = ControlMethods.METHODS.map { (name, m) ->
            listOf(name, m.params.descriptor.serialName.substringAfterLast('.'), m.result.descriptor.serialName.substringAfterLast('.'), m.exclusive.toString(), m.sends.map { it.name }.toString())
        }
        assertEquals(stated, held)
        ControlMethods.METHODS.forEach { (name, m) -> assertEquals(name, m.name) }
    }

    @Test
    fun theSidesAreTheTableSchemas() {
        val from = Spec.read("control/ControlMethods.json").jsonObject.getValue("properties").jsonObject.getValue("notifications").jsonObject
            .getValue("items").jsonObject.getValue("properties").jsonObject.getValue("from").jsonObject.getValue("enum").jsonArray
        assertEquals(from.map { it.jsonPrimitive.content }, ControlSender.entries.map { it.value })
    }
}
