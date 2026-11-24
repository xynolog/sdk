package xynolog.types

import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.KSerializer
import kotlinx.serialization.SerializationException
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement
import kotlinx.serialization.json.JsonIgnoreUnknownKeys
import kotlinx.serialization.json.JsonNull
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.buildJsonArray
import kotlinx.serialization.json.buildJsonObject
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertInstanceOf
import org.junit.jupiter.api.Assertions.assertNull
import org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import xynolog.Spec
import kotlin.io.path.listDirectoryEntries
import kotlin.io.path.nameWithoutExtension

/** A union's value is read as the one member whose signature admits it, as Typing states each member's. */
class UnionsTest {
    private val schemas = Spec.src.resolve("components/schemas").listDirectoryEntries("*.json").map { it.nameWithoutExtension }.sorted()

    /** The union serializer generated for [name], where its schema is a union. */
    private fun unionOf(name: String): SignatureUnionSerializer<*>? =
        runCatching { Class.forName("xynolog.types.${name}Serializer").getField("INSTANCE").get(null) }.getOrNull() as? SignatureUnionSerializer<*>

    private fun answer(wire: String): AnchoredTextAnswer = wireJson.decodeFromString(AnchoredTextAnswer.serializer(), wire)

    @Test
    fun everyUnionStatesASignatureOfEachOfItsMembers() {
        val unions = schemas.mapNotNull(::unionOf)
        assertTrue(unions.size > 10, "the unions found: ${unions.size}")
        unions.forEach { union ->
            assertEquals(union.members.size, union.variants().size, union.descriptor.serialName)
            assertTrue(union.members.all { it.isNotEmpty() }, union.descriptor.serialName)
        }
    }

    @Test
    fun aUnionIsDecodedAsTheOneMemberThatAdmitsAValue() {
        assertInstanceOf(AnchoredTextAbsent::class.java, answer("""{"kind":"no-map"}"""))
        assertInstanceOf(ExtractionDeclined::class.java, answer("""{"kind":"declined","declined":"encrypted"}"""))
        val lacking = assertThrows(SerializationException::class.java) { answer("""{"kind":"declined"}""") }
        assertTrue(lacking.message.orEmpty().contains("declined"), lacking.message)
        val unnamed = assertThrows(SerializationException::class.java) { answer("""{"kind":"later"}""") }
        assertTrue(unnamed.message.orEmpty().contains("`extracted`, `declined`, `not-yet`, `no-map`, `unknown`"), unnamed.message)
    }

    @Test
    fun aValueNoMemberNamesIsNoneOfThem() {
        assertNull(member(JsonPrimitive("text"), AnchoredTextAnswerSerializer.members))
        assertEquals("a JobStoredProgress that is none of its members", noneOf("JobStoredProgress", JobStoredProgressSerializer.members))
        assertThrows(SerializationException::class.java) {
            wireJson.decodeFromString(JobStoredProgress.serializer(), "\"text\"")
        }
    }

    @Test
    fun eachKindIsTheJsonItNames() {
        val values: List<JsonElement> =
            listOf(JsonPrimitive("a"), JsonPrimitive(1), JsonPrimitive(1.5), JsonPrimitive(true), buildJsonArray {}, buildJsonObject {}, JsonNull)
        val admitted =
            mapOf(
                Kind.TEXT to listOf(0),
                Kind.INTEGER to listOf(1),
                Kind.NUMBER to listOf(1, 2),
                Kind.BOOLEAN to listOf(3),
                Kind.LIST to listOf(4),
                Kind.OBJECT to listOf(5),
                Kind.NULL to listOf(6),
                Kind.ANY to values.indices.toList(),
            )
        assertEquals(Kind.entries.toSet(), admitted.keys)
        admitted.forEach { (kind, indices) -> assertEquals(indices, values.indices.filter { kind.of(values[it]) }, kind.name) }
    }

    @Test
    fun aLiteralIsTheOneValueItStates() {
        assertTrue(Literal.Integer(3).isOf(JsonPrimitive(3)))
        assertTrue(!Literal.Integer(3).isOf(JsonPrimitive("3")))
        assertTrue(Literal.Boolean(false).isOf(JsonPrimitive(false)))
        assertTrue(!Literal.Boolean(false).isOf(JsonPrimitive(true)))
        assertEquals("`3`, `false`, `x`", listOf(Literal.Integer(3), Literal.Boolean(false), Literal.Text("x")).joinToString(", "))
    }

    /** A union told apart by `kind`, whose second member admits only the members it names. */
    @Serializable(with = Closed.Serializer::class)
    private sealed interface Closed {
        @Serializable
        data class Open(val kind: String, val a: String) : Closed

        @OptIn(ExperimentalSerializationApi::class)
        @JsonIgnoreUnknownKeys
        @Serializable
        data class Shut(val kind: String, val b: Long) : Closed

        object Serializer : SignatureUnionSerializer<Closed>(
            Closed::class,
            members =
                listOf(
                    listOf(Signature(Kind.OBJECT, required = listOf("kind", "a"), allowed = null, fixed = listOf("kind" to listOf(Literal.Text("open"))), values = null)),
                    listOf(Signature(Kind.OBJECT, required = listOf("kind", "b"), allowed = listOf("kind", "b"), fixed = listOf("kind" to listOf(Literal.Text("shut"))), values = null)),
                ),
            variants = { listOf(Open.serializer(), Shut.serializer()) },
        )
    }

    private val closed: KSerializer<Closed> = Closed.Serializer

    @Test
    fun aMemberThatOnlyNamesAValueSaysItDoesNotAdmitIt() {
        assertEquals(Closed.Shut("shut", 1), wireJson.decodeFromString(closed, """{"kind":"shut","b":1}"""))
        val refused = assertThrows(SerializationException::class.java) { wireJson.decodeFromString(closed, """{"kind":"shut","b":1,"c":2}""") }
        assertEquals("a Closed its member Shut does not admit", refused.message)
        val unnamed = assertThrows(SerializationException::class.java) { wireJson.decodeFromString(closed, """{"kind":"other"}""") }
        assertEquals("a Closed states a `kind` that is one of `open`, `shut`", unnamed.message)
    }
}
