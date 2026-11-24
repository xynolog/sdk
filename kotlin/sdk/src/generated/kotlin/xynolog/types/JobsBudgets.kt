// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** jobs/budgets.json: the retry budget of each job type. */
@Serializable
public data class JobsBudgets(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** One row for each job type. */
    public val budgets: kotlin.collections.List<JobsBudgetsBudgetsItem>,
) {
    /** How Java makes a `JobsBudgets`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val budgets: kotlin.collections.List<JobsBudgetsBudgetsItem>,
    ) {
        public fun build(): JobsBudgets = JobsBudgets(comment = comment, budgets = budgets)
    }

    public companion object {
        /** A builder of a `JobsBudgets` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, budgets: kotlin.collections.List<JobsBudgetsBudgetsItem>): Builder = Builder(comment, budgets)
    }
}
