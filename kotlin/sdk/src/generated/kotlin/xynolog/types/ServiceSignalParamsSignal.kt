// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** term: SIGTERM, and SIGKILL 15 seconds later if it has not exited. kill: SIGKILL, so nothing it would settle on the way out is settled. */
@Serializable
public enum class ServiceSignalParamsSignal(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("term")
    Term("term"),

    @SerialName("kill")
    Kill("kill"),
}
