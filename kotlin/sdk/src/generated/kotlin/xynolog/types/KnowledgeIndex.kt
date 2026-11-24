// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** What a knowledge base's record is indexed into, and the services that keep and read the indexes: the Weaver's graph, the Smelter's vectors and anchored text, and the Librarian that answers from them. Each can be rebuilt from the record. */
@Serializable
public data class KnowledgeIndex(
    public val apiVersion: StackApiVersion,
    @EncodeDefault
    public val kind: KnowledgeIndexKind = KnowledgeIndexKind.KnowledgeIndex,
    public val metadata: Metadata,
    /** The indexes, the services that keep and read them, and the knowledge base they index. */
    public val spec: KnowledgeIndexSpec,
) {
    /** How Java makes a `KnowledgeIndex`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: StackApiVersion,
        private val metadata: Metadata,
        private val spec: KnowledgeIndexSpec,
    ) {
        public fun build(): KnowledgeIndex = KnowledgeIndex(apiVersion = apiVersion, metadata = metadata, spec = spec)
    }

    public companion object {
        /** A builder of a `KnowledgeIndex` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: StackApiVersion, metadata: Metadata, spec: KnowledgeIndexSpec): Builder = Builder(apiVersion, metadata, spec)
    }
}
