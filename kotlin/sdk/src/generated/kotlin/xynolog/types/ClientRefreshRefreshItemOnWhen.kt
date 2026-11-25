// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Which of a channel's two ways of event the row is for. */
@Serializable
public enum class ClientRefreshRefreshItemOnWhen(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("enriched")
    Enriched("enriched"),

    @SerialName("unenriched")
    Unenriched("unenriched"),
}
