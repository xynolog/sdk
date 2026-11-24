// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The `WWW-Authenticate` of a 401. */
@Serializable
public data class GatewayMessagesChallenges(
    /** For a request that presents no credential. The challenge. `{origin}` is the origin the Unauthorized response names: `http://` and the request's `Host`, or, for a request that names none, the gateway's `publicUrl`. */
    public val noCredential: String,
    /** For a request whose credential, a bearer token or a media token, is refused. The challenge. `{origin}` is the origin the Unauthorized response names: `http://` and the request's `Host`, or, for a request that names none, the gateway's `publicUrl`. */
    public val refused: String,
) {
    /** How Java makes a `GatewayMessagesChallenges`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val noCredential: String,
        private val refused: String,
    ) {
        public fun build(): GatewayMessagesChallenges = GatewayMessagesChallenges(noCredential = noCredential, refused = refused)
    }

    public companion object {
        /** A builder of a `GatewayMessagesChallenges` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(noCredential: String, refused: String): Builder = Builder(noCredential, refused)
    }
}
