// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** One knowledge base this machine knows: a registered or running local clone, or a codespace stack recorded here. Registration, the directory, the stack and the forward are separate facts, each stated as it is. */
@Serializable
public data class Root(
    public val placement: KbPlacement,
    /** For a local root: the clone's path. */
    public val path: String? = null,
    /** For a local root: whether the directory exists. A registered root whose directory is gone is kept, and says so. */
    public val present: Boolean? = null,
    /** For a local root: how the control server's own directory selects it, when it does — standing in it (cwd), or XYNOLOG_ROOT. */
    public val current: RootCurrent? = null,
    /** Whether the registry (roots.json) records it. */
    public val registered: Boolean,
    /** Whether a stack of it is recorded on this machine. */
    public val running: Boolean,
    /** When a command last used it, in RFC 3339, as the registry records it. */
    public val lastUsed: String? = null,
    /** The KB's did:web identifier, from its committed .xynolog/config.yaml — "did:web:" + its site.domain, verbatim. REQUIRED: a KB that declares no domain has no identity to publish, and the launcher refuses to start it rather than inventing or defaulting one. NOT unique within a document: a did names the knowledge base, not a running copy of it, so a local clone and a codespace of the same repo legitimately share one and both are published. host:port is the unique field (at most one entry per address), so consumers look up by ADDRESS and use the did to VERIFY that the copy they reached is the KB they meant — an address alone cannot say which KB is which, and an identity alone cannot say which copy. */
    public val did: String? = null,
    /** Human-readable site name from the KB's .xynolog/config.yaml (site.siteName), for display */
    public val siteName: String? = null,
    /** Why its identity could not be read from its clone, when it could not. */
    public val identityError: String? = null,
    /** The Inference document a start of it runs, as the registry records it. */
    public val config: String? = null,
    /** For a present local root: the Inference documents its clone has, as start --config names them. */
    public val configs: kotlin.collections.List<String>? = null,
    /** owner/name GitHub slug — present for codespace placements, where the repo is the stack's identity */
    public val repo: String? = null,
    /** For a codespace root: the codespace's name. */
    public val codespace: String? = null,
    /** For a codespace root: GitHub's word for the codespace's state (Available, Shutdown), when gh answered. */
    public val codespaceState: String? = null,
    /** For a codespace root: the port on this machine its knowledge base is forwarded to, when one is recorded. */
    public val forwardPort: Long? = null,
    /** For a codespace root: whether the recorded forward is alive. */
    public val forwarded: Boolean? = null,
    /** For a codespace root: whether its knowledge base answers through the forward. */
    public val reachable: Boolean? = null,
) {
    /** How Java makes a `Root`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val placement: KbPlacement,
        private val registered: Boolean,
        private val running: Boolean,
    ) {
        private var path: String? = null
        private var present: Boolean? = null
        private var current: RootCurrent? = null
        private var lastUsed: String? = null
        private var did: String? = null
        private var siteName: String? = null
        private var identityError: String? = null
        private var config: String? = null
        private var configs: kotlin.collections.List<String>? = null
        private var repo: String? = null
        private var codespace: String? = null
        private var codespaceState: String? = null
        private var forwardPort: Long? = null
        private var forwarded: Boolean? = null
        private var reachable: Boolean? = null

        public fun path(path: String?): Builder = apply { this.path = path }
        public fun present(present: Boolean?): Builder = apply { this.present = present }
        public fun current(current: RootCurrent?): Builder = apply { this.current = current }
        public fun lastUsed(lastUsed: String?): Builder = apply { this.lastUsed = lastUsed }
        public fun did(did: String?): Builder = apply { this.did = did }
        public fun siteName(siteName: String?): Builder = apply { this.siteName = siteName }
        public fun identityError(identityError: String?): Builder = apply { this.identityError = identityError }
        public fun config(config: String?): Builder = apply { this.config = config }
        public fun configs(configs: kotlin.collections.List<String>?): Builder = apply { this.configs = configs }
        public fun repo(repo: String?): Builder = apply { this.repo = repo }
        public fun codespace(codespace: String?): Builder = apply { this.codespace = codespace }
        public fun codespaceState(codespaceState: String?): Builder = apply { this.codespaceState = codespaceState }
        public fun forwardPort(forwardPort: Long?): Builder = apply { this.forwardPort = forwardPort }
        public fun forwarded(forwarded: Boolean?): Builder = apply { this.forwarded = forwarded }
        public fun reachable(reachable: Boolean?): Builder = apply { this.reachable = reachable }

        public fun build(): Root = Root(placement = placement, path = path, present = present, current = current, registered = registered, running = running, lastUsed = lastUsed, did = did, siteName = siteName, identityError = identityError, config = config, configs = configs, repo = repo, codespace = codespace, codespaceState = codespaceState, forwardPort = forwardPort, forwarded = forwarded, reachable = reachable)
    }

    public companion object {
        /** A builder of a `Root` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(placement: KbPlacement, registered: Boolean, running: Boolean): Builder = Builder(placement, registered, running)
    }
}
