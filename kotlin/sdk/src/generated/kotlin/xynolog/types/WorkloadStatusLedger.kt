// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The Gateway's request tracking: correlation IDs it currently holds so replies can be routed to the app client that sent each request, and the tracking capacity. */
@Serializable
public data class WorkloadStatusLedger(
    /** Number of request IDs currently held to route replies to their requesting app clients. Includes requests still waiting for a reply and recently answered requests still within the tracking window. */
    public val claims: Long,
    /** The maximum number of IDs held in this Gateway's local tracking projection. */
    public val capacity: Long,
) {
    /** How Java makes a `WorkloadStatusLedger`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val claims: Long,
        private val capacity: Long,
    ) {
        public fun build(): WorkloadStatusLedger = WorkloadStatusLedger(claims = claims, capacity = capacity)
    }

    public companion object {
        /** A builder of a `WorkloadStatusLedger` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(claims: Long, capacity: Long): Builder = Builder(claims, capacity)
    }
}
