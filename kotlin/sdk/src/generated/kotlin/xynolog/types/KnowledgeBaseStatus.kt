// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One knowledge base's stack as xynolog status reads it: what it is, where it runs, and each of its own services. The services every knowledge base shares are reported once, in the snapshot's shared list. */
@Serializable
public data class KnowledgeBaseStatus(
    /** What the snapshot calls the knowledge base: the last segment of its DID, or the whole DID where two would share one, or its key. */
    public val name: String,
    /** The knowledge base's key on this machine, which names its containers and its state. */
    public val key: String,
    /** Whether a stack of it is recorded. When none is, its services are found by name. */
    public val recorded: Boolean,
    /** Where the stack actually runs. "local": containers on this machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here. */
    public val placement: DiscoveredKBPlacement,
    /** Its clone, for a local stack. */
    public val root: String? = null,
    /** owner/name GitHub slug — present for codespace placements, where the repo is the stack's identity */
    public val repo: String? = null,
    /** The KB's did:web identifier, from its committed .xynolog/config.yaml — "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no domain has no identity to publish, and the launcher refuses to start it rather than inventing or defaulting one. NOT unique within a document: a did names the knowledge base, not a running copy of it, so a local clone and a codespace of the same repo legitimately share one and both are published. host:port is the unique field (at most one entry per address), so consumers look up by ADDRESS and use the did to VERIFY that the copy they reached is the KB they meant — an address alone cannot say which KB is which, and an identity alone cannot say which copy. */
    public val did: String? = null,
    /** Human-readable site name from the KB's .xynolog/config.yaml (site.siteName), for display */
    public val siteName: String? = null,
    /** Why its identity could not be read from its clone, when it could not. */
    public val identityError: String? = null,
    /** The knowledge base as the discovery document publishes it, when it does. */
    public val kb: DiscoveredKB? = null,
    /** The runtime its record names. */
    public val runtime: Runtime? = null,
    /** The base URL of its gateway, from its record. */
    public val gateway: String? = null,
    /** Where the values the launcher generates for it are kept, as xynolog settings secret-store describes it. */
    public val secretStore: String? = null,
    /** This machine's address on the network, when the stack is started with network lan. */
    public val lan: String? = null,
    /** Whether a xynolog start of it holds its start lock: its services are not ready, whatever they report. */
    public val starting: Boolean,
    public val session: Session? = null,
    /** Whether each of its counted services, and the issuer it signs in at, answers. */
    public val healthy: Boolean,
    /** Its own services, group by group, then the issuer it signs in at. Empty for a codespace's, whose services its own launcher reports. */
    public val services: kotlin.collections.List<ServiceStatus>,
    /** The ledger and job queue readings the launcher can attribute to this knowledge base. A missing reading means the Collector has not reported that metric, not that its value is zero. */
    public val workload: WorkloadStatus? = null,
) {
    /** How Java makes a `KnowledgeBaseStatus`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val key: String,
        private val recorded: Boolean,
        private val placement: DiscoveredKBPlacement,
        private val starting: Boolean,
        private val healthy: Boolean,
        private val services: kotlin.collections.List<ServiceStatus>,
    ) {
        private var root: String? = null
        private var repo: String? = null
        private var did: String? = null
        private var siteName: String? = null
        private var identityError: String? = null
        private var kb: DiscoveredKB? = null
        private var runtime: Runtime? = null
        private var gateway: String? = null
        private var secretStore: String? = null
        private var lan: String? = null
        private var session: Session? = null
        private var workload: WorkloadStatus? = null

        public fun root(root: String?): Builder = apply { this.root = root }
        public fun repo(repo: String?): Builder = apply { this.repo = repo }
        public fun did(did: String?): Builder = apply { this.did = did }
        public fun siteName(siteName: String?): Builder = apply { this.siteName = siteName }
        public fun identityError(identityError: String?): Builder = apply { this.identityError = identityError }
        public fun kb(kb: DiscoveredKB?): Builder = apply { this.kb = kb }
        public fun runtime(runtime: Runtime?): Builder = apply { this.runtime = runtime }
        public fun gateway(gateway: String?): Builder = apply { this.gateway = gateway }
        public fun secretStore(secretStore: String?): Builder = apply { this.secretStore = secretStore }
        public fun lan(lan: String?): Builder = apply { this.lan = lan }
        public fun session(session: Session?): Builder = apply { this.session = session }
        public fun workload(workload: WorkloadStatus?): Builder = apply { this.workload = workload }

        public fun build(): KnowledgeBaseStatus = KnowledgeBaseStatus(name = name, key = key, recorded = recorded, placement = placement, root = root, repo = repo, did = did, siteName = siteName, identityError = identityError, kb = kb, runtime = runtime, gateway = gateway, secretStore = secretStore, lan = lan, starting = starting, session = session, healthy = healthy, services = services, workload = workload)
    }

    public companion object {
        /** A builder of a `KnowledgeBaseStatus` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, key: String, recorded: Boolean, placement: DiscoveredKBPlacement, starting: Boolean, healthy: Boolean, services: kotlin.collections.List<ServiceStatus>): Builder = Builder(name, key, recorded, placement, starting, healthy, services)
    }
}
