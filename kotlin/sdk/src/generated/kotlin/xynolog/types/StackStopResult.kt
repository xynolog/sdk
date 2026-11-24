// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A stop that ran to its end: what status reads afterwards. A stop that failed is an error. */
@Serializable
public data class StackStopResult(
    /** Whether the stop stopped nothing. */
    public val dryRun: Boolean,
    /** The knowledge bases still recorded, as status reads them after the stop. Absent from a dry run. */
    public val knowledgeBases: kotlin.collections.List<KnowledgeBaseStatus>? = null,
    /** The shared services, as status reads them after the stop. Absent from a dry run. */
    public val shared: kotlin.collections.List<ServiceStatus>? = null,
) {
    /** How Java makes a `StackStopResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val dryRun: Boolean,
    ) {
        private var knowledgeBases: kotlin.collections.List<KnowledgeBaseStatus>? = null
        private var shared: kotlin.collections.List<ServiceStatus>? = null

        public fun knowledgeBases(knowledgeBases: kotlin.collections.List<KnowledgeBaseStatus>?): Builder = apply { this.knowledgeBases = knowledgeBases }
        public fun shared(shared: kotlin.collections.List<ServiceStatus>?): Builder = apply { this.shared = shared }

        public fun build(): StackStopResult = StackStopResult(dryRun = dryRun, knowledgeBases = knowledgeBases, shared = shared)
    }

    public companion object {
        /** A builder of a `StackStopResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(dryRun: Boolean): Builder = Builder(dryRun)
    }
}
