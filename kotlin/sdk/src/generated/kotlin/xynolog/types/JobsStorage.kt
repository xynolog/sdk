// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** jobs/storage.json: where the job queue keeps its state on the broker. */
@Serializable
public data class JobsStorage(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** The work-queue stream every job is published into. */
    public val stream: JobsStorageStream,
    /** The durable consumer that delivers each job to the dispatcher holding its lease. */
    public val consumer: JobsStorageConsumer,
    /** The KV bucket that keeps one record per job, keyed by the job's id. */
    public val bucket: JobsStorageBucket,
) {
    /** How Java makes a `JobsStorage`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val stream: JobsStorageStream,
        private val consumer: JobsStorageConsumer,
        private val bucket: JobsStorageBucket,
    ) {
        public fun build(): JobsStorage = JobsStorage(comment = comment, stream = stream, consumer = consumer, bucket = bucket)
    }

    public companion object {
        /** A builder of a `JobsStorage` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, stream: JobsStorageStream, consumer: JobsStorageConsumer, bucket: JobsStorageBucket): Builder = Builder(comment, stream, consumer, bucket)
    }
}
