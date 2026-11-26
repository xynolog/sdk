package xynolog.cache

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import xynolog.types.CacheStatus

/** Each of Protocol's CacheStatus is the status of one CacheState: a status the schema gains fails. */
class CacheStateTest {
    @Test
    fun eachStatusIsAState() {
        assertEquals(CacheStatus.entries, listOf(CacheState.Pending.status, CacheState.Ready(Unit).status, CacheState.Failed(IllegalStateException()).status))
    }
}
