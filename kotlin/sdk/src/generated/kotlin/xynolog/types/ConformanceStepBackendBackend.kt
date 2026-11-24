// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The directive. */
@Serializable
public enum class ConformanceStepBackendBackend(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("listen")
    Listen("listen"),

    @SerialName("emit")
    Emit("emit"),

    @SerialName("record")
    Record("record"),

    @SerialName("content")
    Content("content"),

    @SerialName("description")
    Description("description"),

    @SerialName("annotations")
    Annotations("annotations"),

    @SerialName("anchored-text")
    AnchoredText("anchored-text"),

    @SerialName("uploaded")
    Uploaded("uploaded"),

    @SerialName("refuse")
    Refuse("refuse"),

    @SerialName("unanswered")
    Unanswered("unanswered"),

    @SerialName("answer-lost")
    AnswerLost("answer-lost"),

    @SerialName("hold")
    Hold("hold"),

    @SerialName("release")
    Release("release"),

    @SerialName("rechunk")
    Rechunk("rechunk"),

    @SerialName("carry")
    Carry("carry"),

    @SerialName("cut")
    Cut("cut"),

    @SerialName("down")
    Down("down"),

    @SerialName("up")
    Up("up"),

    @SerialName("archivist")
    Archivist("archivist"),
}
