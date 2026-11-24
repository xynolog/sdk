// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** What it applies to: every knowledge base on this machine, or one. */
@Serializable
public enum class SettingAppliesTo(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("machine")
    Machine("machine"),

    @SerialName("knowledge-base")
    KnowledgeBase("knowledge-base"),
}
