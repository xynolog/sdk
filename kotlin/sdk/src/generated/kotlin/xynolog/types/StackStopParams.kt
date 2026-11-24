// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** stack.stop's params: what xynolog stop takes, but its help. */
@Serializable
public data class StackStopParams(
    /** The version of the control API the request is written to. */
    public val apiVersion: ApiVersion,
    /** Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started. */
    public val target: Target? = null,
    /** The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else every installed one. */
    public val runtime: Runtime? = null,
    /** Just this one service, as --service names it. */
    public val service: String? = null,
    /** Just this one group of services, as --group names it. */
    public val group: ServiceGroup? = null,
    /** For a codespace target: destroy the codespace, state and all, and forget its record. The command line's --delete. Refused without deleteConfirmed. */
    public val delete: Boolean? = null,
    /** That the person confirmed the deletion: delete is refused with control.confirmation-required without it. */
    public val deleteConfirmed: Boolean? = null,
    /** Whether to stop nothing, and report each runtime command a stop would run as a command progress line. */
    public val dryRun: Boolean? = null,
) {
    /** How Java makes a `StackStopParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
    ) {
        private var target: Target? = null
        private var runtime: Runtime? = null
        private var service: String? = null
        private var group: ServiceGroup? = null
        private var delete: Boolean? = null
        private var deleteConfirmed: Boolean? = null
        private var dryRun: Boolean? = null

        public fun target(target: Target?): Builder = apply { this.target = target }
        public fun runtime(runtime: Runtime?): Builder = apply { this.runtime = runtime }
        public fun service(service: String?): Builder = apply { this.service = service }
        public fun group(group: ServiceGroup?): Builder = apply { this.group = group }
        public fun delete(delete: Boolean?): Builder = apply { this.delete = delete }
        public fun deleteConfirmed(deleteConfirmed: Boolean?): Builder = apply { this.deleteConfirmed = deleteConfirmed }
        public fun dryRun(dryRun: Boolean?): Builder = apply { this.dryRun = dryRun }

        public fun build(): StackStopParams = StackStopParams(apiVersion = apiVersion, target = target, runtime = runtime, service = service, group = group, delete = delete, deleteConfirmed = deleteConfirmed, dryRun = dryRun)
    }

    public companion object {
        /** A builder of a `StackStopParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion): Builder = Builder(apiVersion)
    }
}
