// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** stack.start's params: what xynolog start takes, but its help and its narration switches. */
@Serializable
public data class StackStartParams(
    /** The version of the control API the request is written to. */
    public val apiVersion: ApiVersion,
    /** Which knowledge base's stack. Absent: the one the command line chooses, standing where the control server was started. */
    public val target: Target? = null,
    /** The container runtime to ask, as --runtime names it. Absent: the one the stack's record names, else every installed one. */
    public val runtime: Runtime? = null,
    /** The Inference document to run, as --config names it. Absent: the knowledge base's recorded preference, else the default. */
    public val config: String? = null,
    /** Just this one service, as --service names it. */
    public val service: String? = null,
    /** Just this one group of services, as --group names it. */
    public val group: ServiceGroup? = null,
    /** For a codespace target: which of the repository's codespaces, as --codespace names it. */
    public val codespaceName: String? = null,
    /** For a codespace target being created: its VM class, as --machine names it. */
    public val machine: String? = null,
    /** For a codespace target being created: inactivity before it stops, as --idle-timeout takes it. */
    public val idleTimeout: String? = null,
    /** For a codespace target being created: how long a stopped codespace is kept, as --retention-period takes it. */
    public val retentionPeriod: String? = null,
    /** Whether to start the telemetry backends, Jaeger and Prometheus. false is --no-observe. Absent: true. */
    public val observe: Boolean? = null,
    /** Where a started Ollama keeps its models, as --ollama-cache names it. Absent: the host's ~/.ollama when there is one, else the named volume — what the command line's prompt does when nobody answers it. */
    public val ollamaCache: StackStartParamsOllamaCache? = null,
    /** Whether to run nothing, and report each runtime command a start would run as a command progress line. */
    public val dryRun: Boolean? = null,
) {
    /** How Java makes a `StackStartParams`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: ApiVersion,
    ) {
        private var target: Target? = null
        private var runtime: Runtime? = null
        private var config: String? = null
        private var service: String? = null
        private var group: ServiceGroup? = null
        private var codespaceName: String? = null
        private var machine: String? = null
        private var idleTimeout: String? = null
        private var retentionPeriod: String? = null
        private var observe: Boolean? = null
        private var ollamaCache: StackStartParamsOllamaCache? = null
        private var dryRun: Boolean? = null

        public fun target(target: Target?): Builder = apply { this.target = target }
        public fun runtime(runtime: Runtime?): Builder = apply { this.runtime = runtime }
        public fun config(config: String?): Builder = apply { this.config = config }
        public fun service(service: String?): Builder = apply { this.service = service }
        public fun group(group: ServiceGroup?): Builder = apply { this.group = group }
        public fun codespaceName(codespaceName: String?): Builder = apply { this.codespaceName = codespaceName }
        public fun machine(machine: String?): Builder = apply { this.machine = machine }
        public fun idleTimeout(idleTimeout: String?): Builder = apply { this.idleTimeout = idleTimeout }
        public fun retentionPeriod(retentionPeriod: String?): Builder = apply { this.retentionPeriod = retentionPeriod }
        public fun observe(observe: Boolean?): Builder = apply { this.observe = observe }
        public fun ollamaCache(ollamaCache: StackStartParamsOllamaCache?): Builder = apply { this.ollamaCache = ollamaCache }
        public fun dryRun(dryRun: Boolean?): Builder = apply { this.dryRun = dryRun }

        public fun build(): StackStartParams = StackStartParams(apiVersion = apiVersion, target = target, runtime = runtime, config = config, service = service, group = group, codespaceName = codespaceName, machine = machine, idleTimeout = idleTimeout, retentionPeriod = retentionPeriod, observe = observe, ollamaCache = ollamaCache, dryRun = dryRun)
    }

    public companion object {
        /** A builder of a `StackStartParams` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: ApiVersion): Builder = Builder(apiVersion)
    }
}
