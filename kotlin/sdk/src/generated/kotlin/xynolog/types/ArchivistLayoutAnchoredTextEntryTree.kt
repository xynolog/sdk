// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store. */
@Serializable
public enum class ArchivistLayoutAnchoredTextEntryTree(
    /** The value as the wire spells it. */
    public val value: String,
) {
    @SerialName("root")
    Root("root"),

    @SerialName("stateHome")
    StateHome("stateHome"),

    @SerialName("anchoredTextDir")
    AnchoredTextDir("anchoredTextDir"),
}
