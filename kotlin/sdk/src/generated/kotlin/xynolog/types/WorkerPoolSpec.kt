// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** How the worker runs. */
@Serializable
public data class WorkerPoolSpec(
    public val logLevel: LogLevel,
    /** The Worker. */
    public val worker: WorkerPoolSpecWorker,
) {
    /** How Java makes a `WorkerPoolSpec`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val logLevel: LogLevel,
        private val worker: WorkerPoolSpecWorker,
    ) {
        public fun build(): WorkerPoolSpec = WorkerPoolSpec(logLevel = logLevel, worker = worker)
    }

    public companion object {
        /** A builder of a `WorkerPoolSpec` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(logLevel: LogLevel, worker: WorkerPoolSpecWorker): Builder = Builder(logLevel, worker)
    }
}
