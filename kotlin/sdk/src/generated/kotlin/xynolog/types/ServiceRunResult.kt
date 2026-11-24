// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A run that ended: its instance exited. Sent once the instance's container has exited, after all of its output. */
@Serializable
public data class ServiceRunResult(
    public val instance: RunInstance,
    /** The instance's exit status: the service's own, since nothing supervises it (R1). An instance a signal ended exits with 128 and the signal's number: 143 for SIGTERM, 137 for SIGKILL. */
    public val exitCode: Long,
    /** Milliseconds from its container's start to its exit. */
    public val ranMs: Long,
) {
    /** How Java makes a `ServiceRunResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val instance: RunInstance,
        private val exitCode: Long,
        private val ranMs: Long,
    ) {
        public fun build(): ServiceRunResult = ServiceRunResult(instance = instance, exitCode = exitCode, ranMs = ranMs)
    }

    public companion object {
        /** A builder of a `ServiceRunResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(instance: RunInstance, exitCode: Long, ranMs: Long): Builder = Builder(instance, exitCode, ranMs)
    }
}
