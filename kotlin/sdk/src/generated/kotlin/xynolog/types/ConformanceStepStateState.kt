// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The state. */
@Serializable
public enum class ConformanceStepStateState(
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
