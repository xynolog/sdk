package xynolog.transport

import kotlinx.serialization.descriptors.elementNames
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import xynolog.types.BusFrame
import java.lang.reflect.Modifier

/** Frame, written by hand, held to BusFrame: it is the wire's frame, with the trace it was sent under and where its stream was. A member BusFrame gains or loses fails. */
class FrameTest {
    @Test
    fun aFrameIsABusFrameWithItsTraceAndItsPlace() {
        val held = Frame::class.java.declaredFields.filterNot { Modifier.isStatic(it.modifiers) }.map { it.name }.toSet()
        assertEquals(BusFrame.serializer().descriptor.elementNames.toSet() + setOf("trace", "place"), held)
    }
}
