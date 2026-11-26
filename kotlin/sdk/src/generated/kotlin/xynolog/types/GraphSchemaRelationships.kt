// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Each kind of relationship the graph holds. */
@Serializable
public data class GraphSchemaRelationships(
    /** A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says. */
    public val belongsTo: GraphSchemaRelationshipsBelongsTo,
    /** A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says. */
    public val references: GraphSchemaRelationshipsBelongsTo,
    /** A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says. */
    public val taggedAs: GraphSchemaRelationshipsBelongsTo,
) {
    /** How Java makes a `GraphSchemaRelationships`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val belongsTo: GraphSchemaRelationshipsBelongsTo,
        private val references: GraphSchemaRelationshipsBelongsTo,
        private val taggedAs: GraphSchemaRelationshipsBelongsTo,
    ) {
        public fun build(): GraphSchemaRelationships = GraphSchemaRelationships(belongsTo = belongsTo, references = references, taggedAs = taggedAs)
    }

    public companion object {
        /** A builder of a `GraphSchemaRelationships` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(belongsTo: GraphSchemaRelationshipsBelongsTo, references: GraphSchemaRelationshipsBelongsTo, taggedAs: GraphSchemaRelationshipsBelongsTo): Builder = Builder(belongsTo, references, taggedAs)
    }
}
