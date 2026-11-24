// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A knowledge base's operational readings from Collector metrics. Request-tracking occupancy and queue depth are current gauges; completed and failed are worker counters since that worker process started. Missing readings are unknown, never zero. */
@Serializable
public data class WorkloadStatus(
    /** The Gateway's request tracking: correlation IDs it currently holds so replies can be routed to the app client that sent each request, and the tracking capacity. */
    public val ledger: WorkloadStatusLedger? = null,
    /** Current Dispatcher depth and, when the worker has emitted counters, completed and failed work since worker start. These are different measurements and time windows. */
    public val queue: WorkloadStatusQueue? = null,
) {
    /** How Java makes a `WorkloadStatus`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor() {
        private var ledger: WorkloadStatusLedger? = null
        private var queue: WorkloadStatusQueue? = null

        public fun ledger(ledger: WorkloadStatusLedger?): Builder = apply { this.ledger = ledger }
        public fun queue(queue: WorkloadStatusQueue?): Builder = apply { this.queue = queue }

        public fun build(): WorkloadStatus = WorkloadStatus(ledger = ledger, queue = queue)
    }

    public companion object {
        /** A builder of a `WorkloadStatus` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(): Builder = Builder()
    }
}
