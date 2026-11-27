package xynolog.http

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withTimeoutOrNull
import xynolog.Timings
import xynolog.discovery.DiscoveryTransport
import xynolog.discovery.parseDiscoveryDocument
import xynolog.discovery.readOf
import xynolog.telemetry.futureOf
import xynolog.types.DiscoveryAbsent
import xynolog.types.DiscoveryAbsentReason
import xynolog.types.DiscoveryManaged
import xynolog.types.DiscoveryRead
import xynolog.types.DiscoveryUnchanged
import java.io.IOException
import java.net.URI
import java.net.http.HttpClient
import java.net.http.HttpRequest
import java.net.http.HttpResponse
import java.util.concurrent.CompletableFuture
import kotlin.coroutines.CoroutineContext

/** A transport that reads the discovery document at `url` with `http`, each read within `deadlineMs`, and a Java read on `context`. */
private class HttpDiscovery(
    private val url: String,
    private val deadlineMs: Long,
    private val http: HttpClient,
    private val context: CoroutineContext,
) : DiscoveryTransport {
    /** The tag of the last document that read as managed; null when that document had none, or none has. */
    @Volatile
    private var tag: String? = null

    override suspend fun read(): DiscoveryRead {
        val asked = HttpRequest.newBuilder(URI.create(url)).GET()
        tag?.let { asked.header("If-None-Match", it) }
        val response = try {
            withTimeoutOrNull(deadlineMs) { http.exchange(asked.build(), HttpResponse.BodyHandlers.ofString()) }
        } catch (unanswered: IOException) {
            return DiscoveryAbsent(reason = DiscoveryAbsentReason.Unreadable, diagnostic = unanswered.message ?: unanswered::class.java.simpleName)
        } ?: return DiscoveryAbsent(reason = DiscoveryAbsentReason.Unreadable, diagnostic = "the document was not served within ${deadlineMs}ms")
        val status = response.statusCode()
        if (status == 304) return DiscoveryUnchanged()
        if (status !in 200..299) return DiscoveryAbsent(reason = DiscoveryAbsentReason.NotFound, diagnostic = "HTTP $status")
        val type = response.headers().firstValue("content-type").orElse("")
        if ("json" !in type.lowercase()) return DiscoveryAbsent(reason = DiscoveryAbsentReason.NotFound, diagnostic = "the content type is \"$type\", not JSON")
        val state = parseDiscoveryDocument(response.body())
        // Only a good document's tag is kept: one kept for a document that did not read would have this believe it for good.
        if (state is DiscoveryManaged) tag = response.headers().firstValue("etag").orElse(null)
        return readOf(state)
    }

    override fun readFuture(): CompletableFuture<DiscoveryRead> = CoroutineScope(context).futureOf { read() }
}

/** The discovery reader's own HTTP client: the JDK's, with its default proxy selector and trust store, following a redirect. */
private fun redirecting(): HttpClient = HttpClient.newBuilder().version(HttpClient.Version.HTTP_1_1).followRedirects(HttpClient.Redirect.NORMAL).build()

/** `httpDiscovery`, each read within `deadlineMs`. */
internal fun httpDiscovery(url: String, deadlineMs: Long, context: CoroutineContext = Dispatchers.Default): DiscoveryTransport =
    HttpDiscovery(url, deadlineMs, redirecting(), context)

/**
 * A transport that reads the discovery document at `url` with `http`, each
 * read within the timing table's request deadline. Its own client keeps the
 * JDK's default proxy selector and trust store, reads no environment
 * variable, and follows a redirect; a caller's client follows its own
 * redirect policy, and trusts what it trusts. A read waits on its caller's
 * context, and a Java read on `context`.
 */
@JvmOverloads
public fun httpDiscovery(url: String, http: HttpClient = redirecting(), context: CoroutineContext = Dispatchers.Default): DiscoveryTransport =
    HttpDiscovery(url, Timings.HTTP_REQUEST_TIMEOUT_MS, http, context)
