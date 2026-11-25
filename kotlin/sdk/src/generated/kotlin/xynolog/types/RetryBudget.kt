// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A retry budget: how many `attempts` are allowed, with a backoff that starts at `initialDelayMs` and doubles to `maxDelayMs`. */
@Serializable
public data class RetryBudget(
    /** How many attempts the budget allows. */
    public val attempts: Long,
    /** The delay before the second attempt, in milliseconds. */
    public val initialDelayMs: Long,
    /** The longest delay between attempts, in milliseconds. */
    public val maxDelayMs: Long,
) : ClientTimingTimingItemValue {
    /** How Java makes a `RetryBudget`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val attempts: Long,
        private val initialDelayMs: Long,
        private val maxDelayMs: Long,
    ) {
        public fun build(): RetryBudget = RetryBudget(attempts = attempts, initialDelayMs = initialDelayMs, maxDelayMs = maxDelayMs)
    }

    public companion object {
        /** A builder of a `RetryBudget` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(attempts: Long, initialDelayMs: Long, maxDelayMs: Long): Builder = Builder(attempts, initialDelayMs, maxDelayMs)
    }
}
