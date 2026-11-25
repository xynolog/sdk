// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A W3C trace context, as a relayed frame's trace field carries it (bus/registry.json `trace`) and a held job states it as its `trace`: the trace a frame was sent under, so its reader's work is recorded in the same trace. */
@Serializable
public data class TraceCarrier(
    /** W3C `traceparent` (`00-<traceId>-<spanId>-<flags>`). */
    public val traceparent: String,
    /** W3C `tracestate`, when the trace has one. */
    public val tracestate: String? = null,
) {
    /** How Java makes a `TraceCarrier`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val traceparent: String,
    ) {
        private var tracestate: String? = null

        public fun tracestate(tracestate: String?): Builder = apply { this.tracestate = tracestate }

        public fun build(): TraceCarrier = TraceCarrier(traceparent = traceparent, tracestate = tracestate)
    }

    public companion object {
        /** A builder of a `TraceCarrier` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(traceparent: String): Builder = Builder(traceparent)
    }
}
