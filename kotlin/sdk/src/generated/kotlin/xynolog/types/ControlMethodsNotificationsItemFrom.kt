// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Which side sends it. */
@Serializable
public enum class ControlMethodsNotificationsItemFrom(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("client")
    Client("client"),

    @SerialName("launcher")
    Launcher("launcher"),
}
