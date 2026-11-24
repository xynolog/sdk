// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Where the stack runs: on this machine (local), or on a GitHub codespace whose knowledge base is forwarded here (codespace). */
@Serializable
public enum class TargetKind(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("local")
    Local("local"),

    @SerialName("codespace")
    Codespace("codespace"),
}
