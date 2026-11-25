// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Which keys the row reaches: the event's subject, or every key held. */
@Serializable
public enum class ClientRefreshRefreshItemOnReach(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("subject")
    Subject("subject"),

    @SerialName("held")
    Held("held"),
}
