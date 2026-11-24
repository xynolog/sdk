// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)
@file:OptIn(kotlinx.serialization.ExperimentalSerializationApi::class)

package xynolog.types

import kotlinx.serialization.EncodeDefault
import kotlinx.serialization.Serializable

/** A knowledge base's record and the services that keep it: the Gateway, the Dispatcher, the Archivist, and the broker between them. They live and die with the knowledge base. */
@Serializable
public data class StackKnowledgeBase(
    public val apiVersion: StackApiVersion,
    @EncodeDefault
    public val kind: StackKnowledgeBaseKind = StackKnowledgeBaseKind.KnowledgeBase,
    public val metadata: Metadata,
    /** The knowledge base's services, and how each runs. */
    public val spec: StackKnowledgeBaseSpec,
) {
    /** How Java makes a `StackKnowledgeBase`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val apiVersion: StackApiVersion,
        private val metadata: Metadata,
        private val spec: StackKnowledgeBaseSpec,
    ) {
        public fun build(): StackKnowledgeBase = StackKnowledgeBase(apiVersion = apiVersion, metadata = metadata, spec = spec)
    }

    public companion object {
        /** A builder of a `StackKnowledgeBase` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(apiVersion: StackApiVersion, metadata: Metadata, spec: StackKnowledgeBaseSpec): Builder = Builder(apiVersion, metadata, spec)
    }
}
