// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The string's format, where it has one: `date-time` is an RFC 3339 time. */
@Serializable
public enum class ClientOptionDefaultsDefaultsItemSchemaDateTimeFormat(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("date-time")
    DateTime("date-time"),
}
