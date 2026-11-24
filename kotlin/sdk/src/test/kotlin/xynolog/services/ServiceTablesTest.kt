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
import xynolog.sameJson
import xynolog.types.wireJson
import kotlin.io.path.name

/**
 * ServiceTables against protocol/specs/src: every table of a service's area,
 * and of the services' shared environment, telemetry and jobs, that is no
 * case table, and the bounds of the bus's replies, each written back by its
 * type what its file is. A table such a directory gains fails here until the
 * generator carries it; so does the Archivist's HTTP document gaining an
 * operation ArchivistRoute does not name.
 */
class ServiceTablesTest {
    @Test
    fun everyServiceTableIsCarried() {
        val stated = AREAS.flatMap { area ->
            val directory = Spec.src.resolve(area)
            if (!directory.toFile().isDirectory) {
                emptyList()
            } else {
                Spec.jsonFiles(directory).filter { it.parent == directory }.map { it.name }
                    .filter { it.first().isLowerCase() && !it.endsWith("cases.json") }
                    .map { "$area/$it" }
            }
        } - NOT_TABLES + "bus/reply-bounds.json"
        assertEquals(stated.sorted(), ServiceTables.SERVICE_TABLES.keys.sorted())
    }

    @TestFactory
    fun everyServiceTableIsItsFile(): List<DynamicTest> = ServiceTables.SERVICE_TABLES.map { (file, table) ->
        DynamicTest.dynamicTest(file) {
            val written = wireJson.encodeToJsonElement(serializer(table.javaClass), table)
            assertTrue(sameJson(Spec.read(file), written), "$file is not what ServiceTables holds")
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
        /** The services' areas, and their shared environment, telemetry and jobs. */
        val AREAS = listOf(
            "archivist", "dispatcher", "embedding", "gateway", "graph", "librarian", "smelter", "vectors", "weaver", "worker",
            "service-environment", "service-telemetry", "jobs",
        )

        /** What an area holds that is no table: the Archivist's HTTP document, which ArchivistRoute is of. */
        val NOT_TABLES = setOf("archivist/openapi.json")

        val HTTP_METHODS = setOf("get", "put", "post", "delete", "patch", "head", "options")
    }
}
