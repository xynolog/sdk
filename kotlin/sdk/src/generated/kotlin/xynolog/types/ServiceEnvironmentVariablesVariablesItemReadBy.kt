// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** What reads it: the service's own code, or the OpenTelemetry SDK. */
@Serializable
public enum class ServiceEnvironmentVariablesVariablesItemReadBy(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("service")
    Service("service"),

    @SerialName("opentelemetry")
    Opentelemetry("opentelemetry"),
}
