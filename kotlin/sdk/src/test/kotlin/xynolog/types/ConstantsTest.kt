package xynolog.types

import kotlinx.serialization.SerializationException
import kotlinx.serialization.json.JsonPrimitive
import kotlinx.serialization.json.booleanOrNull
import kotlinx.serialization.json.long
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertSame
import org.junit.jupiter.api.Assertions.assertThrows
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import java.nio.file.Path
import kotlin.io.path.listDirectoryEntries
import kotlin.io.path.nameWithoutExtension

/** A member of one integer or boolean is a type of its own: an object, read and written as that value. */
class ConstantsTest {
    /** Every constant the generator writes: its one instance, and its serializer. */
    private val constants: List<Pair<Any, ConstantSerializer<*>>> =
        Path.of("src/generated/kotlin/xynolog/types").listDirectoryEntries("*.kt").mapNotNull { file ->
            val name = "xynolog.types.${file.nameWithoutExtension}"
            val serializer = runCatching { Class.forName("$name\$Serializer").getField("INSTANCE").get(null) }.getOrNull()
            (serializer as? ConstantSerializer<*>)?.let { Class.forName(name).getField("INSTANCE").get(null) to it }
        }

    @Test
    fun aConstantIsReadFromItsValueAloneAndNoOther() {
        assertTrue(constants.size > 5, "the constants found: ${constants.size}")
        constants.forEach { (constant, serializer) ->
            assertSame(constant, wireJson.decodeFromString(serializer, serializer.wire.toString()), serializer.descriptor.serialName)
            val other = serializer.wire.booleanOrNull?.let { JsonPrimitive(!it) } ?: JsonPrimitive(serializer.wire.long + 1)
            val refused = assertThrows(SerializationException::class.java) { wireJson.decodeFromString(serializer, other.toString()) }
            assertEquals("a ${constant::class.simpleName} is ${serializer.wire}", refused.message)
        }
    }

    @Test
    fun aModelWritesItsConstantsAndReadsNoOtherValue() {
        assertEquals("""{"ready":true}""", wireJson.encodeToString(ConformanceDriverLineReady.serializer(), ConformanceDriverLineReady()))
        assertSame(ConformanceDriverLineReadyReady, wireJson.decodeFromString(ConformanceDriverLineReady.serializer(), """{"ready":true}""").ready)
        assertThrows(SerializationException::class.java) {
            wireJson.decodeFromString(ConformanceDriverLineReady.serializer(), """{"ready":false}""")
        }
    }
}
