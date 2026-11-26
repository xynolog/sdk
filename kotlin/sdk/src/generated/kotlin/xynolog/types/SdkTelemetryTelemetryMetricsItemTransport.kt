// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The transport the row comes from: `bus`, the stream and emits; `content`, uploads and reads. */
@Serializable
public enum class SdkTelemetryTelemetryMetricsItemTransport(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("bus")
    Bus("bus"),

    @SerialName("content")
    Content("content"),
}
