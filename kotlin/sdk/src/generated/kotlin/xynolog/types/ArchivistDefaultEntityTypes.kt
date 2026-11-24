// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** archivist/default-entity-types.json: the entity types an Archivist seeds, in the order it seeds them. */
@Serializable
public data class ArchivistDefaultEntityTypes(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** The default entity types, in seed order. */
    public val entityTypes: kotlin.collections.List<String>,
) {
    /** How Java makes a `ArchivistDefaultEntityTypes`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val entityTypes: kotlin.collections.List<String>,
    ) {
        public fun build(): ArchivistDefaultEntityTypes = ArchivistDefaultEntityTypes(comment = comment, entityTypes = entityTypes)
    }

    public companion object {
        /** A builder of a `ArchivistDefaultEntityTypes` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, entityTypes: kotlin.collections.List<String>): Builder = Builder(comment, entityTypes)
    }
}
