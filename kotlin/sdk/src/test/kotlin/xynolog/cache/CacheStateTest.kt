package xynolog.cache

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import xynolog.types.ConformanceDriverLineEmissionEmissionStateFailedStatus
import xynolog.types.ConformanceDriverLineEmissionEmissionStatePendingStatus
import xynolog.types.ConformanceDriverLineEmissionEmissionStateReadyStatus

/** CacheState, written by hand, held to the only schema that states its JSON: a conformance driver's emission. A status either side gains, loses or spells otherwise fails. */
class CacheStateTest {
    @Test
    fun eachStatusIsTheEmissionsSpellingOfIt() {
        val stated = listOf(
            ConformanceDriverLineEmissionEmissionStatePendingStatus.entries.single().value,
            ConformanceDriverLineEmissionEmissionStateReadyStatus.entries.single().value,
            ConformanceDriverLineEmissionEmissionStateFailedStatus.entries.single().value,
        )
        assertEquals(stated, listOf(CacheState.Pending.status, CacheState.Ready(Unit).status, CacheState.Failed(IllegalStateException()).status))
    }
}
