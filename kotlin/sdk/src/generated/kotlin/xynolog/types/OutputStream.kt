// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** Which of a container's streams a line was on. */
@Serializable
public enum class OutputStream(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("stdout")
    Stdout("stdout"),

    @SerialName("stderr")
    Stderr("stderr"),
}
