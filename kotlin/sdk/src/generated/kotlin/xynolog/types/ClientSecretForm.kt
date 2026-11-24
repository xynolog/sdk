// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonIgnoreUnknownKeys

/** The form a service account that holds a client secret posts to its issuer's token endpoint for a client-credentials grant: its client id and secret in the body (RFC 6749 §2.3.1). An account that holds a key proves itself by the client assertion of client-assertion-cases.json instead. */
@Serializable
@JsonIgnoreUnknownKeys
public data class ClientSecretForm(
    /** The grant, client-assertion-cases.json's grantType. */
    @SerialName("grant_type")
    @EncodeDefault
    public val grantType: ClientSecretFormGrantType = ClientSecretFormGrantType.ClientCredentials,
    /** The account's client id. */
    @SerialName("client_id")
    public val clientId: String,
    /** The account's client secret. */
    @SerialName("client_secret")
    public val clientSecret: String,
) {
    /** How Java makes a `ClientSecretForm`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val clientId: String,
        private val clientSecret: String,
    ) {
        public fun build(): ClientSecretForm = ClientSecretForm(clientId = clientId, clientSecret = clientSecret)
    }

    public companion object {
        /** A builder of a `ClientSecretForm` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(clientId: String, clientSecret: String): Builder = Builder(clientId, clientSecret)
    }
}
