// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** An entry of the anchored-text store, keyed by the checksum of the content it was extracted from. */
@Serializable
public data class ArchivistLayoutAnchoredTextEntry(
    /** The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store. */
    public val tree: ArchivistLayoutAnchoredTextEntryTree,
    /** Its path in its tree, `/`-separated. */
    public val path: String,
    /** The schema an entry is. */
    public val schema: JsonElement,
) {
    /** How Java makes a `ArchivistLayoutAnchoredTextEntry`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val tree: ArchivistLayoutAnchoredTextEntryTree,
        private val path: String,
        private val schema: JsonElement,
    ) {
        public fun build(): ArchivistLayoutAnchoredTextEntry = ArchivistLayoutAnchoredTextEntry(tree = tree, path = path, schema = schema)
    }

    public companion object {
        /** A builder of a `ArchivistLayoutAnchoredTextEntry` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(tree: ArchivistLayoutAnchoredTextEntryTree, path: String, schema: JsonElement): Builder = Builder(tree, path, schema)
    }
}
