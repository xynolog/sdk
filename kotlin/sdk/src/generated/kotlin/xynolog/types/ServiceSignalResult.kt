// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A signal sent, or not needed. The instance's exit is its run's answer, not this one. */
@Serializable
public data class ServiceSignalResult(
    /** Whether the instance still ran when the signal came. false: it has exited, and its run's answer is on its way; nothing was sent. */
    public val delivered: Boolean,
) {
    /** How Java makes a `ServiceSignalResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val delivered: Boolean,
    ) {
        public fun build(): ServiceSignalResult = ServiceSignalResult(delivered = delivered)
    }

    public companion object {
        /** A builder of a `ServiceSignalResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(delivered: Boolean): Builder = Builder(delivered)
    }
}
