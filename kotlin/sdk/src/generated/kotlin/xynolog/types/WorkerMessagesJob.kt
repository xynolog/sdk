// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** How an error names the job, by its type, as `{job}`: `{motivation}` is a mark job's motivation. */
@Serializable
public data class WorkerMessagesJob(
    public val mark: String,
    public val yield: String,
) {
    /** How Java makes a `WorkerMessagesJob`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val mark: String,
        private val yield: String,
    ) {
        public fun build(): WorkerMessagesJob = WorkerMessagesJob(mark = mark, yield = yield)
    }

    public companion object {
        /** A builder of a `WorkerMessagesJob` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(mark: String, yield: String): Builder = Builder(mark, yield)
    }
}
