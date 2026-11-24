package xynolog.errors

import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import xynolog.Spec

/** Every vocabulary of protocol/specs/src/errors/codes.json, and its enum here, code for code, in the table's order. A vocabulary the table gains fails until it has one. */
class ErrorCodesTest {
    @Test
    fun everyVocabularyIsAnEnumOfItsCodes() {
        val table = Spec.read("errors/codes.json").jsonObject
        assertEquals(table.keys - "\$comment", VOCABULARIES.keys)
        VOCABULARIES.forEach { (vocabulary, codes) ->
            val stated = table.getValue(vocabulary).jsonObject.getValue("codes").jsonArray.map { it.jsonObject.getValue("code").jsonPrimitive.content }
            assertEquals(stated, codes, vocabulary)
        }
    }

    private companion object {
        val VOCABULARIES: Map<String, List<String>> = mapOf(
            "busRequest" to BusRequestErrorCode.entries.map { it.code },
            "transport" to TransportErrorCode.entries.map { it.code },
            "job" to JobErrorCode.entries.map { it.code },
            "session" to SessionErrorCode.entries.map { it.code },
            "signIn" to SignInErrorCode.entries.map { it.code },
            "kbIdentity" to IdentityUnverifiableReason.entries.map { it.code },
            "spanRefusal" to SpanRefusal.entries.map { it.code },
            "control" to ControlErrorCode.entries.map { it.code },
        )
    }
}
