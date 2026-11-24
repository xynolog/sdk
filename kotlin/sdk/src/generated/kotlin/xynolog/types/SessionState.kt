// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** valid: the stack's gateway accepts the stored token. expired: it refuses it (a refresh, or xynolog login, renews it). unverified: the stack did not answer. none: nothing is stored. */
@Serializable
public enum class SessionState(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("valid")
    Valid("valid"),

    @SerialName("expired")
    Expired("expired"),

    @SerialName("unverified")
    Unverified("unverified"),

    @SerialName("none")
    None("none"),
}
