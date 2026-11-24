// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The Dispatcher's queue. */
@Serializable
public data class StackKnowledgeBaseSpecMessagingJobs(
    /** The queue's driver: `jetstream`. */
    public val type: String,
) {
    /** How Java makes a `StackKnowledgeBaseSpecMessagingJobs`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val type: String,
    ) {
        public fun build(): StackKnowledgeBaseSpecMessagingJobs = StackKnowledgeBaseSpecMessagingJobs(type = type)
    }

    public companion object {
        /** A builder of a `StackKnowledgeBaseSpecMessagingJobs` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(type: String): Builder = Builder(type)
    }
}
