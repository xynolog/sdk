// Generated from protocol/specs/src/client/timing.json; do not edit.
// Regenerate: make generate (codegen/lib/timing/kotlin.ml)

package xynolog

import xynolog.types.RetryBudget

/** The timing a client keeps (protocol/specs/src/client/timing.json). */
internal object Timings {
    const val BUS_REQUEST_TIMEOUT_MS: Long = 30000
    const val EMIT_TIMEOUT_MS: Long = 30000
    val EMIT_RETRY: RetryBudget = RetryBudget(attempts = 4, initialDelayMs = 1000, maxDelayMs = 4000)
    const val HTTP_REQUEST_TIMEOUT_MS: Long = 30000
    const val REQUEST_RETRY_PAUSE_MS: Long = 300
    const val STREAM_OPEN_TIMEOUT_MS: Long = 30000
    const val RECONNECT_MS: Long = 5000
    const val MAX_RECONNECT_MS: Long = 60000
    const val DEGRADED_THRESHOLD_MS: Long = 3000
    const val LINGER_MS: Long = 1000
    const val SEEN_EVENT_IDS_COUNT: Long = 512
    const val RECONNECT_DEBOUNCE_MS: Long = 100
    const val LAZY_REMOVE_MS: Long = 5000
    val REFRESH_RETRY: RetryBudget = RetryBudget(attempts = 4, initialDelayMs = 500, maxDelayMs = 4000)
    const val REFRESH_BEFORE_EXP_MS: Long = 300000
    const val MIN_REFRESH_DELAY_MS: Long = 10000
    const val DEVICE_POLL_MS: Long = 5000
    const val DEVICE_SLOW_DOWN_MS: Long = 5000
    const val DEVICE_POLL_FLOOR_MS: Long = 1000
    const val INVALIDATION_WINDOW_MS: Long = 1000
    const val SAVE_DEBOUNCE_MS: Long = 50
    const val MAX_STORED_BYTES_COUNT: Long = 2097152
    const val ERRORS_KEPT_FOR_FIRST_READER_COUNT: Long = 100
    const val JOB_SILENCE_MS: Long = 10000
    const val JOB_STATUS_POLL_MS: Long = 5000
    const val JOB_POLL_MS: Long = 1000
    const val JOB_POLL_TIMEOUT_MS: Long = 60000
    const val GENERATION_STALL_FLOOR_MS: Long = 120000
    const val GENERATION_STALL_PER_TOKEN_MS: Long = 75
    const val GENERATION_STALL_ASSUMED_TOKENS_COUNT: Long = 500
    const val DELEGATE_SILENCE_MS: Long = 180000
    const val JOB_CLAIM_TIMEOUT_MS: Long = 10000
    const val HELD_JOB_STALL_MS: Long = 900000
    const val HELD_JOB_STALL_CHECK_MS: Long = 60000
    const val MARK_COMMIT_TIMEOUT_MS: Long = 60000
    const val GENERATED_TEXT_ASKS_COUNT: Long = 8
    const val ANCHORED_TEXT_REASK_MS: Long = 5000
    const val HOVER_DELAY_MS: Long = 150
    const val SEARCH_DEBOUNCE_MS: Long = 250
    const val DISCOVERY_INTERVAL_MS: Long = 5000
    const val CHECKS_AT_ONCE_COUNT: Long = 4
}

/** What a caller may set of the timing a client keeps: each member is the entry of protocol/specs/src/client/timing.json that its name says, and has the table's value unless the caller states another. */
public data class ClientTiming @JvmOverloads constructor(
    /** How long a bus request has, from the call, to be answered: the wait for the stream to open, the emit with its retries and the waits between them, and the wait for the reply. When it falls due the request fails as timed out, and an emit still in flight is given up, with no attempt after it. The gateway keeps a reply for redelivery at least twice this long (`replyRetentionSeconds` on POST /bus/subscribe), so a reply published during an outage is still there when the requester reconnects inside its own deadline. */
    public val busRequestTimeoutMs: Long = Timings.BUS_REQUEST_TIMEOUT_MS,
    /** How long bus-driven invalidations of one cache key fold together (CACHE-SEMANTICS B19). The first runs at once; any more inside the window become one refetch at its end. Each refetch is a request the session's principal pays for, and another principal's bulk write invalidates an observed key once per event. */
    public val invalidationWindowMs: Long = Timings.INVALIDATION_WINDOW_MS,
    /** How long a job a client is following may say nothing before the client asks for its status. A job's progress and its end reach the client as passing frames, which a dropped stream loses and nothing redelivers; `job:status-requested` is how a follower learns what it missed. Every frame of the job starts the wait again. */
    public val jobSilenceMs: Long = Timings.JOB_SILENCE_MS,
    /** How often a client asks for the status of a job that has been silent for `jobSilenceMs`, until the job says something or its status is an end. */
    public val jobStatusPollMs: Long = Timings.JOB_STATUS_POLL_MS,
)

