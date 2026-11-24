// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** What xynolog status reports: each knowledge base with its own services, and each service the knowledge bases share, once, with the knowledge bases it serves. */
@Serializable
public data class StatusSnapshotResult(
    /** The target's stack; with no target, the stack of the knowledge base the control server stands in, else every recorded one. */
    public val knowledgeBases: kotlin.collections.List<KnowledgeBaseStatus>,
    /** The services every knowledge base shares, group by group, and those the machine serves for the knowledge bases that name them. */
    public val shared: kotlin.collections.List<ServiceStatus>,
) {
    /** How Java makes a `StatusSnapshotResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val knowledgeBases: kotlin.collections.List<KnowledgeBaseStatus>,
        private val shared: kotlin.collections.List<ServiceStatus>,
    ) {
        public fun build(): StatusSnapshotResult = StatusSnapshotResult(knowledgeBases = knowledgeBases, shared = shared)
    }

    public companion object {
        /** A builder of a `StatusSnapshotResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(knowledgeBases: kotlin.collections.List<KnowledgeBaseStatus>, shared: kotlin.collections.List<ServiceStatus>): Builder = Builder(knowledgeBases, shared)
    }
}
