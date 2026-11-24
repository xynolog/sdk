// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The file holding the stamp the anchored-text store's entries are taken under: the stamp, followed by a newline. */
@Serializable
public data class ArchivistLayoutAnchoredTextStamp(
    /** The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store. */
    public val tree: ArchivistLayoutAnchoredTextStampTree,
    /** Its path in its tree, `/`-separated. */
    public val path: String,
) {
    /** How Java makes a `ArchivistLayoutAnchoredTextStamp`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val tree: ArchivistLayoutAnchoredTextStampTree,
        private val path: String,
    ) {
        public fun build(): ArchivistLayoutAnchoredTextStamp = ArchivistLayoutAnchoredTextStamp(tree = tree, path = path)
    }

    public companion object {
        /** A builder of a `ArchivistLayoutAnchoredTextStamp` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(tree: ArchivistLayoutAnchoredTextStampTree, path: String): Builder = Builder(tree, path)
    }
}
