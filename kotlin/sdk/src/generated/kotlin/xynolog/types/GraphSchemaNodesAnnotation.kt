// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A kind of node: its label, the codec row it holds, the property it is one of its kind by, and the properties a reader finds one by. */
@Serializable
public data class GraphSchemaNodesAnnotation(
    /** Its label. */
    public val label: String,
    /** The part of graph/codec-cases.json whose `properties` and `json` are the node's properties. A node without one holds its key alone. */
    public val row: String? = null,
    /** The property no two nodes of its kind share. */
    public val key: String,
    /** The properties other than its key that a reader finds a node of its kind by. */
    public val lookups: kotlin.collections.List<String>,
) {
    /** How Java makes a `GraphSchemaNodesAnnotation`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val label: String,
        private val key: String,
        private val lookups: kotlin.collections.List<String>,
    ) {
        private var row: String? = null

        public fun row(row: String?): Builder = apply { this.row = row }

        public fun build(): GraphSchemaNodesAnnotation = GraphSchemaNodesAnnotation(label = label, row = row, key = key, lookups = lookups)
    }

    public companion object {
        /** A builder of a `GraphSchemaNodesAnnotation` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(label: String, key: String, lookups: kotlin.collections.List<String>): Builder = Builder(label, key, lookups)
    }
}
