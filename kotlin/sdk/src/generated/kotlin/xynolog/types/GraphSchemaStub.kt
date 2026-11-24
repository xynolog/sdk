// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A link's target the graph has not been given yet: a node of its kind that holds its key and the marker, `true`, and nothing else. A node without the marker is no stub. */
@Serializable
public data class GraphSchemaStub(
    /** The kind of node a stub is, by its name under `nodes`. */
    public val node: String,
    /** The property that marks a stub. */
    public val marker: String,
) {
    /** How Java makes a `GraphSchemaStub`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val node: String,
        private val marker: String,
    ) {
        public fun build(): GraphSchemaStub = GraphSchemaStub(node = node, marker = marker)
    }

    public companion object {
        /** A builder of a `GraphSchemaStub` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(node: String, marker: String): Builder = Builder(node, marker)
    }
}
