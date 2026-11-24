// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** What sets it where the launcher runs the service. */
@Serializable
public enum class ServiceEnvironmentVariablesVariablesItemProvidedBy(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("launcher")
    Launcher("launcher"),

    @SerialName("image")
    Image("image"),

    @SerialName("operator")
    Operator("operator"),
}
