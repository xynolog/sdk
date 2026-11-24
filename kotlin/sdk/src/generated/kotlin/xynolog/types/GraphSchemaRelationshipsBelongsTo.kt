// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A kind of relationship: its type, the kind of node it goes from and the kind it goes to, and what it says. */
@Serializable
public data class GraphSchemaRelationshipsBelongsTo(
    /** Its type. */
    public val type: String,
    /** The kind of node it goes from, by its name under `nodes`. */
    public val from: String,
    /** The kind of node it goes to, by its name under `nodes`. */
    public val to: String,
    /** What one says. */
    public val says: String,
) {
    /** How Java makes a `GraphSchemaRelationshipsBelongsTo`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val type: String,
        private val from: String,
        private val to: String,
        private val says: String,
    ) {
        public fun build(): GraphSchemaRelationshipsBelongsTo = GraphSchemaRelationshipsBelongsTo(type = type, from = from, to = to, says = says)
    }

    public companion object {
        /** A builder of a `GraphSchemaRelationshipsBelongsTo` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(type: String, from: String, to: String, says: String): Builder = Builder(type, from, to, says)
    }
}
