// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** service.signal's params: a signal for a run's instance. */
@Serializable
public data class ServiceSignalParams(
    /** The version of the control API the request is written to. */
    public val apiVersion: ApiVersion,
    /** The knowledge base whose stack documents name the service's image, and whose stack the instance belongs to: stack.stop of it removes the instance too. */
    public val target: LocalTarget,
    /** The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else the first installed one. */
    public val runtime: Runtime? = null,
    public val instance: RunInstance,
    /** term: SIGTERM, and SIGKILL 15 seconds later if it has not exited. kill: SIGKILL, so nothing it would settle on the way out is settled. */
    public val signal: ServiceSignalParamsSignal,
) {
    /** How Java makes a `ServiceSignalParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
        private val target: LocalTarget,
        private val instance: RunInstance,
        private val signal: ServiceSignalParamsSignal,
    ) {
        private var runtime: Runtime? = null

        public fun runtime(runtime: Runtime?): Builder = apply { this.runtime = runtime }

        public fun build(): ServiceSignalParams = ServiceSignalParams(apiVersion = apiVersion, target = target, runtime = runtime, instance = instance, signal = signal)
    }

    public companion object {
        /** A builder of a `ServiceSignalParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion, target: LocalTarget, instance: RunInstance, signal: ServiceSignalParamsSignal): Builder = Builder(apiVersion, target, instance, signal)
    }
}