/** What a caller may set of the timing a transport keeps: each member is the entry of protocol/specs/src/client/timing.json that its name says, and has the table's value unless the caller states another. */
public data class TransportTiming @JvmOverloads constructor(
    /** The retry budget of ONE emit. Per request, never per boot pass: re-running a whole catch-up pass to recover from one refusal re-sends hundreds of emits that already succeeded. Small on purpose: an emit a caller awaits must fail while the caller still cares, and the patience for a gateway that is down belongs to the pass above it. */
    public val emitRetry: RetryBudget = Timings.EMIT_RETRY,
    /** The deadline on one HTTP request that is neither the stream nor an emit: one of the gateway's own operations (who a token is, a media token, the resource metadata, health, status), the wait for a resource's bytes to begin arriving, a read of a resource's description or of its anchored text, a request to the issuer (its discovery, a grant, a revocation), and a read of a launcher's discovery document. Unanswered here, the request fails as one that got no answer. It bounds the read of a refusal's body too, of such a request or of the request that opens the stream (`streamOpenTimeoutMs`): a body not read by then is the refusal with none of the gateway's words, refused, renewed or retried as any refusal is. Without it, a gateway or an issuer that accepts a connection and never answers holds a session's start, and every renewal after it, for as long as the process lives. An upload has no deadline: how long it takes is how large the resource is. A read of anchored text may be held by the Archivist while the Smelter reads the content, and the gateway waits for the Archivist as the Archivist's document states (specs/src/archivist/openapi.json): this deadline is longer than its `connectSeconds` and `readSeconds` together, and the hold is shorter than `readSeconds`, which the reader's protocol rules (`reader/lib/protocol_rules.ml`) hold. */
    public val httpRequestTimeoutMs: Long = Timings.HTTP_REQUEST_TIMEOUT_MS,
    /** How long a client waits for the gateway to answer the request that opens its stream (POST /bus/subscribe): for the answer's status and headers. Unanswered here, the open has failed, and the stream is opened again on the backoff (`reconnectMs`), as after any open that failed. Without it, a gateway that accepts the connection and says nothing is waited on for as long as the process lives, and the stream is never opened again. The gateway answers an open as promptly as one of its own operations, so this is as long as `httpRequestTimeoutMs`. Only the answer is bounded here. An answer that refuses the open has its body read within `httpRequestTimeoutMs`, as any refusal's is: one not read by then is the refusal with none of the gateway's words. An open stream that carries nothing for a while has not failed, since a knowledge base where nothing happens has nothing to send. */
    public val streamOpenTimeoutMs: Long = Timings.STREAM_OPEN_TIMEOUT_MS,
    /** The first wait before a failed stream is opened again. Each further failure doubles it, up to `maxReconnectMs`, and a successful open resets it. Also the cadence at which a transport with no usable credential checks for one, which costs no request. */
    public val reconnectMs: Long = Timings.RECONNECT_MS,
    /** How long a superseded connection keeps draining after a make-before-break handoff. Closing it the instant its replacement opens discards replies already written to the old socket and not yet read. The overlap doubles nothing: a frame both connections carry has one id, and is delivered once (`seenEventIdsCount`). */
    public val lingerMs: Long = Timings.LINGER_MS,
    /** How many of the event ids it delivered last a client remembers. A frame whose id is among them is one it has delivered already, and is dropped: that is what makes a frame carried by both streams of a handoff, or replayed to the new one, arrive once. A client that remembers fewer delivers twice whenever more than that many events pass between the two copies. */
    public val seenEventIdsCount: Int = Timings.SEEN_EVENT_IDS_COUNT.toInt(),
    /** How long a removal from the subscription waits before the stream is reopened without it. Removal only narrows delivery, and reopening on every scope a viewer brushes past would churn the connection. */
    public val lazyRemoveMs: Long = Timings.LAZY_REMOVE_MS,
)
