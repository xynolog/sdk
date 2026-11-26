// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The projections of what the `__system__` stream adds up to, in the state directory. */
@Serializable
public data class ArchivistLayoutSystemProjections(
    /** The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store. */
    public val tree: ArchivistLayoutEventStreamTree,
    /** The directory that holds them, in its tree, `/`-separated. */
    public val path: String,
    /** Each projection's file. */
    public val files: kotlin.collections.List<ArchivistLayoutSystemProjectionsFilesItem>,
) {
    /** How Java makes a `ArchivistLayoutSystemProjections`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val tree: ArchivistLayoutEventStreamTree,
        private val path: String,
        private val files: kotlin.collections.List<ArchivistLayoutSystemProjectionsFilesItem>,
    ) {
        public fun build(): ArchivistLayoutSystemProjections = ArchivistLayoutSystemProjections(tree = tree, path = path, files = files)
    }

    public companion object {
        /** A builder of a `ArchivistLayoutSystemProjections` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(tree: ArchivistLayoutEventStreamTree, path: String, files: kotlin.collections.List<ArchivistLayoutSystemProjectionsFilesItem>): Builder = Builder(tree, path, files)
    }
}
