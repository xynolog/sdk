// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The inference provider: who serves the model. `anthropic`, `google`, `openai` and `together` are those companies' own APIs. `llamacpp`, `ollama` and `vllm` are servers a deployment runs or reaches, each named for the server's software. */
@Serializable
public enum class InferenceProvider(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("anthropic")
    Anthropic("anthropic"),

    @SerialName("google")
    Google("google"),

    @SerialName("llamacpp")
    Llamacpp("llamacpp"),

    @SerialName("ollama")
    Ollama("ollama"),

    @SerialName("openai")
    Openai("openai"),

    @SerialName("together")
    Together("together"),

    @SerialName("vllm")
    Vllm("vllm"),
}
