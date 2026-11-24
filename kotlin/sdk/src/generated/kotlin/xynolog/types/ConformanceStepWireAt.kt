// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** When it is read: on arrival, once answered (the default), or once its stream has caught up. */
@Serializable
public enum class ConformanceStepWireAt(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("arrival")
    Arrival("arrival"),

    @SerialName("answer")
    Answer("answer"),

    @SerialName("live")
    Live("live"),
}
