// Generated from the component schemas in protocol/specs/src; do not edit.
// Regenerate: make generate (codegen/lib/kotlin_sdk/kotlin_sdk.ml)

package xynolog.types

import kotlinx.serialization.Serializable

/** The refusal of every route of the HTTP surface but `/health`: a token that is missing, or not of the knowledge base's issuer and audience, or without the service role. */
@Serializable
public data class ArchivistMessagesUnauthorized(
    public val status: HttpStatus,
    /** The body's `error`. */
    public val error: String,
    /** The `WWW-Authenticate` header when a token was presented. */
    public val presented: String,
    /** The `WWW-Authenticate` header when none was. */
    public val absent: String,
) {
    /** How Java makes a `ArchivistMessagesUnauthorized`: `builder` takes what it must state, a setter each thing it may, and `build` makes it. */
    public class Builder internal constructor(
        private val status: HttpStatus,
        private val error: String,
        private val presented: String,
        private val absent: String,
    ) {
        public fun build(): ArchivistMessagesUnauthorized = ArchivistMessagesUnauthorized(status = status, error = error, presented = presented, absent = absent)
    }

    public companion object {
        /** A builder of a `ArchivistMessagesUnauthorized` that states these, and what its setters add. */
        @JvmStatic
        public fun builder(status: HttpStatus, error: String, presented: String, absent: String): Builder = Builder(status, error, presented, absent)
    }
}
