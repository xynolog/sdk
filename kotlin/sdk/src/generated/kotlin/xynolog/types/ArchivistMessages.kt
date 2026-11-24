// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

/** archivist/messages.json: the words of the Archivist's own refusals, and of the messages it logs that a reader relies on. */
@Serializable
public data class ArchivistMessages(
    /** The rule the table states, in prose. */
    @SerialName("\$comment")
    public val comment: String,
    /** Each refusal to start of the Archivist's own, written in service-environment/boot-refusals.json's `line`. */
    public val boot: kotlin.collections.List<ArchivistMessagesBootItem>,
    /** The failure a reply that cannot be sent is answered with instead, on the operation's failure channel. */
    public val unsent: kotlin.collections.List<ArchivistMessagesUnsentItem>,
    /** Each refusal of an operation, on the operation's failure channel. */
    public val refusals: kotlin.collections.List<ArchivistMessagesRefusalsItem>,
    /** The refusal of every route of the HTTP surface but `/health`: a token that is missing, or not of the knowledge base's issuer and audience, or without the service role. */
    public val unauthorized: ArchivistMessagesUnauthorized,
    /** Each other error a route of the HTTP surface answers with. */
    public val http: kotlin.collections.List<ArchivistMessagesHttpItem>,
    /** Each message the Archivist logs that a reader of its output relies on. */
    public val logged: kotlin.collections.List<ArchivistMessagesLoggedItem>,
) {
    /** How Java makes a `ArchivistMessages`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val comment: String,
        private val boot: kotlin.collections.List<ArchivistMessagesBootItem>,
        private val unsent: kotlin.collections.List<ArchivistMessagesUnsentItem>,
        private val refusals: kotlin.collections.List<ArchivistMessagesRefusalsItem>,
        private val unauthorized: ArchivistMessagesUnauthorized,
        private val http: kotlin.collections.List<ArchivistMessagesHttpItem>,
        private val logged: kotlin.collections.List<ArchivistMessagesLoggedItem>,
    ) {
        public fun build(): ArchivistMessages = ArchivistMessages(comment = comment, boot = boot, unsent = unsent, refusals = refusals, unauthorized = unauthorized, http = http, logged = logged)
    }

    public companion object {
        /** A builder of a `ArchivistMessages` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(comment: String, boot: kotlin.collections.List<ArchivistMessagesBootItem>, unsent: kotlin.collections.List<ArchivistMessagesUnsentItem>, refusals: kotlin.collections.List<ArchivistMessagesRefusalsItem>, unauthorized: ArchivistMessagesUnauthorized, http: kotlin.collections.List<ArchivistMessagesHttpItem>, logged: kotlin.collections.List<ArchivistMessagesLoggedItem>): Builder = Builder(comment, boot, unsent, refusals, unauthorized, http, logged)
    }
}
