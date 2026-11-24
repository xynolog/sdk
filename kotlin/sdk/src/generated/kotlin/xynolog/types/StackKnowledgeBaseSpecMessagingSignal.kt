// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The Gateway's signal plane. */
@Serializable
public data class StackKnowledgeBaseSpecMessagingSignal(
    /** `in-process`, one Gateway on its own fabric, or `nats`, on the broker. */
    public val type: String,
) {
    /** How Java makes a `StackKnowledgeBaseSpecMessagingSignal`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val type: String,
    ) {
        public fun build(): StackKnowledgeBaseSpecMessagingSignal = StackKnowledgeBaseSpecMessagingSignal(type = type)
    }

    public companion object {
        /** A builder of a `StackKnowledgeBaseSpecMessagingSignal` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(type: String): Builder = Builder(type)
    }
}
