// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The span's kind, in OTLP's words. */
@Serializable
public enum class SdkTelemetryTelemetrySpansItemKind(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("client")
    Client("client"),

    @SerialName("consumer")
    Consumer("consumer"),

    @SerialName("internal")
    Internal("internal"),

    @SerialName("producer")
    Producer("producer"),

    @SerialName("server")
    Server("server"),
}
