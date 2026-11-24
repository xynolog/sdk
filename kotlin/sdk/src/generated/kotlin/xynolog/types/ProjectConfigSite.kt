// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The knowledge base's identity. */
@Serializable
public data class ProjectConfigSite(
    /** The knowledge base's permanent identity, in did:web's colon-path form (`owner.github.io:repo`): stamped into every event it records, so never a machine's address and never changed. With no white space in it, which no DID holds (UserId.json). */
    public val domain: String,
    /** The name people see for the knowledge base. */
    public val siteName: String,
) {
    /** How Java makes a `ProjectConfigSite`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val domain: String,
        private val siteName: String,
    ) {
        public fun build(): ProjectConfigSite = ProjectConfigSite(domain = domain, siteName = siteName)
    }

    public companion object {
        /** A builder of a `ProjectConfigSite` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(domain: String, siteName: String): Builder = Builder(domain, siteName)
    }
}
