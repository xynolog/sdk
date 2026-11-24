// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The database the issuer keeps its realms in. */
@Serializable
public data class IssuerSpecDatabase(
    /** The database's driver: `postgres`. */
    public val type: String,
    /** The database the issuer keeps its realms in: a lowercase PostgreSQL identifier, as PostgreSQL itself names an unquoted one. On a PostgreSQL the launcher runs, the launcher creates it; on one somebody else runs (`external`), it must already exist there. */
    public val name: String,
    /** The user the issuer signs in as. */
    public val user: String,
    public val image: Image? = null,
    public val resources: Resources? = null,
    /** The port a PostgreSQL the launcher runs is published on, on this machine, where the issuer reaches it. One somebody else runs is reached at `external`. */
    public val port: Long? = null,
    /** A database somebody else runs. */
    public val external: IssuerSpecDatabaseExternal? = null,
) {
    /** How Java makes a `IssuerSpecDatabase`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val type: String,
        private val name: String,
        private val user: String,
    ) {
        private var image: Image? = null
        private var resources: Resources? = null
        private var port: Long? = null
        private var external: IssuerSpecDatabaseExternal? = null

        public fun image(image: Image?): Builder = apply { this.image = image }
        public fun resources(resources: Resources?): Builder = apply { this.resources = resources }
        public fun port(port: Long?): Builder = apply { this.port = port }
        public fun external(external: IssuerSpecDatabaseExternal?): Builder = apply { this.external = external }

        public fun build(): IssuerSpecDatabase = IssuerSpecDatabase(type = type, name = name, user = user, image = image, resources = resources, port = port, external = external)
    }

    public companion object {
        /** A builder of a `IssuerSpecDatabase` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(type: String, name: String, user: String): Builder = Builder(type, name, user)
    }
}
