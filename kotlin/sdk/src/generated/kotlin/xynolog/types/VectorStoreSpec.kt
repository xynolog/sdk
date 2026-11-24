// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The vector store, and where it is published. */
@Serializable
public data class VectorStoreSpec(
    /** The vector store's driver: `qdrant`. */
    public val type: String,
    public val image: Image,
    public val resources: Resources,
    /** The port the vector store is published on, on this machine, where every knowledge base's Smelter and Librarian reach it. */
    public val port: Long,
) {
    /** How Java makes a `VectorStoreSpec`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val type: String,
        private val image: Image,
        private val resources: Resources,
        private val port: Long,
    ) {
        public fun build(): VectorStoreSpec = VectorStoreSpec(type = type, image = image, resources = resources, port = port)
    }

    public companion object {
        /** A builder of a `VectorStoreSpec` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(type: String, image: Image, resources: Resources, port: Long): Builder = Builder(type, image, resources, port)
    }
}
