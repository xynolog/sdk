package xynolog.readme

// The README's first program, a whole file but for its package: its imports are in the region, as a reader's file has them.

// readme: a-first-program
import kotlinx.coroutines.flow.MutableStateFlow
import xynolog.XynologClient
import xynolog.channels.BRIDGED_CHANNELS
import xynolog.http.HttpContentTransport
import xynolog.http.HttpTransport

suspend fun main(args: Array<String>) {
    val (baseUrl, token) = args
    HttpTransport(baseUrl, MutableStateFlow(token), BRIDGED_CHANNELS).use { transport ->
        XynologClient(transport, HttpContentTransport(transport), transport).use { client ->
            println(client.browse.kb().name)
        }
    }
}
// readme: end
