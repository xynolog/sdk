// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Where a started Ollama keeps its models, as --ollama-cache names it. Absent: the host's ~/.ollama when there is one, else the named volume — what the command line's prompt does when nobody answers it. */
@Serializable
public enum class StackStartParamsOllamaCache(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("host")
    Host("host"),

    @SerialName("volume")
    Volume("volume"),
}
