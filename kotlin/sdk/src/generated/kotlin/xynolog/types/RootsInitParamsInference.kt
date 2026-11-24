// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Inference provider for the generated local stack documents. */
@Serializable
public enum class RootsInitParamsInference(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("anthropic")
    Anthropic("anthropic"),

    @SerialName("ollama")
    Ollama("ollama"),
}
