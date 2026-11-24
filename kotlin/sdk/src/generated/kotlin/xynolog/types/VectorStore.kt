// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** The vector store the launcher runs for the knowledge bases on a machine, each knowledge base's index in collections of its own. It belongs to no knowledge base, so its document is kept in the launcher's state home, in `stack/vectors.yaml`, not in a knowledge base's repository. A knowledge base keeps its index in it by naming `shared` at `spec.vectors`. */
@Serializable
public data class VectorStore(
    public val apiVersion: StackApiVersion,
    @EncodeDefault
    public val kind: VectorStoreKind = VectorStoreKind.VectorStore,
    public val metadata: Metadata,
    /** The vector store, and where it is published. */
    public val spec: VectorStoreSpec,
) {
    /** How Java makes a `VectorStore`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: StackApiVersion,
        private val metadata: Metadata,
        private val spec: VectorStoreSpec,
    ) {
        public fun build(): VectorStore = VectorStore(apiVersion = apiVersion, metadata = metadata, spec = spec)
    }

    public companion object {
        /** A builder of a `VectorStore` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: StackApiVersion, metadata: Metadata, spec: VectorStoreSpec): Builder = Builder(apiVersion, metadata, spec)
    }
}
