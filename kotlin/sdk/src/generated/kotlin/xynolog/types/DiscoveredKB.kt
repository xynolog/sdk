// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonIgnoreUnknownKeys

/** One knowledge base the Xynolog launcher manages on this machine, as published in the discovery document (see DiscoveryDocument). Endpoints and identity only — never credentials; login remains the consumer's per-KB business. */
@Serializable
@JsonIgnoreUnknownKeys
public data class DiscoveredKB(
    /** Hostname the KB is reachable on from this machine (always "localhost" — local stacks bind locally and codespace KBs arrive through a local port forward) */
    public val host: String,
    /** Local TCP port of the KB's API (the gateway port for a local stack; the allocated forward port for a codespace stack) */
    public val port: Long,
    /** Where the stack actually runs. "local": containers on this machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here. */
    public val placement: KbPlacement,
    /** owner/name GitHub slug — present for codespace placements, where the repo is the stack's identity */
    public val repo: String? = null,
    /** The KB's did:web identifier, from its committed .xynolog/config.yaml — "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no domain has no identity to publish, and the launcher refuses to start it rather than inventing or defaulting one. NOT unique within a document: a did names the knowledge base, not a running copy of it, so a local clone and a codespace of the same repo legitimately share one and both are published. host:port is the unique field (at most one entry per address), so consumers look up by ADDRESS and use the did to VERIFY that the copy they reached is the KB they meant — an address alone cannot say which KB is which, and an identity alone cannot say which copy. */
    public val did: String,
    /** Human-readable site name from the KB's .xynolog/config.yaml (site.siteName), for display */
    public val siteName: String? = null,
    /** The agent that owns this entry's lifecycle (the launcher writes "xynolog-launcher"). Consumers treat managed entries as authoritative for themselves — upsert on appearance, remove on disappearance — and never touch entries they did not write. */
    public val managedBy: String,
) {
    /** How Java makes a `DiscoveredKB`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val host: String,
        private val port: Long,
        private val placement: KbPlacement,
        private val did: String,
        private val managedBy: String,
    ) {
        private var repo: String? = null
        private var siteName: String? = null

        public fun repo(repo: String?): Builder = apply { this.repo = repo }
        public fun siteName(siteName: String?): Builder = apply { this.siteName = siteName }

        public fun build(): DiscoveredKB = DiscoveredKB(host = host, port = port, placement = placement, repo = repo, did = did, siteName = siteName, managedBy = managedBy)
    }

    public companion object {
        /** A builder of a `DiscoveredKB` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(host: String, port: Long, placement: KbPlacement, did: String, managedBy: String): Builder = Builder(host, port, placement, did, managedBy)
    }
}
