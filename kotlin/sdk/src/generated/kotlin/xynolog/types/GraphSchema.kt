// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** graph/schema.json: the shape of the graph a store keeps, as a reader of the store finds it. */
@Serializable
public data class GraphSchema(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each kind of node the graph holds. */
    public val nodes: GraphSchemaNodes,
    /** Each kind of relationship the graph holds. */
    public val relationships: GraphSchemaRelationships,
    /** A link's target the graph has not been given yet: a node of its kind that holds its key and the marker, `true`, and nothing else. A node without the marker is no stub. */
    public val stub: GraphSchemaStub,
) {
    /** How Java makes a `GraphSchema`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val nodes: GraphSchemaNodes,
        private val relationships: GraphSchemaRelationships,
        private val stub: GraphSchemaStub,
    ) {
        public fun build(): GraphSchema = GraphSchema(comment = comment, nodes = nodes, relationships = relationships, stub = stub)
    }

    public companion object {
        /** A builder of a `GraphSchema` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, nodes: GraphSchemaNodes, relationships: GraphSchemaRelationships, stub: GraphSchemaStub): Builder = Builder(comment, nodes, relationships, stub)
    }
}
