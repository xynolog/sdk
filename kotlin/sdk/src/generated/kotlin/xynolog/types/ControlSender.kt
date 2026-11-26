// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Which side of the control API sends a message: the client, whose notifications arrive on the launcher's stdin, or the launcher, whose notifications leave on its stdout (LAUNCHER-CONTROL.md F1). */
@Serializable
public enum class ControlSender(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("client")
    Client("client"),

    @SerialName("launcher")
    Launcher("launcher"),
}
