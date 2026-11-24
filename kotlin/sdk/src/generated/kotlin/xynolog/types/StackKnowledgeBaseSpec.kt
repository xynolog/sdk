// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The knowledge base's services, and how each runs. */
@Serializable
public data class StackKnowledgeBaseSpec(
    public val logLevel: LogLevel,
    /** The Gateway: where every client and every service reaches the knowledge base. */
    public val gateway: StackKnowledgeBaseSpecGateway,
    /** The Dispatcher: it hands queued jobs to workers. */
    public val dispatcher: StackKnowledgeBaseSpecDispatcher,
    /** The Archivist: it keeps the knowledge base's record in its working tree. */
    public val archivist: StackKnowledgeBaseSpecArchivist,
    /** The broker the job queue and the signal plane share: the launcher's, run from `image`, or somebody else's, at `external`. */
    public val messaging: StackKnowledgeBaseSpecMessaging,
    /** The issuer the knowledge base trusts: the one the launcher runs for the knowledge bases on a machine, at `shared`, with the knowledge base's own realm in it, or somebody else's, at `external`. */
    public val issuer: StackKnowledgeBaseSpecIssuer,
) {
    /** How Java makes a `StackKnowledgeBaseSpec`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val logLevel: LogLevel,
        private val gateway: StackKnowledgeBaseSpecGateway,
        private val dispatcher: StackKnowledgeBaseSpecDispatcher,
        private val archivist: StackKnowledgeBaseSpecArchivist,
        private val messaging: StackKnowledgeBaseSpecMessaging,
        private val issuer: StackKnowledgeBaseSpecIssuer,
    ) {
        public fun build(): StackKnowledgeBaseSpec = StackKnowledgeBaseSpec(logLevel = logLevel, gateway = gateway, dispatcher = dispatcher, archivist = archivist, messaging = messaging, issuer = issuer)
    }

    public companion object {
        /** A builder of a `StackKnowledgeBaseSpec` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(logLevel: LogLevel, gateway: StackKnowledgeBaseSpecGateway, dispatcher: StackKnowledgeBaseSpecDispatcher, archivist: StackKnowledgeBaseSpecArchivist, messaging: StackKnowledgeBaseSpecMessaging, issuer: StackKnowledgeBaseSpecIssuer): Builder = Builder(logLevel, gateway, dispatcher, archivist, messaging, issuer)
    }
}
