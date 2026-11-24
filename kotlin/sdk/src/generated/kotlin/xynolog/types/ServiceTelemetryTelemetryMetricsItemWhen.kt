// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** When the row arrives. */
@Serializable
public enum class ServiceTelemetryTelemetryMetricsItemWhen(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("export")
    Export("export"),

    @SerialName("traffic")
    Traffic("traffic"),

    @SerialName("supervised")
    Supervised("supervised"),

    @SerialName("fatal")
    Fatal("fatal"),
}
