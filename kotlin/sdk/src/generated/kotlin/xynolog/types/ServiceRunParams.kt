// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** service.run's params: one instance of one of a knowledge base's own services, run once from the image the target's stack documents name, unsupervised, on the caller's document, arguments and environment. contract/LAUNCHER-CONTROL.md, R1-R8. */
@Serializable
public data class ServiceRunParams(
    /** The version of the control API the request is written to. */
    public val apiVersion: ApiVersion,
    /** The knowledge base whose stack documents name the service's image, and whose stack the instance belongs to: stack.stop of it removes the instance too. */
    public val target: LocalTarget,
    /** The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else the first installed one. */
    public val runtime: Runtime? = null,
    /** The service whose image runs. */
    public val service: RunService,
    public val instance: RunInstance,
    /** The configuration document's text, written as it is, at the path the image's own arguments name: it need not be JSON. Absent: no file is at that path. */
    public val document: String? = null,
    /** The arguments the image's program is given in place of the image's own (--config and the document's path). Absent: the image's own. */
    public val args: kotlin.collections.List<String>? = null,
    /** Every variable the instance is given beside the image's own, by name: nothing of the launcher's is added (R2). Empty: none. */
    public val environment: kotlin.collections.Map<String, String>,
    /** Directories of this machine, each mounted read-write at its own path, so that a path the document names is the same inside the instance and out (R4). Empty: none. */
    public val mounts: kotlin.collections.List<String>,
    /** Directories put before the image's PATH, in order, each mounted at its own path. Empty: the image's PATH as it is. */
    public val pathFirst: kotlin.collections.List<String>,
    /** The ports the instance listens on, each published at the same number on the host address (R3). Empty: none. */
    public val ports: kotlin.collections.List<Long>,
) {
    /** How Java makes a `ServiceRunParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
        private val target: LocalTarget,
        private val service: RunService,
        private val instance: RunInstance,
        private val environment: kotlin.collections.Map<String, String>,
        private val mounts: kotlin.collections.List<String>,
        private val pathFirst: kotlin.collections.List<String>,
        private val ports: kotlin.collections.List<Long>,
    ) {
        private var runtime: Runtime? = null
        private var document: String? = null
        private var args: kotlin.collections.List<String>? = null

        public fun runtime(runtime: Runtime?): Builder = apply { this.runtime = runtime }
        public fun document(document: String?): Builder = apply { this.document = document }
        public fun args(args: kotlin.collections.List<String>?): Builder = apply { this.args = args }

        public fun build(): ServiceRunParams = ServiceRunParams(apiVersion = apiVersion, target = target, runtime = runtime, service = service, instance = instance, document = document, args = args, environment = environment, mounts = mounts, pathFirst = pathFirst, ports = ports)
    }

    public companion object {
        /** A builder of a `ServiceRunParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion, target: LocalTarget, service: RunService, instance: RunInstance, environment: kotlin.collections.Map<String, String>, mounts: kotlin.collections.List<String>, pathFirst: kotlin.collections.List<String>, ports: kotlin.collections.List<Long>): Builder = Builder(apiVersion, target, service, instance, environment, mounts, pathFirst, ports)
    }
}
