// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonElement

@Serializable
public data class ArchivistLayoutSystemProjectionsFilesItem(
    /** The file's name. */
    public val name: String,
    /** The schema the projection is. */
    public val schema: JsonElement,
) {
    /** How Java makes a `ArchivistLayoutSystemProjectionsFilesItem`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val name: String,
        private val schema: JsonElement,
    ) {
        public fun build(): ArchivistLayoutSystemProjectionsFilesItem = ArchivistLayoutSystemProjectionsFilesItem(name = name, schema = schema)
    }

    public companion object {
        /** A builder of a `ArchivistLayoutSystemProjectionsFilesItem` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(name: String, schema: JsonElement): Builder = Builder(name, schema)
    }
}
