// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Where a client's stream is: one of the states of client/connection-states.json, which says what each means and where it moves. */
@Serializable
public enum class ConnectionState(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("initial")
    Initial("initial"),

    @SerialName("connecting")
    Connecting("connecting"),

    @SerialName("open")
    Open("open"),

    @SerialName("reconnecting")
    Reconnecting("reconnecting"),

    @SerialName("degraded")
    Degraded("degraded"),

    @SerialName("unauthenticated")
    Unauthenticated("unauthenticated"),

    @SerialName("closed")
    Closed("closed"),
}
