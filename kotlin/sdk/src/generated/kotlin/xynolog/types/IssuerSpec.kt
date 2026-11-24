// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The issuer, where it is published, and the database it keeps its realms in. */
@Serializable
public data class IssuerSpec(
    /** The issuer's driver: `keycloak`. */
    public val type: String,
    public val image: Image,
    public val resources: Resources,
    /** The port the issuer is published on, on this machine: the origin of every realm's `iss`, so the one number wherever the issuer is reached. */
    public val port: Long,
    /** The database the issuer keeps its realms in. */
    public val database: IssuerSpecDatabase,
) {
    /** How Java makes a `IssuerSpec`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val type: String,
        private val image: Image,
        private val resources: Resources,
        private val port: Long,
        private val database: IssuerSpecDatabase,
    ) {
        public fun build(): IssuerSpec = IssuerSpec(type = type, image = image, resources = resources, port = port, database = database)
    }

    public companion object {
        /** A builder of a `IssuerSpec` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(type: String, image: Image, resources: Resources, port: Long, database: IssuerSpecDatabase): Builder = Builder(type, image, resources, port, database)
    }
}
