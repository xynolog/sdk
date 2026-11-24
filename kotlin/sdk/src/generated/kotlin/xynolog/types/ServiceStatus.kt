// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One service, as xynolog status reads it: where it runs, its state, and whether it answers. Nothing is reported that the launcher did not observe: an endpoint is named only when the stack's record or the descriptor names one, and a page to open only when the service answers. */
@Serializable
public data class ServiceStatus(
    /** The service, as xynolog status names it. */
    public val role: String,
    /** The group it belongs to. */
    public val group: ServiceGroup,
    /** The product its driver names (Neo4j, Keycloak), when its record names a driver. */
    public val product: String? = null,
    /** Where it runs: the runtime its container runs under, external (somebody else runs it), or host (a process on this machine). Absent when nothing runs it. */
    public val runsOn: String? = null,
    /** running: its container runs. stopped: its container exists and does not run (containerState says how). reachable, unreachable: somebody else runs it, and its endpoint answers or does not. absent: there is no container of it. not-configured: the stack's documents ask for none. */
    public val state: ServiceStatusState,
    /** The runtime's own word for a container that is not running (exited, created). */
    public val containerState: String? = null,
    /** Whether its health endpoint answers. */
    public val healthy: Boolean,
    /** Whether its health counts toward its knowledge base's: a service the documents ask for none of, and a telemetry backend --no-observe leaves out, do not. */
    public val counted: Boolean,
    /** The endpoint the launcher asks its health of: an http URL, or tcp://host:port. */
    public val probe: String? = null,
    /** The page a person opens: the Browser, Jaeger's and Prometheus's interfaces, the collector's metrics readout. Present only when the service answers. The collector's OTLP receiver is never one. */
    public val page: String? = null,
    /** For the issuer the knowledge base signs in at, when it is the machine's: its realm there. */
    public val realm: String? = null,
    /** For a service several knowledge bases share: the name of each it serves, as knowledgeBases names them. */
    public val serves: kotlin.collections.List<String>? = null,
) {
    /** How Java makes a `ServiceStatus`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val role: String,
        private val group: ServiceGroup,
        private val state: ServiceStatusState,
        private val healthy: Boolean,
        private val counted: Boolean,
    ) {
        private var product: String? = null
        private var runsOn: String? = null
        private var containerState: String? = null
        private var probe: String? = null
        private var page: String? = null
        private var realm: String? = null
        private var serves: kotlin.collections.List<String>? = null

        public fun product(product: String?): Builder = apply { this.product = product }
        public fun runsOn(runsOn: String?): Builder = apply { this.runsOn = runsOn }
        public fun containerState(containerState: String?): Builder = apply { this.containerState = containerState }
        public fun probe(probe: String?): Builder = apply { this.probe = probe }
        public fun page(page: String?): Builder = apply { this.page = page }
        public fun realm(realm: String?): Builder = apply { this.realm = realm }
        public fun serves(serves: kotlin.collections.List<String>?): Builder = apply { this.serves = serves }

        public fun build(): ServiceStatus = ServiceStatus(role = role, group = group, product = product, runsOn = runsOn, state = state, containerState = containerState, healthy = healthy, counted = counted, probe = probe, page = page, realm = realm, serves = serves)
    }

    public companion object {
        /** A builder of a `ServiceStatus` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(role: String, group: ServiceGroup, state: ServiceStatusState, healthy: Boolean, counted: Boolean): Builder = Builder(role, group, state, healthy, counted)
    }
}
