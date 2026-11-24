// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

/** A resource's view, in the state directory. */
@Serializable
public data class ArchivistLayoutView(
    /** The tree the file is in: `root`, the working tree, `stateHome`, the state directory, or `anchoredTextDir`, the anchored-text store. */
    public val tree: ArchivistLayoutViewTree,
    /** Its path in its tree, `/`-separated. */
    public val path: String,
    /** The schema a view is. */
    public val schema: JsonElement,
) {
    /** How Java makes a `ArchivistLayoutView`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val tree: ArchivistLayoutViewTree,
        private val path: String,
        private val schema: JsonElement,
    ) {
        public fun build(): ArchivistLayoutView = ArchivistLayoutView(tree = tree, path = path, schema = schema)
    }

    public companion object {
        /** A builder of a `ArchivistLayoutView` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(tree: ArchivistLayoutViewTree, path: String, schema: JsonElement): Builder = Builder(tree, path, schema)
    }
}
