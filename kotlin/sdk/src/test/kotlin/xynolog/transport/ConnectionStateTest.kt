package xynolog.transport

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import xynolog.types.ConformanceStepStateState

/** ConnectionState, written by hand, held to the only schema that states the states: the conformance step's. A state either side gains or loses fails. */
class ConnectionStateTest {
    @Test
    fun theStatesAreTheConformanceStepsStates() {
        assertEquals(ConformanceStepStateState.entries.map { it.value }, ConnectionState.entries.map { it.wire })
    }
}
