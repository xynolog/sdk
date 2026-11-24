// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** logs.follow's params. */
@Serializable
public data class LogsFollowParams(
    /** The version of the control API the request is written to. */
    public val apiVersion: ApiVersion,
    /** Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started. */
    public val target: Target? = null,
    /** Keep to the local stacks, as --runtime does. */
    public val runtime: Runtime? = null,
    /** Just this service's container, as --service names it. Absent: each Xynolog service the stack runs. */
    public val service: String? = null,
) {
    /** How Java makes a `LogsFollowParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
    ) {
        private var target: Target? = null
        private var runtime: Runtime? = null
        private var service: String? = null

        public fun target(target: Target?): Builder = apply { this.target = target }
        public fun runtime(runtime: Runtime?): Builder = apply { this.runtime = runtime }
        public fun service(service: String?): Builder = apply { this.service = service }

        public fun build(): LogsFollowParams = LogsFollowParams(apiVersion = apiVersion, target = target, runtime = runtime, service = service)
    }

    public companion object {
        /** A builder of a `LogsFollowParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion): Builder = Builder(apiVersion)
    }
}
