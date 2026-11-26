// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** What a state home differs by (sign-in-store/README.md): macOS, Windows, and every other system. */
@Serializable
public enum class System(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("macos")
    Macos("macos"),

    @SerialName("windows")
    Windows("windows"),

    @SerialName("other")
    Other("other"),
}
