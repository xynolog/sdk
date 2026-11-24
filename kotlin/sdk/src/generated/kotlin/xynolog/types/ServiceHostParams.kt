// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** service.host's params. */
@Serializable
public data class ServiceHostParams(
    /** The version of the control API the request is written to. */
    public val apiVersion: ApiVersion,
    /** The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else the first installed one. */
    public val runtime: Runtime? = null,
) {
    /** How Java makes a `ServiceHostParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
    ) {
        private var runtime: Runtime? = null

        public fun runtime(runtime: Runtime?): Builder = apply { this.runtime = runtime }

        public fun build(): ServiceHostParams = ServiceHostParams(apiVersion = apiVersion, runtime = runtime)
    }

    public companion object {
        /** A builder of a `ServiceHostParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion): Builder = Builder(apiVersion)
    }
}
