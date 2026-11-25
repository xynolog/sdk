// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Where a knowledge base's stack runs: on this machine (local), or in a GitHub codespace whose knowledge base is forwarded here (codespace). */
@Serializable
public enum class KbPlacement(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("local")
    Local("local"),

    @SerialName("codespace")
    Codespace("codespace"),
}
