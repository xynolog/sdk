// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** worker/messages.json: the words of a Worker service's refusals to start, of the errors it fails a job with, and of the messages it logs that a reader relies on. */
@Serializable
public data class WorkerMessages(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each refusal to start, written in service-environment/boot-refusals.json's `line`. */
    public val boot: kotlin.collections.List<WorkerMessagesBootItem>,
    /** Each line of the `{reasons}` of `invalid`. */
    public val reasons: kotlin.collections.List<WorkerMessagesReasonsItem>,
    /** How an error names the job, by its type, as `{job}`: `{motivation}` is a mark job's motivation. */
    public val job: WorkerMessagesJob,
    /** Each error a job is failed with that is the worker's own: the `error` of its `job:fail`. */
    public val errors: kotlin.collections.List<WorkerMessagesErrorsItem>,
    /** Each `{detail}` of `unreadable`. */
    public val details: kotlin.collections.List<WorkerMessagesDetailsItem>,
    /** Each `{said}` of `wait-stated`. */
    public val waits: kotlin.collections.List<WorkerMessagesWaitsItem>,
    /** Each message a Worker service logs that a reader of its output relies on. */
    public val logged: kotlin.collections.List<SmelterMessagesLoggedItem>,
) {
    /** How Java makes a `WorkerMessages`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val boot: kotlin.collections.List<WorkerMessagesBootItem>,
        private val reasons: kotlin.collections.List<WorkerMessagesReasonsItem>,
        private val job: WorkerMessagesJob,
        private val errors: kotlin.collections.List<WorkerMessagesErrorsItem>,
        private val details: kotlin.collections.List<WorkerMessagesDetailsItem>,
        private val waits: kotlin.collections.List<WorkerMessagesWaitsItem>,
        private val logged: kotlin.collections.List<SmelterMessagesLoggedItem>,
    ) {
        public fun build(): WorkerMessages = WorkerMessages(comment = comment, boot = boot, reasons = reasons, job = job, errors = errors, details = details, waits = waits, logged = logged)
    }

    public companion object {
        /** A builder of a `WorkerMessages` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, boot: kotlin.collections.List<WorkerMessagesBootItem>, reasons: kotlin.collections.List<WorkerMessagesReasonsItem>, job: WorkerMessagesJob, errors: kotlin.collections.List<WorkerMessagesErrorsItem>, details: kotlin.collections.List<WorkerMessagesDetailsItem>, waits: kotlin.collections.List<WorkerMessagesWaitsItem>, logged: kotlin.collections.List<SmelterMessagesLoggedItem>): Builder = Builder(comment, boot, reasons, job, errors, details, waits, logged)
    }
}
