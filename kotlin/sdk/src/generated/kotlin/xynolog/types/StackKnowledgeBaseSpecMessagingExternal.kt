// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** A broker somebody else runs, serving this knowledge base alone: a second knowledge base on it would share the job queue and, on a `nats` signal plane, the frames and the gateway's record of pending replies. The launcher refuses to start a knowledge base whose `servers` another knowledge base on its machine names. */
@Serializable
public data class StackKnowledgeBaseSpecMessagingExternal(
    /** Where it listens: `host:port`. */
    public val servers: String,
    public val user: SecretRef,
    public val password: SecretRef,
) {
    /** How Java makes a `StackKnowledgeBaseSpecMessagingExternal`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val servers: String,
        private val user: SecretRef,
        private val password: SecretRef,
    ) {
        public fun build(): StackKnowledgeBaseSpecMessagingExternal = StackKnowledgeBaseSpecMessagingExternal(servers = servers, user = user, password = password)
    }

    public companion object {
        /** A builder of a `StackKnowledgeBaseSpecMessagingExternal` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(servers: String, user: SecretRef, password: SecretRef): Builder = Builder(servers, user, password)
    }
}
