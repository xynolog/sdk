// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The grant, client-assertion-cases.json's grantType. */
@Serializable
public enum class ClientSecretFormGrantType(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("client_credentials")
    ClientCredentials("client_credentials"),
}
