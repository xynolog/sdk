package xynolog.http

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.CsvSource
import xynolog.errors.TransportErrorCode

/** A refusal's body is read as the table holds it: a null where its schema allows none is refused, not read as absent. */
class RefusalBodiesTest {
    @ParameterizedTest
    @CsvSource(
        delimiter = '|',
        value = [
            """{"error":"refused","code":"refusal-rate"}|true""",
            """{"error":"refused","code":"emit-rate"}|false""",
            """{"error":"refused","code":"refusal-rate","hint":null}|false""",
            """{"code":"refusal-rate"}|false""",
        ],
    )
    fun a429RefusesTheTokenOnlyByALimitRefusalNamingRefusalRate(body: String, refuses: Boolean) {
        assertEquals(refuses, refusal("refused", 429, body.toByteArray(), null).reason == TransportErrorCode.Unauthorized)
    }

    @ParameterizedTest
    @CsvSource(
        delimiter = '|',
        nullValues = ["none"],
        value = [
            """{"error":"refused"}|refused""",
            """{"error":"refused","hint":null}|none""",
            """{"code":"x"}|none""",
        ],
    )
    fun theGatewaysWordsAreWhatAnErrorResponseStates(body: String, words: String?) {
        assertEquals(words, said(body.toByteArray()))
    }
}
