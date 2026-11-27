package xynolog.services

import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import kotlinx.serialization.serializer
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.DynamicTest
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.TestFactory
import xynolog.Spec
import xynolog.Tables
import xynolog.sameJson
import xynolog.types.wireJson

/**
 * ServiceTables and Tables against protocol/specs/src: each table written
 * back by its type what its file is; and ArchivistRoute against the
 * Archivist's HTTP document, which fails here when it gains an operation
 * ArchivistRoute does not name.
 */
class ServiceTablesTest {
    @TestFactory
    fun everyCarriedTableIsItsFile(): List<DynamicTest> = (ServiceTables.SERVICE_TABLES + Tables.TABLES).map { (file, table) ->
        DynamicTest.dynamicTest(file) {
            val written = wireJson.encodeToJsonElement(serializer(table.javaClass), table)
            assertTrue(sameJson(Spec.read(file), written), "$file is not what the SDK holds")
        }
    }

    @Test
    fun everyArchivistRouteIsAnOperationOfItsDocument() {
        val stated = Spec.read("archivist/openapi.json").jsonObject.getValue("paths").jsonObject.flatMap { (path, reference) ->
            val item = Spec.read("archivist/" + reference.jsonObject.getValue("\$ref").jsonPrimitive.content).jsonObject
            item.keys.filter { it in HTTP_METHODS }.map { it.uppercase() to path }
        }
        assertEquals(stated.toSet(), ArchivistRoute.entries.map { it.method to it.path }.toSet())
        assertEquals(stated.size, ArchivistRoute.entries.size)
    }

    private companion object {
        val HTTP_METHODS = setOf("get", "put", "post", "delete", "patch", "head", "options")
    }
}
