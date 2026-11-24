// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The metric's instrument. */
@Serializable
public enum class ServiceTelemetryTelemetryMetricsItemInstrument(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("counter")
    Counter("counter"),

    @SerialName("up-down counter")
    UpDownCounter("up-down counter"),

    @SerialName("gauge")
    Gauge("gauge"),

    @SerialName("histogram")
    Histogram("histogram"),
}
