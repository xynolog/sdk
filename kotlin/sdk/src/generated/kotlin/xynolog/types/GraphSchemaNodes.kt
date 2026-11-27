// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** Each kind of node the graph holds. */
@Serializable
public data class GraphSchemaNodes(
    /** A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by. */
    public val resource: GraphSchemaNodesResource,
    /** A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by. */
    public val annotation: GraphSchemaNodesResource,
    /** A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by. */
    public val entityType: GraphSchemaNodesResource,
) {
    /** How Java makes a `GraphSchemaNodes`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val resource: GraphSchemaNodesResource,
        private val annotation: GraphSchemaNodesResource,
        private val entityType: GraphSchemaNodesResource,
    ) {
        public fun build(): GraphSchemaNodes = GraphSchemaNodes(resource = resource, annotation = annotation, entityType = entityType)
    }

    public companion object {
        /** A builder of a `GraphSchemaNodes` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(resource: GraphSchemaNodesResource, annotation: GraphSchemaNodesResource, entityType: GraphSchemaNodesResource): Builder = Builder(resource, annotation, entityType)
    }
}
