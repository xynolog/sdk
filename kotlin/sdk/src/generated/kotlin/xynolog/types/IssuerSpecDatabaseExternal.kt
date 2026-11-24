// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A database somebody else runs. */
@Serializable
public data class IssuerSpecDatabaseExternal(
    /** A host name or address the issuer can reach. */
    public val host: String,
    /** The port it listens on. */
    public val port: Long,
    public val password: SecretRef,
) {
    /** How Java makes a `IssuerSpecDatabaseExternal`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val host: String,
        private val port: Long,
        private val password: SecretRef,
    ) {
        public fun build(): IssuerSpecDatabaseExternal = IssuerSpecDatabaseExternal(host = host, port = port, password = password)
    }

    public companion object {
        /** A builder of a `IssuerSpecDatabaseExternal` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(host: String, port: Long, password: SecretRef): Builder = Builder(host, port, password)
    }
}
