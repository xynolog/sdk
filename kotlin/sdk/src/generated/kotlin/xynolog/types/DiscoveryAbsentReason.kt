// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Why a client that read a launcher's discovery document found no launcher: one of the reasons of client/discovery-absent.json, which says what each means. */
@Serializable
public enum class DiscoveryAbsentReason(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("not-found")
    NotFound("not-found"),

    @SerialName("not-json")
    NotJson("not-json"),

    @SerialName("invalid")
    Invalid("invalid"),

    @SerialName("unsupported-version")
    UnsupportedVersion("unsupported-version"),

    @SerialName("unreadable")
    Unreadable("unreadable"),
}
