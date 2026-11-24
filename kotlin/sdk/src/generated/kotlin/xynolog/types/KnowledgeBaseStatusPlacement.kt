// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Where the stack actually runs. "local": containers on this machine. "codespace": a GitHub-hosted VM whose KB is port-forwarded here. */
@Serializable
public enum class KnowledgeBaseStatusPlacement(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("local")
    Local("local"),

    @SerialName("codespace")
    Codespace("codespace"),
}
