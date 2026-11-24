// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A resource's event stream: a directory of event files. */
@Serializable
public data class ArchivistLayoutEventStream(
    /** The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store. */
    public val tree: ArchivistLayoutEventStreamTree,
    /** Its path in its tree, `/`-separated. */
    public val path: String,
) {
    /** How Java makes a `ArchivistLayoutEventStream`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val tree: ArchivistLayoutEventStreamTree,
        private val path: String,
    ) {
        public fun build(): ArchivistLayoutEventStream = ArchivistLayoutEventStream(tree = tree, path = path)
    }

    public companion object {
        /** A builder of a `ArchivistLayoutEventStream` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(tree: ArchivistLayoutEventStreamTree, path: String): Builder = Builder(tree, path)
    }
}
