// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** status.snapshot's params. */
@Serializable
public data class StatusSnapshotParams(
    /** The version of the control API the request is written to. */
    public val apiVersion: ApiVersion,
    /** Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started. */
    public val target: Target? = null,
    /** The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else every installed one. */
    public val runtime: Runtime? = null,
) {
    /** How Java makes a `StatusSnapshotParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
    ) {
        private var target: Target? = null
        private var runtime: Runtime? = null

        public fun target(target: Target?): Builder = apply { this.target = target }
        public fun runtime(runtime: Runtime?): Builder = apply { this.runtime = runtime }

        public fun build(): StatusSnapshotParams = StatusSnapshotParams(apiVersion = apiVersion, target = target, runtime = runtime)
    }

    public companion object {
        /** A builder of a `StatusSnapshotParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion): Builder = Builder(apiVersion)
    }
}
