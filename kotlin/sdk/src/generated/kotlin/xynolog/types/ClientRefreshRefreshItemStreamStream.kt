// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** `reopened`, the stream open again after a drop; or `unreadable`, an event that cannot be read. */
@Serializable
public enum class ClientRefreshRefreshItemStreamStream(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("reopened")
    Reopened("reopened"),

    @SerialName("unreadable")
    Unreadable("unreadable"),
}
