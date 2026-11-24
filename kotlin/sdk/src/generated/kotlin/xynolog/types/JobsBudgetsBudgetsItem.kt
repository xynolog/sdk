// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

@Serializable
public data class JobsBudgetsBudgetsItem(
    public val jobType: JobType,
    /** How many times a failed attempt of a job of this type may be retried: its record's `metadata.maxRetries`. */
    public val maxRetries: Long,
) {
    /** How Java makes a `JobsBudgetsBudgetsItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val jobType: JobType,
        private val maxRetries: Long,
    ) {
        public fun build(): JobsBudgetsBudgetsItem = JobsBudgetsBudgetsItem(jobType = jobType, maxRetries = maxRetries)
    }

    public companion object {
        /** A builder of a `JobsBudgetsBudgetsItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(jobType: JobType, maxRetries: Long): Builder = Builder(jobType, maxRetries)
    }
}
