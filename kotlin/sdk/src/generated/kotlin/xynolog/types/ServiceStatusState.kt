// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** running: its container runs. stopped: its container exists and does not run (containerState says how). reachable, unreachable: somebody else runs it, and its endpoint answers or does not. absent: there is no container of it. not-configured: the stack's documents ask for none. */
@Serializable
public enum class ServiceStatusState(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("running")
    Running("running"),

    @SerialName("stopped")
    Stopped("stopped"),

    @SerialName("reachable")
    Reachable("reachable"),

    @SerialName("unreachable")
    Unreachable("unreachable"),

    @SerialName("absent")
    Absent("absent"),

    @SerialName("not-configured")
    NotConfigured("not-configured"),
}
