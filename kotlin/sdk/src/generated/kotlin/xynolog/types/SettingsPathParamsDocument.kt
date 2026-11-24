// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Whose document: the Browser's, the worker's, the issuer's or the vector store's. */
@Serializable
public enum class SettingsPathParamsDocument(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("browser")
    Browser("browser"),

    @SerialName("worker")
    Worker("worker"),

    @SerialName("issuer")
    Issuer("issuer"),

    @SerialName("vectors")
    Vectors("vectors"),
}
