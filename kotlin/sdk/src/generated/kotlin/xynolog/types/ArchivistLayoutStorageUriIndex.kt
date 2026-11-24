// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** An entry of the storage-uri index, which names the resource whose content is at a storage URI. */
@Serializable
public data class ArchivistLayoutStorageUriIndex(
    /** The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store. */
    public val tree: ArchivistLayoutStorageUriIndexTree,
    /** Its path in its tree, `/`-separated. */
    public val path: String,
    /** The schema an entry is. */
    public val schema: JsonElement,
) {
    /** How Java makes a `ArchivistLayoutStorageUriIndex`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val tree: ArchivistLayoutStorageUriIndexTree,
        private val path: String,
        private val schema: JsonElement,
    ) {
        public fun build(): ArchivistLayoutStorageUriIndex = ArchivistLayoutStorageUriIndex(tree = tree, path = path, schema = schema)
    }

    public companion object {
        /** A builder of a `ArchivistLayoutStorageUriIndex` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(tree: ArchivistLayoutStorageUriIndexTree, path: String, schema: JsonElement): Builder = Builder(tree, path, schema)
    }
}
