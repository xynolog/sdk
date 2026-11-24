// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A start that ran to its end: the stack as status reads it afterwards. A start that failed is an error, whatever it started before it did; its progress lines say what it did. */
@Serializable
public data class StackStartResult(
    /** Whether the start ran nothing. */
    public val dryRun: Boolean,
    /** The started knowledge base's stack, as status reads it after the start. Absent from a dry run, and from a start of services no knowledge base owns. */
    public val knowledgeBase: KnowledgeBaseStatus? = null,
    /** The shared services, as status reads them after the start. Absent from a dry run. */
    public val shared: kotlin.collections.List<ServiceStatus>? = null,
) {
    /** How Java makes a `StackStartResult`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val dryRun: Boolean,
    ) {
        private var knowledgeBase: KnowledgeBaseStatus? = null
        private var shared: kotlin.collections.List<ServiceStatus>? = null

        public fun knowledgeBase(knowledgeBase: KnowledgeBaseStatus?): Builder = apply { this.knowledgeBase = knowledgeBase }
        public fun shared(shared: kotlin.collections.List<ServiceStatus>?): Builder = apply { this.shared = shared }

        public fun build(): StackStartResult = StackStartResult(dryRun = dryRun, knowledgeBase = knowledgeBase, shared = shared)
    }

    public companion object {
        /** A builder of a `StackStartResult` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(dryRun: Boolean): Builder = Builder(dryRun)
    }
}
