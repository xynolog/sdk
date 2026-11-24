// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The request a `wire` step named has ended with no answer reaching the client: the client closed it, or the proxy kept the gateway's answer from it (`answer-lost`). */
@Serializable
public data class ConformanceStepClosed(
    /** The request. */
    public val closed: String,
) : ConformanceStep {
    /** How Java makes a `ConformanceStepClosed`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val closed: String,
    ) {
        public fun build(): ConformanceStepClosed = ConformanceStepClosed(closed = closed)
    }

    public companion object {
        /** A builder of a `ConformanceStepClosed` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(closed: String): Builder = Builder(closed)
    }
}
