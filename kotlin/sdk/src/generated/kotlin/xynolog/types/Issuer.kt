// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** The issuer the launcher runs for the knowledge bases on a machine, with a realm for each, and the database it keeps their realms in. It belongs to no knowledge base, so its document is kept in the launcher's state home, in `stack/issuer.yaml`, not in a knowledge base's repository. A knowledge base trusts it by naming `shared`; one trusting somebody else's issuer names it at `external`. */
@Serializable
public data class Issuer(
    public val apiVersion: StackApiVersion,
    @EncodeDefault
    public val kind: IssuerKind = IssuerKind.Issuer,
    public val metadata: Metadata,
    /** The issuer, where it is published, and the database it keeps its realms in. */
    public val spec: IssuerSpec,
) {
    /** How Java makes a `Issuer`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: StackApiVersion,
        private val metadata: Metadata,
        private val spec: IssuerSpec,
    ) {
        public fun build(): Issuer = Issuer(apiVersion = apiVersion, metadata = metadata, spec = spec)
    }

    public companion object {
        /** A builder of a `Issuer` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: StackApiVersion, metadata: Metadata, spec: IssuerSpec): Builder = Builder(apiVersion, metadata, spec)
    }
}
