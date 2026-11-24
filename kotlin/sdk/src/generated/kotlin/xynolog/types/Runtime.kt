// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** A container runtime the launcher drives, as --runtime names it: Apple container, Docker or Podman. */
@Serializable
public enum class Runtime(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("container")
    Container("container"),

    @SerialName("docker")
    Docker("docker"),

    @SerialName("podman")
    Podman("podman"),
}
