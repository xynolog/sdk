// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Where this machine and a run's instance meet, under a runtime: the address the launcher publishes an instance's ports on, and the address the instance reaches this machine's listeners at. A caller writes it into a document before the run. */
@Serializable
public data class ServiceHostResult(
    public val runtime: Runtime,
    /** The host address: an IP address or a host name, as the launcher's own stack dials it under this runtime. */
    public val address: String,
) {
    /** How Java makes a `ServiceHostResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val runtime: Runtime,
        private val address: String,
    ) {
        public fun build(): ServiceHostResult = ServiceHostResult(runtime = runtime, address = address)
    }

    public companion object {
        /** A builder of a `ServiceHostResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(runtime: Runtime, address: String): Builder = Builder(runtime, address)
    }
}
