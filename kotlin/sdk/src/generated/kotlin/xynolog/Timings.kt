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
