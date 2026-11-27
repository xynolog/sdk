// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The knowledge base's own stream, of the events that name no resource. It is not sharded. */
@Serializable
public data class ArchivistLayoutSystemStream(
    /** The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store. */
    public val tree: ArchivistLayoutEventStreamTree,
    /** Its path in its tree, `/`-separated. */
    public val path: String,
) {
    /** How Java makes a `ArchivistLayoutSystemStream`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val tree: ArchivistLayoutEventStreamTree,
        private val path: String,
    ) {
        public fun build(): ArchivistLayoutSystemStream = ArchivistLayoutSystemStream(tree = tree, path = path)
    }

    public companion object {
        /** A builder of a `ArchivistLayoutSystemStream` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(tree: ArchivistLayoutEventStreamTree, path: String): Builder = Builder(tree, path)
    }
}
