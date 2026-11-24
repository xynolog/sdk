// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Current Dispatcher depth and, when the worker has emitted counters, completed and failed work since worker start. These are different measurements and time windows. */
@Serializable
public data class WorkloadStatusQueue(
    /** Jobs currently waiting for a worker. */
    public val pending: Long,
    /** Jobs currently claimed by workers. */
    public val running: Long,
    /** Jobs completed since worker start. */
    public val completed: Long? = null,
    /** Jobs finally failed since worker start. */
    public val failed: Long? = null,
) {
    /** How Java makes a `WorkloadStatusQueue`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val pending: Long,
        private val running: Long,
    ) {
        private var completed: Long? = null
        private var failed: Long? = null

        public fun completed(completed: Long?): Builder = apply { this.completed = completed }
        public fun failed(failed: Long?): Builder = apply { this.failed = failed }

        public fun build(): WorkloadStatusQueue = WorkloadStatusQueue(pending = pending, running = running, completed = completed, failed = failed)
    }

    public companion object {
        /** A builder of a `WorkloadStatusQueue` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(pending: Long, running: Long): Builder = Builder(pending, running)
    }
}
