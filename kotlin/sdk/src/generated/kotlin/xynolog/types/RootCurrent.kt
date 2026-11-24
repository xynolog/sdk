// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** For a local root: how the control server's own directory selects it, when it does — standing in it (cwd), or XYNOLOG_ROOT. */
@Serializable
public enum class RootCurrent(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("cwd")
    Cwd("cwd"),

    @SerialName("xynolog-root")
    XynologRoot("xynolog-root"),
}
